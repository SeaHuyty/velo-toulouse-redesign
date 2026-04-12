import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:velo_toulouse_redesign/views/widgets/top_bar/app_bar.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StationAppBar(title: 'Please wait'),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
        child: Column(
          children: [
            const SizedBox(height: 70,),
            Image.asset('assets/images/mock_qr.JPG', width: 230),

            const SizedBox(height: 15),
            Text('Scan to Pay'),

            const SizedBox(height: 3),
            Text('or', style: TextStyle(color: Colors.blueGrey),),

            const SizedBox(height: 3),
            Text('Download QR', style: TextStyle(color: Colors.blue)),

            const SizedBox(height: 3),
            SizedBox(
              width: 230,
              child: Text(
                'and upload to Mobile Banking app supporting KHQR',
                style: TextStyle(color: Colors.blueGrey, fontSize: 13),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 55),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text('Subtotal:'), Text('2.00 USD')],
            ),

            const SizedBox(height: 15),
            DottedLine(
              dashLength: 6,
              dashGapLength: 4,
              lineThickness: 1,
              dashColor: Colors.grey,
            ),

            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text('Total:', style: TextStyle(fontWeight: FontWeight.bold),), Text('2.00 USD', style: TextStyle(fontWeight: FontWeight.bold),)],
            ),
          ],
        ),
      ),
    );
  }
}
