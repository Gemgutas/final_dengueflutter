import 'dart:convert';

import 'package:http/http.dart' as http;



class Createddata {



  Future datacreated(municipalitytext,barangaytext,deathtext,active_casetext, monthtext) async {
    final response =
    await http.post(Uri.parse('http://192.168.43.14:8000/api/dengue-info/store'),
        body: jsonEncode({
          "municipality":municipalitytext,
          "barangay":barangaytext,
          "death":deathtext,
          "recovered":active_casetext,
          "month":monthtext,
        }),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',

        });
    print(response.statusCode);
    if (response.statusCode == 200) {

      print('Data Created Successfully');
      print(response.body);
    } else {
      print('error');
    }
  }

}

