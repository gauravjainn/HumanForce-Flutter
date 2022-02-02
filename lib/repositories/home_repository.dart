import 'package:cloud_firestore/cloud_firestore.dart';

class HomeRepository {
  final Firestore _firestore;

  HomeRepository() : _firestore = Firestore.instance;

  Future<Map<String, dynamic>> getHomeScreenData() async {
    final dataList = await Future.wait(
        [_getCurrentTrending(), _getBestSeller(), _getNewestArrival()]);
    Map<String, dynamic> homeScreenData = {};
    Map<String, dynamic> data = {};
    dataList.forEach(
        (element) => homeScreenData[element.documentID] = element.data);

    data["data"] = homeScreenData;

    return data;
  }

  Future<DocumentSnapshot> _getCurrentTrending() {
    return _firestore
        .collection("Human Force")
        .document("Current Trending")
        .get();
  }

  Future<DocumentSnapshot> _getBestSeller() {
    return _firestore.collection("Human Force").document("Best Seller").get();
  }

  Future<DocumentSnapshot> _getNewestArrival() {
    return _firestore
        .collection("Human Force")
        .document("Newest Arrival")
        .get();
  }
}
