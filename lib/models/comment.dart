class Comment {

  String postID;
  String commentID;
  String commentDetail;
  String imageUrl;
  String ownerID;
  int voteCount;
  List<String> upVoteList;
  List<String> downVoteList;
  bool isAccepted;
  int timestamp;

  Comment({ 
    this.postID, 
    this.commentID, 
    this.commentDetail,
    this.imageUrl,
    this.ownerID, 
    this.voteCount,
    this.upVoteList,
    this.downVoteList, 
    this.isAccepted, 
    this.timestamp 
  });
}