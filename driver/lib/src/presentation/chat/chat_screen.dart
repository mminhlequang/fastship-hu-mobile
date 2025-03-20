import 'package:app/src/constants/constants.dart';
import 'package:app/src/utils/app_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:internal_core/internal_core.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _chatController = TextEditingController();

  @override
  void dispose() {
    _scrollController.dispose();
    _chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: appHideKeyboard,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('User_1234'.tr()),
          actions: [
            IconButton(
              icon: WidgetAppSVG('ic_phone'),
              onPressed: () {
                // Todo:
              },
            ),
            Gap(4.sw),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  ListView.separated(
                    controller: _scrollController,
                    reverse: true,
                    padding: EdgeInsets.fromLTRB(16.sw, 66.sw, 16.sw, 47.sw),
                    itemCount: 20,
                    separatorBuilder: (context, index) => Gap(16.sw),
                    itemBuilder: (context, index) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: index.isOdd
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12.sw, vertical: 8.sw),
                            decoration: BoxDecoration(
                              color: index.isOdd
                                  ? hexColor('#86D05D')
                                  : Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                                bottomRight: index.isOdd
                                    ? Radius.zero
                                    : Radius.circular(12),
                                bottomLeft: index.isOdd
                                    ? Radius.circular(12)
                                    : Radius.zero,
                              ),
                            ),
                            child: Text(
                              index.isOdd
                                  ? 'Đơn hàng đã đến nơi rồi bạn ơi. Nhanh nhanh ra nhận thôi nào!'
                                  : 'Hello!',
                              style: w400TextStyle(
                                fontSize: 16.sw,
                                color:
                                    index.isOdd ? Colors.white : appColorText,
                              ),
                            ),
                          ),
                          Gap(4.sw),
                          Text(
                            '8:32 a.m',
                            style: w400TextStyle(
                                color: appColorText.withValues(alpha: .5)),
                          ),
                        ],
                      );
                    },
                  ),
                  Positioned(
                    top: 0,
                    child: Container(
                      color: Colors.white,
                      width: context.width,
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.sw, vertical: 8.sw),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Gong Cha Bubble Tea',
                            style: w500TextStyle(),
                          ),
                          Gap(2.sw),
                          Text(
                            '${'Order code'.tr()}: 436EREHS',
                            style: w400TextStyle(color: grey1),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 8.sw,
                    left: 0,
                    right: 0,
                    child: SizedBox(
                      height: 23.sw,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.only(left: 16.sw, right: 12.sw),
                        children: [
                          'Please wait for me 2mins',
                          'I’m coming',
                          'I have arrived, please receive the goods',
                        ]
                            .map((e) => Padding(
                                  padding: EdgeInsets.only(right: 4.sw),
                                  child: WidgetRippleButton(
                                    onTap: () {
                                      // Todo:
                                    },
                                    radius: 99,
                                    border: Border.all(
                                        color: hexColor('#E8E8E8')),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8.sw, vertical: 4.sw),
                                      child: Text(
                                        e,
                                        style: w500TextStyle(
                                          fontSize: 12.sw,
                                          color: grey1,
                                        ),
                                      ),
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              width: context.width,
              padding: EdgeInsets.fromLTRB(16.sw, 12.sw, 16.sw,
                  12.sw + context.mediaQueryPadding.bottom),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _chatController,
                      style: w400TextStyle(),
                      maxLines: null,
                      decoration: InputDecoration(
                        isDense: true,
                        isCollapsed: true,
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 12.sw, vertical: 8.sw),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: hexColor('#EFEFEF')),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: hexColor('#EFEFEF')),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        hintText: 'Enter your message here...'.tr(),
                        hintStyle: w400TextStyle(color: grey9),
                      ),
                    ),
                  ),
                  Gap(8.sw),
                  GestureDetector(
                    onTap: () {
                      appHaptic();
                      // Todo:
                    },
                    child: WidgetAppSVG('ic_image'),
                  ),
                  Gap(8.sw),
                  GestureDetector(
                    onTap: () {
                      appHaptic();
                      // Todo:
                    },
                    child: WidgetAppSVG('ic_camera'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
