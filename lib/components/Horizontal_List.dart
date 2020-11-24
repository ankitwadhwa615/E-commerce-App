import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/Pages/Category_sorted_screen.dart';
import 'package:flutter/material.dart';
import '../db/Category_service.dart';

class HorizontalList extends StatefulWidget {
  @override
  _HorizontalListState createState() => _HorizontalListState();
}

class _HorizontalListState extends State<HorizontalList> {
  CategoryService categoryService=CategoryService();
  List<DocumentSnapshot> category = <DocumentSnapshot>[];
  bool isLoading=false;
  _getCategory() async {
    setState(() {
      isLoading=true;
    });
    List<DocumentSnapshot> data = await categoryService.getCategories()
        .catchError((e){print(e);});
    setState(() {
      category = data;
      isLoading=false;
    });
  }
  @override
  void initState() {
    super.initState();
    _getCategory();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 105.0,
      child: ListView.builder(
          itemCount: category.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Row(
              children: [
                              SizedBox(
                width: 7.5,
              ),
                InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CategorySortedScreen(category[index]['category'].toString())));
                    },
                    child: Column(
                      children: <Widget>[
                        CircleAvatar(
                          radius: 42,
                          backgroundColor: Colors.white,
                          backgroundImage: NetworkImage(
                            category[index]['image'],
                          ),
                        ),
                        Text('${category[index]['category']}')
                      ],
                    )),
                SizedBox(
                  width: 7.5,
                ),
              ],
            );
          }),
    );
  }
}
