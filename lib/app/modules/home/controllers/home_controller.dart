import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:yaka2/app/data/models/clothes_model.dart';
import 'package:yaka2/app/data/models/collar_model.dart';
import 'package:yaka2/app/data/services/about_us_service.dart';
import 'package:yaka2/app/data/services/auth_service.dart';
import 'package:yaka2/app/data/services/fav_service.dart';
import 'package:yaka2/app/modules/user_profil/controllers/user_profil_controller.dart';

import '../../../data/models/banner_model.dart';
import '../../../data/models/category_model.dart';
import '../../../data/services/banner_service.dart';
import '../../../data/services/category_service.dart';
import 'collar_controller.dart';

class HomeController extends GetxController {
  RxInt bannerDotsIndex = 0.obs;
  RxString balance = '0'.obs;
  RxString sortName = ''.obs;
  RxInt sortMachineID = 0.obs;
  RxString sortMachineName = 'Yaka'.obs;
  final storage = GetStorage();
  final CollarController collarController = Get.put(CollarController());
  final ClothesController clothesController = Get.put(ClothesController());
  final GoodsController goodsController = Get.put(GoodsController());
  getAllProducts() {
    collarController.collarList.clear();
    clothesController.clothesList.clear();
    goodsController.goodsList.clear();
    goodsController.goodsLoading.value = 0;
    clothesController.clothesLoading.value = 0;
    collarController.collarLoading.value = 0;
    collarController.getData();
    clothesController.getDataClothes();
    goodsController.getDataGoods();
  }

  savePhoneNumber(String number) {
    storage.write('phoneNumber', number);
  }

  Future<String> returnPhoneNumber() async {
    String number = '';
    print(await storage.read('phoneNumber'));
    if (await storage.read('phoneNumber') == null) {
      number = 'belginiz yok';
    } else {
      number = await storage.read('phoneNumber');
    }
    print(number);
    print(number);
    print('ASddddddddddda');
    print(number);
    print(number);
    print('ASddddddddddda');

    print(number);
    print(number);
    return number;
  }

  //
  RxInt page = 1.obs;
  RxInt limit = 10.obs;
  RxInt loading = 0.obs;
  RxList showAllList = [].obs;
//
  late final Future<List<BannerModel>> getBanners;
  late final Future<List<CategoryModel>> getCategories;
  late final Future<List<DressesModel>> favProducts;
  late final Future<List<CollarModel>> favCollars;

  @override
  void onInit() {
    super.onInit();
    getFavorites();
    userMoney();
    getBanners = BannerService().getBanners();
    getCategories = CategoryService().getCategories();
  }

  dynamic userMoney() async {
    final token = await Auth().getToken();
    final UserProfilController controller = Get.put(UserProfilController());
    if (token == null) {
      balance.value = '0';
      controller.userLogin.value = false;
    } else {
      await AboutUsService().getuserData().then((value) {
        balance.value = '${value.balance! / 100}';
      });
      controller.userLogin.value = true;
    }
  }

  dynamic getFavorites() async {
    final token = await Auth().getToken();
    if (token == null) {
    } else {
      favProducts = FavService().getProductFavList();
      favCollars = FavService().getCollarFavList();
    }
  }
}
