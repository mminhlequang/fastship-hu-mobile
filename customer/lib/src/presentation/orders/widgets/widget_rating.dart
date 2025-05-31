import 'package:app/src/constants/constants.dart';
import 'package:app/src/presentation/widgets/widget_appbar.dart';
import 'package:app/src/presentation/widgets/widget_button.dart';
import 'package:app/src/utils/app_utils.dart';
import 'package:app/src/utils/utils.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:internal_core/internal_core.dart';
import 'package:internal_core/widgets/widget_commons.dart';
import 'package:network_resources/cart/models/models.dart';
import 'package:network_resources/network_resources.dart';
import 'package:network_resources/order/models/models.dart';
import 'package:network_resources/rating/repo.dart';

class WidgetRating extends StatefulWidget {
  final OrderModel m;
  const WidgetRating({
    super.key,
    required this.m,
  });

  @override
  State<WidgetRating> createState() => _WidgetRatingState();
}

class _WidgetRatingState extends State<WidgetRating> {
  bool loading = false;
  double storeRating = 5; // Rating cho quán ăn
  Map<int, double> itemRatings = {}; // Rating cho từng món ăn
  TextEditingController commentController = TextEditingController();
  List<String> get _satisfactionTags => [
        'Fast delivery',
        'Friendly service',
        'Delicious food',
        'Good quality',
        'Reasonable price',
      ];

  @override
  void initState() {
    super.initState();
    // Khởi tạo rating cho từng món ăn
    for (int i = 0; i < (widget.m.items?.length ?? 0); i++) {
      itemRatings[i] = 5;
    }
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  _onSubmit() async {
    if (loading) return;

    setState(() {
      loading = true;
    });

    try {
      final futures = <Future>[];

      for (int i = 0; i < (widget.m.items?.length ?? 0); i++) {
        futures.add(RatingRepo().insertProductRating({
          "product_id": widget.m.items?[i].product?.id,
          "star": itemRatings[i],
          "content": commentController.text,
          "order_id": widget.m.id,
        }));
      }

      futures.add(RatingRepo().insertStoreRating({
        "store_id": widget.m.store?.id,
        "star": storeRating,
        "content": commentController.text,
        "order_id": widget.m.id
      }));

      await Future.wait(futures);
    } catch (e) {
      print(e);
    } finally {
      if (mounted) {
        Navigator.of(context).pop();
        appShowSnackBar(
          context: context,
          msg: "Thank you for your feedback!".tr(),
          type: AppSnackBarType.success,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          WidgetAppBar(
            showBackButton: true,
            title: 'Rate Your Order'.tr(),
            actions: [],
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),

                  // Thông tin quán ăn
                  _buildStoreInfo(),

                  const SizedBox(height: 24),

                  // Rating cho quán ăn
                  _buildStoreRating(),

                  const SizedBox(height: 24),

                  // Danh sách món ăn với rating
                  _buildFoodItemsList(),

                  const SizedBox(height: 24),

                  // Comment section
                  _buildCommentSection(),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          _buildSubmitButton(),
        ],
      ),
    );
  }

  Widget _buildStoreInfo() {
    return Center(
      child: Column(
        children: [
          WidgetAvatar.withoutBorder(
            imageUrl: widget.m.store?.avatarImage ?? '',
            radius: 60,
          ),
          const SizedBox(height: 16),
          Text(
            widget.m.store?.name ?? '',
            textAlign: TextAlign.center,
            style: w500TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 8),
          Text(
            widget.m.store?.address ?? '',
            textAlign: TextAlign.center,
            style: w400TextStyle(
              fontSize: 14,
              height: 1.4,
              color: appColorText2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoreRating() {
    return Column(
      children: [
        Text(
          "How was the restaurant?".tr(),
          style: w500TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 8),
        Text(
          "Rate the overall service and quality".tr(),
          textAlign: TextAlign.center,
          style: w400TextStyle(
            fontSize: 14,
            height: 1.4,
            color: appColorText2,
          ),
        ),
        const SizedBox(height: 16),
        RatingBar.builder(
          initialRating: storeRating,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: false,
          itemCount: 5,
          itemSize: 40,
          unratedColor: appColorBorder,
          itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, _) => WidgetAppSVG(
            'icon91',
            color: appColorPrimaryOrange,
          ),
          onRatingUpdate: (value) {
            setState(() {
              storeRating = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildFoodItemsList() {
    if (widget.m.items == null || widget.m.items!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Rate each dish".tr(),
          style: w500TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 12),
        DottedBorder(
          options: RoundedRectDottedBorderOptions(
            radius: Radius.circular(16),
            padding: EdgeInsets.all(16),
            strokeWidth: 1,
            dashPattern: [8, 4],
            color: Color(0xFFCEC6C5),
          ),
          child: Column(
            children: [
              ...widget.m.items!.asMap().entries.map((entry) {
                int index = entry.key;
                CartItemModel item = entry.value;
                return _buildFoodItem(item, index);
              }).toList(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFoodItem(CartItemModel item, int index) {
    return Column(
      children: [
        if (index > 0)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Divider(color: Color(0xFFF1EFE9), height: 1),
          ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hình ảnh món ăn
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Color(0xFFF8F1F0)),
              ),
              child: WidgetAppImage(
                imageUrl: item.product?.image ?? '',
                width: 60,
                height: 60,
                radius: 12,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),

            // Thông tin món ăn và rating
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product?.name ?? '',
                    style: w500TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        'Qty: ${item.quantity}',
                        style: w400TextStyle(
                          fontSize: 14,
                          color: appColorText2,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '•',
                        style: w400TextStyle(
                          fontSize: 14,
                          color: appColorText2,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        currencyFormatted(item.product?.price ?? 0),
                        style: w500TextStyle(
                          fontSize: 14,
                          color: appColorPrimaryOrange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Rating bar cho món ăn
                  RatingBar.builder(
                    initialRating: itemRatings[index] ?? 0,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    itemSize: 24,
                    unratedColor: appColorBorder,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                    itemBuilder: (context, _) => WidgetAppSVG(
                      'icon91',
                      color: appColorPrimaryOrange,
                    ),
                    onRatingUpdate: (value) {
                      setState(() {
                        itemRatings[index] = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCommentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Add a comment".tr(),
          style: w500TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 8),
        Text(
          "Share your experience to help others".tr(),
          style: w400TextStyle(
            fontSize: 14,
            color: appColorText2,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _satisfactionTags
              .map((tag) => WidgetInkWellTransparent(
                    onTap: () {
                      appHaptic();
                      commentController.text = tag;
                      setState(() {});
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: commentController.text == tag
                          ? BoxDecoration(
                              color: appColorPrimary,
                              borderRadius: BorderRadius.circular(120),
                              border: Border.all(color: appColorPrimary),
                            )
                          : BoxDecoration(
                              color: appColorBackground,
                              borderRadius: BorderRadius.circular(120),
                              border: Border.all(color: appColorBorder),
                            ),
                      child: Text(tag,
                          style: w400TextStyle(
                            color: commentController.text == tag
                                ? Colors.white
                                : appColorText2,
                          )),
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: commentController,
          maxLines: 4,
          onChanged: (value) {
            setState(() {});
          },
          decoration: InputDecoration(
            hintText: "Write your comment here...".tr(),
            hintStyle: w400TextStyle(
              fontSize: 14,
              color: appColorText2,
            ),
            fillColor: appColorBackground,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: appColorBorder2),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: appColorBorder2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: appColorPrimaryOrange),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            offset: Offset(0, -4),
            blurRadius: 20,
          ),
        ],
      ),
      child: WidgetButtonConfirm(
        isLoading: loading,
        onPressed: loading ? null : _onSubmit,
        text: loading ? 'Submitting...'.tr() : 'Submit Review'.tr(),
        color: loading ? appColorBorder : appColorPrimaryOrange,
      ),
    );
  }
}
