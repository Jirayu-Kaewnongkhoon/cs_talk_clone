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

  Future updateUserData(String name) async {
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

  Future createPost(String postDetail) async {
    return await collection.add({
      'postDetail': postDetail,
      'ownerID': uid,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    }).then((doc) => doc.update({
      'postID': doc.id,
    }));
  }

  List<Post> _postsFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) => Post(
      postID: doc.data()['postID'],
      postDetail: doc.data()['postDetail'],
      ownerID: doc.data()['ownerID'],
      acceptedCommentID: doc.data()['acceptedCommentID'],
      timestamp: doc.data()['timestamp'],
    )).toList();
  }

  Stream<List<Post>> get posts {
    return collection
      .orderBy('timestamp', descending: true)
      .snapshots()
      .map(_postsFromSnapshot);
  }

  Future createComment(String commentDetail) async {
    return await collection.doc(postID).collection('comments').add({
      'postID': postID,
      'commentDetail': commentDetail,
      'ownerID': uid,
      'voteCount': 0,
      'upVoteList': <String>[],
      'downVoteList': <String>[],
      'isAccepted': false,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    }).then((doc) => doc.update({
      'commentID': doc.id,
    }));
  }

  Future voteComment({ List<String> upVoteList, List<String> downVoteList }) async {
    return await collection
      .doc(postID)
      .collection('comments')
      .doc(commentID)
      .update({
        'upVoteList': upVoteList,
        'downVoteList': downVoteList,
        'voteCount': upVoteList.length - downVoteList.length,
      });
  }

  // Future acceptComment(bool isAccepted) async {
  //   return await collection
  //     .doc(postID)
  //     .collection('comments')
  //     .doc(commentID)
  //     .update({
  //       'isAccepted': isAccepted,
  //     });
  // }

  Future addAcceptedComment() async {
    return await collection
      .doc(postID)
      .update({
        'acceptedCommentID': commentID,
      });
  }

  List<Comment> _commentsFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) => Comment(
      postID: doc.data()['postID'],
      commentID: doc.data()['commentID'],
      commentDetail: doc.data()['commentDetail'],
      ownerID: doc.data()['ownerID'],
      voteCount: doc.data()['voteCount'],
      upVoteList: List.from(doc.data()['upVoteList']),
      downVoteList: List.from(doc.data()['downVoteList']),
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