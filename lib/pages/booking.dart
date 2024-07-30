import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hotel_des/pages/pay_method_1.dart'; // import your payment page

class BookingPage extends StatefulWidget {
  final Map<String, dynamic> room;
  final String hotelId;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final int guests;
  final int beds;
  

  const BookingPage({
    super.key,
    required this.room,
    required this.hotelId,
    required this.checkInDate,
    required this.checkOutDate,
    required this.guests,
    required this.beds,
  });

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String? _currentPassword;

  @override
  void initState() {
    super.initState();
    _loadEmail();
  }

  // Hàm để lấy email từ SharedPreferences
  Future<void> _loadEmail() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('userEmail') ?? '';
    setState(() {
      _emailController.text = email;
    });
    if (email.isNotEmpty) {
      await _loadUserData(email);
    }
  }

  // Hàm để lấy thông tin khách hàng bằng email
  Future<void> _loadUserData(String email) async {
    final response = await http.get(Uri.parse('http://localhost:4031/api/users/searchByEmail?email=$email'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _nameController.text = data['TenKhachHang'] ?? '';
        _emailController.text = data['Email'] ?? '';
        _phoneController.text = data['SDT'] ?? '';
        _currentPassword = data['Password'];  // Lưu mật khẩu hiện tại (đã mã hóa)
      });
    } else {
      throw Exception('Failed to fetch user data');
    }
  }

  // Hàm để gọi API cập nhật thông tin người dùng
  Future<void> _updateUser(String userId) async {
    final response = await http.put(
      Uri.parse('http://localhost:4031/api/users/update/$userId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'TenKhachHang': _nameController.text,
        'Email': _emailController.text,
        'SDT': _phoneController.text,
        'Password': _currentPassword ?? '',  // Gửi mật khẩu hiện tại (chưa mã hóa)
      }),
    );

    if (response.statusCode == 200) {
      print('Cập nhật thành công');
    } else {
      throw Exception('Failed to update user');
    }
  }

  // Hàm để lấy ID khách hàng bằng email
  Future<String?> _getUserIdByEmail(String email) async {
    final response = await http.get(Uri.parse('http://localhost:4031/api/users/searchByEmail?email=$email'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['ID'].toString();
    } else {
      throw Exception('Failed to fetch user ID');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Đặt Chỗ'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: _nameController.text.isEmpty ? 'Tên' : '',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _emailController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: _emailController.text.isEmpty ? 'Email' : '',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: _phoneController.text.isEmpty ? 'Số Điện Thoại' : '',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
            ),
            const SizedBox(height: 50),
            GestureDetector(
              onTap: () async {
                try {
                  final email = _emailController.text;
                  final userId = await _getUserIdByEmail(email);
                  if (userId != null) {
                    await _updateUser(userId);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentPage(
                          room: widget.room,
                          name: _nameController.text,
                          email: _emailController.text,
                          phone: _phoneController.text,
                          hotelId: widget.hotelId, // Truyền hotelId sang PaymentPage
                          checkInDate: widget.checkInDate,
                          checkOutDate: widget.checkOutDate,
                          guests: widget.guests,
                          beds: widget.beds,

                        ),
                      ),
                    );
                  } else {
                    print('User ID not found');
                  }
                } catch (e) {
                  print('Error: $e');
                }
              },
              child: Container(
                height: 70,
                width: 369,
                padding: const EdgeInsets.all(5),
                margin: const EdgeInsets.symmetric(horizontal: 25),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(25, 29, 33, 1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Text(
                    "Đi Đến Thanh Toán",
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
