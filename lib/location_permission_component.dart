import 'package:app_maps/gps/gps_bloc.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class LocationPermissionComponent extends StatelessWidget {
  const LocationPermissionComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Lottie.asset(
            //   'assets/images/enable_location.json',
            //   height: 200,
            //   width: 200,
            //   repeat: true,
            // ),
            const SizedBox(height: 8),
            const Text('Habilitar ubicación', style: TextStyle(fontSize: 18)),
            SizedBox(
              width: 200,
              child: FloatingActionButton(
                child: Icon(Icons.map_outlined),
                onPressed: () => context.read<GpsBloc>().askGpsAccess(),
              ),
            )
          ],
        ));
  }
}
