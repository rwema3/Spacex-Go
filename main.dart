import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'cubits/index.dart';
import 'repositories/index.dart';
import 'services/index.dart';
import 'utils/index.dart';

Future<void> main() async {
  final httpClient = Dio();
  final notificationsCubit = kIsWeb
      ? null
      : NotificationsCubit(
          FlutterLocalNotificationsPlugin(),
          notificationDetails: NotificationDetails(
            android: AndroidNotificationDetails(
              'channel.launches',
              'Launches notifications',
              'Stay up-to-date with upcoming SpaceX launches',
              importance: Importance.high,
            ),
            iOS: IOSNotificationDetails(),
          ),
          initializationSettings: InitializationSettings(
            android: AndroidInitializationSettings('notification_launch'),
            iOS: IOSInitializationSettings(),
          ),
        );
  await notificationsCubit?.init();

  runApp(CherryApp(
    notificationsCubit: notificationsCubit,
    vehiclesRepository: VehiclesRepository(
      VehiclesService(httpClient),
    ),
    launchesRepository: LaunchesRepository(
      LaunchesService(httpClient),
    ),
    achievementsRepository: AchievementsRepository(
      AchievementsService(httpClient),
    ),

      child: BlocConsumer<ThemeCubit, ThemeState>(
        listener: (context, state) => null,
        builder: (context, state) =>