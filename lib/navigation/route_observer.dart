import 'package:flutter/widgets.dart';

/// Observer global des routes
/// Utilisé pour détecter quand une page est poussée / popée
/// Exemple : quitter FeedScreen → pause vidéo
final RouteObserver<PageRoute<dynamic>> routeObserver =
    RouteObserver<PageRoute<dynamic>>();
