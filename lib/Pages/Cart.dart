import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/db/Cart_products_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'Address_form.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  CartProductService _productService = CartProductService();
  List<DocumentSnapshot> products = <DocumentSnapshot>[];
  double totalAmount=0;
  var quantity = [1, 2, 3];
  bool isLoading = false;
  @override
  void initState() {
   getProductAndAmount();
    super.initState();
  }
  getProductAndAmount() async{
    setState(() {
      isLoading=true;
      totalAmount=0;
    });
    List<DocumentSnapshot> data = await _productService.getCartProducts().catchError((e){print(e);});
    setState(() {
      products = data;
      for(int i=0;i<products.length;i++){
        double price=products[i]['currentPrice'];
        int quantity=products[i]['quantity'];
        totalAmount=totalAmount+(price*quantity);
      }
      isLoading=false;
    });
  }
  getProduct() async {
    setState(() {
      isLoading=true;
    });
    List<DocumentSnapshot> data = await _productService.getCartProducts().catchError((e){print(e);});
    setState(() {
      products = data;

      isLoading=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: Colors.black,
        title: Text
          (
          'Shopping cart',
          style: TextStyle(color: Colors.white,fontFamily: 'Lobster'),
        ),
      ),


      body: isLoading?Center(child: CircularProgressIndicator()):products.length==0?EmptyCart(): ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(top:5.0),
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
                                    child: Image.network('${products[index]['images'][0]}')),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: Card(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text('Quantity:  ',style: TextStyle(fontWeight: FontWeight.bold),),
                                        DropdownButtonHideUnderline(
                                          child: DropdownButton<int>(
                                            elevation: 0,
                                            iconEnabledColor: Colors.black,
                                            items: quantity.map((int dropDownStringItem) {
                                              return DropdownMenuItem<int>(
                                                value: dropDownStringItem,
                                                child: Text('${dropDownStringItem}'),
                                              );
                                            }).toList(),
                                            onChanged: (int quantitySelected){
                                              setState(() {
                                                _productService.updateData(products[index]['id'], quantitySelected);
                                                getProductAndAmount();
                                              });
                                            },
                                            value: products[index]['quantity'],
                                          ),
                                        ),
                                      ],
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
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      '${products[index]['brand']}',
                                      style: TextStyle(
                                          fontSize: 20.0, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                                    child: Text('${products[index]['description']}',
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
                                            fontSize: 15.0, fontWeight: FontWeight.bold),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(products[index]['size']),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        '₹${products[index]['currentPrice']}',
                                        style: TextStyle(
                                            color: Colors.redAccent,
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      Text(
                                        '${products[index]['oldPrice']}',
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w500,
                                          decoration: TextDecoration.lineThrough,
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
                      MaterialButton(
                        onPressed: () {
                          setState(() {
                            isLoading=true;
                          });
                          _productService.deleteData(products[index]['id']);
                          setState(() {
                            isLoading=false;
                            totalAmount=totalAmount-(products[index]['currentPrice']*products[index]['quantity']);
                            getProduct();
                          });
                          Fluttertoast.showToast(msg: "Product removed from cart",backgroundColor: Colors.black,textColor: Colors.white,);
                        },
                        color: Colors.white38,
                        elevation: .3,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Remove"),
                            SizedBox(width: 10),
                            Icon(Icons.delete)
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }),


      bottomNavigationBar:Container(
        color:Colors.white70,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Expanded(
          flex: 2,
                child: ListTile(
                 title: Text('₹${totalAmount}',style: TextStyle(fontSize: 22,fontWeight: FontWeight.w600),),
                  subtitle: Text('inclusive of all taxes',style: TextStyle(fontSize: 12,color: Colors.redAccent,)),
                ),
              ),
              Expanded(
                flex:3,
                child: MaterialButton(
                  height: 45.0,
                  elevation: 0.3,
                  onPressed: (){
                    if(products.length!=0){
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => Address()));}
                    else{
                      Fluttertoast.showToast(msg: "your cart is empty",backgroundColor: Colors.black,textColor: Colors.white,);
                    }
                  },
                  color: Colors.black,
                  child: Text('Place Order',style: TextStyle(color:Colors.white,fontSize: 17),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}
class EmptyCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        SizedBox(height: 150,),
        Image.asset('images/EmptyCart.gif',fit: BoxFit.fill,),
        SizedBox(height: 15,),
        Center(
          child: Text('Hey, your cart is empty..',style: TextStyle(fontSize: 26,fontWeight: FontWeight.w500,),
          ),
        )
      ],
    );
  }
}