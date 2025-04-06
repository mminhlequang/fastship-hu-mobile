import 'package:app/src/constants/constants.dart';
import 'package:app/src/presentation/widgets/widget_appbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:internal_core/internal_core.dart';
import 'package:network_resources/product/model/product.dart';
import 'package:network_resources/store/models/models.dart';

class MyFavoriteScreen extends StatefulWidget {
  const MyFavoriteScreen({super.key});

  @override
  State<MyFavoriteScreen> createState() => _MyFavoriteScreenState();
}

class _MyFavoriteScreenState extends State<MyFavoriteScreen> {
  bool isRestaurant = true;
  List<StoreModel> restaurants = [];
  List<ProductModel> foods = [];

  @override
  void initState() {
    super.initState();
    _fetchRestaurants();
  }
  _fetchRestaurants() async {
    // final r = await appGet(
    //   path: '/restaurants',
    //   params: {},
    // );


  }

  _fetchFoods() async {
    // final r = await appGet(
    //   path: '/foods',
    //   params: {},
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColorBackground,
      body: Column(
        children: [
          WidgetAppBar(
            title: 'My Favorite'.tr(),
          ),
          
           Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: WidgetInkWellTransparent(
                      onTap: () {
                        appHaptic();
                        setState(() {
                          isRestaurant = true;
                        });
                        _fetchRestaurants();
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.sw),
                        child: Center(
                          child: Text(
                            'All restaurants',
                            style: w400TextStyle(
                                fontSize: 18.sw,
                                color: isRestaurant
                                    ? appColorText
                                    : Color(0xFF847D79)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: WidgetInkWellTransparent(
                      onTap: () {
                        appHaptic();
                        setState(() {
                          isRestaurant = false;
                        });
                        _fetchFoods();
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.sw),
                        child: Center(
                          child: Text(
                            'All foods',
                            style: w400TextStyle(
                                fontSize: 18.sw,
                                color: !isRestaurant
                                    ? appColorText
                                    : Color(0xFF847D79)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              AnimatedPositioned(
                duration: Duration(milliseconds: 300),
                left: isRestaurant ? 0 : context.width / 2 - 16 + 12,
                child: Container(
                  width: context.width / 2 - 16 - 12,
                  height: 2,
                  color: appColorText2,
                ),
              )
            ],
          ),
        ],
      ),
    );  }
}