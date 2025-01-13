import '../features/dashboard/features/cart/data/cart_repository.dart';
import '../features/dashboard/features/cart/logics/cart_bloc.dart';
import '../features/dashboard/features/doctors/logics/doctors_bloc.dart';
import '../features/dashboard/features/epharmacy/logics/medicine_scan_bloc.dart';
import '../features/dashboard/features/order/logics/order_bloc.dart';
import './app_exporter.dart';

final providers = [
  // splash bloc
  BlocProvider<SplashBloc>(create: (_) => SplashBloc()),
  // welcome cubit
  BlocProvider<WelcomeCubit>(create: (_) => WelcomeCubit()),
  // register cubits
  BlocProvider<DateCubit>(create: (_) => DateCubit()),
  // gender cubit
  BlocProvider<GenderCubit>(create: (_) => GenderCubit()),
  // imagepicker cubit
  BlocProvider<ImagePickerCubit>(create: (_) => ImagePickerCubit()),
  // register bloc
  BlocProvider<RegisterBloc>(
    create: (_) => RegisterBloc(),
  ),

  // login bloc
  BlocProvider<LoginBloc>(
    create: (_) => LoginBloc(loginRepository: LoginRepository()),
  ),
  // navigation cubit
  BlocProvider<NavigationCubit>(create: (_) => NavigationCubit()),

  // home bloc
  BlocProvider<HomeBloc>(
      create: (_) => HomeBloc(HiveRepository())..add(HomeRefreshRequested())),

  // account bloc
  BlocProvider<AccountBloc>(
      create: (_) => AccountBloc(hiveRepository: HiveRepository())
        ..add(const AccountRefreshRequested())),

  // theme cubit
  BlocProvider<ThemeCubit>(create: (_) => ThemeCubit()),

  // profile bloc
  BlocProvider<ProfileBloc>(
    create: (_) => ProfileBloc(
      profileRepository: ProfileRepository(),
    ),
  ),

  // ephearmacy bloc
  BlocProvider<EpharmacyBloc>(
    create: (_) => EpharmacyBloc(),
  ),

  // add the detailed medicine bloc
  BlocProvider<DetailedMedicineBloc>(create: (_) => DetailedMedicineBloc()),

  // add the search bloc
  BlocProvider<EpharmacySearchBloc>(
    create: (_) => EpharmacySearchBloc(),
  ),

  // add cart bloc
  BlocProvider<CartBloc>(
    create: (_) => CartBloc(
      CartRepository(),
    ),
  ),

  // add payment cubit
  BlocProvider<PaymentCubit>(
    create: (_) => PaymentCubit(),
  ),

  // add address cubit
  BlocProvider<AddressCubit>(
    create: (_) => AddressCubit(),
  ),

  // add order bloc
  BlocProvider<OrderBloc>(
    create: (_) => OrderBloc(),
  ),

  // add medicine scan bloc
  BlocProvider<MedicineScanBloc>(
    create: (_) => MedicineScanBloc(),
  ),


  ///  add the doctors bloc
  /// 
  BlocProvider<DoctorsBloc>(
    create: (_) => DoctorsBloc(),
  ),
];
