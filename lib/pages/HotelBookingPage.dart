import 'package:flutter/material.dart';
import 'package:hotel_des/pages/booking.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HotelBookingPage extends StatefulWidget {
  final String hotelId;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final int guests;
  final int beds;

  const HotelBookingPage({
    super.key,
    required this.hotelId,
    required this.checkInDate,
    required this.checkOutDate,
    required this.guests,
    required this.beds,
  });

  @override
  _HotelBookingPageState createState() => _HotelBookingPageState();
}

class _HotelBookingPageState extends State<HotelBookingPage> {
  late Future<List<dynamic>> roomData;

  @override
  void initState() {
    super.initState();
    roomData = fetchRoomData();
  }

  Future<List<dynamic>> fetchRoomData() async {
    final response = await http.get(Uri.parse(
        'http://localhost:4031/api/typeroom/getRoomByIDHotel/${widget.hotelId}'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load room data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thông tin phòng'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: roomData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Không có dữ liệu'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final room = snapshot.data![index];
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              '${room['HinhAnh']}',
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            room['IDLoaiPhong']['TenLoai'],
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: const [
                              Icon(Icons.check_circle, color: Colors.green),
                              SizedBox(width: 8),
                              Text('Refundable'),
                            ],
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: const [
                              Icon(Icons.free_breakfast),
                              SizedBox(width: 8),
                              Text('Breakfast included'),
                            ],
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: const [
                              Icon(Icons.wifi),
                              SizedBox(width: 8),
                              Text('Wi-Fi'),
                            ],
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: const [
                              Icon(Icons.ac_unit),
                              SizedBox(width: 8),
                              Text('Air Conditioner'),
                            ],
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: const [
                              Icon(Icons.bathtub),
                              SizedBox(width: 8),
                              Text('Bath'),
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${room['GiaPhong']} VND',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BookingPage(
                                    room: room,
                                    hotelId: widget.hotelId,
                                    checkInDate: widget.checkInDate,
                                    checkOutDate: widget.checkOutDate,
                                    guests: widget.guests,
                                    beds: widget.beds,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              height: 50,
                              width: double.infinity,
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 0, 0, 0),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  width: 1.0,
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  "Select",
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
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
