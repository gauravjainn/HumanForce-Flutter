import 'package:flutter/material.dart';
import 'package:human_forces/models/contact_us_model.dart';
import 'package:url_launcher/url_launcher.dart';

const String phone_number = "+91 12345 67890";
const String location =
    "https://www.google.com/maps/search/?api=1&query=24.5764,73.6996";
const String mailId = "jsmith@humnforce.com";

List<ContactUsModel> contactUs = [
  ContactUsModel(
    name: phone_number,
    icon: Icons.phone,
    onTap: () async {
      await launch("tel://$phone_number");
    },
  ),
  ContactUsModel(
    name: mailId,
    icon: Icons.mail,
    onTap: () async {
      await launch("mailto:$mailId");
    },
  ),
  ContactUsModel(
    name: "Prabhat Nagar Hiran ",
    icon: Icons.location_on,
    onTap: () async {
      await launch(location);
    },
  ),
];
