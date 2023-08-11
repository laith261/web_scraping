// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:html/parser.dart' as pares;
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const MyHonePage(),
//     );
//   }
// }
//
// class MyHonePage extends StatelessWidget {
//   const MyHonePage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: const [
//             Butt(image: "assets/zara.png", url: "https://www.zara.com"),
//             Butt(image: "assets/shien.png", url: "https://shein.com"),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class Butt extends StatelessWidget {
//   const Butt({Key? key, required this.image, required this.url})
//       : super(key: key);
//   final String image;
//   final String url;
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox.square(
//       dimension: 100,
//       child: ElevatedButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => Web(url: url),
//             ),
//           );
//         },
//         child: Image.asset(image),
//       ),
//     );
//   }
// }
//
// class Web extends StatefulWidget {
//   const Web({Key? key, required this.url}) : super(key: key);
//   final String url;
//   @override
//   State<Web> createState() => _WebState();
// }
//
// class _WebState extends State<Web> {
//   late WebViewController _controller;
//   String? name;
//   List<String>? sizes = [];
//   JavascriptChannel _extractDataJSChannel(BuildContext context) {
//     return JavascriptChannel(
//       name: 'Flutter',
//       onMessageReceived: (JavascriptMessage message) {
//         var dom = pares.parse(message.message);
//         setState(() {
//           name = dom.querySelector("div.goods-name")?.text;
//           sizes = dom
//                   .querySelector("ul.goods-size__sizes.choose-size")
//                   ?.text
//                   .split(RegExp(r"\s+")) ??
//               [];
//         });
//         print(name);
//         print(sizes);
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: name != null
//           ? FloatingActionButton(
//               onPressed: () {
//                 showModalBottomSheet(
//                   context: context,
//                   builder: (BuildContext context) {
//                     return SizedBox(
//                       width: double.infinity,
//                       height: 150,
//                       child: Column(
//                         children: [
//                           Text(name ?? ""),
//                           if (sizes?.isNotEmpty ?? false)
//                             Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceEvenly,
//                                 children: sizes
//                                         ?.map((element) => Text(element))
//                                         .toList() ??
//                                     [])
//                         ],
//                       ),
//                     );
//                   },
//                 );
//               },
//               child: const Icon(Icons.add_shopping_cart),
//             )
//           : null,
//       body: WebView(
//         initialUrl: widget.url,
//         javascriptMode: JavascriptMode.unrestricted,
//         javascriptChannels: <JavascriptChannel>{
//           _extractDataJSChannel(context),
//         },
//         onWebViewCreated: (WebViewController webViewController) {
//           _controller = webViewController;
//         },
//         onPageStarted: (url) {
//           setState(() {
//             name = null;
//             sizes = [];
//           });
//           _controller.evaluateJavascript(
//               "(function(){Flutter.postMessage(window.document.documentElement.outerHTML)})();");
//         },
//         onPageFinished: (String url) {},
//       ),
//     );
//   }
// }
