import 'package:flutter/material.dart';
import 'package:frontend/model/bus_stop_model.dart';
import 'package:frontend/model/itinerary_model.dart';
import 'package:frontend/router/bottom_nav_util.dart';
import 'package:frontend/router/routes.dart';
import 'package:frontend/services/app_preferences_service.dart';
import 'package:frontend/view/bus/bus_view.dart';
import 'package:frontend/view/home/home_view.dart';
import 'package:frontend/view/itinerary/itinerary_view.dart';
import 'package:frontend/view/map/map_view.dart';
import 'package:frontend/view/on_boarding/on_boarding_view.dart';
import 'package:frontend/viewmodel/home_viewmodel.dart';
import 'package:frontend/viewmodel/itinerary_viewmodel.dart';
import 'package:frontend/viewmodel/map_viewmodel.dart';
import 'package:frontend/viewmodel/on_boarding_viewmodel.dart';
import 'package:frontend/widgets/nav_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

final appRouter = GoRouter(
  initialLocation: Routes.onBoarding.path,
  redirect: (context, state) {
    final isFirstTime = AppPreferences.isFirstTime;

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
      builder: (context, state) => ChangeNotifierProvider(
        create: (_) => OnBoardingViewModel(),
        child: OnBoardingView(
          onConfirmPress: (context, viewModel) async {
            await viewModel.logUserIn();
            if (context.mounted) {
              context.goNamed(Routes.home.name);
            }
          },
        ),
      ),
    ),

    // itinerary
    GoRoute(
      name: Routes.itinerary.name,
      path: Routes.itinerary.path,
      builder: (context, state) {
        final extraData = state.extra as Map<String, List<Itinerary>?>?;
        final itinerary = extraData?['itinerary'];
        return ChangeNotifierProvider(
          create: (_) => ItineraryViewModel(),
          child: ItineraryView(
            itinerary: itinerary,
            onBackPress: (context) => context.pop(),
            onNewItineraryTap: (context) => context.goNamed(Routes.home.path),
          ),
        );
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
            onSwapPress: (viewModel) {
              viewModel.swapStartAndDestination();
            },
            onSearchItineraryPress: (context, viewModel) {
              context.goNamed(
                Routes.map.name,
                extra: {
                  'start': viewModel.start,
                  'dest': viewModel.destination,
                },
              );
            },
          ),
        ),
        // map
        GoRoute(
          name: Routes.map.name,
          path: Routes.map.path,
          builder: (context, state) {
            final extraData = state.extra as Map<String, BusStop?>?;
            final start = extraData?['start'];
            final dest = extraData?['dest'];

            return MapView(
              start: start,
              dest: dest,
              onBackTap: (context) => context.goNamed(Routes.home.path),
              onSeeItineraryTap: (context, viewModel) {
                context.pushNamed(
                  Routes.itinerary.name,
                  extra: {'itinerary': viewModel.itinerary},
                );
              },
            );
          },
        ),
        // bus
        GoRoute(
          name: Routes.bus.name,
          path: Routes.bus.path,
          builder: (context, state) {
            return BusView();
          },
        ),
      ],
    ),
  ],
);
