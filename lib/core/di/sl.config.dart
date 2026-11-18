// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:dio/dio.dart' as _i361;
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as _i163;
import 'package:get_it/get_it.dart' as _i174;
import 'package:image_picker/image_picker.dart' as _i183;
import 'package:injectable/injectable.dart' as _i526;
import 'package:logger/logger.dart' as _i974;
import 'package:medicine_lab_reader/core/ads/ad_service.dart' as _i329;
import 'package:medicine_lab_reader/core/ads/ad_service_impl.dart' as _i581;
import 'package:medicine_lab_reader/core/ads/ads_cubit.dart' as _i565;
import 'package:medicine_lab_reader/core/ads/app_open_gate.dart' as _i225;
import 'package:medicine_lab_reader/core/database/app_database.dart' as _i818;
import 'package:medicine_lab_reader/core/di/register_module.dart' as _i298;
import 'package:medicine_lab_reader/core/network/dio/dio_client.dart' as _i49;
import 'package:medicine_lab_reader/core/network/dio/dio_module.dart' as _i526;
import 'package:medicine_lab_reader/core/network/network_info.dart' as _i17;
import 'package:medicine_lab_reader/core/router/app_router.dart' as _i781;
import 'package:medicine_lab_reader/core/services/image_storage_service.dart'
    as _i745;
import 'package:medicine_lab_reader/core/services/notification_service.dart'
    as _i731;
import 'package:medicine_lab_reader/core/theme/theme_cubit.dart' as _i546;
import 'package:medicine_lab_reader/features/dashboard/presentation/bloc/dashboard_cubit.dart'
    as _i418;
import 'package:medicine_lab_reader/features/expiry/presentation/bloc/expiry_tracker_cubit.dart'
    as _i2;
import 'package:medicine_lab_reader/features/medicines/data/repository/form_hints_repository_impl.dart'
    as _i919;
import 'package:medicine_lab_reader/features/medicines/data/repository/medicine_info_repository_impl.dart'
    as _i435;
import 'package:medicine_lab_reader/features/medicines/data/repository/medicine_products_repository_impl.dart'
    as _i971;
import 'package:medicine_lab_reader/features/medicines/data/repository/medicine_repository_impl.dart'
    as _i152;
import 'package:medicine_lab_reader/features/medicines/data/sources/dailymed_source.dart'
    as _i793;
import 'package:medicine_lab_reader/features/medicines/data/sources/ingredient_resolver.dart'
    as _i685;
import 'package:medicine_lab_reader/features/medicines/data/sources/medicine_info_cache.dart'
    as _i364;
import 'package:medicine_lab_reader/features/medicines/data/sources/medicine_local_data_source.dart'
    as _i1067;
import 'package:medicine_lab_reader/features/medicines/data/sources/medlineplus_source.dart'
    as _i572;
import 'package:medicine_lab_reader/features/medicines/data/sources/openfda_source.dart'
    as _i48;
import 'package:medicine_lab_reader/features/medicines/data/sources/pubchem_source.dart'
    as _i652;
import 'package:medicine_lab_reader/features/medicines/data/sources/rxnorm_source.dart'
    as _i414;
import 'package:medicine_lab_reader/features/medicines/data/sources/wikidata_source.dart'
    as _i627;
import 'package:medicine_lab_reader/features/medicines/data/sources/wikipedia_source.dart'
    as _i729;
import 'package:medicine_lab_reader/features/medicines/domain/repo/form_hints_repository.dart'
    as _i51;
import 'package:medicine_lab_reader/features/medicines/domain/repo/medicine_info_repository.dart'
    as _i9;
import 'package:medicine_lab_reader/features/medicines/domain/repo/medicine_products_repository.dart'
    as _i259;
import 'package:medicine_lab_reader/features/medicines/domain/repo/medicine_repository.dart'
    as _i4;
import 'package:medicine_lab_reader/features/medicines/domain/services/check_expiry.dart'
    as _i656;
import 'package:medicine_lab_reader/features/medicines/domain/services/image_storage.dart'
    as _i136;
import 'package:medicine_lab_reader/features/medicines/domain/services/reminder_scheduler.dart'
    as _i232;
import 'package:medicine_lab_reader/features/medicines/domain/usecase/delete_medicine_usecase.dart'
    as _i953;
import 'package:medicine_lab_reader/features/medicines/domain/usecase/find_duplicates_usecase.dart'
    as _i767;
import 'package:medicine_lab_reader/features/medicines/domain/usecase/get_form_hints_usecase.dart'
    as _i785;
import 'package:medicine_lab_reader/features/medicines/domain/usecase/get_medicine_info_usecase.dart'
    as _i286;
import 'package:medicine_lab_reader/features/medicines/domain/usecase/get_medicine_products_usecase.dart'
    as _i358;
import 'package:medicine_lab_reader/features/medicines/domain/usecase/get_medicine_usecase.dart'
    as _i942;
import 'package:medicine_lab_reader/features/medicines/domain/usecase/reschedule_reminders_usecase.dart'
    as _i413;
import 'package:medicine_lab_reader/features/medicines/domain/usecase/save_medicine_usecase.dart'
    as _i151;
import 'package:medicine_lab_reader/features/medicines/domain/usecase/suggest_medicine_names_usecase.dart'
    as _i408;
import 'package:medicine_lab_reader/features/medicines/domain/usecase/watch_medicine_usecase.dart'
    as _i376;
import 'package:medicine_lab_reader/features/medicines/domain/usecase/watch_medicines_usecase.dart'
    as _i820;
import 'package:medicine_lab_reader/features/medicines/presentation/bloc/form_hints/form_hints_cubit.dart'
    as _i229;
import 'package:medicine_lab_reader/features/medicines/presentation/bloc/inventory/inventory_bloc.dart'
    as _i898;
import 'package:medicine_lab_reader/features/medicines/presentation/bloc/medicine_details/medicine_details_cubit.dart'
    as _i394;
import 'package:medicine_lab_reader/features/medicines/presentation/bloc/medicine_form/medicine_form_cubit.dart'
    as _i568;
import 'package:medicine_lab_reader/features/medicines/presentation/bloc/medicine_info/medicine_info_cubit.dart'
    as _i562;
import 'package:medicine_lab_reader/features/scanner/data/services/cloud_scan_settings_impl.dart'
    as _i630;
import 'package:medicine_lab_reader/features/scanner/data/services/image_source_service_impl.dart'
    as _i617;
import 'package:medicine_lab_reader/features/scanner/data/services/ocr_module.dart'
    as _i1050;
import 'package:medicine_lab_reader/features/scanner/data/services/ocr_space_service.dart'
    as _i484;
import 'package:medicine_lab_reader/features/scanner/domain/services/cloud_ocr_service.dart'
    as _i318;
import 'package:medicine_lab_reader/features/scanner/domain/services/cloud_scan_settings.dart'
    as _i633;
import 'package:medicine_lab_reader/features/scanner/domain/services/image_source_service.dart'
    as _i367;
import 'package:medicine_lab_reader/features/scanner/domain/services/medicine_ocr_service.dart'
    as _i809;
import 'package:medicine_lab_reader/features/scanner/domain/services/medicine_parser.dart'
    as _i1060;
import 'package:medicine_lab_reader/features/scanner/domain/usecase/pick_image_usecase.dart'
    as _i559;
import 'package:medicine_lab_reader/features/scanner/domain/usecase/scan_medicine_usecase.dart'
    as _i343;
import 'package:medicine_lab_reader/features/scanner/presentation/bloc/scan_bloc.dart'
    as _i1053;
import 'package:medicine_lab_reader/features/search/presentation/bloc/products_cubit.dart'
    as _i543;
import 'package:medicine_lab_reader/features/search/presentation/bloc/search_cubit.dart'
    as _i512;
import 'package:medicine_lab_reader/features/search/presentation/bloc/suggestions_cubit.dart'
    as _i371;
import 'package:medicine_lab_reader/features/settings/presentation/bloc/cloud_scan_cubit.dart'
    as _i554;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    final dioModule = _$DioModule();
    final ocrModule = _$OcrModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.factory<_i512.SearchCubit>(() => _i512.SearchCubit());
    gh.lazySingleton<_i225.AppOpenGate>(() => _i225.AppOpenGate());
    gh.lazySingleton<_i818.AppDatabase>(() => registerModule.database);
    gh.lazySingleton<_i974.Logger>(() => registerModule.logger);
    gh.lazySingleton<_i183.ImagePicker>(() => registerModule.imagePicker);
    gh.lazySingleton<_i163.FlutterLocalNotificationsPlugin>(
      () => registerModule.notificationsPlugin,
    );
    gh.lazySingleton<_i298.Clock>(() => registerModule.clock);
    gh.lazySingleton<_i361.Dio>(() => dioModule.dio());
    gh.lazySingleton<_i781.AppRouter>(() => _i781.AppRouter());
    gh.lazySingleton<_i809.MedicineOcrService>(() => ocrModule.ocr());
    gh.lazySingleton<_i1060.MedicineParser>(() => _i1060.MedicineParser());
    gh.factory<bool>(() => registerModule.isMobile, instanceName: 'isMobile');
    gh.lazySingleton<_i136.ImageStorage>(() => _i745.ImageStorageService());
    gh.lazySingleton<_i17.NetworkInfo>(() => _i17.NetworkInfoImpl());
    gh.lazySingleton<_i329.AdService>(() => _i581.AdServiceImpl());
    gh.lazySingleton<_i565.AdsCubit>(
      () => _i565.AdsCubit(gh<_i329.AdService>(), gh<_i225.AppOpenGate>()),
    );
    gh.lazySingleton<_i656.CheckExpiry>(
      () => _i656.CheckExpiry(gh<_i298.Clock>()),
    );
    gh.lazySingleton<_i546.ThemeCubit>(
      () => _i546.ThemeCubit(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i364.MedicineInfoCache>(
      () => _i364.MedicineInfoCache(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i633.CloudScanSettings>(
      () => _i630.CloudScanSettingsImpl(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i49.DioClient>(
      () => _i49.DioClient(gh<_i361.Dio>(), gh<_i17.NetworkInfo>()),
    );
    gh.lazySingleton<_i1067.MedicineLocalDataSource>(
      () => _i1067.MedicineLocalDataSource(gh<_i818.AppDatabase>()),
    );
    gh.lazySingleton<_i367.ImageSourceService>(
      () => _i617.ImageSourceServiceImpl(
        gh<_i183.ImagePicker>(),
        gh<bool>(instanceName: 'isMobile'),
        gh<_i225.AppOpenGate>(),
      ),
    );
    gh.lazySingleton<_i232.ReminderScheduler>(
      () => _i731.NotificationService(
        gh<_i163.FlutterLocalNotificationsPlugin>(),
        gh<_i974.Logger>(),
        gh<_i225.AppOpenGate>(),
      ),
    );
    gh.factory<_i554.CloudScanCubit>(
      () => _i554.CloudScanCubit(gh<_i633.CloudScanSettings>()),
    );
    gh.lazySingleton<_i318.CloudOcrService>(
      () => _i484.OcrSpaceService(gh<_i49.DioClient>()),
    );
    gh.lazySingleton<_i559.PickImageUsecase>(
      () => _i559.PickImageUsecase(gh<_i367.ImageSourceService>()),
    );
    gh.lazySingleton<_i343.ScanMedicineUsecase>(
      () => _i343.ScanMedicineUsecase(
        gh<_i809.MedicineOcrService>(),
        gh<_i1060.MedicineParser>(),
        gh<_i318.CloudOcrService>(),
        gh<_i633.CloudScanSettings>(),
      ),
    );
    gh.lazySingleton<_i793.DailyMedSource>(
      () => _i793.DailyMedSource(gh<_i49.DioClient>()),
    );
    gh.lazySingleton<_i572.MedlinePlusSource>(
      () => _i572.MedlinePlusSource(gh<_i49.DioClient>()),
    );
    gh.lazySingleton<_i652.PubChemSource>(
      () => _i652.PubChemSource(gh<_i49.DioClient>()),
    );
    gh.lazySingleton<_i414.RxNormSource>(
      () => _i414.RxNormSource(gh<_i49.DioClient>()),
    );
    gh.lazySingleton<_i627.WikidataSource>(
      () => _i627.WikidataSource(gh<_i49.DioClient>()),
    );
    gh.lazySingleton<_i729.WikipediaSource>(
      () => _i729.WikipediaSource(gh<_i49.DioClient>()),
    );
    gh.lazySingleton<_i4.MedicineRepository>(
      () => _i152.MedicineRepositoryImpl(gh<_i1067.MedicineLocalDataSource>()),
    );
    gh.lazySingleton<_i767.FindDuplicatesUsecase>(
      () => _i767.FindDuplicatesUsecase(gh<_i4.MedicineRepository>()),
    );
    gh.lazySingleton<_i942.GetMedicineUsecase>(
      () => _i942.GetMedicineUsecase(gh<_i4.MedicineRepository>()),
    );
    gh.lazySingleton<_i376.WatchMedicineUsecase>(
      () => _i376.WatchMedicineUsecase(gh<_i4.MedicineRepository>()),
    );
    gh.lazySingleton<_i820.WatchMedicinesUsecase>(
      () => _i820.WatchMedicinesUsecase(gh<_i4.MedicineRepository>()),
    );
    gh.factory<_i418.DashboardCubit>(
      () => _i418.DashboardCubit(gh<_i820.WatchMedicinesUsecase>()),
    );
    gh.factory<_i1053.ScanBloc>(
      () => _i1053.ScanBloc(
        gh<_i559.PickImageUsecase>(),
        gh<_i343.ScanMedicineUsecase>(),
        gh<_i633.CloudScanSettings>(),
      ),
    );
    gh.lazySingleton<_i48.OpenFdaSource>(
      () =>
          _i48.OpenFdaSource(gh<_i49.DioClient>(), gh<_i793.DailyMedSource>()),
    );
    gh.lazySingleton<_i413.RescheduleRemindersUsecase>(
      () => _i413.RescheduleRemindersUsecase(
        gh<_i4.MedicineRepository>(),
        gh<_i232.ReminderScheduler>(),
      ),
    );
    gh.lazySingleton<_i953.DeleteMedicineUsecase>(
      () => _i953.DeleteMedicineUsecase(
        gh<_i4.MedicineRepository>(),
        gh<_i136.ImageStorage>(),
        gh<_i232.ReminderScheduler>(),
      ),
    );
    gh.lazySingleton<_i151.SaveMedicineUsecase>(
      () => _i151.SaveMedicineUsecase(
        gh<_i4.MedicineRepository>(),
        gh<_i136.ImageStorage>(),
        gh<_i232.ReminderScheduler>(),
      ),
    );
    gh.lazySingleton<_i685.IngredientResolver>(
      () => _i685.IngredientResolver(gh<_i414.RxNormSource>()),
    );
    gh.factory<_i394.MedicineDetailsCubit>(
      () => _i394.MedicineDetailsCubit(
        gh<_i376.WatchMedicineUsecase>(),
        gh<_i953.DeleteMedicineUsecase>(),
      ),
    );
    gh.factory<_i568.MedicineFormCubit>(
      () => _i568.MedicineFormCubit(
        gh<_i151.SaveMedicineUsecase>(),
        gh<_i767.FindDuplicatesUsecase>(),
        gh<_i942.GetMedicineUsecase>(),
      ),
    );
    gh.lazySingleton<_i51.FormHintsRepository>(
      () => _i919.FormHintsRepositoryImpl(
        gh<_i414.RxNormSource>(),
        gh<_i48.OpenFdaSource>(),
        gh<_i685.IngredientResolver>(),
      ),
    );
    gh.lazySingleton<_i9.MedicineInfoRepository>(
      () => _i435.MedicineInfoRepositoryImpl(
        gh<_i364.MedicineInfoCache>(),
        gh<_i414.RxNormSource>(),
        gh<_i48.OpenFdaSource>(),
        gh<_i572.MedlinePlusSource>(),
        gh<_i729.WikipediaSource>(),
        gh<_i627.WikidataSource>(),
        gh<_i652.PubChemSource>(),
      ),
    );
    gh.factory<_i2.ExpiryTrackerCubit>(
      () => _i2.ExpiryTrackerCubit(
        gh<_i820.WatchMedicinesUsecase>(),
        gh<_i953.DeleteMedicineUsecase>(),
      ),
    );
    gh.factory<_i898.InventoryBloc>(
      () => _i898.InventoryBloc(
        gh<_i820.WatchMedicinesUsecase>(),
        gh<_i953.DeleteMedicineUsecase>(),
      ),
    );
    gh.lazySingleton<_i259.MedicineProductsRepository>(
      () => _i971.MedicineProductsRepositoryImpl(
        gh<_i414.RxNormSource>(),
        gh<_i685.IngredientResolver>(),
      ),
    );
    gh.lazySingleton<_i785.GetFormHintsUsecase>(
      () => _i785.GetFormHintsUsecase(gh<_i51.FormHintsRepository>()),
    );
    gh.factory<_i229.FormHintsCubit>(
      () => _i229.FormHintsCubit(gh<_i785.GetFormHintsUsecase>()),
    );
    gh.lazySingleton<_i286.GetMedicineInfoUsecase>(
      () => _i286.GetMedicineInfoUsecase(gh<_i9.MedicineInfoRepository>()),
    );
    gh.lazySingleton<_i408.SuggestMedicineNamesUsecase>(
      () => _i408.SuggestMedicineNamesUsecase(gh<_i9.MedicineInfoRepository>()),
    );
    gh.lazySingleton<_i358.GetMedicineProductsUsecase>(
      () => _i358.GetMedicineProductsUsecase(
        gh<_i259.MedicineProductsRepository>(),
      ),
    );
    gh.factory<_i371.SuggestionsCubit>(
      () => _i371.SuggestionsCubit(gh<_i408.SuggestMedicineNamesUsecase>()),
    );
    gh.factory<_i562.MedicineInfoCubit>(
      () => _i562.MedicineInfoCubit(gh<_i286.GetMedicineInfoUsecase>()),
    );
    gh.factory<_i543.ProductsCubit>(
      () => _i543.ProductsCubit(gh<_i358.GetMedicineProductsUsecase>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i298.RegisterModule {}

class _$DioModule extends _i526.DioModule {}

class _$OcrModule extends _i1050.OcrModule {}
