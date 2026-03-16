import 'package:frontend/router/routes.dart';

enum BottomTab { home, map, bus }

class BottomNavUtil {
  static int locationToIndex(String location) {
    return location.startsWith(Routes.map.path)
        ? BottomTab.map.index
        : location.startsWith(Routes.busList.path)
        ? BottomTab.bus.index
        : BottomTab.home.index;
  }

  static String indexToRouteName(int index) {
    return BottomTab.values[index] == BottomTab.map
        ? Routes.map.name
        : BottomTab.values[index] == BottomTab.bus
        ? Routes.busList.name
        : Routes.home.name;
  }
}
