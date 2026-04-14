import 'package:auto_route/annotations.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../app.dart';

@RoutePage()
class WebViewPage extends StatefulWidget {
  final String url;
  final String title;

  const WebViewPage({
    required this.url,
    required this.title,
    super.key,
  });

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() => _isLoading = true),
          onPageFinished: (_) => setState(() => _isLoading = false),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.current.whiteColor,
      appBar: AppBar(
        forceMaterialTransparency: true,
        scrolledUnderElevation: Dimens.d0,
        centerTitle: true,
        title:Text(widget.title),
        titleTextStyle: AppTextStyles.titleTextDefault(fontWeight:FontWeight.w500,fontSize: Dimens.d20),

      ),
      body: Stack(
        children: [
          WebViewWidget(
            controller: _controller,
          ),
          if (_isLoading)
            Center(
                child: CircularProgressIndicator(
              color: AppColors.current.primaryColor,
            )),
        ],
      ),
    );
  }
}
