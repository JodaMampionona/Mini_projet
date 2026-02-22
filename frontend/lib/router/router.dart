import 'package:flutter/material.dart';
import 'package:frontend/model/itinerary_model.dart';
import 'package:frontend/model/place_model.dart';
import 'package:frontend/model/session_model.dart';
import 'package:frontend/model/stop_model.dart';
import 'package:frontend/router/bottom_nav_util.dart';
import 'package:frontend/router/routes.dart';
import 'package:frontend/services/app_preferences_service.dart';
import 'package:frontend/view/bus/bus_view.dart';
import 'package:frontend/view/bus_stops_map/bus_stops_map.dart';
import 'package:frontend/view/home/home_view.dart';
import 'package:frontend/view/itinerary/itinerary_view.dart';
import 'package:frontend/view/map/map_view.dart';
import 'package:frontend/view/on_boarding/on_boarding_view.dart';
import 'package:frontend/view/search/search_view.dart';
import 'package:frontend/viewmodel/bus_viewmodel.dart';
import 'package:frontend/viewmodel/home_viewmodel.dart';
import 'package:frontend/viewmodel/itinerary_viewmodel.dart';
import 'package:frontend/viewmodel/map_viewmodel.dart';
import 'package:frontend/viewmodel/search_viewmodel.dart';
import 'package:frontend/widgets/nav_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

final appRouter = GoRouter(
  initialLocation: Routes.onBoarding.path,
  redirect: (context, state) {
    return null;
    final isFirstTime = SessionModel.isFirstTime;

    final isOnboarding = state.matchedLocation == Routes.onBoarding.path;

    if (isFirstTime && !isOnboarding) {
      return Routes.onBoarding.path;
    }

    if (!isFirstTime && isOnboarding) {
      return Routes.home.path;
    }

    return null;
  },
  routes: [
    // onBoarding
    GoRoute(
      name: Routes.onBoarding.name,
      path: Routes.onBoarding.path,
      builder: (context, state) => OnBoardingView(
        onConfirmPress: (context) => context.goNamed(Routes.home.name),
      ),
    ),

    // search
    GoRoute(
      name: Routes.search.name,
      path: Routes.search.path,
      builder: (context, state) {
        final extraData = state.extra as Map<String, dynamic>?;
        final isStart = extraData?['isStart'] ?? true;
        final from = extraData?['from'] ?? '';
        return ChangeNotifierProvider(
          create: (_) => SearchViewModel(),
          child: SearchView(
            showGeolocationPrompt: isStart,
            inputPlaceholder: isStart
                ? 'Où vous trouvez-vous ?'
                : 'Où voulez-vous aller ?',
            onPlaceTap: (place) {
              final extra = {isStart ? 'start' : 'end': place};
              if ((from as String).startsWith(Routes.home.name)) {
                context.goNamed(Routes.map.name, extra: extra);
              } else {
                context.pop(place);
              }
            },
          ),
        );
      },
    ),

    // itinerary
    GoRoute(
      name: Routes.itinerary.name,
      path: Routes.itinerary.path,
      builder: (context, state) {
        final extraData = state.extra as Map<String, List<Itinerary>?>?;
        final itinerary = extraData?['itinerary'] ?? [];

        return ChangeNotifierProvider(
          create: (_) => ItineraryViewModel(),
          child: ItineraryView(
            itinerary: itinerary,
            onBackPress: (context) => context.pop(),
            onNewItineraryTap: (context) => context.goNamed(Routes.map.name),
          ),
        );
      },
    ),

    // bus stops and map
    GoRoute(
      name: Routes.busStopMap.name,
      path: Routes.busStopMap.path,
      builder: (context, state) {
        final extraData = state.extra as Map<String, dynamic>?;
        final stops = extraData?['stops'] ?? [];
        final busName = extraData?['busName'] ?? '';

        return BusStopsMap(stops: stops, busName: busName);
      },
    ),

    ShellRoute(
      builder: (context, state, child) {
        final currentIndex = BottomNavUtil.locationToIndex(
          state.matchedLocation,
        );

        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => HomeViewModel()),
            ChangeNotifierProvider(create: (_) => MapViewModel()),
            ChangeNotifierProvider(create: (_) => ItineraryViewModel()),
            ChangeNotifierProvider(create: (_) => BusViewModel()),
          ],
          child: Scaffold(
            bottomNavigationBar: BottomNavBar(
              onTap: (index) {
                if (index == currentIndex) return;
                final newRoute = BottomNavUtil.indexToRouteName(index);
                context.goNamed(newRoute);
              },
              currentIndex: currentIndex,
            ),
            body: child,
          ),
        );
      },

      routes: [
        // home
        GoRoute(
          name: Routes.home.name,
          path: Routes.home.path,
          builder: (context, state) => HomeView(
            onSearchItineraryPress: (context) {
              context.pushNamed(
                Routes.search.name,
                extra: {'isStart': false, 'from': Routes.home.name},
              );
            },
          ),
        ),
        // map
        GoRoute(
          name: Routes.map.name,
          path: Routes.map.path,
          builder: (context, state) {
            final extraData = state.extra as Map<String, dynamic>?;
            final start = extraData?['start'];
            final end = extraData?['end'];
            return MapView(
              start: start,
              end: end,
              onBackTap: (context) => context.goNamed(Routes.home.path),
              onSeeItineraryTap: (context, viewModel) {
                context.pushNamed(
                  Routes.itinerary.name,
                  extra: {'itinerary': viewModel.itinerary},
                );
              },
              onStartTap: (context, vm) async {
                final place = await context.pushNamed<Place>(
                  Routes.search.name,
                  extra: {'isStart': true},
                );
                vm.updateStartController(place);
              },
              onEndTap: (context, vm) async {
                final place = await context.pushNamed<Place>(
                  Routes.search.name,
                  extra: {'isStart': false},
                );
                vm.updateDestController(place);
              },
            );
          },
        ),
        // bus
        GoRoute(
          name: Routes.bus.name,
          path: Routes.bus.path,
          builder: (context, state) {
            return BusView(
              onItemTap: (List<Stop> busStops, String busName) {
                context.pushNamed(
                  Routes.busStopMap.name,
                  extra: {'busName': busName, 'stops': busStops},
                );
              },
            );
          },
        ),
      ],
    ),
  ],
);
