import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:expandable_text/expandable_text.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hotel_des/pages/HotelBookingPage.dart';

class DetailPage extends StatelessWidget {
  final String title;
  final String description;
  final List<String> imagePaths;
  final String rating;
  final String hotelId;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final int guests;
  final int beds;

  const DetailPage({
    required this.title,
    required this.description,
    required this.imagePaths,
    required this.rating,
    required this.hotelId,
    required this.checkInDate,
    required this.checkOutDate,
    required this.guests,
    required this.beds,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite_border, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
              options: CarouselOptions(
                height: 200,
                autoPlay: true,
                enlargeCenterPage: true,
                aspectRatio: 16 / 9,
                viewportFraction: 0.8,
              ),
              items: imagePaths.map((path) {
                return Builder(
                  builder: (BuildContext context) {
                    return Image.network(
                      path,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    );
                  },
                );
              }).toList(),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 150),
                      Icon(Icons.star, color: Colors.amber, size: 30),
                      Text(
                        rating,
                        style: TextStyle(fontSize: 30),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      SizedBox(width: 20),
                      Icon(Icons.arrow_forward, color: Colors.black),
                      SizedBox(width: 20),
                      Text(
                        'Địa điểm hàng đầu: Được khách gần đây đánh giá cao ($rating sao)',
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 90),
                  Text(
                    'Tiện Nghi',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Wrap(
                    spacing: 30,
                    runSpacing: 30,
                    children: [
                      _buildAmenityIcon(Icons.wifi, 'Wifi'),
                      _buildAmenityIcon(Icons.pool, 'Hồ Bơi'),
                      _buildAmenityIcon(Icons.local_bar, 'Bar / Lounge'),
                      _buildAmenityIcon(Icons.fitness_center, 'Gym'),
                      _buildAmenityIcon(Icons.room_service, 'Dọn Phòng'),
                      _buildAmenityIcon(Icons.local_parking, 'Giữ Xe'),
                      _buildAmenityIcon(Icons.restaurant, 'Nhà Hàng'),
                      _buildAmenityIcon(Icons.breakfast_dining, 'Bữa Sáng'),
                      _buildAmenityIcon(
                          Icons.local_laundry_service, 'Giặt Giũ'),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Mô Tả Khách Sạn',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  ExpandableText(
                    utf8.decode(description.runes
                        .toList()), // Ensure the text is UTF-8 decoded
                    expandText: 'show more',
                    collapseText: 'show less',
                    maxLines: 5,
                    linkColor: Colors.blue,
                    linkStyle: TextStyle(fontSize: 17),
                    style: TextStyle(fontSize: 23),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Chính Sách Lưu Trú',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  FutureBuilder<Map<String, dynamic>>(
                    future: _fetchPolicy(hotelId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData) {
                        return Center(child: Text('Không có dữ liệu'));
                      } else {
                        final policy = snapshot.data!;
                        return ExpandableText(
                          utf8.decode(policy['NoiDung'].runes.toList()) ?? '',
                          expandText: 'show more',
                          collapseText: 'show less',
                          maxLines: 5,
                          linkColor: Colors.blue,
                          linkStyle: TextStyle(fontSize: 17),
                          style: TextStyle(fontSize: 23),
                        );
                      }
                    },
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HotelBookingPage(
                              hotelId: hotelId,
                              checkInDate: checkInDate,
                              checkOutDate: checkOutDate,
                              guests: guests,
                              beds: beds,
                            ), // Chuyển đến trang HotelBookingPage
                          ),
                        );
                      },
                      child: Text('Chọn Phòng'),
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        textStyle: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> _fetchPolicy(String hotelId) async {
    final response = await http.get(
        Uri.parse('http://localhost:4031/api/policy/searchPolicy/$hotelId'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data.isNotEmpty ? data[0] : {};
    } else {
      throw Exception('Failed to fetch policy data');
    }
  }

  Widget _buildAmenityIcon(IconData icon, String label) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromARGB(255, 110, 91, 91)),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      width: 120,
      child: Column(
        children: [
          SizedBox(height: 17),
          Icon(icon, size: 50),
          SizedBox(height: 10),
          Text(label,
              textAlign: TextAlign.center, style: TextStyle(fontSize: 15)),
        ],
      ),
    );
  }
}
