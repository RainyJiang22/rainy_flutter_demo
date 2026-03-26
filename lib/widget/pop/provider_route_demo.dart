import 'package:first_flutter_demo/widget/pop/item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart' show ChangeNotifierProvider;

// class ProviderRouteDemo extends StatefulWidget {
//   const ProviderRouteDemo({super.key});
//
//   @override
//   State<ProviderRouteDemo> createState() => _ProviderRouteDemoState();
// }
//
// class _ProviderRouteDemoState extends State<ProviderRouteDemo> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Provider Router Demo')),
//       body: Center(
//         child: ChangeNotifierProvider<CartModel>(
//           data: CartModel(),
//           child: Builder(builder: (context) {
//             return Column(
//               children: <Widget>[
//                 Builder(builder: (context) {
//                   var cart = ChangeNotifierProvider.of<CartModel>(context);
//                   return Text("总价: ${cart.totalPrice}");
//                 }),
//                 Builder(builder: (context) {
//                   print("ElevatedButton build"); //在后面优化部分会用到
//                   return ElevatedButton(
//                     child: Text("添加商品"),
//                     onPressed: () {
//                       //给购物车中添加商品，添加后总价会更新
//                       ChangeNotifierProvider.of<CartModel>(context).add(
//                           Item(20.0, 1));
//                     },
//                   );
//                 }),
//               ],
//             );
//           }),
//         ),
//       )
//     );
//   }
// }
