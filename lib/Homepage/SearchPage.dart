import 'package:flutter/material.dart';
import '../pages/SearchDetailPage.dart' as SearchDetail;
import '../pages/DetailPage.dart'; // Đảm bảo rằng đây là đúng đường dẫn đến DetailPage
import 'dart:convert';
import 'package:http/http.dart' as http;

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late Future<List<Map<String, dynamic>>> _hotels;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  int _nights = 1;
  int _guests = 1;
  int _beds = 1;

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

  Future<List<Map<String, dynamic>>> _searchHotels(String name, String address) async {
    final response = await http.get(Uri.parse('http://localhost:4031/api/hotels/search?tenKhachSan=$name&diaChi=$address'));
    if (response.statusCode == 200) {
      List<dynamic> hotels = json.decode(response.body);
      return hotels.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Không thể tìm kiếm khách sạn');
    }
  }

  Future<Map<String, dynamic>> _fetchHotelById(String id) async {
    final response = await http.get(Uri.parse('http://localhost:4031/api/hotels/$id'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Không thể tải thông tin khách sạn');
    }
  }

  void _performSearch() {
    setState(() {
      _hotels = _searchHotels(_searchController.text, _locationController.text);
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchBar(),
              const SizedBox(height: 16),
              _buildHeader(),
              const SizedBox(height: 26),
              _buildSuggestedDestinations(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Column(
      children: [
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search for a hotel name',
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        SizedBox(height: 8),
        TextField(
          controller: _locationController,
          decoration: InputDecoration(
            hintText: 'Search for a city, area, or address',
            prefixIcon: Icon(Icons.location_on),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        SizedBox(height: 8),
        ElevatedButton(
          onPressed: _performSearch,
          child: Text('Search'),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Text(
      'Gợi Ý Điểm Đến',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildSuggestedDestinations(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _hotels,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Không có dữ liệu'));
        } else {
          return Column(
            children: snapshot.data!.map((hotel) {
              return Column(
                children: [
                  _buildDestinationCard(
                    context,
                    utf8.decode(hotel['TenKhachSan'].runes.toList()),
                    utf8.decode(hotel['DiaChi'].runes.toList()),
                    hotel['HinhAnhKS'],
                    hotel['ID'],
                  ),
                  const SizedBox(height: 16),
                ],
              );
            }).toList(),
          );
        }
      },
    );
  }

  Widget _buildDestinationCard(BuildContext context, String title, String address, String imageUrl, String id) {
    return InkWell(
      onTap: () {
        _navigateToDetailPage(id);
      },
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 163,
              height: 118,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    address,
                    style: TextStyle(
                      color: Colors.grey,
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
}
