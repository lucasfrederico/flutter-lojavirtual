import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrderTile extends StatelessWidget {
  final String orderId;

  OrderTile(this.orderId);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: StreamBuilder<DocumentSnapshot>(
          stream: Firestore.instance
              .collection('orders')
              .document(orderId)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            int currentStatus = snapshot.data['status'];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Código do pedido: ${snapshot.data.documentID}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 4.0,
                ),
                Text(_buildProductsText(snapshot.data)),
                SizedBox(
                  height: 4.0,
                ),
                Text(
                  'Status do pedido:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 4.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildCircle('1', 'Preparação', currentStatus, 1),
                    Container(
                      height: 1.0,
                      width: 40.0,
                      color: Colors.grey[500],
                    ),
                    _buildCircle('2', 'Transporte', currentStatus, 2),
                    Container(
                      height: 1.0,
                      width: 40.0,
                      color: Colors.grey[500],
                    ),
                    _buildCircle('3', 'Entrega', currentStatus, 3)
                  ],
                )
              ],
            );
          },
        ),
      ),
    );
  }

  String _buildProductsText(DocumentSnapshot snapshot) {
    String text = 'Descrição:\n';
    for (LinkedHashMap product in snapshot.data()['products']) {
      text +=
          '${product['quantity']}x ${product['product']['title']} (R\$ ${product['product']['price'].toString()})\n';
    }
    text += 'Total: R\$ ${snapshot.data()['totalPrice'].toString()}';

    return text;
  }

  Widget _buildCircle(
      String title, String subTitle, int currentStatus, int thisStatus) {
    Color backColor;
    Widget child;

    if (currentStatus < thisStatus) {
      backColor = Colors.grey[500];
      child = Text(
        title,
        style: TextStyle(color: Colors.white),
      );
    } else if (currentStatus == thisStatus) {
      backColor = Colors.blue;
      child = Stack(
        alignment: Alignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ],
      );
    } else {
      backColor = Colors.green;
      child = Icon(Icons.check, color: Colors.white,);
    }

    return Column(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: backColor,
          child: child,
        ),
        Text(subTitle)
      ],
    );
  }
}
