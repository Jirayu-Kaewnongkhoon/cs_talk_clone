import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cstalk_clone/models/comment.dart';
import 'package:cstalk_clone/models/post.dart';
import 'package:cstalk_clone/models/user.dart';

class DatabaseService {

  final CollectionReference collection = FirebaseFirestore.instance.collection('posts');

  String uid;
  String postID;
  String commentID;

  DatabaseService({ this.uid, this.postID, this.commentID });

  Future updateUserData(String uid, String name) async {
    return await FirebaseFirestore.instance.collection('users')
      .doc(uid)
      .set({
        'uid': uid,
        'name': name,
      });
  }

  UserData _userDataFromSnapShot(DocumentSnapshot snapshot) {
    return UserData(
      uid: snapshot.data()['uid'],
      name: snapshot.data()['name'],
    );
  }

  Stream<UserData> get userData {
    return FirebaseFirestore.instance.collection('users')
      .doc(uid)
      .snapshots()
      .map(_userDataFromSnapShot);
  }

  Future createPost(String postDetail, String ownerName) async {
    return await collection.add({
      'postDetail': postDetail,
      'ownerName': ownerName,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    }).then((doc) => doc.update({
      'postID': doc.id,
    }));
  }

  List<Post> _postsFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) => Post(
      postID: doc.data()['postID'],
      postDetail: doc.data()['postDetail'],
      ownerName: doc.data()['ownerName'],
      timestamp: doc.data()['timestamp'],
    )).toList();
  }

  Stream<List<Post>> get posts {
    return collection
      .orderBy('timestamp', descending: true)
      .snapshots()
      .map(_postsFromSnapshot);
  }

  Future createComment(String postID, String commentDetail, String ownerName) async {
    return await collection.doc(postID).collection('comments').add({
      'postID': postID,
      'commentDetail': commentDetail,
      'ownerName': ownerName,
      'voteCount': 0,
      'isUpVote': false,
      'isDownVote': false,
      'isAccepted': false,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    }).then((doc) => doc.update({
      'commentID': doc.id,
    }));
  }

  Future voteComment({ int voteCount, bool isUpVote, bool isDownVote }) async {
    return await collection.doc(postID).collection('comments').doc(commentID).update({
      'isUpVote': isUpVote,
      'isDownVote': isDownVote,
      'voteCount': voteCount,
    });
  }

  List<Comment> _commentsFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) => Comment(
      postID: doc.data()['postID'],
      commentID: doc.data()['commentID'],
      commentDetail: doc.data()['commentDetail'],
      ownerName: doc.data()['ownerName'],
      voteCount: doc.data()['voteCount'],
      isUpVote: doc.data()['isUpVote'],
      isDownVote: doc.data()['isDownVote'],
      isAccepted: doc.data()['isAccepted'],
      timestamp: doc.data()['timestamp'],
    )).toList();
  }

  Stream<List<Comment>> get comments {
    return collection
      .doc(postID)
      .collection('comments')
      .orderBy('voteCount', descending: true)
      .snapshots()
      .map(_commentsFromSnapshot);
  }
}