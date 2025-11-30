import * as aws from "aws-sdk"
import { initializeApp } from "firebase-admin/app"
import { getFirestore } from "firebase-admin/firestore"
import { getStorage } from "firebase-admin/storage"
import * as functions from "firebase-functions/v2"

initializeApp()

const firestore = getFirestore()
firestore.settings({
    // undefined の値を Firestore に追加しない設定。
    ignoreUndefinedProperties: true,
})

const storage = getStorage()

functions.setGlobalOptions({ region: "asia-northeast1" })

const download = async (filePath: string): Promise<Buffer> => {
    const response = await storage.bucket().file(filePath).get()
    const bufferResponse = await response[0].download()
    const buffer = bufferResponse[0].buffer
    return Buffer.from(buffer)
}

const secretAccessKey = functions.params.defineSecret("AWS_SECRET_KEY").value()
const accessKeyId = functions.params.defineSecret("AWS_PUBLIC_KEY").value()

aws.config.update({
    accessKeyId,
    secretAccessKey,
    region: "us-east-1",
})

const awsRekognition = new aws.Rekognition()

const _compareFaces = async (sourceImage: Buffer, targetImage: Buffer) => {
    const response = await awsRekognition
        .compareFaces({
            SourceImage: {
                Bytes: sourceImage,
            },
            TargetImage: {
                Bytes: targetImage,
            },
            SimilarityThreshold: 80,
        })
        .promise()

    return response
}

export const compareFaces = functions.https.onCall(async (request) => {
    const { auth, data } = request

    if (auth == null) {
        throw new functions.https.HttpsError("unauthenticated", "認証エラー")
    }

    const filePath = data.file_path
    const roomId = data.room_id

    if (!filePath || typeof filePath !== "string" || !roomId || typeof roomId !== "string") {
        throw new functions.https.HttpsError("invalid-argument", "file_path,roomId が必要です")
    }

    const groupImage = await download(filePath)

    const members = await firestore.collectionGroup("related_rooms").where("room_id", "==", roomId).get()
    const userIds = members.docs
        .map((doc) => doc.data()?.user_id)
        .filter((userId): userId is string => typeof userId === "string")

    const userImages = await Promise.all(
        userIds.map(async (userId) => {
            const imagePath = await firestore.collection("users").doc(userId).get()

            const avatarPath = imagePath.data()?.avatar_path
            if (!avatarPath) {
                throw new functions.https.HttpsError(
                    "invalid-argument",
                    "avatar_path が設定されていないユーザーがいます"
                )
            }

            return download(avatarPath)
        })
    )

    const compareFacesResponses = await Promise.all(
        userImages.map(async (userImage) => {
            return _compareFaces(userImage, groupImage)
        })
    )

    // すべてのユーザーが顔が、１人以上と一致しているかどうかを判断
    const success = compareFacesResponses.every((response) =>
        response.FaceMatches ? response.FaceMatches.length > 0 : false
    )
    return {
        success,
    }
})
