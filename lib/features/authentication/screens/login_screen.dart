import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:not_whatsapp/common/widgets/custom_button.dart';
import 'package:not_whatsapp/constants/colors.dart';
import 'package:not_whatsapp/constants/font_styles.dart';
import 'package:not_whatsapp/features/authentication/controller/auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const routeName = '/login-screen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _phoneController = TextEditingController();
  Country? country;
  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void pickCountry() {
    showCountryPicker(
      countryListTheme: CountryListThemeData(
        backgroundColor: backgroundColor,
        textStyle: FontStyle.bodyText(context).copyWith(
          color: Colors.white,
          fontWeight: FontWeight.normal,
        ),
      ),
      context: context,
      onSelect: (Country _country) {
        setState(() {
          country = _country;
        });
      },
    );
  }

  void sendPhoneNumber() {
    String phoneNumber = _phoneController.text.trim();

    if (country != null && phoneNumber.isNotEmpty) {
      ref.read(authControllerProvider).signInWithPhone(
            context,
            '+${country!.phoneCode}$phoneNumber',
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: backgroundColor,
          title: Text(
            'Enter your phone number',
            style: FontStyle.h2(context),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.05,
            horizontal: MediaQuery.of(context).size.width * 0.05,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //Top Half

              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //Heading

                  Text(
                    'NotWhatsapp will need to verify your phone number.',
                    style: FontStyle.h3(context)
                        .copyWith(fontWeight: FontWeight.normal),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),

                  //Pick Country

                  TextButton.icon(
                    onPressed: () {
                      pickCountry();
                    },
                    icon: const Icon(Icons.arrow_drop_down),
                    label: Text(
                      'Pick A Country',
                      style: FontStyle.bodyText(context),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),

                  //Enter Phone Number

                  Row(
                    mainAxisAlignment: country != null
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.center,
                    children: [
                      country != null
                          ? Text(
                              '+${country!.phoneCode}',
                              style: FontStyle.bodyText(context),
                            )
                          : Container(),
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.65,
                        child: TextField(
                          controller: _phoneController,
                          decoration: InputDecoration(
                            hintText: 'Phone Number',
                            hintStyle: FontStyle.bodyText(context),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),

              //Bottom Half

              SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: CustomButton(
                  buttonText: 'Next',
                  buttonColor: tabColor,
                  onTap: () {
                    sendPhoneNumber();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
