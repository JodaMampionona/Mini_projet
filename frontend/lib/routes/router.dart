import 'package:frontend/routes/routes.dart';
import 'package:frontend/services/app_preferences_service.dart';
import 'package:frontend/view/home/home_view.dart';
import 'package:frontend/view/itinerary/itinerary_view.dart';
import 'package:frontend/view/on_boarding/on_boarding_view.dart';
import 'package:frontend/viewmodel/home_viewmodel.dart';
import 'package:frontend/viewmodel/itinerary_viewmodel.dart';
import 'package:frontend/viewmodel/on_boarding_viewmodel.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

final appRouter = GoRouter(
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
  initialLocation: Routes.onBoarding.path,
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
    ShellRoute(
      builder: (context, state, child) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => HomeViewModel()),
          ChangeNotifierProvider(create: (_) => ItineraryViewModel()),
        ],
        child: child,
      ),
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
              context.pushNamed(
                Routes.itinerary.name,
                extra: {'start': viewModel.startId, 'dest': viewModel.destId},
              );
            },
          ),
        ),
        // itinerary view
        GoRoute(
          name: Routes.itinerary.name,
          path: Routes.itinerary.path,
          builder: (context, state) {
            final extraData = state.extra as Map<String, int>?;
            final start = extraData?['start'] ?? -1;
            final dest = extraData?['dest'] ?? -1;
            return ItineraryView(
              start: start,
              dest: dest,
              onBackPress: (context) {
                context.pop();
              },
            );
          },
        ),
      ],
    ),
  ],
);
