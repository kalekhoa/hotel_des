import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hotel_des/components/my_textfield.dart'; // Import your custom MyTextField
import 'package:hotel_des/pages/login_page.dart';

class NewpassPage extends StatelessWidget {
  NewpassPage({super.key});

  // text editing controllers
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 1),
              Image.asset(
                'acess/logo.png',
                width: 168,
                height: 181,
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Text(
                      'Điền Mật Khẩu Mới',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              // password textfield
              MyTextField(
                controller: passwordController,
                hintText: 'Nhập Mật Khẩu',
                obscureText: true,
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Text(
                      'Xác Nhận Mật Khẩu',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              // password textfield
              MyTextField(
                controller: passwordConfirmController,
                hintText: 'Nhập Lại Mật Khẩu',
                obscureText: true,
              ),
              const SizedBox(height: 10),
              const SizedBox(height: 40),
              GestureDetector(
                onTap: () async {
                  if (passwordController.text == passwordConfirmController.text) {
                    await _changePassword(context, passwordController.text);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Mật khẩu không khớp!')),
                    );
                  }
                },
                child: Container(
                  height: 65,
                  width: 328,
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(57, 57, 57, 20),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(
                    child: Text(
                      "Đổi Mật Khẩu",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _changePassword(BuildContext context, String newPassword) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('userEmail') ?? '';

      if (email.isNotEmpty) {
        final userId = await _getUserIdByEmail(email);

        if (userId != null) {
          final userData = await _getUserDataById(userId);
          if (userData != null) {
            await _updateUser(userId, newPassword, userData);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Đổi mật khẩu thành công!')),
            );
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Không thể tìm thấy thông tin người dùng!')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Không thể tìm thấy ID người dùng!')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Không thể lấy email từ SharedPreferences!')),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Có lỗi xảy ra khi đổi mật khẩu!')),
      );
    }
  }

  Future<String?> _getUserIdByEmail(String email) async {
    final response = await http.get(Uri.parse('http://localhost:4031/api/users/searchByEmail?email=$email'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['ID'].toString();
    } else {
      throw Exception('Failed to fetch user ID');
    }
  }

  Future<Map<String, dynamic>?> _getUserDataById(String userId) async {
    final response = await http.get(Uri.parse('http://localhost:4031/api/users/$userId'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch user data');
    }
  }

  Future<void> _updateUser(String userId, String newPassword, Map<String, dynamic> userData) async {
    final response = await http.put(
      Uri.parse('http://localhost:4031/api/users/update/$userId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'TenKhachHang': userData['TenKhachHang'],
        'Email': userData['Email'],
        'SDT': userData['SDT'],
        'DiaChi': userData['DiaChi'],
        'HinhAnh': userData['HinhAnh'],
        'Password': newPassword,
      }),
    );

    if (response.statusCode == 200) {
      print('Cập nhật thành công');
    } else {
      throw Exception('Failed to update user');
    }
  }
}
