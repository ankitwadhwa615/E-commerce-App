import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/db/Product_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce/Pages/HomePage.dart';
import 'package:ecommerce/Pages/Cart.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../components/Radio_Button.dart';
import '../db/Cart_products_service.dart';

class ProductDetails extends StatefulWidget {
  final product_id;
  final product_brand_name;
  final product_description;
  final product_details;
  final product_new_price;
  final product_old_price;
  final List product_images;
  final product_category;

  ProductDetails(
      {this.product_id,
      this.product_brand_name,
      this.product_description,
      this.product_details,
      this.product_images,
      this.product_new_price,
      this.product_old_price,
      this.product_category});

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  List<RadioModel> SizeList = [
    RadioModel(false, '7', 15),
    RadioModel(false, '8', 15),
    RadioModel(false, '9', 15),
    RadioModel(false, '10', 10),
    RadioModel(false, '11', 10),
  ];
  CartProductService _productService = CartProductService();
  String size = null;
  bool isLoading = false;
  final _auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    setState(() {
      isLoading = true;
    });
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
        print(user.email);
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget imageCarousal = Container(
      child: Carousel(
        boxFit: BoxFit.fill,
        dotBgColor: Colors.transparent,
        images: [
          Image.network(widget.product_images[0]),
          Image.network(widget.product_images[1]),
          Image.network(widget.product_images[2]),
        ],
        autoplay: false,
        dotSize: 3.0,
        dotColor: Colors.grey,
        dotIncreasedColor: Colors.black,
        indicatorBgPadding: 8.0,
      ),
    );
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(
              elevation: 0.1,
              backgroundColor: Colors.black,
              title: InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomeScreen()));
                },
                child: Text(
                  'Shoe Bazaar',
                  style: TextStyle(
                      fontSize: 25, color: Colors.white, fontFamily: 'Lobster'),
                ),
              ),
              actions: <Widget>[
                IconButton(
                    icon: Icon(Icons.shopping_cart, color: Colors.white),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Cart()));
                    })
              ],
            ),

//============body================
            body: ListView(
              children: <Widget>[
                Container(height: 460, child: imageCarousal),
                SizedBox(height: 15),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '${widget.product_brand_name}',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 22.0,
                          fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      '${widget.product_description}',
                      style: TextStyle(fontSize: 16.0),
                      textAlign: TextAlign.center,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '₹${widget.product_new_price}',
                          style: TextStyle(
                              fontSize: 25.0,
                              color: Colors.red,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          '${widget.product_old_price}',
                          style: TextStyle(
                            fontSize: 17.0,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'inclusive of all taxes',
                      style: TextStyle(fontSize: 14.0, color: Colors.black54),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                SizedBox(
                  height: 15.0,
                ),
                Divider(
                  color: Colors.black,
                  thickness: 1.0,
                ),
                //========================================Size buttons=======================================
                Padding(
                  padding: const EdgeInsets.only(left: 12, bottom: 6, top: 8),
                  child: Text(
                    'Size',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                Container(
                  height: 70,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: SizeList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return new GestureDetector(
                        onTap: () {
                          setState(() {
                            SizeList.forEach(
                                (element) => element.isSelected = false);
                            SizeList[index].isSelected = true;
                            size = SizeList[index].buttonText;
                            print(size);
                          });
                        },
                        child: new RadioItem(SizeList[index]),
                      );
                    },
                  ),
                ),

                //==========buy now button========
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 4,
                        child: MaterialButton(
                          onPressed: () {
                            if(size==null){
                              Fluttertoast.showToast(msg: "Please select a size",backgroundColor: Colors.black,textColor: Colors.white,);
                            }else {
                              setState(() {
                                isLoading=true;
                              });
                              _productService.uploadProducts(
                                quantity: 1,
                                brand: widget.product_brand_name,
                                details: widget.product_details,
                                description: widget.product_description,
                                oldPrice: widget.product_old_price,
                                currentPrice: widget.product_new_price,
                                size: size,
                                images: widget.product_images,
                              );
                              setState(() {
                                isLoading=false;
                              });
                              Navigator.pushReplacement(
                                  context, MaterialPageRoute(builder: (context) => Cart()));
                            }
                          },
                          elevation: 0.2,
                          color: Colors.black,
                          textColor: Colors.white,
                          child: Text('Buy now'),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: IconButton(
                          onPressed: () {

                            if(size==null){
                              Fluttertoast.showToast(msg: "Please select a size",backgroundColor: Colors.black,textColor: Colors.white,);
                            }else {
                              setState(() {
                                isLoading=true;
                              });
                              _productService.uploadProducts(
                                quantity: 1,
                                brand: widget.product_brand_name,
                                details: widget.product_details,
                                description: widget.product_description,
                                oldPrice: widget.product_old_price,
                                currentPrice: widget.product_new_price,
                                size: size,
                                images: widget.product_images,
                              );
                              setState(() {
                                isLoading=false;
                              });
                              Fluttertoast.showToast(msg: "Product added to cart",backgroundColor: Colors.black,textColor: Colors.white,);
                            }
                          },
                          icon: Icon(Icons.add_shopping_cart),
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  title: Text(
                    'Product Details:',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text('${widget.product_details}'),
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 5.0, top: 12.0, bottom: 5.0),
                      child: Text(
                        'Product name:',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Flexible(
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0,
                                right: 24.0,
                                top: 12.0,
                                bottom: 5.0),
                            child: Text(
                              '${widget.product_description}',
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 5.0, top: 12.0, bottom: 5.0),
                      child: Text(
                        'Brand name:',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 12.0, right: 5.0, top: 12.0, bottom: 5.0),
                      child: Text('${widget.product_brand_name}',
                          textAlign: TextAlign.right),
                    )
                  ],
                ),

                Divider(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Similar Products',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                    Container(
                      height: 400.0,
                      child: SimilarProducts(),
                    ),
                  ],
                ),
              ],
            ),
          );
  }
}

//===================================Similar Products=============================================================================
class SimilarProducts extends StatefulWidget {
  @override
  _SimilarProductsState createState() => _SimilarProductsState();
}

class _SimilarProductsState extends State<SimilarProducts> {
  ProductService _productService = ProductService();
  List<DocumentSnapshot> products = <DocumentSnapshot>[];
  bool isLoading = false;
  @override
  void initState() {
    _getProduct();
    super.initState();
  }

  _getProduct() async {
    setState(() {
      isLoading = true;
    });
    List<DocumentSnapshot> data =
        await _productService.getProducts().catchError((e) {
      print(e);
    });
    setState(() {
      products = data;
      isLoading = false;
    });
  }

  ProductDetails productDetails = ProductDetails();

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : GridView.builder(
            itemCount: products.length,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemBuilder: (BuildContext context, int index) {
              return Similar_Single_Product(
                prod_brand_name: products[index]['brand'],
                prod_displayname: products[index]['displayName'],
                prod_description: products[index]['description'],
                prod_details: products[index]['details'],
                prod_image: products[index]['images'],
                prod_oldPrice: products[index]['oldPrice'],
                prod_price: products[index]['currentPrice'],
              );
            });
  }
}

class Similar_Single_Product extends StatelessWidget {
  final prod_displayname;
  final prod_brand_name;
  final prod_description;
  final prod_details;
  final List prod_image;
  final prod_oldPrice;
  final prod_price;
  Similar_Single_Product(
      {this.prod_displayname,
      this.prod_brand_name,
      this.prod_description,
      this.prod_details,
      this.prod_image,
      this.prod_oldPrice,
      this.prod_price});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Material(
        child: InkWell(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => ProductDetails(
                      product_brand_name: prod_brand_name,
                      product_description: prod_description,
                      product_details: prod_details,
                      product_images: prod_image,
                      product_new_price: prod_price,
                      product_old_price: prod_oldPrice,
                    )),
          ),
          child: GridTile(
            footer: Container(
              color: Colors.white70,
              child: ListTile(
                leading: Text(
                  '$prod_displayname',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                title: (Text(
                  'Rs:$prod_price',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w800,
                  ),
                )),
                subtitle: Text(
                  'Rs$prod_oldPrice',
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w800,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ),
            ),
            child: Image.network(
              prod_image[0],
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
