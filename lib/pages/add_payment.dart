import 'package:flutter/material.dart';

class AddPayment extends StatefulWidget {
  const AddPayment({super.key});

  @override
  _AddPaymentState createState() => _AddPaymentState();
}

class _AddPaymentState extends State<AddPayment> {
  final _formKey = GlobalKey<FormState>();
  String cardHolderName = '';
  String cardNumber = '';
  String expiryMonth = '';
  String expiryYear = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Phương Thức Thanh Toán'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Text(
                'Thông Tin Thẻ',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Tên Chủ Thẻ*'),
                onChanged: (value) {
                  setState(() {
                    cardHolderName = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Số Thẻ Tín Dụng/Thẻ Ghi Nợ*'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    cardNumber = value;
                  });
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Tháng'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          expiryMonth = value;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Năm'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          expiryYear = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Trở về trang trước đó
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text('HUỶ'),
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Navigator.pop(context, {
                            'cardHolderName': cardHolderName,
                            'cardNumber': cardNumber,
                            'expiryMonth': expiryMonth,
                            'expiryYear': expiryYear,
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text('XÁC NHẬN'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
