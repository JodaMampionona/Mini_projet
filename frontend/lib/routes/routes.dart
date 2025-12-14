class Route {
  String path, name;

  Route({required this.path, required this.name});
}

class Routes {
  static final onBoarding = Route(path: '/onBoarding', name: '/onBoarding');
  static final home = Route(path: '/home', name: '/home');
  static final itinerary = Route(path: '/itinerary', name: '/itinerary');
}
