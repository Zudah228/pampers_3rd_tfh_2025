import * as aws from "aws-sdk";
import { initializeApp } from "firebase-admin/app";
import { getFirestore } from "firebase-admin/firestore";
import { getStorage } from "firebase-admin/storage";
import * as functions from "firebase-functions/v2";

initializeApp(functions.config().firebase);

const firestore = getFirestore();
firestore.settings({
	// undefined の値を Firestore に追加しない設定。
	ignoreUndefinedProperties: true,
});

const storage = getStorage();

functions.setGlobalOptions({ region: "asia-northeast1" });

const download = async (filePath: string): Promise<Buffer> => {
	const response = await storage.bucket().file(filePath).get();
	const bufferResponse = await response[0].download();
	const buffer = bufferResponse[0].buffer;
	return Buffer.from(buffer);
};

const awsRekognition = new aws.Rekognition();

const _compareFaces = async (sourceImage: Buffer, targetImage: Buffer) => {
	const response = await awsRekognition
		.compareFaces({
			SourceImage: {
				Bytes: sourceImage,
			},
			TargetImage: {
				Bytes: targetImage,
			},
		})
		.promise();

	return response;
};

export const compareFaces = functions.https.onCall(async (request) => {
	const { auth, data } = request;

	if (auth == null) {
		throw new functions.https.HttpsError("unauthenticated", "認証エラー");
	}

	const imageBase64 = data.image;
	const roomId = data.room_id;

	if (!imageBase64 || typeof imageBase64 !== "string" || !roomId || typeof roomId !== "string") {
		throw new functions.https.HttpsError(
			"resource-exhausted",
			"file_path,roomId が必要です",
		);
	}

	const groupImage = Buffer.from(imageBase64, "base64");

	const members = await firestore
		.collectionGroup("related_rooms")
		.where("room_id", "==", roomId)
		.get();
	const userIds = members.docs.map<string>((doc) => doc.data().user_id);

	const userImages = await Promise.all(
		userIds.map(async (userId) => {
			const imagePath = await firestore.collection("users").doc(userId).get();

			const avatarPath = imagePath.data()?.avatar_path;
			if (!avatarPath) {
				throw new functions.https.HttpsError(
					"resource-exhausted",
					"avatar_path が設定されていないユーザーがいます",
				);
			}

			return download(avatarPath);
		}),
	);

	const compareFacesResponses = await Promise.all(
		userImages.map(async (userImage) => {
			return _compareFaces(groupImage, userImage);
		}),
	);

    // すべてのユーザーが顔が、１人以上と一致しているかどうかを判断
	const success = compareFacesResponses.every(
        (response) => response.FaceMatches ? response.FaceMatches.length > 0 : false,
    )
    ;
	return {
        success,
    };
});
