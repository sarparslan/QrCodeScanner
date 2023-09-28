import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karel/Screens/Qr.dart';
import 'package:karel/Services/api.dart';
import 'package:karel/Util/util.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _verifypasswordController =
      TextEditingController();
  void initState() {
    super.initState();
    _usernameController.text =
        ""; // You can set an initial value here if needed
    _passwordController.text =
        ""; // You can set an initial value here if needed
    _verifypasswordController.text = "";
  }

  bool _obscureText = true;
  bool _verifyObscureText = true;
  bool _passwordsMatch = false;
  bool _verifyFieldTouched = false;

  var util_object = Util();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: Center(
                child: Image.asset(
              "images/karel_logo.png",
              width: 200,
              height: 200,
            )),
          ),
          // This space will be occupied by the logos or any other central content

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
                // Verify Password Input Field

                SizedBox(height: 20),
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
                  controller: _verifypasswordController,
                  obscureText: _verifyObscureText,
                  placeholder: "Şifre Tekrar",
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemGrey6,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  suffix: GestureDetector(
                    // ADD THIS BLOCK
                    onTap: () {
                      setState(() {
                        _verifyObscureText = !_verifyObscureText;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Icon(
                        _verifyObscureText
                            ? CupertinoIcons.eye
                            : CupertinoIcons.eye_slash,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ),
                  onChanged: (text) {
                    setState(() {
                      _passwordsMatch = _passwordController.text == text;
                      _verifyFieldTouched = true;
                    });
                  },
                ),
                SizedBox(height: 20),
                (!_passwordsMatch &&
                        _verifyFieldTouched) // Check both conditions
                    ? Text(
                        "Şifreler Eşleşmiyor!",
                        style: TextStyle(color: Colors.red),
                      )
                    : Container(),
                SizedBox(height: 20),

                // SignUp Button
                Container(
                  width: double.infinity,
                  child: CupertinoButton.filled(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Text(
                      "Kayıt Ol",
                      style: GoogleFonts.nunitoSans(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: CupertinoColors.white,
                      ),
                    ),
                    onPressed: () async {
                      if (_passwordController.text ==
                          _verifypasswordController.text) {
                        var result = await Api.registerCall(
                            username: _usernameController.text,
                            password: _passwordController.text);
                        Navigator.of(context).pop();
                        if (result?.status == "success") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => QrPage()),
                          );
                        } else {
                          util_object.errorAlertAndNavigate(context,
                              "Böyle Bir Kullanıcı Mevcut", "Giriş Yapılamadı");
                        }
                      }
                      // Handle the login logic here
                    },
                  ),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Hesabınız var mı? Giriş yapın!',
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
