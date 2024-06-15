

import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
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
            _buildHeader(),
            _buildSearchCard(),
            _buildSuggestedDestinations(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        'Tìm nơi nghỉ dưỡng phù hợp cho bạn',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSearchCard() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            _buildLocationRow(),
            _buildDivider(),
            _buildDateRow(),
            _buildDivider(),
            _buildGuestRoomRow(),
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
      children: [
        Icon(Icons.location_on, color: Colors.white),
        const SizedBox(width: 16),
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

  Widget _buildDateRow() {
    return Column(
      children: [
        Row(
          children: [
            Icon(Icons.calendar_today, color: Colors.white),
            const SizedBox(width: 16),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Thứ 2, 14/3/2022',
                  border: InputBorder.none,
                ),
              ),
            ),
            Icon(Icons.nights_stay, color: Colors.white),
            const SizedBox(width: 16),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: '1 Đêm',
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const SizedBox(width: 32),
            Text(
              'Trả Phòng: Thứ 3, 14/3/2022',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGuestRoomRow() {
    return Row(
      children: [
        Icon(Icons.person, color: Colors.white),
        const SizedBox(width: 16),
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: '1 Khách',
              border: InputBorder.none,
            ),
          ),
        ),
        Icon(Icons.bed, color: Colors.white),
        const SizedBox(width: 16),
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: '1 Giường',
              border: InputBorder.none,
            ),
          ),
        ),
      ],
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
          Text(
            'Gợi Ý Điểm Đến',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildDestinationCard('Beach Resort Lux', 'Waikiki, 4.1 miles from center', 'Ocean View 1 king Bed\nNo prepayment', '\$720', 4.5),
                const SizedBox(width: 16),
                _buildDestinationCard('Hotel Standard', 'San Francisco, 1.2 miles from center', 'Standard Room\nFree cancellation', '\$650', 4.0),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDestinationCard(String title, String location, String details, String price, double rating) {
    return Card(
      child: Container(
        width: 250,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network('https://via.placeholder.com/150', fit: BoxFit.cover),
            const SizedBox(height: 8),
            Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(location, style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            Text(details, style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(price, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    Text(rating.toString(), style: TextStyle(color: Colors.amber)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
