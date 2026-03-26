import 'package:flutter/material.dart';
import 'package:frontend/model/bus_model.dart';
import 'package:frontend/model/bus_stop_model.dart';
import 'package:frontend/model/itinerary_model.dart';
import 'package:frontend/provider/session_state_provider.dart';
import 'package:frontend/router/bottom_nav_util.dart';
import 'package:frontend/router/routes.dart';
import 'package:frontend/view/bus_list/bus_list_view.dart';
import 'package:frontend/view/history/history_view.dart';
import 'package:frontend/view/home/home_view.dart';
import 'package:frontend/view/itinerary/itinerary_view.dart';
import 'package:frontend/view/map/map_view.dart';
import 'package:frontend/view/on_boarding/on_boarding_view.dart';
import 'package:frontend/view/search/search_view.dart';
import 'package:frontend/view/stop_details/stop_details_view.dart';
import 'package:frontend/viewmodel/bus_details_viewmodel.dart';
import 'package:frontend/viewmodel/bus_list_viewmodel.dart';
import 'package:frontend/viewmodel/history_viewmodel.dart';
import 'package:frontend/viewmodel/home_viewmodel.dart';
import 'package:frontend/viewmodel/map_viewmodel.dart';
import 'package:frontend/viewmodel/search_viewmodel.dart';
import 'package:frontend/viewmodel/stop_details_viewmodel.dart';
import 'package:frontend/widgets/nav_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../view/bus_details/bus_details_view.dart';

final appRouter = GoRouter(
  initialLocation: Routes.onBoarding.path,
  redirect: (context, state) async {
    final isFirstTime = await context.read<SessionStateProvider>().isFirstTime;

    final isOnboarding = state.matchedLocation == Routes.onBoarding.path;

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
      builder: (context, state) => OnBoardingView(),
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
            onBusStopTap: (busStop) {
              final extra = {isStart ? 'start' : 'end': busStop};
              if ((from as String).startsWith(Routes.home.name) ||
                  from.startsWith(Routes.history.name)) {
                context.goNamed(Routes.map.name, extra: extra);
              } else {
                context.pop(busStop);
              }
            },
          ),
        );
      },
    ),

    // history
    GoRoute(
      name: Routes.history.name,
      path: Routes.history.path,
      builder: (context, state) {
        return ChangeNotifierProvider(
          create: (_) => HistoryViewModel(),
          child: HistoryView(
            onHistoryItemTap: (BusStop start, BusStop end) {
              context.goNamed(
                Routes.map.name,
                extra: {'start': start, 'end': end},
              );
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

        return ItineraryView(
          itinerary: itinerary,
          onBackPress: (context) => context.pop(),
          onNewItineraryTap: (context) => context.goNamed(Routes.map.name),
        );
      },
    ),

    // bus stops and map
    GoRoute(
      name: Routes.busDetails.name,
      path: Routes.busDetails.path,
      builder: (context, state) {
        final extraData = state.extra as Map<String, dynamic>?;
        final bus = extraData?['bus'] as Bus;

        return ChangeNotifierProvider(
          create: (_) => BusDetailsViewModel(),
          child: BusDetailsView(bus: bus),
        );
      },
    ),

    // stop and map
    GoRoute(
      name: Routes.stopDetails.name,
      path: Routes.stopDetails.path,
      builder: (context, state) {
        final extraData = state.extra as Map<String, dynamic>?;
        final stop = extraData?['stop'] as BusStop;
        return ChangeNotifierProvider(
          create: (_) => StopDetailsViewModel(),
          child: StopDetailsView(
            stop: stop,
            onBusTap: (Bus bus) {
              context.pushNamed(Routes.busDetails.name, extra: {'bus': bus});
            },
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
            ChangeNotifierProvider(create: (_) => BusListViewModel()),
          ],
          child: PopScope(
            canPop: state.matchedLocation.startsWith(Routes.home.name),
            onPopInvokedWithResult: (didPop, result) {
              if (!state.matchedLocation.startsWith(Routes.home.name)) {
                context.goNamed(Routes.home.name);
              }
            },
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
          ),
        );
      },

      routes: [
        // home
        GoRoute(
          name: Routes.home.name,
          path: Routes.home.path,
          builder: (context, state) => HomeView(
            onHistoryPress: (vm) {
              context.pushNamed(Routes.history.name).then((_) {
                if (!context.mounted) return;
                vm.loadHistory();
              });
            },
            onSearchItineraryPress: () {
              context.pushNamed(
                Routes.search.name,
                extra: {'isStart': false, 'from': Routes.home.name},
              );
            },
            onHistoryItemTap: (BusStop start, BusStop end) {
              context.goNamed(
                Routes.map.name,
                extra: {'start': start, 'end': end},
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
                final busStop = await context.pushNamed<BusStop>(
                  Routes.search.name,
                  extra: {'isStart': true},
                );
                vm.updateStart(busStop);
              },
              onEndTap: (context, vm) async {
                final busStop = await context.pushNamed<BusStop>(
                  Routes.search.name,
                  extra: {'isStart': false},
                );
                vm.updateEnd(busStop);
              },
            );
          },
        ),
        // bus
        GoRoute(
          name: Routes.busList.name,
          path: Routes.busList.path,
          builder: (context, state) {
            return BusListView(
              onBusTap: (Bus bus) {
                context.pushNamed(Routes.busDetails.name, extra: {'bus': bus});
              },
              onStopTap: (BusStop stop) {
                context.pushNamed(
                  Routes.stopDetails.name,
                  extra: {'stop': stop},
                );
              },
            );
          },
        ),
      ],
    ),
  ],
);
