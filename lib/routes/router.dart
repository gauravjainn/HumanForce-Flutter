import 'package:human_forces/pages/about_us.dart';

import 'package:human_forces/pages/cart_screen.dart';
import 'package:human_forces/pages/category_screen.dart';
import 'package:human_forces/pages/check_out_screen.dart';
import 'package:human_forces/pages/contact_us.dart';
import 'package:human_forces/pages/home_screen.dart';
import 'package:human_forces/pages/human_forces.dart';
import 'package:auto_route/auto_route_annotations.dart';
import 'package:human_forces/pages/my_order_screen.dart';
import 'package:human_forces/pages/pre_load_category_screen.dart';
import 'package:human_forces/pages/product_detail_screen.dart';
import 'package:human_forces/pages/product_list_screen.dart';
import 'package:human_forces/pages/product_without_filter_screen.dart';
import 'package:human_forces/pages/profile_screen.dart';

@autoRouter
class $Router {
  @initial
  HumanForces humanForces;
  HomeScreen homeScreen;
  CategoryScreen categoryScreen;
  ProductListScreen productListScreen;
  ProductListWithoutFilter productListWithoutFilter;
  ProductDetailScreen productDetailScreen;
  CartScreen cartScreen;
  MyOrderScreen myOrderScreen;
  ProfileScreen profileScreen;
  CheckOutScreen checkOutScreen;
  AboutUsScreen aboutUsScreen;
  ContactUsScreen contactUsScreen;
  PreLoadCategoryScreen preLoadCategoryScreen;
}
