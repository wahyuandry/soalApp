import 'package:flutter/material.dart';
import 'package:latihan_soal/constants/r.dart';
import 'package:latihan_soal/helpers/user_email.dart';
import 'package:latihan_soal/models/network_response.dart';
import 'package:latihan_soal/models/user_by_email.dart';
import 'package:latihan_soal/repository/auth_api.dart';
import 'package:latihan_soal/view/main_page.dart';

import '../helpers/preference_helper.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);
  static String route = "register_page";

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

enum Gender { lakilaki, perempuan }

class _RegisterPageState extends State<RegisterPage> {
  String gender = "Laki-Laki";
  List<String> classSlta = ["10", "11", "12"];
  String selectedClass = "10";

  final emailController = TextEditingController();
  final schoolController = TextEditingController();
  final fullNameController = TextEditingController();

  onTapGender(Gender genderInput) {
    if (genderInput == Gender.lakilaki) {
      gender = "Laki-Laki";
    } else {
      gender = "Perempuan";
    }

    setState(() {});
  }

  initDataUser() {
    emailController.text = UserEmail.getUserEmail()!;
    fullNameController.text = UserEmail.getUserDisplayName()!;
    setState(() {});
  }

  @override
  void initState() {
    initDataUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff0f3f5),
      // resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 20),
        child: AppBar(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15.0),
            bottomRight: Radius.circular(25.0),
          )),
          elevation: 0,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(
            "Yuk isi data diri",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: ButtonLogin(
            onTap: () async {
              final json = {
                "email": emailController.text,
                "nama_lengkap": fullNameController.text,
                "nama_sekolah": schoolController.text,
                "kelas": selectedClass,
                "gender": gender,
                "foto": UserEmail.getUserPhotoUrl(),
              };
              final result = await AuthApi().postRegister(json);
              if (result.status == Status.success) {
                final registerResult = UserByEmail.fromJson(result.data!);
                if (registerResult.status == 1) {
                  await PreferenceHelper().setUserData(registerResult.data!);
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      MainPage.route, (context) => false);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(registerResult.message!),
                    ),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Terjadi kesalahan, silahkan ulangi kembali"),
                  ),
                );
              }
            },
            backgroundColor: R.colors.primary,
            borderColor: R.colors.primary,
            child: Text(
              R.strings.daftar,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RegusterTextField(
                controller: emailController,
                hinttext: 'Email Anda',
                title: 'Email',
                enabled: false,
              ),
              RegusterTextField(
                hinttext: 'Nama Lengkap Anda',
                title: 'Nama Lengkap',
                controller: fullNameController,
              ),
              Text(
                "Jenis Kelamin",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          primary: gender == "Laki-Laki"
                              ? R.colors.primary
                              : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(
                              width: 1,
                              color: R.colors.greyBorder,
                            ),
                          ),
                        ),
                        onPressed: () {
                          onTapGender(Gender.lakilaki);
                        },
                        child: Text(
                          "Laki-Laki",
                          style: TextStyle(
                            fontSize: 14,
                            color: gender == "Laki-Laki"
                                ? Colors.white
                                : Color(0xff282828),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          primary: gender == "Perempuan"
                              ? R.colors.primary
                              : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(
                              width: 1,
                              color: R.colors.greyBorder,
                            ),
                          ),
                        ),
                        onPressed: () {
                          onTapGender(Gender.perempuan);
                        },
                        child: Text(
                          "Perempuan",
                          style: TextStyle(
                            fontSize: 14,
                            color: gender == "Perempuan"
                                ? Colors.white
                                : Color(0xff282828),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Text(
                "Kelas",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 5),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                  border: Border.all(
                    color: R.colors.greyBorder,
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                      value: selectedClass,
                      items: classSlta
                          .map(
                            (e) => DropdownMenuItem<String>(
                              child: Text(e),
                              value: e,
                            ),
                          )
                          .toList(),
                      onChanged: (val) {
                        selectedClass = val!;
                        setState(() {});
                      }),
                ),
              ),
              SizedBox(height: 5),
              RegusterTextField(
                hinttext: 'Nama Sekolah',
                title: 'Nama Sekolah',
                controller: schoolController,
              ),
              // Spacer(), tidak bisa pakai spacer jika pakai SingleChildScrollView
            ],
          ),
        ),
      ),
    );
  }
}

class RegusterTextField extends StatelessWidget {
  const RegusterTextField({
    Key? key,
    required this.title,
    required this.hinttext,
    this.controller,
    this.enabled = true,
  }) : super(key: key);
  final String title;
  final String hinttext;
  final bool enabled;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 5),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            border: Border.all(
              color: R.colors.greyBorder,
            ),
          ),
          child: TextField(
            enabled: enabled,
            controller: controller,
            decoration: InputDecoration(
                border: InputBorder.none, //biar border hilang
                hintText: hinttext,
                hintStyle: TextStyle(
                  color: R.colors.greyHintText,
                )),
          ),
        ),
      ],
    );
  }
}
