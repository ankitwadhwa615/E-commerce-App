import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/db/Orders_service.dart';
import 'package:flutter/material.dart';

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  OrderProductService _orderProductService = OrderProductService();
  List<DocumentSnapshot> orders = <DocumentSnapshot>[];
  bool isLoading = false;
  @override
  void initState() {
    getOrderedProducts();
    super.initState();
  }

  getOrderedProducts() async {
    setState(() {
      isLoading = true;
    });
    List<DocumentSnapshot> data =
        await _orderProductService.getOrderedProducts().catchError((e) {
      print(e);
    });
    setState(() {
      orders = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: Colors.black,
        title: Text(
          'Orders',
          style: TextStyle(color: Colors.white, fontFamily: 'Lobster'),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : orders.length == 0
              ? NoOrders()
              : ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                            height: 100.0,
                                            child: Image.network(
                                                '${orders[index]['images'][0]}')),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5.0),
                                          child: Card(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    'Quantity:  ',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    '${orders[index]['quantity']}',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              '${orders[index]['brand']}',
                                              style: TextStyle(
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 5.0, bottom: 5.0),
                                            child: Text(
                                              '${orders[index]['description']}',
                                              style: TextStyle(
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.w300,
                                                  color: Colors.black54),
                                            ),
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Text(
                                                "Size:",
                                                style: TextStyle(
                                                    fontSize: 15.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child:
                                                    Text(orders[index]['size']),
                                              ),
                                              Text(
                                                "   Order date:",
                                                style: TextStyle(
                                                    fontSize: 15.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: Text(
                                                    '${orders[index]['date']}/${orders[index]['month']}/${orders[index]['year']}'),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Text(
                                                "Payment Method:",
                                                style: TextStyle(
                                                    fontSize: 15.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(6.0),
                                                child: Text(
                                                  '${orders[index]['paymentMethod']}',
                                                ),
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Text(
                                                '₹${orders[index]['currentPrice']}',
                                                style: TextStyle(
                                                    color: Colors.redAccent,
                                                    fontSize: 20.0,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              SizedBox(
                                                width: 10.0,
                                              ),
                                              Text(
                                                '${orders[index]['oldPrice']}',
                                                style: TextStyle(
                                                  fontSize: 15.0,
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.w500,
                                                  decoration: TextDecoration
                                                      .lineThrough,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
    );
  }
}

class NoOrders extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        SizedBox(
          height: 150,
        ),
        Image.asset(
          'images/EmptyCart.gif',
          fit: BoxFit.fill,
        ),
        SizedBox(
          height: 15,
        ),
        Center(
          child: Text(
            'No orders yet..',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w500,
            ),
          ),
        )
      ],
    );
  }
}
