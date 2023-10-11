import 'package:example/pages/booking_view_page.dart';
import 'package:example/pages/mobile/mobile_home_page.dart';
import 'package:example/pages/web/web_home_page.dart';
import 'package:example/widgets/responsive_widget.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ResponsiveWidget(
                      mobileWidget: MobileHomePage(),
                      webWidget: WebHomePage(),
                    );
                  }));
                },
                child: Text("Calendar View")),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return BookingViewPage();
                  }));
                },
                child: Text("Booking View")),
          ],
        ),
      ),
    );
  }
}
