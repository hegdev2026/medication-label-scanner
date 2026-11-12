// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as _i163;
import 'package:get_it/get_it.dart' as _i174;
import 'package:image_picker/image_picker.dart' as _i183;
import 'package:injectable/injectable.dart' as _i526;
import 'package:logger/logger.dart' as _i974;
import 'package:medicine_lab_reader/core/database/app_database.dart' as _i818;
import 'package:medicine_lab_reader/core/di/register_module.dart' as _i298;
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
import 'package:medicine_lab_reader/features/medicines/data/repository/medicine_repository_impl.dart'
    as _i152;
import 'package:medicine_lab_reader/features/medicines/data/sources/medicine_local_data_source.dart'
    as _i1067;
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
import 'package:medicine_lab_reader/features/medicines/domain/usecase/get_medicine_usecase.dart'
    as _i942;
import 'package:medicine_lab_reader/features/medicines/domain/usecase/reschedule_reminders_usecase.dart'
    as _i413;
import 'package:medicine_lab_reader/features/medicines/domain/usecase/save_medicine_usecase.dart'
    as _i151;
import 'package:medicine_lab_reader/features/medicines/domain/usecase/watch_medicine_usecase.dart'
    as _i376;
import 'package:medicine_lab_reader/features/medicines/domain/usecase/watch_medicines_usecase.dart'
    as _i820;
import 'package:medicine_lab_reader/features/medicines/presentation/bloc/inventory/inventory_bloc.dart'
    as _i898;
import 'package:medicine_lab_reader/features/medicines/presentation/bloc/medicine_details/medicine_details_cubit.dart'
    as _i394;
import 'package:medicine_lab_reader/features/medicines/presentation/bloc/medicine_form/medicine_form_cubit.dart'
    as _i568;
import 'package:medicine_lab_reader/features/scanner/data/services/image_source_service_impl.dart'
    as _i617;
import 'package:medicine_lab_reader/features/scanner/data/services/ocr_module.dart'
    as _i1050;
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
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    final ocrModule = _$OcrModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.lazySingleton<_i818.AppDatabase>(() => registerModule.database);
    gh.lazySingleton<_i974.Logger>(() => registerModule.logger);
    gh.lazySingleton<_i183.ImagePicker>(() => registerModule.imagePicker);
    gh.lazySingleton<_i163.FlutterLocalNotificationsPlugin>(
      () => registerModule.notificationsPlugin,
    );
    gh.lazySingleton<_i298.Clock>(() => registerModule.clock);
    gh.lazySingleton<_i781.AppRouter>(() => _i781.AppRouter());
    gh.lazySingleton<_i809.MedicineOcrService>(() => ocrModule.ocr());
    gh.lazySingleton<_i1060.MedicineParser>(() => _i1060.MedicineParser());
    gh.factory<bool>(() => registerModule.isMobile, instanceName: 'isMobile');
    gh.lazySingleton<_i136.ImageStorage>(() => _i745.ImageStorageService());
    gh.lazySingleton<_i367.ImageSourceService>(
      () => _i617.ImageSourceServiceImpl(
        gh<_i183.ImagePicker>(),
        gh<bool>(instanceName: 'isMobile'),
      ),
    );
    gh.lazySingleton<_i232.ReminderScheduler>(
      () => _i731.NotificationService(
        gh<_i163.FlutterLocalNotificationsPlugin>(),
        gh<_i974.Logger>(),
      ),
    );
    gh.lazySingleton<_i656.CheckExpiry>(
      () => _i656.CheckExpiry(gh<_i298.Clock>()),
    );
    gh.lazySingleton<_i546.ThemeCubit>(
      () => _i546.ThemeCubit(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i1067.MedicineLocalDataSource>(
      () => _i1067.MedicineLocalDataSource(gh<_i818.AppDatabase>()),
    );
    gh.lazySingleton<_i343.ScanMedicineUsecase>(
      () => _i343.ScanMedicineUsecase(
        gh<_i809.MedicineOcrService>(),
        gh<_i1060.MedicineParser>(),
      ),
    );
    gh.lazySingleton<_i559.PickImageUsecase>(
      () => _i559.PickImageUsecase(gh<_i367.ImageSourceService>()),
    );
    gh.factory<_i1053.ScanBloc>(
      () => _i1053.ScanBloc(
        gh<_i559.PickImageUsecase>(),
        gh<_i343.ScanMedicineUsecase>(),
      ),
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
    return this;
  }
}

class _$RegisterModule extends _i298.RegisterModule {}

class _$OcrModule extends _i1050.OcrModule {}
