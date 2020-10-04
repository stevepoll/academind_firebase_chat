const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

exports.myFunction = functions.firestore
  .document('chats/va9JV9tf4msAzkPrzMoQ/messages/{message}')
  .onCreate((snap, context) => {
    const snapData = snap.data();
    return admin.messaging().sendToTopic('chat', {
      notification: {
        title: snapData.userName, 
        body: snapData.text,
        clickAction: 'FLUTTER_NOTIFICATION_CLICK',
      }
    });
  });
