import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meditouch/features/dashboard/features/account/logics/account_states.dart';

import '../../../../../common/repository/hive_repository.dart';
import 'account_events.dart';

class AccountBloc extends Bloc<AccountEvents, AccountStates> {
  final HiveRepository hiveRepository;

  AccountBloc({required this.hiveRepository}) : super(AccountInitial()) {
    on<AccountRefreshRequested>(_onRefresh);
  }

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
}
