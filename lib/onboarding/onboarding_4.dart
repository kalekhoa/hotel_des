import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotel_des/botton_nav_with_animated_icons.dart';
import 'package:hotel_des/pages/login_page.dart';

import 'package:hotel_des/Homepage/HomePage.dart';
class Onboarding4Widget extends StatefulWidget {
  const Onboarding4Widget({super.key});

  @override
  State<Onboarding4Widget> createState() => _Onboarding4WidgetState();
}

class _Onboarding4WidgetState extends State<Onboarding4Widget> {
  late FocusNode _unfocusNode;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _unfocusNode = FocusNode();
  }

  @override
  void dispose() {
    _unfocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Flexible(
                      flex: 1,
                      child: Text(
                        'Tìm Kiếm Nơi Nghỉ Ngơi Ngay',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20,),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>  BottomNavWithAnimatedIcons(),
                    ),
                  );
                },
                child: Container(
                  height: 40,
                  width: 369,
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(25, 29, 33, 1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Center(
                    child: Text(
                      "Đi Đến Trang Chủ",
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5,),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ),
                  );
                },
                child: Container(
                  height: 40,
                  width: 369,
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      width: 1.0,
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      "Đăng Nhập",
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50,),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  'acess/5.png',  // Chỉnh lại đường dẫn
                  width: 444,
                  height: 400,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
