import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PersonalDataPage extends StatefulWidget {
  PersonalDataPage({Key? key}) : super(key: key);

  @override
  _PersonalDataPageState createState() => _PersonalDataPageState();
}

class _PersonalDataPageState extends State<PersonalDataPage> {
  String tenKhachHang = '';
  String email = '';
  String sdt = '';
  String diaChi = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      // Retrieve email from shared preferences
      final prefs = await SharedPreferences.getInstance();
      email = prefs.getString('userEmail') ?? '';

      // Fetch user data from API
      final response = await http.get(Uri.parse('http://localhost:4031/api/users/searchByEmail?email=$email'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          tenKhachHang = data['TenKhachHang'];
          email = data['Email'];
          sdt = data['SDT'] ?? 'N/A';
          diaChi = data['DiaChi'] ?? 'N/A';
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Dữ liệu cá nhân'),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Dữ liệu cá nhân'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildPersonalDataItem('Dữ liệu cá nhân', '', isTitle: true),
            buildPersonalDataItem('Tên đầy đủ', tenKhachHang),
            Divider(thickness: 1, color: Colors.grey),
            buildPersonalDataItem('Email', email),
            Divider(thickness: 1, color: Colors.grey),
            buildPersonalDataItem('Số điện thoại', sdt),
            Divider(thickness: 1, color: Colors.grey),
            buildPersonalDataItem('Địa chỉ', diaChi),
            Divider(thickness: 1, color: Colors.grey),
            Container(
              padding: EdgeInsets.all(16.0),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Text(
                'Đây là địa chỉ email dùng để đăng nhập và nhận các thông báo',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPersonalDataItem(String title, String value, {bool isTitle = false}) {
    return Container(
      padding: EdgeInsets.all(16.0),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: isTitle ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          if (value.isNotEmpty)
            Text(
              value,
              style: TextStyle(fontSize: 18),
            ),
        ],
      ),
    );
  }
}
