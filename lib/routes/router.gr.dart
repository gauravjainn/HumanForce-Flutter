// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_route/router_utils.dart';
import 'package:human_forces/pages/human_forces.dart';
import 'package:human_forces/pages/home_screen.dart';
import 'package:human_forces/pages/category_screen.dart';
import 'package:human_forces/pages/product_list_screen.dart';
import 'package:human_forces/models/product_list_model.dart';
import 'package:human_forces/pages/product_without_filter_screen.dart';
import 'package:human_forces/pages/product_detail_screen.dart';
import 'package:human_forces/models/product_selector_model.dart';
import 'package:human_forces/pages/cart_screen.dart';
import 'package:human_forces/pages/my_order_screen.dart';
import 'package:human_forces/pages/profile_screen.dart';
import 'package:human_forces/pages/check_out_screen.dart';
import 'package:human_forces/models/product_model.dart';
import 'package:human_forces/pages/about_us.dart';
import 'package:human_forces/pages/contact_us.dart';
import 'package:human_forces/pages/pre_load_category_screen.dart';

class Router {
  static const humanForces = '/';
  static const homeScreen = '/home-screen';
  static const categoryScreen = '/category-screen';
  static const productListScreen = '/product-list-screen';
  static const productListWithoutFilter = '/product-list-without-filter';
  static const productDetailScreen = '/product-detail-screen';
  static const cartScreen = '/cart-screen';
  static const myOrderScreen = '/my-order-screen';
  static const profileScreen = '/profile-screen';
  static const checkOutScreen = '/check-out-screen';
  static const aboutUsScreen = '/about-us-screen';
  static const contactUsScreen = '/contact-us-screen';
  static const preLoadCategoryScreen = '/pre-load-category-screen';
  static GlobalKey<NavigatorState> get navigatorKey =>
      getNavigatorKey<Router>();
  static NavigatorState get navigator => navigatorKey.currentState;

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case Router.humanForces:
        return MaterialPageRoute(
          builder: (_) => HumanForces(),
          settings: settings,
        );
      case Router.homeScreen:
        return MaterialPageRoute(
          builder: (_) => HomeScreen(),
          settings: settings,
        );
      case Router.categoryScreen:
        if (hasInvalidArgs<String>(args, isRequired: true)) {
          return misTypedArgsRoute<String>(args);
        }
        final typedArgs = args as String;
        return MaterialPageRoute(
          builder: (_) => CategoryScreen(category: typedArgs),
          settings: settings,
        );
      case Router.productListScreen:
        if (hasInvalidArgs<ProductListModel>(args, isRequired: true)) {
          return misTypedArgsRoute<ProductListModel>(args);
        }
        final typedArgs = args as ProductListModel;
        return MaterialPageRoute(
          builder: (_) => ProductListScreen(productListModel: typedArgs),
          settings: settings,
        );
      case Router.productListWithoutFilter:
        if (hasInvalidArgs<String>(args)) {
          return misTypedArgsRoute<String>(args);
        }
        final typedArgs = args as String;
        return MaterialPageRoute(
          builder: (_) => ProductListWithoutFilter(typedArgs),
          settings: settings,
        );
      case Router.productDetailScreen:
        if (hasInvalidArgs<ProductSelectorModel>(args)) {
          return misTypedArgsRoute<ProductSelectorModel>(args);
        }
        final typedArgs = args as ProductSelectorModel;
        return MaterialPageRoute(
          builder: (_) => ProductDetailScreen(typedArgs),
          settings: settings,
        );
      case Router.cartScreen:
        return MaterialPageRoute(
          builder: (_) => CartScreen(),
          settings: settings,
        );
      case Router.myOrderScreen:
        return MaterialPageRoute(
          builder: (_) => MyOrderScreen(),
          settings: settings,
        );
      case Router.profileScreen:
        return MaterialPageRoute(
          builder: (_) => ProfileScreen(),
          settings: settings,
        );
      case Router.checkOutScreen:
        if (hasInvalidArgs<List<ProductModel>>(args, isRequired: true)) {
          return misTypedArgsRoute<List<ProductModel>>(args);
        }
        final typedArgs = args as List<ProductModel>;
        return MaterialPageRoute(
          builder: (_) => CheckOutScreen(productsList: typedArgs),
          settings: settings,
        );
      case Router.aboutUsScreen:
        return MaterialPageRoute(
          builder: (_) => AboutUsScreen(),
          settings: settings,
        );
      case Router.contactUsScreen:
        return MaterialPageRoute(
          builder: (_) => ContactUsScreen(),
          settings: settings,
        );
      case Router.preLoadCategoryScreen:
        if (hasInvalidArgs<String>(args, isRequired: true)) {
          return misTypedArgsRoute<String>(args);
        }
        final typedArgs = args as String;
        return MaterialPageRoute(
          builder: (_) => PreLoadCategoryScreen(category: typedArgs),
          settings: settings,
        );
      default:
        return unknownRoutePage(settings.name);
    }
  }
}
