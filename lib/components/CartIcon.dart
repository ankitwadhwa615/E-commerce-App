import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/Pages/Cart.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce/db/Cart_products_service.dart';

class CartIcon extends StatefulWidget {
  @override
  _CartIconState createState() => _CartIconState();
}

class _CartIconState extends State<CartIcon> {
  @override
  void initState() {
    super.initState();
    getCartProducts();
  }

  getCartProducts() async {
    List<DocumentSnapshot> data =
        await _cartProductService.getCartProducts().catchError((e) {
      print(e);
    });
    setState(() {
      products = data;
    });
  }

  CartProductService _cartProductService = CartProductService();
  List<DocumentSnapshot> products = <DocumentSnapshot>[];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Cart()));
      },
      child: new Stack(
        children: <Widget>[
          new IconButton(
            icon: new Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
            onPressed: null,
          ),
          products.length != 0
              ? Positioned(
                  top: 3.0,
                  right: 4,
                  child: new Stack(
                    children: <Widget>[
                      new Icon(Icons.brightness_1,
                          size: 18.0, color: Colors.white),
                      new Positioned(
                          top: 3.0,
                          right: 5.0,
                          child: new Center(
                            child: new Text(
                              products.length.toString(),
                              style: new TextStyle(
                                  color: Colors.black,
                                  fontSize: 11.0,
                                  fontWeight: FontWeight.w700),
                            ),
                          )),
                    ],
                  ))
              : Container(),
        ],
      ),
    );
  }
}
