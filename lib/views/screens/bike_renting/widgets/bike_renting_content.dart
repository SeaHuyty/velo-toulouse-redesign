import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../widgets/top_bar/app_bar.dart';
import '../../../widgets/rent_bike/station_info_widget.dart';
import '../../../widgets/rent_bike/single_ticket_card_widget.dart';
import '../../../widgets/buttons/button.dart';
import '../view_model/bike_renting_view_model.dart';
import '../../../../views/utils/async_value.dart';

class BikeRentingContent extends StatelessWidget {
  const BikeRentingContent({super.key});
 
  
  @override
  Widget build(BuildContext context) {
    BikeRentingViewModel mv = context.watch<BikeRentingViewModel>();
    final status = mv.stationStatus;

    if (status.state == AsyncValueState.loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (status.state == AsyncValueState.error) {
      return Scaffold(
        body: Center(child: Text("Error: ${status.error}")),
      );
    }

    final station = status.data!;
    final bike = mv.selectedBike;
    

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: const StationAppBar(title: "Bike Renting"),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              children: [
                if (bike != null)
                  StationInfoWidget(
                    station: station,
                    bike: bike,
                  ),
                
                const SizedBox(height: 50),
                
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: SingleTicketCard(
                    title: "Single Ticket",
                    price: 2.00,
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: VeloButton(
            text: "Continue to Payment",
            onPressed: () {
              
            },
          ),
        ),
      ],
    );
  }
}