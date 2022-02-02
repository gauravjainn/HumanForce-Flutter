import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:human_forces/cubits/user_cubit/user_cubit.dart';
import 'package:human_forces/pages/home_screen.dart';
import 'package:human_forces/pages/login_screen.dart';

class HumanForces extends StatefulWidget {
  const HumanForces();

  @override
  _HumanForcesState createState() => _HumanForcesState();
}

class _HumanForcesState extends State<HumanForces> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        if (state is UserLoggedIn) {
          return HomeScreen();
        } else {
          return LoginScreen();
        }
      },
    );
  }
}
