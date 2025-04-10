import 'package:app/src/constants/constants.dart';
import 'package:app/src/presentation/widgets/widget_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internal_core/internal_core.dart';
import 'package:network_resources/voucher/models/models.dart';
import 'package:network_resources/voucher/repo.dart';
import 'package:url_launcher/url_launcher_string.dart';

class VoucherDetailScreen extends StatefulWidget {
  final VoucherModel voucher;
  const VoucherDetailScreen({super.key, required this.voucher});

  @override
  State<VoucherDetailScreen> createState() => _VoucherDetailScreenState();
}

class _VoucherDetailScreenState extends State<VoucherDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColorBackground,
      body: Column(
        children: [
          WidgetAppBar(
            title: widget.voucher.name,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    16.sw, 12, 16.sw, context.mediaQueryPadding.bottom + 12),
                child: Html(
                    data: widget.voucher.content,
                    style: {
                      "*": Style.fromTextStyle(GoogleFonts.fredoka()),
                      "h1": Style.fromTextStyle(
                          w500TextStyle(height: 1.4, fontSize: fs36())),
                      "h2": Style.fromTextStyle(
                          w300TextStyle(height: 1.4, fontSize: fs24(context))),
                      "h4": Style.fromTextStyle(
                        w300TextStyle(
                          fontSize: 16.sw,
                          height: 1.4,
                        ),
                      ),
                      "p": Style.fromTextStyle(
                          w300TextStyle(height: 1.4, fontSize: 16.sw)),
                    },
                    onLinkTap: (
                      String? url,
                      Map<String, String> attributes,
                      element,
                    ) {
                      if (url != null) {
                        launchUrlString(url);
                      }
                    }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
