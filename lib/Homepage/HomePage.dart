import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hotel_des/pages/DetailPage.dart'; // Ensure this imports your DetailPage.dart file correctly

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDate = DateTime.now();
  int _nights = 1;
  int _guests = 1;
  int _beds = 1;
  late Future<List<Map<String, dynamic>>> _hotels;

  @override
  void initState() {
    super.initState();
    _hotels = _fetchHotels();
  }

  Future<List<Map<String, dynamic>>> _fetchHotels() async {
    final response = await http.get(Uri.parse('http://localhost:4031/api/hotels/all'));
    if (response.statusCode == 200) {
      List<dynamic> hotels = json.decode(response.body);
      return hotels.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Không thể tải danh sách khách sạn');
    }
  }

  void _navigateToDetailPage(String id) async {
    try {
      final hotelResponse = await http.get(Uri.parse('http://localhost:4031/api/hotels/$id'));
      if (hotelResponse.statusCode == 200) {
        Map<String, dynamic> hotel = json.decode(hotelResponse.body);

        final imagesResponse = await http.get(Uri.parse('http://localhost:4031/api/images/searchpichotel/$id'));
        if (imagesResponse.statusCode == 200) {
          Map<String, dynamic> imagesData = json.decode(imagesResponse.body);
          List<String> imagePaths = List<String>.from(imagesData['TenHinhAnhKS']);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailPage(
                title: hotel['TenKhachSan'],
                description: hotel['MoTa'],
                imagePaths: imagePaths,
                rating: hotel['DanhGia'].toString(),
                hotelId: hotel['ID'],
                checkInDate: _selectedDate,
                checkOutDate: _selectedDate.add(Duration(days: _nights)),
                guests: _guests,
                beds: _beds,
              ),
            ),
          );
        } else {
          throw Exception('Không thể tải hình ảnh của khách sạn');
        }
      } else {
        throw Exception('Không thể tải thông tin khách sạn');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Widget _buildHotelCard(Map<String, dynamic> hotel) {
    return GestureDetector(
      onTap: () {
        _navigateToDetailPage(hotel['ID']);
      },
      child: Card(
        child: Container(
          width: 250,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Image.network(hotel['HinhAnhKS']),
              const SizedBox(height: 8),
              Text(hotel['TenKhachSan'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(utf8.decode(hotel['DiaChi'].runes.toList()), style: TextStyle(color: Colors.grey)),

              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(hotel['SDT'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 16),
                      Text(hotel['DanhGia'].toString(), style: TextStyle(color: Colors.amber)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _selectDuration(BuildContext context) async {
    int? selectedNights = await _showNumberPickerDialog(context, _nights, 'Chọn Số Đêm');
    if (selectedNights != null) {
      setState(() {
        _nights = selectedNights;
      });
    }
  }

  void _selectGuests(BuildContext context) async {
    int? selectedGuests = await _showNumberPickerDialog(context, _guests, 'Chọn Số Khách');
    int? selectedBeds = await _showNumberPickerDialog(context, _beds, 'Chọn Số Giường');
    if (selectedGuests != null && selectedBeds != null) {
      setState(() {
        _guests = selectedGuests;
        _beds = selectedBeds;
      });
    }
  }

  Future<int?> _showNumberPickerDialog(BuildContext context, int currentValue, String title) async {
    return showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        int tempValue = currentValue;
        return AlertDialog(
          title: Text(title),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('Số lượng: $tempValue'),
                  Slider(
                    value: tempValue.toDouble(),
                    min: 1,
                    max: 10,
                    divisions: 9,
                    label: tempValue.toString(),
                    onChanged: (double newValue) {
                      setState(() {
                        tempValue = newValue.toInt();
                      });
                    },
                  ),
                ],
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text('HỦY'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('XÁC NHẬN'),
              onPressed: () {
                Navigator.of(context).pop(tempValue);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: <Widget>[
                Image.asset(
                  'assets/background.png',
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Tìm nơi nghỉ dưỡng phù hợp\n cho bạn',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            _buildSearchCard(context),
            _buildSuggestedDestinations(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(1),
        ),
        child: Column(
          children: [
            _buildLocationRow(),
            _buildDivider(),
            _buildDateRow(context),
            _buildDivider(),
            _buildGuestRoomRow(context),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              child: Text('Tìm phòng'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationRow() {
    return Row(
      children: const [
        Icon(Icons.location_on, color: Color.fromARGB(153, 0, 0, 0)),
        SizedBox(width: 16),
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Hochiminh City, Vietnam',
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateRow(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => _selectDate(context),
          child: Row(
            children: [
              Icon(Icons.calendar_today, color: Color.fromARGB(153, 0, 0, 0)),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Thứ 2, ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                  style: TextStyle(color: Color.fromARGB(153, 0, 0, 0)),
                ),
              ),
              Icon(Icons.nights_stay, color: Color.fromARGB(153, 0, 0, 0)),
              const SizedBox(width: 16),
              Expanded(
                child: GestureDetector(
                  onTap: () => _selectDuration(context),
                  child: Text(
                    '$_nights Đêm',
                    style: TextStyle(color: Color.fromARGB(153, 0, 0, 0)),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const SizedBox(width: 32),
            Text(
              'Trả Phòng: Thứ 3, ${_selectedDate.add(Duration(days: _nights)).day}/${_selectedDate.add(Duration(days: _nights)).month}/${_selectedDate.add(Duration(days: _nights)).year}',
              style: TextStyle(color: Color.fromARGB(153, 0, 0, 0)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGuestRoomRow(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectGuests(context),
      child: Row(
        children: [
          Icon(Icons.person, color: Color.fromARGB(153, 0, 0, 0)),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              '$_guests Khách',
              style: TextStyle(color: Color.fromARGB(153, 0, 0, 0)),
            ),
          ),
          Icon(Icons.bed, color: Color.fromARGB(153, 0, 0, 0)),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              '$_beds Giường',
              style: TextStyle(color: Color.fromARGB(153, 0, 0, 0)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      color: Colors.white,
      height: 20,
      thickness: 1,
    );
  }

  Widget _buildSuggestedDestinations() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text(
            'Gợi Ý Điểm Đến',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: _hotels,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Lỗi: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('Không có khách sạn nào được tìm thấy.'));
              } else {
                return GridView.builder(
                  shrinkWrap: true, // Allows GridView to be constrained by the parent
                  physics: NeverScrollableScrollPhysics(), // Disable scrolling within GridView
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Two cards per row
                    crossAxisSpacing: 16.0, // Space between columns
                    mainAxisSpacing: 16.0, // Space between rows
                  ),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return _buildHotelCard(snapshot.data![index]);
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
