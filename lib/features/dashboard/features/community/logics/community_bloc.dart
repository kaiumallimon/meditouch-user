import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/models/community_model.dart';
import '../data/repository/community_repository.dart';

import 'community_events.dart';
import 'community_state.dart';

class CommunityBloc extends Bloc<CommunityEvent, CommunityState> {
  final CommunityRepository repository;

  CommunityBloc(this.repository) : super(CommunityInitial()) {
    on<FetchPosts>(_fetchPosts);
    on<AddPost>(_addPost);
    on<ToggleReact>(_toggleReact);
    on<AddComment>(_addComment);
  }

  Future<void> _fetchPosts(
      FetchPosts event, Emitter<CommunityState> emit) async {
    emit(CommunityLoading());
    try {
      final postStream = repository.getPosts();
      await emit.forEach(postStream, onData: (List<CommunityModel> posts) {
        return CommunityLoaded(posts);
      });
    } catch (e) {
      emit(CommunityError('Failed to fetch posts: ${e.toString()}'));
    }
  }

  Future<void> _addPost(AddPost event, Emitter<CommunityState> emit) async {
    try {
      final success = await repository.addPost(event.post);
      if (!success) throw Exception('Failed to add post');
    } catch (e) {
      emit(CommunityError('Failed to add post: ${e.toString()}'));
    }
  }

  Future<void> _toggleReact(
      ToggleReact event, Emitter<CommunityState> emit) async {
    try {
      await repository.toggleReact(event.postId, event.userId);
    } catch (e) {
      emit(CommunityError('Failed to toggle react: ${e.toString()}'));
    }
  }

  Future<void> _addComment(
      AddComment event, Emitter<CommunityState> emit) async {
    try {
      final success = await repository.addComment(event.postId, event.comment);
      if (!success) throw Exception('Failed to add comment');
    } catch (e) {
      emit(CommunityError('Failed to add comment: ${e.toString()}'));
    }
  }
}
