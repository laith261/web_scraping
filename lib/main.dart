import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:html/parser.dart' as pares;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHonePage(),
    );
  }
}

class MyHonePage extends StatelessWidget {
  const MyHonePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Butt(image: "assets/zara.png", url: "https://www.zara.com"),
            Butt(image: "assets/shien.png", url: "https://shein.com"),
          ],
        ),
      ),
    );
  }
}

class Butt extends StatelessWidget {
  const Butt({Key? key, required this.image, required this.url})
      : super(key: key);
  final String image;
  final String url;
  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 100,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Web(url: url),
            ),
          );
        },
        child: Image.asset(image),
      ),
    );
  }
}

class Web extends StatefulWidget {
  const Web({Key? key, required this.url}) : super(key: key);
  final String url;
  @override
  State<Web> createState() => _WebState();
}

class _WebState extends State<Web> {
  String? name;
  List<String>? sizes = [];
  bool fetch = false;
  late final WebViewController _controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..setNavigationDelegate(
      NavigationDelegate(
        onUrlChange: (url) {
          setState(() {
            fetch = false;
            name = null;
            sizes = [];
          });
        },
        onProgress: (int progress) {},
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) {
          return NavigationDecision.navigate;
        },
      ),
    )
    ..addJavaScriptChannel("myCh", onMessageReceived: (ch) {
      var dom = pares.parse(ch.message);
      setState(() {
        name = dom.querySelector("div.goods-name")?.text;
        sizes = dom
                .querySelector("ul.goods-size__sizes.choose-size")
                ?.text
                .split(RegExp(r"\s+")) ??
            [];
        fetch = false;
      });
      showBottom();
    })
    ..loadRequest(Uri.parse(widget.url));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() => fetch = true);
          _controller.runJavaScriptReturningResult(
              "(function(){myCh.postMessage(window.document.documentElement.outerHTML)})();");
        },
        child: fetch
            ? const CircularProgressIndicator(
                backgroundColor: Colors.white,
                color: Colors.black,
              )
            : const Icon(Icons.add_shopping_cart),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }

  void showBottom() {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          width: double.infinity,
          height: 350,
          child: Column(
            children: [
              Text(
                name!,
                textAlign: TextAlign.center,
              ),
              if (sizes?.isNotEmpty ?? false)
                Wrap(
                  children: sizes!.map((element) => Text(element)).toList(),
                ),
            ],
          ),
        );
      },
    );
  }
}
