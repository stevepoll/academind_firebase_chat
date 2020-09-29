import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('chats/va9JV9tf4msAzkPrzMoQ/messages')
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        final docs = chatSnapshot.data.documents;
        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (ctx, index) {
            return Text(docs[index]['text']);
          },
        );
      },
    );
  }
}
