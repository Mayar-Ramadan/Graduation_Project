const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.notifyOnNewReading = functions.database
  .ref("/users/{userId}/water_readings/{readingId}")
  .onCreate(async (snapshot, context) => {

    const data = snapshot.val();
    const userId = context.params.userId;

    const payload = {
      notification: {
        title: "💧 New Water Reading",
        body: data.status ? `Status: ${data.status}` : "New update",
      },
    };

    const tokenSnap = await admin.database()
      .ref(`/users/${userId}/fcmToken`)
      .once("value");

    const token = tokenSnap.val();

    if (!token) {
      console.log("No FCM token found");
      return null;
    }

    return admin.messaging().sendToDevice(token, payload);
  });