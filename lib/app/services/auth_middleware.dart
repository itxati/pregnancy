import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'auth_service.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final authService = Get.find<AuthService>();
    
    // If user is not logged in and trying to access protected routes
    if (!authService.isLoggedIn && _isProtectedRoute(route)) {
      return const RouteSettings(name: '/login');
    }
    
    // If user is logged in and trying to access auth routes
    if (authService.isLoggedIn && _isAuthRoute(route)) {
      return const RouteSettings(name: '/goal_selection');
    }
    
    return null;
  }

  bool _isProtectedRoute(String? route) {
    if (route == null) return false;
    
    // Add routes that require authentication
    final protectedRoutes = [
      '/goal_selection',
      '/info',
      '/get_pregnant_requirements',
      '/track_pregnance',
      '/profile',
      '/track_my_pregnancy',
      '/track_my_baby',
      '/postpartum_care',
    ];
    
    return protectedRoutes.any((protectedRoute) => 
        route.startsWith(protectedRoute));
  }

  bool _isAuthRoute(String? route) {
    if (route == null) return false;
    
    // Add routes that should redirect if already authenticated
    final authRoutes = [
      '/login',
      '/signup',
      '/forget_password',
    ];
    
    return authRoutes.any((authRoute) => route.startsWith(authRoute));
  }
}
