import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:human_forces/bloc_provider.dart';
import 'package:human_forces/blocs/simple_bloc_observer.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();

  HydratedBloc.storage = await HydratedStorage.build();

  runApp(BlocProviderScreen());
}
