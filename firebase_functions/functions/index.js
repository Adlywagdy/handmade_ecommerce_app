const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

/**
 * Cloud Function to send a Push Notification via FCM whenever
 * a new notification document is created for a user in Firestore.
 */
exports.sendPushNotification = functions.firestore
  .document("users/{userId}/notifications/{notificationId}")
  .onCreate(async (snapshot, context) => {
    const userId = context.params.userId;
    const notificationData = snapshot.data();

    if (!notificationData) {
      console.log("No notification data found in snapshot");
      return null;
    }

    try {
      // 1. Retrieve the user's document to get the FCM Token
      const userDoc = await admin.firestore().collection("users").doc(userId).get();
      if (!userDoc.exists) {
        console.log(`User document not found for ID: ${userId}`);
        return null;
      }

      const userData = userDoc.data();
      const fcmToken = userData.fcmToken;

      if (!fcmToken) {
        console.log(`No FCM token registered for user: ${userId}`);
        return null;
      }

      console.log(`Sending push notification to user ${userId} with token: ${fcmToken}`);

      // 2. Build the FCM message payload
      const message = {
        token: fcmToken,
        notification: {
          title: notificationData.title,
          body: notificationData.body,
        },
        data: {
          type: String(notificationData.type !== undefined ? notificationData.type : ""),
          targetId: String(notificationData.targetId || ""),
          id: String(notificationData.id || snapshot.id),
        },
        android: {
          priority: "high",
          notification: {
            sound: "default",
            clickAction: "FLUTTER_NOTIFICATION_CLICK",
          },
        },
        apns: {
          payload: {
            aps: {
              sound: "default",
              badge: 1,
            },
          },
        },
      };

      // 3. Dispatch the message
      const response = await admin.messaging().send(message);
      console.log(`Successfully sent FCM push notification response:`, response);
      return response;
    } catch (error) {
      console.error(`Error sending push notification to user ${userId}:`, error);
      return null;
    }
  });

/**
 * Scheduled Cloud Function to run every 24 hours.
 * It checks user carts for items that have been left abandoned for over 24 hours
 * and sends a push notification reminder to complete checkout.
 */
exports.sendAbandonedCartReminder = functions.pubsub
  .schedule("every 24 hours")
  .onRun(async (context) => {
    const now = admin.firestore.Timestamp.now();
    const threshold = new Date(now.toDate().getTime() - 24 * 60 * 60 * 1000); // 24 hours ago

    try {
      console.log("Checking for abandoned carts older than: " + threshold.toISOString());

      // Query cart documents updated before the threshold
      const cartsSnapshot = await admin
        .firestore()
        .collection("carts")
        .where("updatedAt", "<=", threshold)
        .get();

      console.log(`Found ${cartsSnapshot.docs.length} candidate carts to check.`);

      for (const cartDoc of cartsSnapshot.docs) {
        const cartData = cartDoc.data();
        const userId = cartDoc.id; // The cart document ID matches the user's UID

        // If cart has items and a reminder hasn't been sent yet
        if (cartData.items && cartData.items.length > 0 && !cartData.cartReminderSent) {
          // Fetch user document for FCM token
          const userDoc = await admin.firestore().collection("users").doc(userId).get();
          if (userDoc.exists) {
            const userData = userDoc.data();
            const fcmToken = userData.fcmToken;

            if (fcmToken) {
              console.log(`Sending abandoned cart reminder to user: ${userId}`);

              const message = {
                token: fcmToken,
                notification: {
                  title: "عربتك بانتظارك! 🛒",
                  body: "لقد نسيت بعض المنتجات المصنوعة يدوياً في سلتك. أكمل طلبك الآن!",
                },
                data: {
                  type: "abandonedCart",
                  targetId: "cart",
                },
              };

              await admin.messaging().send(message);

              // Update reminder sent flag to avoid repeat notifications
              await cartDoc.ref.update({ cartReminderSent: true });

              // Write the notification doc to Firestore so it shows up in their Notification Center
              await admin
                .firestore()
                .collection("users")
                .doc(userId)
                .collection("notifications")
                .add({
                  id: "abandoned-cart-" + Date.now(),
                  title: "عربتك بانتظارك! 🛒",
                  body: "لقد نسيت بعض المنتجات المصنوعة يدوياً في سلتك. أكمل طلبك الآن!",
                  type: 8, // index representing cart alert / custom type
                  createdAt: Date.now(),
                  isRead: false,
                  targetId: "cart",
                });
            }
          }
        }
      }
      return null;
    } catch (error) {
      console.error("Error processing abandoned cart reminders:", error);
      return null;
    }
  });
