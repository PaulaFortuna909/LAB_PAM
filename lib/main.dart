import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/app_theme.dart';
import 'data/repositories/clinic_repository.dart';
import 'logic/home/home_cubit.dart';
import 'screens/home_screen.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );
  runApp(Lab3App(repository: JsonClinicRepository()));
}

class Lab3App extends StatelessWidget {
  const Lab3App({super.key, required this.repository});

  final ClinicRepository repository;

  @override
  Widget build(BuildContext context) {
    // HomeCubit e deasupra lui MaterialApp ca să fie accesibil
    // și din pagina de detalii (favorite sincronizate).
    return BlocProvider(
      create: (_) => HomeCubit(repository)..load(),
      child: MaterialApp(
        title: 'Lab 3 - State Management',
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(),
        home: const HomeScreen(),
      ),
    );
  }
}
