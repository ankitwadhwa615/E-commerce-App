import 'package:flutter/material.dart';

class RadioItem extends StatelessWidget {
  final RadioModel _item;
  RadioItem(this._item,);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: _item.isSelected ? Colors.red : Colors.black,
            width: 1.5,
          )),
      child: Padding(
        padding: EdgeInsets.all(_item.padding),
        child: Text(
          _item.buttonText,
          style: TextStyle(
              color: _item.isSelected ? Colors.red : Colors.black,
              fontSize: 18),
        ),
      ),
    );
  }
}

class RadioModel {
  bool isSelected;
  final String buttonText;
  final double padding;
  RadioModel(
    this.isSelected,
    this.buttonText,
      this.padding

  );
}
