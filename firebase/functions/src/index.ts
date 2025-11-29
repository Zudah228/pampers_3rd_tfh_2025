import { initializeApp } from "firebase-admin/app"
import { getFirestore } from "firebase-admin/firestore"
import { getStorage } from "firebase-admin/storage"
import * as functions from "firebase-functions/v2"

initializeApp(functions.config().firebase)

const firestore = getFirestore()
firestore.settings({
    // undefined の値を Firestore に追加しない設定。
    ignoreUndefinedProperties: true,
})

const storage = getStorage()

functions.setGlobalOptions({ region: "asia-northeast1" });

export const saveFaceIds = functions.https.onCall(async (request) => {
    const { auth, data } = request

    if (auth == null) {
        throw new functions.https.HttpsError("unauthenticated", "認証エラー")
    }

    const filePath = data.file_path
    const roomId = data.room_id

    if (!filePath || !roomId) {
        throw new functions.https.HttpsError("resource-exhausted", "file_path,roomId が必要です")
    }

    const response = await storage.bucket().file(filePath).get()
    // TODO: Azure 経由で顔の ID をとってきて、face_ids を返す
    response

    const face_ids: string[] = []

    await firestore.doc(`room/${roomId}`).update({
        face_ids,
    })

    return {
      face_ids
    }
})

export const fetchFaceIds = functions.https.onCall(async (request) => {
    const { auth, data } = request

    if (auth == null) {
        throw new functions.https.HttpsError("unauthenticated", "認証エラー")
    }

    const filePath = data.file_path

    if (!filePath) {
        throw new functions.https.HttpsError("resource-exhausted", "file_path が必要です")
    }

    const response = await storage.bucket().file(filePath).get()
    // TODO: Azure 経由で顔の ID をとってきて、face_ids を返す
    response

    const face_ids: string[] = []

    return {
      face_ids
    }
})
