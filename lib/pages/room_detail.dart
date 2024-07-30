import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RoomDetail(),
    );
  }
}

class RoomDetail extends StatelessWidget {
  final List<Map<String, List<String>>> amenities = [
    {
      "Các hoạt động": [
        "Ghế dài tắm nắng bãi biển",
        "Khăn tắm biển",
        "Đồ chơi bãi biển",
        "Trung tâm thể dục thể hình",
        "Hồ bơi ngoài trời",
        "Bãi biển riêng"
      ]
    },
    {
      "Tiện ích chung": ["Máy lạnh", "Phòng gia đình", "Hồ bơi"]
    },
    {
      "Kết nối mạng": ["Wi-Fi tại khu vực chung (thu phí)"]
    },
    {
      "Thể thao & Giải trí": ["Trung tâm thể dục thể hình"]
    },
    {
      "Tiện nghi công cộng": [
        "Cà phê/trà tại sảnh",
        "Thang máy",
        "Nhà hàng",
        "Nhà hàng phục vụ bữa sáng",
        "Két an toàn",
        "Wi-Fi tại khu vực chung"
      ]
    },
    {
      "Tiện nghi văn phòng": ["Dịch vụ văn phòng", "Tiện nghi họp hội nghị"]
    },
    {
      "Tiện nghi người khuyết tật": ["Phù hợp cho xe lăn"]
    },
    {
      "Ẩm thực": [
        "Nhà hàng có máy lạnh",
        "Quầy bar",
        "Bữa sáng",
        "Tiệm cà phê"
      ]
    },
    {
      "Dịch vụ khách sạn": [
        "Lễ tân 24h",
        "Dịch vụ tư vấn/tour du lịch"
      ]
    },
    {
      "Các tiện ích liên quan": ["Cửa hàng"]
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tất Cả Tiện Nghi'),
      ),
      body: ListView.builder(
        itemCount: amenities.length,
        itemBuilder: (context, index) {
          String title = amenities[index].keys.first;
          List<String> items = amenities[index][title]!;
          return ExpansionTile(
            title: Text(title),
            children: items.map((item) => ListTile(title: Text(item))).toList(),
          );
        },
      ),
    );
  }
}
