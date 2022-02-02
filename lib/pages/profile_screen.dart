import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:human_forces/cubits/user_cubit/user_cubit.dart';
import 'package:human_forces/utils/strings.dart';
import 'package:human_forces/widgets/common_widget.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(builder: (context, state) {
      if (state is UserLoggedIn) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Padding(
              padding: const EdgeInsets.all(4.0),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Align(
                        alignment: Alignment.center,
                        child: getCircleAvatar(
                            80, 80, state.userModel.shop_name ?? "", 20)),
                    SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: Text("${state.userModel.shop_name}",
                          style: TextStyle(
                              color: my_black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18)),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    _buildCardColumn(state),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.2,
                    ),
                    Center(
                        child: Image.asset(logo_transparent,
                            width: 125, height: 125)),
                    SizedBox(
                      height: 20,
                    ),
                    Center(child: Text("Verison 1.0.0")),
                    Center(child: Text("Made with ❤️ at Blupie Technologies")),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        );
      }
      return Container();
    });
  }

  Widget _buildCardColumn(UserLoggedIn state) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.all(12),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          _getRowInfo(
              customer_id, "Customer Id", "${state.userModel.customer_id}"),
          Divider(
            thickness: 1,
            color: Colors.grey.shade200,
          ),
          _getRowInfo(
              retailer_id, "Retailer Id", "${state.userModel.retailer_id}"),
          Divider(
            thickness: 1,
            color: Colors.grey.shade200,
          ),
          _getRowInfo(owner, "Owner Name", "${state.userModel.name}"),
          Divider(
            thickness: 1,
            color: Colors.grey.shade200,
          ),
          _getRowInfo(
              joined_from, "Joined From", "${state.userModel.joined_from}"),
          Divider(
            thickness: 1,
            color: Colors.grey.shade200,
          ),
          _getRowInfo(
              bond_duration, "Bond Duration", "${state.userModel.bond}"),
        ],
      ),
    );
  }

  Widget _getRowInfo(String image, String name, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: 10,
        ),
        SvgPicture.asset(
          image,
          width: 30,
          height: 30,
        ),
        SizedBox(
          width: 10,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                  style:
                      TextStyle(color: my_black, fontWeight: FontWeight.bold)),
              SizedBox(
                height: 5,
              ),
              Text(value,
                  style:
                      TextStyle(color: my_black, fontWeight: FontWeight.normal))
            ],
          ),
        )
      ],
    );
  }
}
