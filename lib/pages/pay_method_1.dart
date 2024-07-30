import 'package:flutter/material.dart';
import 'package:hotel_des/pages/thank.dart';
import 'add_payment.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class PaymentPage extends StatefulWidget {
  final Map<String, dynamic> room;
  final String name;
  final String email;
  final String phone;
  final String hotelId;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final int guests;
  final int beds;

  const PaymentPage({
    Key? key,
    required this.room,
    required this.name,
    required this.email,
    required this.phone,
    required this.hotelId,
    required this.checkInDate,
    required this.checkOutDate,
    required this.guests,
    required this.beds,
  }) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  Map<String, String>? cardInfo;
  bool hasCardInfo = false;
  String? gioNhanPhong;
  String? gioTraPhong;
  int? hoaDonThanhToanId;
  int? khachHangId;

  @override
  void initState() {
    super.initState();
    fetchPolicyData();
    _fetchUserIdByEmail(widget.email);
  }

  Future<void> fetchPolicyData() async {
    final response = await http.get(Uri.parse(
        'http://localhost:4031/api/policy/searchPolicy/${widget.hotelId}'));
    if (response.statusCode == 200) {
      // Handle policy data here if needed
    } else {
      throw Exception('Failed to load policy data');
    }
  }

  Future<void> _fetchUserIdByEmail(String email) async {
    final response = await http.get(Uri.parse(
        'http://localhost:4031/api/users/searchByEmail?email=$email'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        khachHangId = data['ID'];
      });
    } else {
      throw Exception('Failed to fetch user ID');
    }
  }

  Future<void> createPaymentBill(double tongTien, String trangThai, int chiTietSoLuong) async {
    final response = await http.post(
      Uri.parse('http://localhost:4031/api/paymentbills/create'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'TongTien': tongTien,
        'TrangThai': trangThai,
        'ChiTietSoLuong': chiTietSoLuong,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        hoaDonThanhToanId = data['ID'];
      });
    } else {
      throw Exception('Failed to create payment bill');
    }
  }

  Future<void> createPaymentDetail(int phongId, int hoaDonThanhToanId, int khachHangId) async {
    final response = await http.post(
      Uri.parse('http://localhost:4031/api/paymentdetails/create'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'IDPhong': phongId,
        'IDHoaDonThanhToan': hoaDonThanhToanId,
        'IDKhachHang': khachHangId,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Chi tiết thanh toán đã được tạo thành công!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tạo chi tiết thanh toán thất bại!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatCurrency =
        NumberFormat.currency(locale: 'vi_VN', symbol: '');

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('Thanh Toán'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Đặt phòng của bạn',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Image.network(
              '${widget.room['HinhAnh']}',
              width: 377,
              height: 226,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.room['IDLoaiPhong']['TenLoai'],
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '4.5',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            Divider(height: 32, thickness: 1),
            _buildInfoRow('Giờ nhận phòng:', '${widget.checkInDate.day}/${widget.checkInDate.month}/${widget.checkInDate.year} (${gioNhanPhong ?? '02:00 PM'})'),
            _buildInfoRow('Giờ trả phòng:', '${widget.checkOutDate.day}/${widget.checkOutDate.month}/${widget.checkOutDate.year} (${gioTraPhong ?? '12:00 AM'})'),
            _buildInfoRow('Loại phòng:', widget.room['IDLoaiPhong']['TenLoai']),
            _buildInfoRow('Số khách:', '${widget.guests} khách'),
            _buildInfoRow('Số giường:', '${widget.beds} giường'),
            _buildInfoRow('Giá:', '${formatCurrency.format(widget.room['GiaPhong'])} VND'),
            _buildInfoRow('Tên Khách:', widget.name),
            _buildInfoRow('Email:', widget.email),
            _buildInfoRow('Số điện thoại:', widget.phone),
            Divider(height: 32, thickness: 1),
            _buildInfoRow('Tổng:', '${formatCurrency.format(widget.room['GiaPhong'])} VND'),
            Text(
              'Bao Gồm Thuế',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 32),
            GestureDetector(
              onTap: () {
                _showPaymentDialog(context);
              },
              child: Container(
                height: 70,
                width: 390,
                padding: const EdgeInsets.all(5),
                margin: const EdgeInsets.symmetric(horizontal: 25),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(25, 29, 33, 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    'THANH TOÁN',
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 24,
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

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  void _showPaymentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text('Hình Thức Thanh Toán')),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 50),
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  final result = await Navigator.push<Map<String, String>>(
                    context,
                    MaterialPageRoute(builder: (context) => AddPayment()),
                  );
                  if (result != null) {
                    setState(() {
                      cardInfo = result;
                      hasCardInfo = true;
                    });
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        'THAY ĐỔI PHƯƠNG THỨC THANH TOÁN',
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              if (hasCardInfo)
                GestureDetector(
                  onTap: () async {
                    await createPaymentBill(
                      double.parse(widget.room['GiaPhong'].toString()),
                      'Đã Thanh Toán',
                      1,
                    );
                    if (hoaDonThanhToanId != null && khachHangId != null) {
                      await createPaymentDetail(
                        widget.room['ID'],
                        hoaDonThanhToanId!,
                        khachHangId!,
                      );
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ThankPage(),
                      ),
                    );
                  },
                  child: Container(
                    height: 50,
                    color: Colors.grey[200],
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRb8xh1D8ujxHfvztus4R7HjpKdIA5gq0rlr8njHTF96chCKmlfM6mQVYEbvMENtjOAz0Q&usqp=CAU',
                          height: 30,
                          width: 40,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${cardInfo!['cardHolderName']} - ${cardInfo!['cardNumber']}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              SizedBox(height: 10),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  side: BorderSide(color: Colors.black),
                  foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                ),
                onPressed: () async {
                  await createPaymentBill(
                    double.parse(widget.room['GiaPhong'].toString()),
                    'Chưa Thanh Toán',
                    1,
                  );
                  if (hoaDonThanhToanId != null && khachHangId != null) {
                    await createPaymentDetail(
                      widget.room['ID'],
                      hoaDonThanhToanId!,
                      khachHangId!,
                    );
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ThankPage(),
                    ),
                  );
                },
                child: Text('TRẢ KHI NHẬN PHÒNG'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Đóng'),
            ),
          ],
        );
      },
    );
  }
}
