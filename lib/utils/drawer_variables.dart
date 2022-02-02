import 'package:human_forces/models/drawer_model.dart';
import 'package:human_forces/routes/router.gr.dart' as myRouter;
import 'package:human_forces/utils/strings.dart';

List<DrawerModel> drawerItems = [
  DrawerModel(
    name: "Home",
    route: myRouter.Router.homeScreen,
    image: home_svg,
  ),
  DrawerModel(
      name: "Explore", image: explore_svg, subItems: exploreDrawerItems),
  DrawerModel(
    name: "Newest Arrival",
    route: myRouter.Router.productListWithoutFilter,
    image: new_arrival_svg,
  ),
  DrawerModel(
    name: "Best Seller",
    route: myRouter.Router.productListWithoutFilter,
    image: best_seller_svg,
  ),
  DrawerModel(
    name: "Current Trending",
    route: myRouter.Router.productListWithoutFilter,
    image: current_trending_svg,
  ),
  DrawerModel(
    name: "My Orders",
    route: myRouter.Router.myOrderScreen,
    image: my_orders_svg,
  ),
];

List<DrawerModel> exploreDrawerItems = [
  DrawerModel(
    name: "Men",
    image: men_svg,
    route: myRouter.Router.categoryScreen,
  ),
  DrawerModel(
    name: "Women",
    image: women_svg,
    route: myRouter.Router.categoryScreen,
  ),
  DrawerModel(
    name: "Kids",
    image: kids_svg,
    route: myRouter.Router.preLoadCategoryScreen,
  ),
  DrawerModel(
    name: "Sports",
    image: sports_svg,
    route: myRouter.Router.categoryScreen,
  ),
  DrawerModel(
    name: "Footwear",
    image: footware_svg,
    route: myRouter.Router.categoryScreen,
  ),
  DrawerModel(
    name: "Accessories",
    image: accessories_svg,
    route: myRouter.Router.categoryScreen,
  ),
];
