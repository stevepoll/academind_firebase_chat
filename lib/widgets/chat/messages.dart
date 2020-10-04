import 'package:academind_firebase_chat/widgets/chat/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chats/va9JV9tf4msAzkPrzMoQ/messages')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        final docs = chatSnapshot.data.docs;
        return ListView.builder(
          reverse: true,
          itemCount: docs.length,
          itemBuilder: (ctx, index) {
            final doc = docs[index].data();

            return MessageBubble(
              doc['text'],
              doc['userName'],
              doc['userImage'],
              doc['userId'] == user.uid,
              key: ValueKey(docs[index].id),
            );
          },
        );
      },
    );
  }
}
