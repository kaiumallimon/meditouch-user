import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meditouch/features/dashboard/features/home/data/repository/home_repository.dart';
import 'package:meditouch/features/dashboard/features/home/logics/home_event.dart';
import 'package:meditouch/features/dashboard/features/home/logics/home_state.dart';

import '../../../../../common/repository/hive_repository.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HiveRepository hiveRepository;

  HomeBloc(this.hiveRepository) : super(HomeInitial()) {
    on<HomeRefreshRequested>(_onRefresh);
  }

  Future<void> _onRefresh(
      HomeRefreshRequested event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {
      final userInfo = await hiveRepository.getUserInfo();
      final cartItemsCount =
          await HomeRepository().getCartItemsCount(userInfo!['id']);
      emit(HomeLoaded(userInfo, cartItemsCount));
    } catch (e) {
      emit(HomeError('Failed to fetch data: ${e.toString()}'));
    }
  }
}
