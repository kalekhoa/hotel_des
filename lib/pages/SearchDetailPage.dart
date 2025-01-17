
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:hotel_des/pages/HotelBookingPage.dart';
import 'package:hotel_des/pages/booking.dart';

class SearchDetailPage extends StatelessWidget {
  const SearchDetailPage({super.key});

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
            _buildSearchBar(),
            _buildSuggestedDestinations(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search),
          hintText: 'Hochiminh City, Vietnam',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          filled: true,
          fillColor: Colors.grey[200],
        ),
      ),
    );
  }

  Widget _buildSuggestedDestinations(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDestinationCard(
            context: context,
            imageUrl: 'https://via.placeholder.com/400x200',
            title: 'Beach Resort Lux',
            location: 'TP. Hồ Chí Minh',
            price: '\$830',
            rating: 4.8,
            town: 'SAIGON TOWN',
          ),
          const SizedBox(height: 16),
          _buildDestinationCard(
            context: context,
            imageUrl: 'https://via.placeholder.com/400x200',
            title: 'Lux Hotel',
            location: 'TP. Hồ Chí Minh',
            price: '\$830',
            rating: 4.8,
            town: 'Sóng Dữ Pear',
          ),
        ],
      ),
    );
  }

  Widget _buildDestinationCard({
    required BuildContext context,
    required String imageUrl,
    required String title,
    required String location,
    required String price,
    required double rating,
    required String town,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPage(
              title: title,
              location: location,
              price: price,
              rating: rating,
              town: town,
            ),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              child: Stack(
                children: [
                  Image.network(imageUrl, width: double.infinity, height: 200, fit: BoxFit.cover),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        town,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 16),
                          SizedBox(width: 4),
                          Text(
                            rating.toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    location,
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    price,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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

class DetailPage extends StatelessWidget {
  final String title;
  final String location;
  final String price;
  final double rating;
  final String town;

  const DetailPage({super.key, 
    required this.title,
    required this.location,
    required this.price,
    required this.rating,
    required this.town,
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1),
                ),
                child:  ClipRRect(borderRadius:BorderRadius.circular(1) ,child: Image.asset('acess/logo.png')),
              ),
            ),
            // CarouselSlider(
            //   options: CarouselOptions(
            //     height: 200,
            //     autoPlay: true,
            //     enlargeCenterPage: true,
            //     aspectRatio: 16 / 9,
            //     viewportFraction: 0.8,
            //   ),
            //   items: imagePaths.map((path) {
            //     return Builder(
            //       builder: (BuildContext context) {
            //         return Image.asset(
            //           path,
            //           fit: BoxFit.cover,
            //           width: double.infinity,
            //         );
            //       },
            //     );
            //   }).toList(),
            // ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      
                      Text(
                        'Beach Resort Lux',
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 150),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 24),
                      SizedBox(width: 4),
                      Text(
                        rating.toString(),
                        style: TextStyle(fontSize: 24),
                      ),
                    ],
                  ),
                  Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    location,
                    style: TextStyle(color: Colors.grey,fontSize: 24),
                  ),
                  const SizedBox(height: 8),
                  // Text(
                  //   title,
                  //   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  // ),
                  const SizedBox(height: 8),
                  Text(
                    price,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  
                  const SizedBox(height: 16),
                  Text(
                    'Town: $town',
                    style: TextStyle(fontSize: 18),
                  ),
                  // Add more details as needed
                ],
              ),
            ),
                  SizedBox(height: 8),
                  Row(
                    children: const [
                      SizedBox(width:20),
                      Icon(Icons.arrow_forward, color: Colors.black,),
                      SizedBox(width: 20),
                      Text(
                        'Địa điểm hàng đầu: Được khách gần đây '
                        '\nđánh giá cao (4.8 sao)',
                        style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 90),
                  Text('Tiện Nghi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                      _buildAmenityIcon(Icons.restaurant, 'Nhà Máy'),
                      _buildAmenityIcon(Icons.breakfast_dining, 'Bữa Sáng'),
                      _buildAmenityIcon(Icons.local_laundry_service, 'Giặt Giũ'),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text('Mô Tả Khách Sạn', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Wrap(children: [
                    TextDetailHotel(context)
                  ],),
                  SizedBox(height: 16),
                  Text('Chính Sách Lưu Trú', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Wrap(children: [
                    TextPolicy(context)
                  ],),
                  SizedBox(height: 16),
                  Center(
                    child: GestureDetector(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) =>  HotelBookingPage(),
                  //   ),
                  // );
                },
                child: Container(
                  height: 50,
                  width: 369,
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(25, 29, 33, 1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Text(
                      "Chọn Phòng",
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 16,
                      ),
                    ),
                  ),
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
          Icon(icon, size: 50,),
          SizedBox(height: 10),
          Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: 15)),
        ],
      ),
    );
  }
}
Widget TextDetailHotel(BuildContext context) {
    return ExpandableText(
        'Nếu dự định có một kỳ nghỉ dài, thì Citadines Bayfront Nha Trang chính là lựa chọn dành cho quý khách. Với đầy đủ tiện nghi với chất lượng dịch vụ tuyệt vời, Citadines Bayfront Nha Trang sẽ khiến quý khách cảm thấy thoải mái như ở nhà vậy.\n\n'
                    'Khách sạn này là nơi tốt nhất dành cho những ai mong muốn một nơi thanh bình, thư thái để ẩn mình khỏi đám đông ồn ào, xô bồ.\n\n'
                    'Dịch vụ hướng dẫn song hành với hàng loạt các nghi tinh phong phú sẽ đem đến cho quý khách trải nghiệm của một kỳ nghỉ viên mãn nhất.\n\n'
                    'Trung tâm thể dục của khách sạn là một trong những tiện nghi không thể bỏ qua khi lưu trú tại đây.\n\n'
                    'Hưởng thụ một ngày thư thái đầy thú vị và tận hưởng các dịch vụ tại hồ bơi của khách sạn trong kỳ nghỉ vui bất tận.\n\n'
                    'Quầy tiếp tân 24 giờ luôn sẵn sàng phục vụ quý khách từ thủ tục nhận phòng đến trả phòng hay bất kỳ yêu cầu nào. Nếu cần giúp đỡ xin hãy liên hệ đội ngũ tiếp tân, chúng tôi luôn sẵn sàng hỗ trợ quý khách.\n\n'
                    'Tận hưởng những món ăn yêu thích với phong cách ẩm thực đặc biệt từ Citadines Bayfront Nha Trang chỉ dành riêng cho quý khách.\n\n'
                    'Song WiFi phủ khắp các khu vực chung của khách sạn cho phép quý khách luôn kết nối với gia đình và bạn bè.\n\n'
                    'Citadines Bayfront Nha Trang là khách sạn sở hữu đầy đủ tiện nghi và dịch vụ xuất sắc theo nhận định của hầu hết khách lưu trú.\n\n'
                    'Tận hưởng trải nghiệm lưu trú xa hoa đầy thú vị không đâu sánh bằng tại Citadines Bayfront Nha Trang.',
        expandText: 'show more',
        collapseText: 'show less',
        maxLines: 5,
        linkColor: Colors.blue,
        linkStyle: TextStyle(fontSize: 17),
        style:TextStyle(fontSize: 16),
    );
}
Widget TextPolicy(BuildContext context) {
    return ExpandableText(
        'Giờ nhận phòng/trả phòng\n\nNhận phòng từ 12:00\nTrả phòng trước 12:00\n\n'
        'Giấy Tờ Bắt Buộc\n\nKhi nhận phòng, bạn cần cung cấp Giấy Chứng nhận Kết Hôn. Vui lòng mang theo các giấy tờ cần thiết dưới dạng bản cứng.\n\n'
        'Hướng Dẫn Nhận Phòng Chung\n\n'
        'Trẻ em dưới 6 tuổi được ở miễn phí nếu sử dụng giường sẵn có.\n'
        'Trẻ em từ 6 tuổi trở lên (sử dụng giường sẵn có) sẽ phải trả phụ phí khi nhận phòng.\n'
        'Trẻ em từ 11 tuổi trở lên được tính là người lớn và phải sử dụng giường phụ. Phí giường phụ phụ thuộc vào loại phòng bạn chọn.\n'
        'Tất cả các yêu cầu đặc biệt đều dựa vào tình trạng phòng trống. Có thể phát sinh phụ phí.\n'
        'Để biết thêm thông tin cụ thể, vui lòng liên hệ với chỗ nghỉ để biết thêm chi tiết.\n\n'
        'Khách sẽ được chỗ nghỉ yêu cầu cung cấp giấy tờ khai báo y tế đầy đủ (sàng lọc PCR COVID-19, được cấp trong vòng 72 giờ trước khi nhận phòng). Yêu cầu này sẽ được thực hiện cho tất cả các đặt phòng có ngày đến trước ngày 31 tháng 7 năm 2021.',
        expandText: 'show more' ,
        collapseText: 'show less',
        maxLines: 5,
        linkColor: Colors.blue,
        linkStyle: TextStyle(fontSize: 17),
        style:TextStyle(fontSize: 16),   
    );
}

