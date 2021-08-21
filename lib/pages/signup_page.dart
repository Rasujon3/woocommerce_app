import 'package:flutter/material.dart';
import 'package:woocommerce_app/api_service.dart';
import 'package:woocommerce_app/models/customer.dart';

import 'package:woocommerce_app/utils/ProgressHUD.dart';
import 'package:woocommerce_app/utils/validator_service.dart';
import 'package:woocommerce_app/utils/form_helper.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  APIService apiService;
  CustomerModel model;
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  bool hidePassword = true;
  bool isApiCallProcess = false;

  @override
  void initState() {
    super.initState();
    apiService = new APIService();
    model =
    new CustomerModel();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        automaticallyImplyLeading: true,
        title: Text("Sign Up"),
      ),
      body: ProgressHUD(
        child: new Form(
          key: globalKey,
          child: _formUI(),),
        inAsyncCall: isApiCallProcess,
        opacity: 0.3,
      ),
    );
  }
}

Widget _formUI() {
  return SingleChildScrollView(
    child: Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        child: Align(
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FormHelper.fieldLabel("First Name"),
              FormHelper.textInput(
                context,
                model.firstName,
                    (value) =>
                {
                  this.model.firstName = value,
                },
                onValidate: (value) {
                  if (value
                      .toString()
                      .isEmpty) {
                    return 'Please enter First Name';
                  }
                  return null;
                },
              ),

              FormHelper.fieldLabel("Last Name"),
              FormHelper.textInput(
                context,
                model.lastName,
                    (value) =>
                {
                  this.model.lastName = value,
                },
                onValidate: (value) {
                  if (value
                      .toString()
                      .isEmpty) {
                    return 'Please enter Last Name';
                  }
                  return null;
                },
              ),

              FormHelper.fieldLabel("Email Id"),
              FormHelper.textInput(
                context,
                model.email,
                    (value) =>
                {
                  this.model.email = value,
                },
                onValidate: (value) {
                  if (value
                      .toString()
                      .isEmpty) {
                    return 'Please enter Email Id';
                  }
                  if (value.isNotEmpty && !value.toString().isValidEmail()) {
                    return 'Please enter valid email id';
                  }
                  return null;
                },
              ),

              FormHelper.fieldLabel("Password"),
              FormHelper.textInput(
                context,
                model.password,
                    (value) =>
                {
                  this.model.password = value,
                },
                onValidate: (value) {
                  if (value
                      .toString()
                      .isEmpty) {
                    return 'Please enter Password';
                  }
                  return null;
                },
                obscureText: hidePassword,
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      hidePassword = !hidePassword;
                    });
                  },
                  color: Theme
                      .of(context)
                      .accentColor
                      .withOpacity(0.4),
                  icon: Icon(
                    hidePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              new Center(
                child: FormHelper.saveButton("Register", () {
                  if (validateAndSave()) {
                    print(model.toJson());
                    setState(() {
                      isApiCallProcess = true;
                    });

                    apiService.createCustomer(model).then(
                            (ret) {
                          setState(() {
                            isApiCallProcess = false;
                          });

                          if (ret) {
                            FormHelper.showMessage(
                              context,
                              "WooCommerce App",
                              "Registration Successful",
                              "OK",
                                  () {
                                Navigator.of(context).pop();
                              },
                            );
                          } else {
                            FormHelper.showMessage(context,
                              "WooCommerce App",
                              "Email Id already registered",
                              "OK",
                                  () {
                                Navigator.of(context).pop();
                              },
                            );
                          }
                        },
                    );
                  }
                },
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

bool validateAndSave() {
  final form = globalKey.currentState;
  if (form.validate()) {
    form.save();
    return true;
  }
  return false;
}

