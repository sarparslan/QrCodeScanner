import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karel/Auth/register.dart';
import 'package:karel/Screens/Qr.dart';
import 'package:karel/Services/api.dart';
import 'package:karel/Util/util.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
  var util_object = Util();

  @override
  void initState() {
    super.initState();
    _usernameController.text =
        ""; // You can set an initial value here if needed
    _passwordController.text =
        ""; // You can set an initial value here if needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // This space will be occupied by the logos or any other central content
          Expanded(
            child: Center(
                child: Image.asset(
              "images/karel_logo.png",
              width: 200,
              height: 200,
            )),
          ),

          // Auth fields
          Container(
            padding: const EdgeInsets.all(32.0),
            margin: const EdgeInsets.only(
                bottom: 50.0), // Add some bottom margin to lift the fields up
            child: Column(
              children: [
                // Email Input Field
                CupertinoTextField(
                  prefix: Container(
                    width:
                        40, // Adjust the width of the container to control the icon position
                    alignment: Alignment
                        .center, // Align the icon vertically within the container
                    child: Icon(
                      CupertinoIcons.person,
                      size: 28, // Adjust the size of the logo/icon
                      color: Colors
                          .blueGrey, // Customize the color of the logo/icon
                    ),
                  ),
                  controller: _usernameController,
                  keyboardType: TextInputType.emailAddress,
                  placeholder: "Kullanıcı Adı",
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemGrey6,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                SizedBox(height: 20),

                // Password Input Field
                CupertinoTextField(
                  prefix: Container(
                    width: 40,
                    alignment: Alignment.center,
                    child: Icon(
                      CupertinoIcons.lock,
                      size: 28,
                      color: Colors.blueGrey,
                    ),
                  ),
                  controller: _passwordController,
                  obscureText: _obscureText,
                  placeholder: "Şifre",
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemGrey6,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  suffix: GestureDetector(
                    // ADD THIS BLOCK
                    onTap: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Icon(
                        _obscureText
                            ? CupertinoIcons.eye
                            : CupertinoIcons.eye_slash,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40),

                // Login Button
                Container(
                  width: double.infinity,
                  child: CupertinoButton.filled(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Text(
                        "Giriş Yap",
                        style: GoogleFonts.nunitoSans(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: CupertinoColors.white,
                        ),
                      ),
                      onPressed: () async {
                        var result = await Api.loginCall(
                            username: _usernameController.text,
                            password: _passwordController.text);

                        if (result?.status == "success") {
                          // await Api.getCourses();
                          setState(() {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => QrPage()));
                          });
                        } else {
                          util_object.errorAlertAndNavigate(
                              context,
                              "Kullanıcı adı veya Şifre hatalı",
                              "Giriş Yapılamadı");
                        }
                      }),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => RegisterScreen()));
                        },
                        child: Text(
                          'Kayıt olun!',
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        )),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
