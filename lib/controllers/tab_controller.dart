import 'package:get/get.dart';

enum HomeTab {allTodos, completedTodos, inCompletedTodos}

class MyTabController extends GetxController{
  var tab = HomeTab.allTodos.obs;

  void setTab(HomeTab tab){
    this.tab.value = tab;
  }
}