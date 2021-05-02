import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cstalk_clone/models/post.dart';

class DatabaseService {

  final CollectionReference collection = FirebaseFirestore.instance.collection('posts');

  String uid;

  DatabaseService({ this.uid });

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
}