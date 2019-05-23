import 'package:flutter/material.dart';
import 'package:flutter_material_components_sample/model/product.dart';
import 'package:flutter_material_components_sample/supplemental/product_columns.dart';

class AsymmetricView extends StatelessWidget {
  final List<Product> products;

  AsymmetricView({Key key, this.products});

  List<Container> _buildColumns(BuildContext context) {
    if (products == null || products.isEmpty) {
      return <Container>[];
    }

    return List.generate(_listItemCount(products.length), (int index) {
      double width = .59 * MediaQuery.of(context).size.width;
      Widget column;

      if (index % 2 == 0) {
        int bottom = _eventCasesIndex(index);
        column = TwoProductCardColumn(
            bottom: products[bottom],
            top: products.length - 1 >= bottom + 1
                ? products[bottom + 1]
                : null);
        width += 32;
      } else {
        column = OneProductCardColumn(
          product: products[_oddCasesIndex(index)],
        );
      }

      return Container(
        width: width,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
        ),
      );
    }).toList();
  }

  int _eventCasesIndex(int input) {
    return input ~/ 2 * 3;
  }

  int _oddCasesIndex(int input) {
    assert(input > 0);
    return (input / 2).ceil() * 3 - 1;
  }

  int _listItemCount(int totalItems) {
    if (totalItems % 3 == 0) {
      return totalItems ~/ 3 * 2;
    } else {
      return (totalItems / 3).ceil() * 2 - 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.fromLTRB(0, 34, 16, 44),
      children: _buildColumns(context),
    );
  }
}