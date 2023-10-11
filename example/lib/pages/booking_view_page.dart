import 'package:flutter/material.dart';

class BookingViewPage extends StatelessWidget {
  const BookingViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Calendar Page"),
        centerTitle: true,
      ),
      body: Center(
        child: Text("Booking View"),
      ),
    );
  }
}
