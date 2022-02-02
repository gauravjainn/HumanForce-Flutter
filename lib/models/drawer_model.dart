class DrawerModel {
  final String name;
  final String image;
  final List<DrawerModel> subItems;
  final String route;

  DrawerModel({
    this.name,
    this.image,
    this.subItems = const <DrawerModel>[],
    this.route = "",
  });
}
