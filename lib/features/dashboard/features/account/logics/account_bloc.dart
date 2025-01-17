import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meditouch/features/dashboard/features/account/logics/account_states.dart';
import '../../../../../common/repository/hive_repository.dart';
import 'account_events.dart';

class AccountBloc extends Bloc<AccountEvents, AccountStates> {
  final HiveRepository hiveRepository;

  AccountBloc({required this.hiveRepository}) : super(AccountInitial()) {
    on<AccountRefreshRequested>(_onRefresh);
    on<AccountLogoutRequested>(_logout);
  }

  /* Method to refresh the user account panel */

  Future<void> _onRefresh(
      AccountRefreshRequested event, Emitter<AccountStates> emit) async {
    emit(AccountLoading());
    try {
      final userInfo = await hiveRepository.getUserInfo();
      emit(AccountLoaded(userInfo!));
    } catch (e) {
      emit(AccountError('Failed to fetch data: ${e.toString()}'));
    }
  }

/* Method to logout the user */
  Future<void> _logout(
      AccountLogoutRequested event, Emitter<AccountStates> emit) async {
    await hiveRepository.deleteUserInfo();
    await clearMessages();
    emit(AccountLogout());
  }


  Future<void> clearMessages() async {
    // Open the Hive box
    Box _chatBox = await Hive.openBox('chatMessages');
    await _chatBox.clear(); // Clears all the stored messages
  }
}
