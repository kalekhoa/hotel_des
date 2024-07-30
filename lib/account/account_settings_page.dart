import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../pages/login_page.dart';
import 'personal_info_page.dart';
import '../onboarding/onboarding_4.dart';

class AccountSettingsPage extends StatelessWidget {
  AccountSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(10),
              color: Colors.black,
              child: Text(
                'Tài khoản',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            buildClickableOption(
              label: 'Thông tin cá nhân',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PersonalInfoPage()),
                );
              },
            ),
            buildClickableOption(
              label: 'Đăng xuất',
              onTap: () async {
                // Xóa email khỏi SharedPreferences
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('userEmail');

                // Chuyển hướng đến trang đăng nhập
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Onboarding4Widget()),
                );
              },
            ),
            buildClickableOption(
              label: 'Tài khoản/Thẻ ngân hàng',
              onTap: () {
                // Handle tap
              },
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(10),
              color: Colors.black,
              child: Text(
                'Hỗ trợ',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            buildClickableOption(
              label: 'Đánh giá ứng dụng?',
              onTap: () {
                // Handle tap
              },
            ),
            buildClickableOption(
              label: 'Yêu cầu xóa tài khoản',
              onTap: () {
                // Handle tap
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildClickableOption({required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey)),
        ),
        child: Text(
          label,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
