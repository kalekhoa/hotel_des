import 'package:flutter/material.dart';
import 'package:hotel_des/botton_nav_with_animated_icons.dart';
import 'package:hotel_des/components/square_tile.dart';
import 'package:hotel_des/components/my_button.dart';
import 'package:hotel_des/components/my_textfield.dart';
import 'package:hotel_des/pages/register_page.dart';
import 'package:hotel_des/Homepage/HomePage.dart';
import 'fogotpass_page.dart'; // Import ForgotPasswordScreen
import 'dart:convert'; // Thêm import này để sử dụng jsonEncode
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  // text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // sign user in method
  void signUserIn(BuildContext context) async {
    final String email = usernameController.text;
    final String password = passwordController.text;

    final url = Uri.parse('http://localhost:4031/api/auth/login');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'email': email, 'password': password});

    try {
      final response = await http.post(url, headers: headers, body: body);
     
      if (response.statusCode == 200) {
        // Lưu email vào shared_preferences
        final prefs = await SharedPreferences.getInstance();
        
        await prefs.setString('userEmail', email);
        
        // Điều hướng đến trang chính
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BottomNavWithAnimatedIcons(),
          ),
        );
      } else if (response.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid email or password')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            // Sử dụng SingleChildScrollView để tránh lỗi khi bàn phím xuất hiện
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 1),
                Image.asset(
                  'acess/logo.png', // Sửa lại đường dẫn tới logo
                  width: 168,
                  height: 181,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Text(
                        'Email',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                MyTextField(
                  controller: usernameController,
                  hintText: 'Điền Email',
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Text(
                        'Mật Khẩu',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                MyTextField(
                  controller: passwordController,
                  hintText: 'Nhập Mật Khẩu',
                  obscureText: true,
                ),
                const SizedBox(height: 25),
                MyButton(
                  onTap: () =>
                      signUserIn(context), // Truyền context vào hàm signUserIn
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    SquareTile(
                        imagePath:
                            'acess/google.png'), // Sửa lại đường dẫn tới hình ảnh google
                    SizedBox(width: 25),
                    SquareTile(
                        imagePath:
                            'acess/img_fb.png'), // Sửa lại đường dẫn tới hình ảnh facebook
                  ],
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ForgotPasswordScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Quên Mật Khẩu?',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Không Có Tài Khoản?',
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'Đăng Kí Ngay',
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
