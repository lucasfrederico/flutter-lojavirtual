import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_lojavirtual/datas/cart_product.dart';
import 'package:flutter_lojavirtual/datas/product_data.dart';
import 'package:flutter_lojavirtual/models/cart_model.dart';
import 'package:flutter_lojavirtual/models/user_model.dart';
import 'package:flutter_lojavirtual/screens/cart_screen.dart';
import 'package:flutter_lojavirtual/screens/login_screen.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductScreen extends StatefulWidget {
  final ProductData product;

  ProductScreen(this.product);

  @override
  _ProductScreenState createState() => _ProductScreenState(product);
}

class _ProductScreenState extends State<ProductScreen> {
  final ProductData product;

  String size;

  _ProductScreenState(this.product);

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          AspectRatio(
            aspectRatio: 0.9,
            child: Carousel(
              images: product.images.map((url) => NetworkImage(url)).toList(),
              dotSize: 4.0,
              dotSpacing: 15.0,
              dotBgColor: Colors.transparent,
              dotColor: primaryColor,
              autoplay: false,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  product.title,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 3,
                ),
                Text(
                  'R\$ ${product.price.toStringAsFixed(2)}',
                  style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      color: primaryColor),
                ),
                SizedBox(
                  height: 16.0,
                ),
                Text(
                  'Tamanho',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 34.0,
                  child: GridView(
                    padding: EdgeInsets.symmetric(vertical: 4.0),
                    scrollDirection: Axis.horizontal,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 0.5,
                    ),
                    children: product.sizes
                        .map(
                          (size) => GestureDetector(
                            onTap: () {
                              setState(() {
                                this.size = size;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4.0),
                                border: Border.all(
                                  color: size == this.size
                                      ? primaryColor
                                      : Colors.grey[500],
                                  width: 3.0,
                                ),
                              ),
                              width: 50.0,
                              alignment: Alignment.center,
                              child: Text(size),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                SizedBox(
                  height: 44.0,
                  child: ScopedModelDescendant<UserModel>(
                    builder: (context, child, model) {
                      return RaisedButton(
                        onPressed: size != null
                            ? () {
                                if (model.isLoggedIn()) {
                                  CartProduct cardProduct = CartProduct();
                                  cardProduct.size = size;
                                  cardProduct.quantity = 1;
                                  cardProduct.pid = product.id;
                                  cardProduct.category = product.category;
                                  cardProduct.productData = product;

                                  CartModel.of(context).addCartItem(cardProduct);

                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => CartScreen(),
                                    ),
                                  );
                                } else {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => LoginScreen(),
                                    ),
                                  );
                                }
                              }
                            : null,
                        child: Text(
                          model.isLoggedIn()
                              ? 'Adicionar ao Carrinho'
                              : 'Entre para comprar',
                          style: TextStyle(fontSize: 18.0),
                        ),
                        color: primaryColor,
                        textColor: Colors.white,
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                Text(
                  'Descrição',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  product.description,
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
