import 'package:equatable/equatable.dart';
import '../data/models/community_model.dart';

abstract class CommunityEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchPosts extends CommunityEvent {}

class AddPost extends CommunityEvent {
  final CommunityModel post;

  AddPost(this.post);

  @override
  List<Object?> get props => [post];
}

class ToggleReact extends CommunityEvent {
  final String postId;
  final String userId;

  ToggleReact(this.postId, this.userId);

  @override
  List<Object?> get props => [postId, userId];
}

class AddComment extends CommunityEvent {
  final String postId;
  final CommentModel comment;

  AddComment(this.postId, this.comment);

  @override
  List<Object?> get props => [postId, comment];
}
