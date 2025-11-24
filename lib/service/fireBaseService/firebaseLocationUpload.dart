import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gtlmd/pages/login/models/userModel.dart';
import 'package:gtlmd/service/fireBaseService/fireBase.dart';
import 'package:intl/intl.dart';

class FirebaseLocationUpload {
  final DatabaseReference databaseArtists =
      FirebaseDatabase.instance.ref("GTLMD_PICKUPBOY");

  Future<void> saveToServer( UserModel userData,
    // String boyId, String companyId,
      List<String> tripList, FireBase firebase) async {
    try {
      if (userData.executiveid.toString().isEmpty || userData.executiveid.toString() == 'null') {
        print('ERROR: Invalid executiveId: "${userData.executiveid.toString()}"');
        return;
      }

      // Get current location before update
      final position = await Geolocator.getCurrentPosition();
      // firebase.latitude = position.latitude.toStringAsFixed(5);
      // firebase.longitude = position.longitude.toStringAsFixed(5);
      firebase.timeStamp = DateTime.now().toString();
      debugPrint(
          'Current Location: ${position.latitude}, ${position.longitude}');

      Map<String, dynamic> updates = {};

      for (String tripid in tripList) {
        updates["CompanyId:${userData.companyid.toString()}/BoyId:${userData.executiveid.toString()}/Trip:$tripid"] = {
          "latitude": firebase.latitude,
          "longitude": firebase.longitude,
          "timestamp": firebase.timeStamp,
        };
      }

      // await databaseArtists.set(updates);
      await databaseArtists.update(updates);

      print(
          " Updated location for pickup boy ${userData.executiveid.toString()} at ${firebase.timeStamp} ${firebase.latitude}, ${firebase.longitude}");
    } catch (e) {
      print(" Error updating Firebase: $e");
    }
  }

  Future<void> deleteLocation(
      String boyid, String companyid, String tripid) async {
    try {
      if (boyid.isEmpty || boyid == 'null') {
        print('ERROR: Invalid executiveId: "$boyid"');
        return;
      }
    } catch (e) {
      print(" Error deleting location from Firebase: $e");
    }

    try {
      await databaseArtists
          .child("CompanyId:$companyid/BoyId:$boyid/Trip:$tripid")
          .remove();
    } catch (e) {
      print(" Error deleting location from Firebase: $e");
    }
  }
}






// import 'package:firebase_database/firebase_database.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:gtlmd/service/fireBaseService/fireBase.dart';

// class FirebaseLocationUpload {
//   final DatabaseReference databaseArtists =
//       FirebaseDatabase.instance.ref("GTLMD_PICKUPBOY");

//   Future<void> saveToServer(
//       String boyId, List<String> drsList, FireBase firebase) async {
//     try {
//       if (boyId.isEmpty || boyId == 'null') {
//         print('ERROR: Invalid executiveId: "$boyId"');
//         return;
//       }

      
//       final position = await Geolocator.getCurrentPosition();
//       firebase.latitude = position.latitude.toStringAsFixed(5);
//       firebase.longitude = position.longitude.toStringAsFixed(5);
//       firebase.timeStamp = DateTime.now().toIso8601String();

      
//       for (String drsNo in drsList) {
//         final locationRef =
//             databaseArtists.child(boyId).child(drsNo).push(); // Generates unique key

//         await locationRef.set({
//           "latitude": firebase.latitude,
//           "longitude": firebase.longitude,
//           "timestamp": firebase.timeStamp,
//         });

//         print(
//             "Location pushed for Boy: $boyId, DRS: $drsNo at ${firebase.timeStamp}");
//       }
//     } catch (e) {
//       print("Error updating Firebase: $e");
//     }
//   }
// }









