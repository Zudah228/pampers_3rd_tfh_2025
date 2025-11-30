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

functions.setGlobalOptions({ region: "asia-northeast1", secrets: ["AWS_SECRET_ACCESS_KEY", "AWS_ACCESS_KEY_ID"] })

const download = async (filePath: string): Promise<Buffer> => {
    const [response] = await storage.bucket().file(filePath).get()
    const [bufferResponse] = await response.download()
    const buffer = bufferResponse.buffer
    return Buffer.from(buffer)
}

const getAws = () => {
    const secretAccessKey = functions.params.defineSecret("AWS_SECRET_ACCESS_KEY").value()
    const accessKeyId = functions.params.defineSecret("AWS_ACCESS_KEY_ID").value()

    aws.config.update({
        accessKeyId,
        secretAccessKey,
        region: "us-east-1",
    })

    return new aws.Rekognition()
}

const _compareFaces = async (sourceImage: Buffer, targetImage: Buffer) => {
    const response = await getAws()
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

    functions.logger.info(`compareFaces called by user: ${auth.uid}, filePath: ${filePath}, roomId: ${roomId}`)

    const groupImage = await download(filePath)
    functions.logger.info(`downloaded ${filePath}`)

    const users = await firestore.collectionGroup("related_rooms")
    .where("id", "==", roomId).get()

    const hasUsers = users.docs.length > 0
    const userIds = users.docs
        .map((doc) => doc.data()?.user_id)
        .filter((userId): userId is string => typeof userId === "string")

    functions.logger.info(`users: ${userIds}`)

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
    const allMatched = compareFacesResponses.every((response) =>
        response.FaceMatches ? response.FaceMatches.length > 0 : false
    )

    const success = allMatched && hasUsers
    return {
        success,
    }
})

export const helloWorld = functions.https.onCall((request, response) => {
    return { message: "Hello from Firebase!" }
})
