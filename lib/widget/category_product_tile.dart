import 'package:flutter/material.dart';
import 'package:silkroute/pages/product.dart';

class CategoryProductTile extends StatefulWidget {
  const CategoryProductTile({this.id});

  final String id;

  @override
  _CategoryProductTileState createState() => _CategoryProductTileState();
}

class _CategoryProductTileState extends State<CategoryProductTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductPage(id: widget.id),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.02,
          vertical: MediaQuery.of(context).size.width * 0.03,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(25),
          ),
          color: Colors.grey[500],
        ),
        alignment: Alignment.center,
        child: Text(
          widget.id,
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
