import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:pavlyprivateapp/shared/BLOC_OBSERVER.dart';

import 'layouts/BottomnavigationBar.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BottomnavigationBar(),
      debugShowCheckedModeBanner: false,
    );

  }
  }

