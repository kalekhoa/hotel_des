import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'order_details_page.dart';  // Import OrderDetailsPage

class OrdersPage extends StatefulWidget {
  OrdersPage({Key? key}) : super(key: key);

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  late Future<List<dynamic>> _orders;

  @override
  void initState() {
    super.initState();
    _orders = _fetchOrders();
  }

  Future<String> _getEmailFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userEmail') ?? '';
  }

  Future<String> _fetchUserIdByEmail(String email) async {
    final response = await http.get(Uri.parse('http://localhost:4031/api/users/searchByEmail?email=$email'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['ID'].toString();
    } else {
      throw Exception('Failed to fetch user ID');
    }
  }

  Future<List<dynamic>> _fetchOrders() async {
    try {
      String email = await _getEmailFromPreferences();
      String userId = await _fetchUserIdByEmail(email);
      final response = await http.get(Uri.parse('http://localhost:4031/api/paymentdetails/GetPaymentDetailByIDuser/$userId'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load orders');
      }
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Khách sạn đã đặt'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _orders,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Không có đơn hàng nào'));
          } else {
            return ListView.builder(
              padding: EdgeInsets.all(16.0),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var order = snapshot.data![index];
                var hotel = order['IDPhong']['IDLoaiPhong']['IDKhachSan'];
                return buildOrderCard(
                  imageUrl: hotel['HinhAnhKS'],
                  hotelName: hotel['TenKhachSan'],
                  roomType: order['IDPhong']['IDLoaiPhong']['TenLoai'],
                  time: 'Thời gian: ${order['IDHoaDonThanhToan']['NgayTao']}',
                  price: 'Giá: ${order['IDPhong']['GiaPhong']} VND',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderDetailsPage(
                          imageUrl: hotel['HinhAnhKS'],
                          hotelName: hotel['TenKhachSan'],
                          roomType: order['IDPhong']['IDLoaiPhong']['TenLoai'],
                          checkInTime: 'Check-in: ${order['IDHoaDonThanhToan']['NgayTao']}',
                          checkOutTime: 'Check-out: ...', // Add actual checkout time if available
                          price: '${order['IDPhong']['GiaPhong']} VND',
                            hotelId: hotel['ID'],  // Pass the hotel ID
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget buildOrderCard({
    required String imageUrl,
    required String hotelName,
    required String roomType,
    required String time,
    required String price,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        padding: EdgeInsets.all(16.0),
        child: Row(
          children: [
            Image.network(imageUrl, width: 100, height: 100, fit: BoxFit.cover),
            SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hotelName,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),
                  Text('Loại phòng: $roomType'),
                  SizedBox(height: 8.0),
                  Text(time),
                  SizedBox(height: 8.0),
                  Text(price),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
