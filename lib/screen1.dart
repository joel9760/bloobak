import 'package:bloobak/mainscreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import 'dbmanager.dart';

class Screen1 extends StatefulWidget {
  const Screen1({super.key});

  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  DbManager dbManager = DbManager();
  final _nameController = TextEditingController();
  final _agectrlr = TextEditingController();
  final _grpctrlr = TextEditingController();
  final _phctrlr = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  String _selectedBloodGroup = 'A+';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Donor',style:TextStyle(fontSize: 24.0,fontWeight: FontWeight.bold,color: Colors.white)),
          backgroundColor: Colors.redAccent),
      body: Form(
        key:_formkey ,
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Name'
                  ),
                  validator: (String? value) {
                    return (value != null && value.contains('@'))
                        ? 'Do not use the @ char.'
                        : null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _agectrlr,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Age'
                  ),
                  validator: (String? value) {
                    return (value != null && value.contains('@'))
                        ? 'Do not use the @ char.'
                        : null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  value: _selectedBloodGroup,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedBloodGroup = newValue!;
                    });
                  },

                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Blood Group'
                  ),
                  validator: (String? value) {
                    return (value != null && value.contains('@'))
                        ? 'Do not use the @ char.'
                        : null;
                  }, items: <String>['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),

                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IntlPhoneField(
                  controller: _phctrlr,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    languageCode: "en",
                    onChanged: (phone) {
                      print(phone.completeNumber);
                    },
                    onCountryChanged: (country) {
                      print('Country changed to: ' + country.name);
                    },
                    ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  if (_formkey.currentState!.validate()) {
                    Donor d = Donor(
                        name: _nameController.text,
                        age: _agectrlr.text,
                        bgroup: _grpctrlr.text,
                        phone: _phctrlr.text);
                    dbManager.insertDonor(d).then((value) => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MainScreen(),
                        ),
                      ),
                      _agectrlr.clear(),
                      _grpctrlr.clear(),
                      _phctrlr.clear(),
                      _nameController.clear(),
                      Fluttertoast.showToast(
                        msg: "Registration Sucessfull",
                        gravity: ToastGravity.CENTER,
                        toastLength: Toast.LENGTH_SHORT,
                        textColor: Colors.white,
                      )
                    });
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
          ),
        );
  }
}