import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/Pages/HomePage.dart';
import 'package:ecommerce/components/loading.dart';
import 'package:ecommerce/db/Cart_products_service.dart';
import 'package:ecommerce/db/Orders_service.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

class PaymentCheckout extends StatefulWidget {
  final totalAmount;
  final name;
  final mobileNo;
  final pinCode;
  final address;
  final locality;
  final city;
  final state;
  PaymentCheckout(
      {@required this.totalAmount,
      @required this.name,
      @required this.address,
      @required this.mobileNo,
      @required this.pinCode,
      @required this.locality,
      @required this.state,
      @required this.city});
  @override
  _PaymentCheckoutState createState() => _PaymentCheckoutState();
}

class _PaymentCheckoutState extends State<PaymentCheckout> {
  Razorpay _razorPay = Razorpay();
  bool paymentDone = false;
  bool payOnDelivery = false;
  bool payNow = false;
  bool isLoading = false;
  OrderProductService _orderProductService = OrderProductService();
  CartProductService _productService = CartProductService();
  List<DocumentSnapshot> products = <DocumentSnapshot>[];
  List<DocumentSnapshot> orders = <DocumentSnapshot>[];
  DateTime now = DateTime.now();
  IconData payOnDeliveryIconFalse = Icons.check_box_outline_blank;
  IconData payOnDeliveryIconTrue = Icons.check_box;
  IconData payNowIconFalse = Icons.check_box_outline_blank;
  IconData payNowIconTrue = Icons.check_box;
  @override
  void initState() {
    super.initState();
    getProduct();
    _razorPay = Razorpay();
    _razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorPay.clear();
  }

  getProduct() async {
    setState(() {
      isLoading = true;
    });
    List<DocumentSnapshot> data =
        await _productService.getCartProducts().catchError((e) {
      print(e);
    });
    setState(() {
      products = data;
      isLoading = false;
    });
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_test_cdSYYam2Bf9NRS',
      'amount': widget.totalAmount * 100,
      'name': 'shoe bazaar',
      'description': 'Test payment',
      'prefill': {'contact': '', 'email': ''},
      'external': {
        'wallets': ['paytm']
      }
    };
    try {
      _razorPay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Loading()
        : Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              elevation: 0.1,
              backgroundColor: Colors.black,
              title: Text(
                'Select a payment method',
                style: TextStyle(
                    fontSize: 20, color: Colors.white, fontFamily: 'Lobster'),
              ),
            ),
            body: ListView(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        payNow = !payNow;
                        payOnDelivery = false;
                        openCheckout();
                      });
                    },
                    child: Card(
                      color: Colors.black,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                payNow ? payNowIconTrue : payNowIconFalse,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            Text(
                              'Pay Now',
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        payOnDelivery = !payOnDelivery;
                        payNow = false;
                      });
                    },
                    child: Card(
                      color: Colors.black,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                payOnDelivery
                                    ? payOnDeliveryIconTrue
                                    : payOnDeliveryIconFalse,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            Text(
                              'Pay On Delivery',
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
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
                          if (paymentDone == false && payOnDelivery == true) {
                            orderPlaced('Pay On Delivery');
                            showAlertDialog(context);
                          } else {
                            Fluttertoast.showToast(
                              msg: 'please Select a Payment method',
                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                            );
                          }
                        },
                        color: Colors.black,
                        child: Text(
                          'place order',
                          style: TextStyle(color: Colors.white, fontSize: 17),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
      msg: 'Success:' + response.paymentId,
      backgroundColor: Colors.black,
      textColor: Colors.white,
    );
    setState(() {
      orderPlaced('Paid Online');
      showAlertDialog(context);
    });
  }

  _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
      msg: 'External Wallet:' + response.walletName,
      backgroundColor: Colors.black,
      textColor: Colors.white,
    );
  }

  _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
      msg: response.message,
      backgroundColor: Colors.black,
      textColor: Colors.white,
    );
    setState(() {
      payNow = false;
      paymentDone = false;
      print(paymentDone);
    });
  }

  void orderPlaced(String paymentMethod) {
    var id = Uuid();
    String orderId = id.v1();
    _orderProductService.uploadUsersDetailsForAdmin(
        orderDateTime: now.toString(),
        month: now.month.toString(),
        date: now.day.toString(),
        year: now.year.toString(),
        orderId: orderId,
        name: widget.name,
        mobileNo: widget.mobileNo,
        address: widget.address,
        locality: widget.locality,
        pinCode: widget.pinCode,
        city: widget.city,
        state: widget.state,
        paymentMethod: paymentMethod,
        totalAmount: widget.totalAmount);
    for (int index = 0; index < products.length; index++) {
      _orderProductService.uploadOrderedProductsForAdmin(
        orderId: orderId,
        category: products[index]['category'],
        brand: products[index]['brand'],
        description: products[index]['description'],
        details: products[index]['details'],
        currentPrice: products[index]['currentPrice'],
        oldPrice: products[index]['oldPrice'],
        size: products[index]['size'],
        quantity: products[index]['quantity'],
        images: products[index]['images'],
      );
    }
    for (int index = 0; index < products.length; index++) {
      _orderProductService.uploadOrdersForUser(
        orderDateTime: now.toString(),
        month: now.month.toString(),
        date: now.day.toString(),
        year: now.year.toString(),
        paymentMethod: paymentMethod,
        brand: products[index]['brand'],
        description: products[index]['description'],
        details: products[index]['details'],
        currentPrice: products[index]['currentPrice'],
        oldPrice: products[index]['oldPrice'],
        size: products[index]['size'],
        quantity: products[index]['quantity'],
        images: products[index]['images'],
      );
    }
    for (int index = 0; index < products.length; index++) {
      _productService.deleteData(products[index]['id']);
    }
  }

  showAlertDialog(BuildContext context) {
    Widget continueButton = GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      },
      child: Card(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Continue Shopping',
                style: TextStyle(color: Colors.white,fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );
    AlertDialog alert = AlertDialog(
      title: Center(
          child: Column(
        children: <Widget>[
          Image.asset('images/check.png'),
          SizedBox(
            height: 15,
          ),
          Text("Order placed successfully")
        ],
      )),
      content: Container(
        height: 150,
        child: Column(
          children: [
            Text(
              'Your order has been placed successfully',
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
            continueButton
          ],
        ),
      ),
    );
    showDialog(
      barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: (){},
              child: alert);
        });
  }
}
