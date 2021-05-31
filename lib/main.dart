import 'package:cov19_app/app/services/api.dart';
import 'package:cov19_app/app/services/api_service.dart';
import 'package:cov19_app/app/services/data_cache_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app/repositories/data_repositories.dart';
import 'app/ui/dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Intl.defaultLocale = 'id_ID';
  await initializeDateFormatting();
  final sharedPreferences = await SharedPreferences.getInstance();
  runApp(MyApp(sharedPreferences: sharedPreferences,));
}

class MyApp extends StatelessWidget {
  final SharedPreferences sharedPreferences;

  const MyApp({Key? key, required this.sharedPreferences}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider<DataRepositories>(
      create: (_) => DataRepositories(
        service: APIService(
          api: API.sandbox(),
        ),
        dataCacheService: DataCacheService(sharedPreferences: sharedPreferences)
      ),
      child: MaterialApp(
        title: 'Coronavirus Tracker',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Color(0xff101010),
          cardColor:Color(0xff222222),
        ),
        home: Dashboard(),
      ),
    );
  }
}
