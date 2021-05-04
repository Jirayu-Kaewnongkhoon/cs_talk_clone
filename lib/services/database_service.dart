import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cstalk_clone/models/comment.dart';
import 'package:cstalk_clone/models/post.dart';

class DatabaseService {

  final CollectionReference collection = FirebaseFirestore.instance.collection('posts');

  String uid;
  String postID;

  DatabaseService({ this.uid, this.postID });

  Future createPost(String postDetail) async {
    return await collection.add({
      'postDetail': postDetail,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    }).then((doc) => doc.update({
      'postID': doc.id,
    }));
  }

  List<Post> _postsFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) => Post(
      postID: doc.data()['postID'],
      postDetail: doc.data()['postDetail'],
      timestamp: doc.data()['timestamp'],
    )).toList();
  }

  Stream<List<Post>> get posts {
    return collection
      .orderBy('timestamp', descending: true)
      .snapshots()
      .map(_postsFromSnapshot);
  }

  Future createComment(String postID, String commentDetail) async {
    return await collection.doc(postID).collection('comments').add({
      'postID': postID,
      'commentDetail': commentDetail,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    }).then((doc) => doc.update({
      'commentID': doc.id,
    }));
  }

  List<Comment> _commentsFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) => Comment(
      postID: doc.data()['postID'],
      commentID: doc.data()['commentID'],
      commentDetail: doc.data()['commentDetail'],
      timestamp: doc.data()['timestamp'],
    )).toList();
  }

  Stream<List<Comment>> get comments {
    return collection
      .doc(postID)
      .collection('comments')
      .orderBy('timestamp', descending: true)
      .snapshots()
      .map(_commentsFromSnapshot);
  }
}