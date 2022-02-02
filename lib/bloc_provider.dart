import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:human_forces/app.dart';
import 'package:human_forces/cubits/cart_cubit/cart_cubit.dart';
import 'package:human_forces/cubits/category_cubit/category_cubit.dart';
import 'package:human_forces/cubits/home_cubit/home_cubit.dart';
import 'package:human_forces/cubits/login_cubit/login_cubit.dart';
import 'package:human_forces/cubits/my_order_cubit/my_orders_cubit.dart';
import 'package:human_forces/cubits/navigator_cubit/navigator_cubit.dart';
import 'package:human_forces/cubits/place_order_cubit/place_order_cubit.dart';
import 'package:human_forces/cubits/product_list_without_filter_cubit/product_list_without_filter_cubit.dart';

import 'package:human_forces/cubits/user_cubit/user_cubit.dart';
import 'package:human_forces/repositories/category_repository.dart';
import 'package:human_forces/repositories/home_repository.dart';
import 'package:human_forces/repositories/login_repository.dart';
import 'package:human_forces/repositories/order_repository.dart';
import 'package:human_forces/repositories/product_repository.dart';

class BlocProviderScreen extends StatefulWidget {
  @override
  _BlocProviderScreenState createState() => _BlocProviderScreenState();
}

class _BlocProviderScreenState extends State<BlocProviderScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => ProductRepository()),
        RepositoryProvider(create: (context) => LoginRepository()),
        RepositoryProvider(create: (context) => HomeRepository()),
        RepositoryProvider(create: (context) => CategoryRepository()),
        RepositoryProvider(create: (context) => OrderRepository()),
      ],
      child: MultiBlocProvider(providers: [
        BlocProvider(
          create: (context) => UserCubit(),
        ),
        BlocProvider(
          create: (context) => LoginCubit(
            LoginRepository(),
            BlocProvider.of<UserCubit>(context),
          ),
        ),
        BlocProvider(
          create: (context) => HomeCubit(context.repository<HomeRepository>()),
        ),
        BlocProvider(
          create: (context) => NavigatorCubit(),
        ),
        BlocProvider(
          create: (context) => CategoryCubit(
              context.repository<CategoryRepository>(),
              context.repository<ProductRepository>()),
        ),
        BlocProvider(
          create: (context) => CartCubit(List()),
        ),
        BlocProvider(
          create: (context) =>
              MyOrdersCubit(context.repository<OrderRepository>()),
        ),
        BlocProvider(
          create: (context) => ProductListWithoutFilterCubit(
              productRepository: context.repository<ProductRepository>()),
        ),
        BlocProvider(
          create: (context) => PlaceOrderCubit(
              orderRepository: context.repository<OrderRepository>()),
        ),
      ], child: App()),
    );
  }
}
