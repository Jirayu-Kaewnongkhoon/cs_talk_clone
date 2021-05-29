import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cstalk_clone/models/comment.dart';
import 'package:cstalk_clone/models/notification.dart';
import 'package:cstalk_clone/models/post.dart';
import 'package:cstalk_clone/models/user.dart';

class UserService {

  final CollectionReference _collection = FirebaseFirestore.instance.collection('users');

  String uid;

  UserService({ this.uid });

  Future updateUserData({ String name, String imageUrl }) async {
    return await _collection
      .doc(uid)
      .set({
        'uid': uid,
        'name': name,
        'imageUrl': imageUrl,
      });
  }

  UserData _userDataFromSnapShot(DocumentSnapshot snapshot) {
    return UserData(
      uid: snapshot.data()['uid'],
      name: snapshot.data()['name'],
      imageUrl: snapshot.data()['imageUrl'],
    );
  }

  Stream<UserData> get userData {
    return _collection
      .doc(uid)
      .snapshots()
      .map(_userDataFromSnapShot);
  }
}

class PostService {

  final CollectionReference _collection = FirebaseFirestore.instance.collection('posts');

  String uid;
  String postID;
  String commentID;
  String tag;

  PostService({ this.uid, this.postID, this.commentID, this.tag });

  Future createPost(String postTitle, String postDetail, List<String> tags, String imageUrl) async {
    return await _collection.add({
      'postTitle': postTitle,
      'postDetail': postDetail,
      'tags': tags,
      'imageUrl': imageUrl,
      'ownerID': uid,
      'acceptedCommentID': '',
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    }).then((doc) => doc.update({
      'postID': doc.id,
    }));
  }

  Future updatePost({ String postTitle, String postDetail, String imageUrl, List<String> tags }) async {
    return await _collection
      .doc(postID)
      .update({
        'postTitle': postTitle,
        'postDetail': postDetail,
        'imageUrl': imageUrl,
        'tags': tags,
      });
  }

  Future removePost() async {
    return await _collection.doc(postID).delete();
  }

  List<Post> _postsFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) => Post(
      postID: doc.data()['postID'],
      postTitle: doc.data()['postTitle'],
      postDetail: doc.data()['postDetail'],
      tags: List<String>.from(doc.data()['tags']),
      imageUrl: doc.data()['imageUrl'],
      ownerID: doc.data()['ownerID'],
      acceptedCommentID: doc.data()['acceptedCommentID'],
      timestamp: doc.data()['timestamp'],
    )).toList();
  }

  Post _postFromSnapshot(DocumentSnapshot snapshot) {
    return Post(
      postID: snapshot.data()['postID'],
      postTitle: snapshot.data()['postTitle'],
      postDetail: snapshot.data()['postDetail'],
      imageUrl: snapshot.data()['imageUrl'],
      tags: List<String>.from(snapshot.data()['tags']),
      ownerID: snapshot.data()['ownerID'],
      acceptedCommentID: snapshot.data()['acceptedCommentID'],
      timestamp: snapshot.data()['timestamp'],
    );
  }

  Stream<List<Post>> get allPosts {
    return _collection
      .orderBy('timestamp', descending: true)
      .snapshots()
      .map(_postsFromSnapshot);
  }

  Stream<Post> get postByID {
    return _collection
      .doc(postID)
      .snapshots()
      .map(_postFromSnapshot);
  }
  
  Stream<List<Post>> get postsByTag {
    return _collection
      .where('tags', arrayContains: tag)
      .orderBy('timestamp', descending: true)
      .snapshots()
      .map(_postsFromSnapshot);
  }

  Stream<List<Post>> get postsByUser {
    return _collection
      .where('ownerID', isEqualTo: uid)
      .orderBy('timestamp', descending: true)
      .snapshots()
      .map(_postsFromSnapshot);
  }

  Stream<String> get acceptedCommentID {
    return _collection
      .doc(postID)
      .snapshots()
      .map((doc) => doc.data()['acceptedCommentID']);
  }
}

class CommentService {

  final CollectionReference _collection = FirebaseFirestore.instance.collection('posts');

  String uid;
  String postID;
  String commentID;

  CommentService({ this.uid, this.postID, this.commentID });

  Future createComment({ String commentDetail, String imageUrl }) async {
    return await _collection.doc(postID).collection('comments').add({
      'postID': postID,
      'commentDetail': commentDetail,
      'imageUrl': imageUrl,
      'ownerID': uid,
      'voteCount': 0,
      'upVoteList': <String>[],
      'downVoteList': <String>[],
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    }).then((doc) => doc.update({
      'commentID': doc.id,
    }));
  }

  Future updateComment(String commentDetail, String imageUrl) async {
    return await _collection
      .doc(postID)
      .collection('comments')
      .doc(commentID)
      .update({
        'commentDetail': commentDetail,
        'imageUrl': imageUrl,
      });
  }

  Future removeComment() async {
    return await _collection
      .doc(postID)
      .collection('comments')
      .doc(commentID)
      .delete();
  }

  Future voteComment({ List<String> upVoteList, List<String> downVoteList }) async {
    return await _collection
      .doc(postID)
      .collection('comments')
      .doc(commentID)
      .update({
        'upVoteList': upVoteList,
        'downVoteList': downVoteList,
        'voteCount': upVoteList.length - downVoteList.length,
      });
  }

  Future addAcceptedComment() async {
    return await _collection
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
      imageUrl: doc.data()['imageUrl'],
      ownerID: doc.data()['ownerID'],
      voteCount: doc.data()['voteCount'],
      upVoteList: List.from(doc.data()['upVoteList']),
      downVoteList: List.from(doc.data()['downVoteList']),
      timestamp: doc.data()['timestamp'],
    )).toList();
  }

  Stream<List<Comment>> get comments {
    return _collection
      .doc(postID)
      .collection('comments')
      .orderBy('voteCount', descending: true)
      .snapshots()
      .map(_commentsFromSnapshot);
  }

  Stream<int> get totalComment {
    return _collection
      .doc(postID)
      .collection('comments')
      .snapshots()
      .map((doc) => doc.size);
  }
}

class NotificationService {

  CollectionReference _collection = FirebaseFirestore.instance.collection('notifications');

  String uid;
  String notificationID;
  String postID;

  NotificationService({ this.uid, this.notificationID, this.postID });

  Future createNotificaion(String type, String userID) async {
    return await _collection.doc(uid).collection('items').add({
      'postID': postID,
      'userID': userID,
      'isActivate': false,
      'type': type,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    }).then((doc) => doc.update({
      'notificationID': doc.id,
    }));
  }

  Future updateNotificaionStatus() async {
    return await _collection
      .doc(uid)
      .collection('items')
      .doc(notificationID)
      .update({
        'isActivate': true,
      });
  }

  Future removeNotification() async {
    return await _collection
      .doc(uid)
      .collection('items')
      .doc(notificationID)
      .delete();
  }

  List<NotificationObject> _notificationsFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) => NotificationObject(
      notificationID: doc.data()['notificationID'],
      postID: doc.data()['postID'],
      userID: doc.data()['userID'],
      isActivate: doc.data()['isActivate'],
      type: doc.data()['type'],
      timestamp: doc.data()['timestamp'],
    )).toList();
  }

  Stream<List<NotificationObject>> get notifications {
    return _collection
      .doc(uid)
      .collection('items')
      .orderBy('timestamp', descending: true)
      .snapshots()
      .map(_notificationsFromSnapshot);
  }

  Future<List<NotificationObject>> get notificationsByPostID async {
    return await _collection
      .doc(uid)
      .collection('items')
      .where('postID', isEqualTo: postID)
      .get()
      .then((snapshot) => _notificationsFromSnapshot(snapshot));
  }

  Future<List<NotificationObject>> get all async {
    return await _collection
      .doc(uid)
      .collection('items')
      .get()
      .then((snapshot) => _notificationsFromSnapshot(snapshot));
  }
}