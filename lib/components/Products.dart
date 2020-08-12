import 'package:ecommerce/Pages/Prduct_Details.dart';
import'package:ecommerce/db/Product_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Products extends StatefulWidget {
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  ProductService _productService = ProductService();
  List<DocumentSnapshot> products = <DocumentSnapshot>[];
  bool isLoading=false;
  @override
  void initState() {
  _getProduct();
    super.initState();
  }
_getProduct() async {
  setState(() {
    isLoading=true;
  });
  List<DocumentSnapshot> data = await _productService.getProducts().catchError((e){print(e);});
  setState(() {
    products = data;
    isLoading=false;
  });
}
  // ignore: non_constant_identifier_names
  @override
  Widget build(BuildContext context) {
    return isLoading?Center(child: CircularProgressIndicator()):GridView.builder(
        itemCount: products.length,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index) {
            return Product(
              product_id: products[index]['id'],
            prod_brand_name: products[index]['brand'],
            prod_displayname: products[index]['displayName'],
            prod_description: products[index]['description'],
            prod_details: products[index]['details'],
            prod_image: products[index]['images'],
            prod_oldPrice: products[index]['oldPrice'],
            prod_price: products[index]['currentPrice'],
            prod_category:  products[index]['category']
          );
        });
  }
}

class Product extends StatelessWidget {
  final product_id;
  final prod_displayname;
  final prod_brand_name;
  final prod_description;
  final prod_details;
  final prod_image;
  final prod_oldPrice;
  final prod_price;
  final prod_category;
  Product({
      this.product_id,
      this.prod_displayname,
        this.prod_brand_name,
      this.prod_description,
      this.prod_details,
      this.prod_image,
      this.prod_oldPrice,
      this.prod_price,
      this.prod_category});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Material(
        child: InkWell(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => ProductDetails(
                  product_id: product_id,
                  product_category: prod_category,
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
                leading: Text('$prod_displayname',
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),
            ),
                title: (Text(
                  'Rs:$prod_price',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.red,
                    fontWeight: FontWeight.w800,
                  ),
                )),
                subtitle: Text(
                  'Rs$prod_oldPrice',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                    fontWeight: FontWeight.w800,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ),
            ),
            child: Image.network(prod_image[0],fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
