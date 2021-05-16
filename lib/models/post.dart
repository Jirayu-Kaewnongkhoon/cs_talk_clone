class Post {

  String postID;
  String postDetail;
  List<String> tags;
  String imageUrl;
  String ownerID;
  String acceptedCommentID;
  int timestamp;

  Post({ this.postID, this.postDetail, this.tags, this.imageUrl, this.ownerID, this.acceptedCommentID, this.timestamp });
}