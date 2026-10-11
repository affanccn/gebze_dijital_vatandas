import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gebze_dijital_vatandas/app/shell/app_shell.dart';
import 'package:gebze_dijital_vatandas/features/home/presentation/home_screen.dart';
import 'package:gebze_dijital_vatandas/features/places/presentation/places_screen.dart';
import 'package:gebze_dijital_vatandas/features/report/presentation/report_screen.dart';
import 'package:gebze_dijital_vatandas/features/content/presentation/content_screen.dart';
import 'package:gebze_dijital_vatandas/features/services/presentation/services_screen.dart';
import 'package:gebze_dijital_vatandas/features/profile/presentation/profile_screen.dart';
import 'package:gebze_dijital_vatandas/features/neighborhood/presentation/neighborhood_screen.dart';
import 'package:gebze_dijital_vatandas/features/parking/presentation/parking_screen.dart';
import 'package:gebze_dijital_vatandas/features/disruptions/presentation/disruptions_screen.dart';
import 'package:gebze_dijital_vatandas/features/participation/presentation/participation_screen.dart';
import 'package:gebze_dijital_vatandas/features/animals/animals.dart';
import 'package:gebze_dijital_vatandas/features/emergency/presentation/emergency_screen.dart';
import 'package:gebze_dijital_vatandas/features/weather/presentation/weather_screen.dart';
import 'package:gebze_dijital_vatandas/features/pharmacies/presentation/pharmacies_screen.dart';
import 'package:gebze_dijital_vatandas/features/splash/presentation/splash_screen.dart';
import 'package:gebze_dijital_vatandas/features/auth/presentation/login_screen.dart';
import 'package:gebze_dijital_vatandas/features/auth/application/auth_service.dart';
import 'package:gebze_dijital_vatandas/features/chatbot/presentation/chat_screen.dart';
import 'package:gebze_dijital_vatandas/features/chatbot/presentation/widgets/bot82_overlay.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/splash',
    redirect: (context, state) {
      final authState = ref.read(authProvider);

      if (authState == AuthState.initial && state.uri.path != '/splash') {
        return '/splash';
      }

      final protectedRoutes = [
        '/report',
        '/services/neighborhood',
        '/services/participation',
        '/services/animals',
      ];

      if (authState == AuthState.guest && protectedRoutes.contains(state.uri.path)) {
        return '/login';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/chatbot',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const ChatbotScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/places',
                builder: (context, state) => const PlacesScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/report',
                builder: (context, state) => const ReportScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/services',
                builder: (context, state) => const ServicesScreen(),
                routes: [
                  GoRoute(
                    path: 'neighborhood',
                    builder: (context, state) => const NeighborhoodScreen(),
                  ),
                  GoRoute(
                    path: 'parking',
                    builder: (context, state) => const ParkingScreen(),
                  ),
                  GoRoute(
                    path: 'disruptions',
                    builder: (context, state) => const DisruptionsScreen(),
                  ),
                  GoRoute(
                    path: 'participation',
                    builder: (context, state) => const ParticipationScreen(),
                  ),
                  GoRoute(
                    path: 'animals',
                    builder: (context, state) => const AnimalsScreen(),
                  ),
                  GoRoute(
                    path: 'emergency',
                    builder: (context, state) => const EmergencyScreen(),
                  ),
                  GoRoute(
                    path: 'weather',
                    builder: (context, state) => const WeatherScreen(),
                  ),
                  GoRoute(
                    path: 'pharmacies',
                    builder: (context, state) => const PharmaciesScreen(),
                  ),
                  GoRoute(
                    path: 'content',
                    builder: (context, state) => const ContentScreen(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
