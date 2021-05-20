class Post {

  String postID;
  String postTitle;
  String postDetail;
  List<String> tags;
  String imageUrl;
  String ownerID;
  String acceptedCommentID;
  int timestamp;

  Post({ this.postID, this.postTitle, this.postDetail, this.tags, this.imageUrl, this.ownerID, this.acceptedCommentID, this.timestamp });
}