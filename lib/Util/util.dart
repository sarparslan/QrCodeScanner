import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Util {
  void successAlertAndNavigate(BuildContext context, String title) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      text: title,
      confirmBtnColor: Colors.green,
      confirmBtnText: "Tamam",
    ).then((value) {
      Future.delayed(Duration(milliseconds: 1000000000000000000), () {
        Navigator.of(context).pop(); // Close the success alert
        Navigator.of(context).pop(); // Navigate back to the login page
      });
    });
  }

  void errorAlertAndNavigate(
      BuildContext context, String content, String title) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      text: content,
      title: title,
      confirmBtnColor: Colors.red,
      confirmBtnText: "Devam",
    ).then((value) {
      Future.delayed(Duration(milliseconds: 1000000000000000000), () {
        Navigator.of(context).pop(); // Close the error alert
        Navigator.of(context).pop(); // Navigate back to the login page
      });
    });
  }

  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: SpinKitWave(
            color: Colors.blue, // Customize spinner color
            size: 50.0,
          ),
        );
      },
    );
  }

  void hideLoadingDialog(BuildContext context) {
    Navigator.of(context).pop(); // Close the loading dialog
  }
}
