import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:yaka2/app/constants/constants.dart';
import 'package:yaka2/app/constants/widgets.dart';
import 'package:yaka2/app/data/services/auth_service.dart';
import 'package:yaka2/app/modules/favorites/controllers/favorites_controller.dart';

import '../../modules/auth/sign_in_page/views/tabbar_view.dart';

class FavButton extends StatefulWidget {
  final int id;
  final bool isCollar;
  final String name;
  final bool whcihPage;
  const FavButton({
    required this.whcihPage,
    required this.isCollar,
    required this.id,
    required this.name,
    super.key,
  });

  @override
  State<FavButton> createState() => _FavButtonState();
}

class _FavButtonState extends State<FavButton> {
  final FavoritesController favoritesController = Get.put(FavoritesController());
  bool value = false;

  @override
  void initState() {
    super.initState();
    work();
  }

  dynamic work() {
    for (var element in favoritesController.favList) {
      if (element['id'] == widget.id && element['name'] == widget.name) {
        value = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      work();

      return GestureDetector(
        onTap: () async {
          final token = await Auth().getToken();
          if (token == null || token == '') {
            showSnackBar('loginError', 'loginErrorSubtitle1', Colors.red);
            await Get.to(() => const TabbarView());
          } else {
            if (widget.isCollar) {
              setState(() {
                value = !value;
                favoritesController.toggleFav(widget.id, widget.name, widget.isCollar);
              });
            }
            if (widget.isCollar) {
              setState(() {
                value = !value;
                favoritesController.toggleFav(widget.id, widget.name, widget.isCollar);
              });
            }
          }
        },
        child: Container(
          padding: EdgeInsets.all(widget.whcihPage ? 8 : 6),
          decoration: BoxDecoration(
            borderRadius: widget.whcihPage ? borderRadius15 : borderRadius10,
            color: Colors.white,
          ),
          child: Icon(
            value ? IconlyBold.heart : IconlyLight.heart,
            color: value ? Colors.red : Colors.black,
            size: widget.whcihPage ? 28 : 22,
          ),
        ),
      );
    });
  }
}
