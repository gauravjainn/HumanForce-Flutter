import 'package:flutter/material.dart';

class ContactUsModel {
  final String name;
  final IconData icon;
  final Function onTap;

  const ContactUsModel({this.name, this.icon, this.onTap});
}
