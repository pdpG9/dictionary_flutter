
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

import '../data/database_helper.dart';

final GetIt getIt = GetIt.instance;

Future<void> setup() async{
  WidgetsFlutterBinding.ensureInitialized();
  getIt.registerLazySingleton(() => DatabaseHelper());
  await getIt.get<DatabaseHelper>().init();
}