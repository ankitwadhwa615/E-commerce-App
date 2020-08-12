import 'package:flutter/material.dart';

class HorizontalList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 105.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          SizedBox(width: 15,),
          InkWell(
            onTap: (){},
            child: Column(
              children: <Widget>[
                CircleAvatar(
                  radius: 42,
                  backgroundImage: AssetImage('images/cats/casual.jpg'),
                ),
                Text('Casual shoes')
              ],
            )
            ),
          SizedBox(width: 15,),
          InkWell(
              onTap: (){},
              child: Column(
                children: <Widget>[
                  CircleAvatar(
                    radius: 42,
                    backgroundImage: AssetImage('images/cats/sneaker.jpg'),
                  ),
                  Text('Sneakers')
                ],
              )
          ),
          SizedBox(width: 15,),
          InkWell(
              onTap: (){},
              child: Column(
                children: <Widget>[
                  CircleAvatar(
                    radius: 42,
                    backgroundImage: AssetImage('images/cats/formal.jpg'),
                  ),
                  Text('Formal shoes')
                ],
              )
          ),
          SizedBox(width: 15,),
          InkWell(
              onTap: (){},
              child: Column(
                children: <Widget>[
                  CircleAvatar(
                    radius: 42,
                    backgroundImage: AssetImage('images/cats/sports.jpg'),
                  ),
                  Text('Sports shoes')
                ],
              )
          ),
          SizedBox(width: 15,),
          InkWell(
              onTap: (){},
              child: Column(
                children: <Widget>[
                  CircleAvatar(
                    radius: 42,
                    backgroundImage: AssetImage('images/cats/sandals.jpg'),
                  ),
                  Text('casual')
                ],
              )
          ),
          SizedBox(width: 15,),
          InkWell(
              onTap: (){},
              child: Column(
                children: <Widget>[
                  CircleAvatar(
                    radius: 42,
                    backgroundImage: AssetImage('images/cats/flipflops.jpg'),
                  ),
                  Text('Flip-Flops')
                ],
              )
          ),
         SizedBox(width: 10,)
        ],
      ),
    );
  }
}
