import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class OrderDetailsPage extends StatefulWidget {
  final String imageUrl;
  final String hotelName;
  final String roomType;
  final String checkInTime;
  final String checkOutTime;
  final String price;
  final String hotelId;

  OrderDetailsPage({
    required this.imageUrl,
    required this.hotelName,
    required this.roomType,
    required this.checkInTime,
    required this.checkOutTime,
    required this.price,
    required this.hotelId,
    Key? key,
  }) : super(key: key);

  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  double _rating = 0;
  final TextEditingController _reviewController = TextEditingController();
  late String userId;
  late String email;
  File? _image;

  @override
  void initState() {
    super.initState();
    _loadUserEmail();
  }

 Future<void> _loadUserEmail() async {
  final prefs = await SharedPreferences.getInstance();
  email = prefs.getString('userEmail') ?? '';

  await _loadUserData(email);
}


  Future<void> _loadUserData(String email) async {
  final response = await http.get(Uri.parse('http://localhost:4031/api/users/searchByEmail?email=$email'));
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    print("Fetched user ID: ${data['ID']}");
    setState(() {
      userId = data['ID'].toString();
    });
   
  } else {
    throw Exception('Failed to fetch user data');
  }
}


  Future<void> _submitReview() async {
    if (userId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không tìm thấy ID người dùng.')),
      );
      return;
    }

    final review = _reviewController.text;
    final rating = _rating.toInt();

    final response = await http.post(
      Uri.parse('http://localhost:4031/api/comment/createComment'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'NoiDung': review,
        'DanhGia': rating,
        'IDKhachSan': widget.hotelId,
        'IDKhachHang': int.parse(userId),
      }),
    );
  
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bình luận của bạn đã được đăng thành công!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đăng bình luận thất bại!')),
      
      );
    }
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    } catch (e) {
      print("Image picker error: $e");
    }
  }

  Future<void> _uploadImage() async {
    if (_image == null) return;

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('http://localhost:4031/api/hotels/uploadimage?file'),
    );
    request.files.add(await http.MultipartFile.fromPath('file', _image!.path));
    final response = await request.send();

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tải ảnh lên thành công!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tải ảnh lên thất bại!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết đơn hàng'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Image.network(widget.imageUrl, width: 100, height: 100, fit: BoxFit.cover),
                    SizedBox(width: 16.0),
                    Expanded(
                      child: Text(
                        widget.hotelName,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              buildInfoRow(label: 'Loại phòng', value: widget.roomType),
              // buildInfoRow(label: 'Thời gian nhận phòng', value: widget.checkInTime),
              // buildInfoRow(label: 'Thời gian trả phòng', value: widget.checkOutTime),
              buildInfoRow(label: 'Số tiền', value: widget.price),
              SizedBox(height: 16.0),
              Text(
                'Viết đánh giá',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              TextField(
                controller: _reviewController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Viết về trải nghiệm của bạn về căn phòng đã thuê',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(8.0),
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'Tối đa 150 kí tự',
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 16.0),
              Text(
                'Đánh giá chất lượng trải nghiệm',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              Row(
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < _rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                    ),
                    onPressed: () {
                      setState(() {
                        _rating = index + 1.0;
                      });
                    },
                  );
                }),
              ),
              SizedBox(height: 16.0),
              Text(
                'Thêm ảnh hoặc video',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.add, color: Colors.black),
                      SizedBox(width: 10),
                      Text(
                        'Thêm ảnh hoặc video',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
              if (_image != null)
                Column(
                  children: [
                    SizedBox(height: 16.0),
                    Image.file(_image!, height: 200),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: _uploadImage,
                      child: Text('Tải ảnh lên'),
                    ),
                  ],
                ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  await _submitReview();
                },
                child: Text('Đăng'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInfoRow({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(value, style: TextStyle(fontSize: 16)),
          ],
        ),
        Divider(thickness: 1, color: Colors.grey),
        SizedBox(height: 8.0),
      ],
    );
  }
}
