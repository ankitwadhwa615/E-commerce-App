import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/Pages/PaymentCheckOut.dart';
import 'package:ecommerce/components/loading.dart';
import 'package:ecommerce/db/Address_service.dart';
import 'package:ecommerce/components/networking.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Address extends StatefulWidget {
  final totalAmount;
  Address({@required this.totalAmount});
  @override
  _AddressState createState() => _AddressState();
}

class _AddressState extends State<Address> {
  bool isLoading = false;
  Color labelColor = Colors.black45;
  var _formKey = GlobalKey<FormState>();
  AddressService addressService = AddressService();
  List<DocumentSnapshot> address = <DocumentSnapshot>[];
  TextEditingController _nameTextController = TextEditingController();
  TextEditingController _mobileNoTextController = TextEditingController();
  TextEditingController _pinCodeTextController = TextEditingController();
  TextEditingController _addressTextController = TextEditingController();
  TextEditingController _localityTextController = TextEditingController();
  String city;
  String state;

  _getAddress() async {
    setState(() {
      isLoading = true;
    });
    List<DocumentSnapshot> data =
        await addressService.getUserAddress().catchError((e) {
      print(e);
    });
    setState(() {
      address = data;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _getAddress();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Loading()
        : address.length != 0
            ? Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  elevation: 0.1,
                  backgroundColor: Colors.black,
                  title: Text(
                    'Address',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontFamily: 'Lobster'),
                  ),
                ),
                body: ListView(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 16, bottom: 8),
                                child: Text('${address[0]['name']}',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Text('${address[0]['address']}'),
                              Text('${address[0]['locality']}'),
                              Text(
                                  '${address[0]['city']}, ${address[0]['state']}, ${address[0]['pinCode']}.'),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 8, bottom: 8),
                                child: Row(
                                  children: <Widget>[
                                    Text('Mobile:'),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text('${address[0]['mobileNo']}',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold))
                                  ],
                                ),
                              ),
                              FlatButton(
                                onPressed: () {
                                  addressService.deleteData(address[0]['id']);
                                  setState(() {
                                    _getAddress();
                                  });
                                },
                                color: Colors.black12,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text('Change or Delete Address'),
                                    Icon(Icons.delete)
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                bottomNavigationBar: Container(
                  color: Colors.white70,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: ListTile(
                            title: Text(
                              '₹${widget.totalAmount}',
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.w600),
                            ),
                            subtitle: Text('inclusive of all taxes',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.redAccent,
                                )),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: MaterialButton(
                            height: 45.0,
                            elevation: 0.3,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PaymentCheckout(
                                            totalAmount: widget.totalAmount,
                                            name: address[0]['name'],
                                            mobileNo:
                                            address[0]['mobileNo'],
                                            pinCode:
                                            address[0]['pinCode'],
                                            address:
                                            address[0]['address'],
                                            locality:
                                            address[0]['locality'],
                                            city: address[0]['city'],
                                            state: address[0]['state']
                                          )));
                            },
                            color: Colors.black,
                            child: Text(
                              'Continue',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 17),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            :
            //=================================================Address adding scaffold===============================================
            Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  elevation: 0.1,
                  backgroundColor: Colors.black,
                  title: Text(
                    'Add Address',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontFamily: 'Lobster'),
                  ),
                ),
                body: Form(
                  key: _formKey,
                  child: isLoading
                      ? Center(child: CircularProgressIndicator())
                      : ListView(
                          children: <Widget>[
                            Container(
                              color: Color.fromRGBO(245, 245, 246, 1.0),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 12, right: 12, top: 12, bottom: 6),
                                child: Text(
                                  'CONTACT DETAILS',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 15),
                                ),
                              ),
                            ),
                            Container(
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16, right: 16, bottom: 8, top: 8),
                                    child: TextFormField(
                                      controller: _nameTextController,
                                      keyboardType: TextInputType.text,
                                      validator: (String value) {
                                        if (value.isEmpty) {
                                          return "please enter a value";
                                        }
                                      },
                                      cursorColor: Colors.black,
                                      style: TextStyle(
                                        height: 1.0,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      decoration: InputDecoration(
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.black, width: 1.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.black45,
                                              width: 0.5),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.black45,
                                              width: 0.5),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.black, width: 1.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                        ),
                                        labelStyle:
                                            TextStyle(color: labelColor),
                                        labelText: 'Name*',
                                      ),
                                      cursorWidth: 0.8,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16,
                                        right: 16,
                                        bottom: 8,
                                        top: 16),
                                    child: TextFormField(
                                      controller: _mobileNoTextController,
                                      keyboardType: TextInputType.number,
                                      validator: (String value) {
                                        if (value.isEmpty) {
                                          return "please enter a value";
                                        } else if (value.length < 10) {
                                          return 'please enter a valid number';
                                        }
                                      },
                                      cursorColor: Colors.black,
                                      style: TextStyle(
                                        height: 1.0,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      decoration: InputDecoration(
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.black45,
                                              width: 0.5),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.black, width: 1.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.black45,
                                              width: 0.5),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.black, width: 1.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                        ),
                                        labelStyle:
                                            TextStyle(color: labelColor),
                                        labelText: 'Mobile No.*',
                                      ),
                                      cursorWidth: 0.8,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              color: Color.fromRGBO(245, 245, 246, 1.0),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 12, right: 12, top: 12, bottom: 6),
                                child: Text(
                                  'ADDRESS',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 15),
                                ),
                              ),
                            ),
                            Container(
                              color: Colors.white,
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16, right: 16, bottom: 8, top: 8),
                                    child: TextFormField(
                                      onChanged: (value) {
                                        getCityName(value);
                                      },
                                      controller: _pinCodeTextController,
                                      keyboardType: TextInputType.number,
                                      validator: (String value) {
                                        if (value.isEmpty) {
                                          return "please enter a value";
                                        } else if (value.length < 6) {
                                          return 'Minimum length id 6';
                                        }
                                      },
                                      cursorColor: Colors.black,
                                      style: TextStyle(
                                        height: 1.0,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      decoration: InputDecoration(
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.black, width: 1.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.black45,
                                              width: 0.5),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.black45,
                                              width: 0.5),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.black, width: 1.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                        ),
                                        labelStyle:
                                            TextStyle(color: labelColor),
                                        labelText: 'Pin Code',
                                      ),
                                      cursorWidth: 0.8,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16,
                                        right: 16,
                                        bottom: 8,
                                        top: 16),
                                    child: TextFormField(
                                      controller: _addressTextController,
                                      keyboardType: TextInputType.text,
                                      validator: (String value) {
                                        if (value.isEmpty) {
                                          return "please enter a value";
                                        }
                                      },
                                      cursorColor: Colors.black,
                                      style: TextStyle(
                                        height: 1.0,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      decoration: InputDecoration(
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.black45,
                                              width: 0.5),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.black, width: 1.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.black45,
                                              width: 0.5),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.black, width: 1.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                        ),
                                        labelStyle:
                                            TextStyle(color: labelColor),
                                        labelText:
                                            'Address(House No.,Building,Street,Area)*',
                                      ),
                                      cursorWidth: 0.8,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16,
                                        right: 16,
                                        bottom: 8,
                                        top: 16),
                                    child: TextFormField(
                                      controller: _localityTextController,
                                      keyboardType: TextInputType.text,
                                      validator: (String value) {
                                        if (value.isEmpty) {
                                          return "please enter a value";
                                        }
                                      },
                                      cursorColor: Colors.black,
                                      style: TextStyle(
                                        height: 1.0,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      decoration: InputDecoration(
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.black45,
                                              width: 0.5),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.black45,
                                              width: 0.5),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.black, width: 1.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.black, width: 1.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                        ),
                                        labelStyle:
                                            TextStyle(color: labelColor),
                                        labelText: 'Locality/Town*',
                                      ),
                                      cursorWidth: 0.8,
                                    ),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                          child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Container(
                                          color: Color.fromRGBO(
                                              245, 245, 246, 1.0),
                                          child: Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: city == null
                                                  ? Text('City/District*',
                                                      style: TextStyle(
                                                          color: labelColor))
                                                  : Text(
                                                      city,
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    )),
                                        ),
                                      )),
                                      Expanded(
                                          child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Container(
                                            color: Color.fromRGBO(
                                                245, 245, 246, 1.0),
                                            child: Padding(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: state == null
                                                    ? Text('State*',
                                                        style: TextStyle(
                                                            color: labelColor))
                                                    : Text(
                                                        state,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ))),
                                      )),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                ),
                bottomNavigationBar: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        bottom: 7, left: 15, right: 15, top: 10),
                    child: FlatButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          if (city != null && state != null) {
                            setState(() {
                              isLoading = true;
                            });
                            addressService.uploadAddress(
                              name: _nameTextController.text,
                              mobileNo: _mobileNoTextController.text,
                              pinCode: _pinCodeTextController.text,
                              address: _addressTextController.text,
                              locality: _localityTextController.text,
                              city: city,
                              state: state,
                            );
                            setState(() {
                              isLoading = false;
                            });
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Address(
                                          totalAmount: widget.totalAmount,
                                        )));
                          } else {
                            Fluttertoast.showToast(
                              msg: "Please enter a valid pin-code",
                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                            );
                          }
                        }
                      },
                      color: Colors.black,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Add Address',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ),
              );
  }

  Future<dynamic> getCityName(String pinCode) async {
    NetworkHelper networkHelper =
        NetworkHelper('https://api.postalpincode.in/pincode/${pinCode}');
    var cityData = await networkHelper.getData();
    setState(() {
      city = cityData[0]['PostOffice'][0]['District'];
      state = cityData[0]['PostOffice'][0]['State'];
    });
    return cityData;
  }
}
