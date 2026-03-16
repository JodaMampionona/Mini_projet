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
  static final busList = Route(path: '/bus-list', name: '/bus-list');
  static final busDetails = Route(path: '/bus-details', name: '/bus-details');
  static final history = Route(path: '/history', name: '/history');
}
