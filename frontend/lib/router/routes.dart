class Route {
  String path, name;

  Route({required this.path, required this.name});
}

class Routes {
  static final onBoarding = Route(path: '/onBoarding', name: '/onBoarding');
  static final home = Route(path: '/home', name: '/home');
  static final search = Route(path: '/search', name: '/search');
  static final map = Route(path: '/map', name: '/map');
  static final itinerary = Route(path: '/itinerary', name: '/itinerary');
  static final bus = Route(path: '/bus', name: '/bus');
  static final busStopMap = Route(path: '/bus-stops', name: '/bus-stops');
}
