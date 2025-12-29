import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// ---------------------------------------------------------------------------
/// Require authentication before executing an action
/// ---------------------------------------------------------------------------
///
/// - Pause les vidéos AVANT navigation
/// - Empêche double navigation
/// - Reprend automatiquement après login réussi
///
Future<void> requireAuth({
  required BuildContext context,
  required bool isAuthenticated,
  required Future<void> Function() action,
}) async {
  if (!context.mounted) return;

  /// -------------------------------------------------------------------------
  /// NOT AUTHENTICATED → LOGIN
  /// -------------------------------------------------------------------------
  if (!isAuthenticated) {
    debugPrint('🔒 requireAuth → redirect login');

    /// 1️⃣ Notifie le feed de se mettre en pause
    WidgetsBinding.instance.addPostFrameCallback((_) {
      VideoPauseNotification().dispatch(context);
    });

    /// 2️⃣ Navigation vers login
    await context.push('/login');

    /// 3️⃣ Retour depuis login → reprise
    if (context.mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        VideoResumeNotification().dispatch(context);
      });
    }

    return;
  }

  /// -------------------------------------------------------------------------
  /// AUTHENTICATED → EXECUTE ACTION
  /// -------------------------------------------------------------------------
  await action();
}

/// ---------------------------------------------------------------------------
/// Notifications internes (découplées)
/// ---------------------------------------------------------------------------

class VideoPauseNotification extends Notification {}

class VideoResumeNotification extends Notification {}
