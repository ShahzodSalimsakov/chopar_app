import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:easy_localization/easy_localization.dart';

class AppUpdateService {
  static final AppUpdateService _instance = AppUpdateService._internal();

  factory AppUpdateService() {
    return _instance;
  }

  AppUpdateService._internal();

  /// Checks if an update is available and returns the app update info
  Future<AppUpdateInfo?> checkForUpdateInfo() async {
    try {
      return await InAppUpdate.checkForUpdate();
    } catch (e) {
      print('Error checking for update info: $e');
      return null;
    }
  }

  /// Performs an immediate update if available
  void performImmediateUpdate() async {
    try {
      await InAppUpdate.performImmediateUpdate();
    } catch (e) {
      print('Error performing immediate update: $e');
      Fluttertoast.showToast(
        msg: tr('immediate_update_not_available'),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  /// Starts a flexible update if available
  void startFlexibleUpdate(BuildContext context) async {
    try {
      await InAppUpdate.startFlexibleUpdate();

      // Show a snackbar to complete the update
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(tr('update_downloaded_restart_to_install')),
          action: SnackBarAction(
            label: tr('restart'),
            onPressed: () {
              InAppUpdate.completeFlexibleUpdate();
            },
          ),
        ),
      );
    } catch (e) {
      print('Error starting flexible update: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(tr('update_error')),
        ),
      );
    }
  }

  Future<void> checkForUpdate() async {
    try {
      final updateInfo = await InAppUpdate.checkForUpdate();

      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        if (updateInfo.flexibleUpdateAllowed) {
          await InAppUpdate.startFlexibleUpdate();
          await InAppUpdate.completeFlexibleUpdate();
        } else if (updateInfo.immediateUpdateAllowed) {
          await InAppUpdate.performImmediateUpdate();
        } else {
          Fluttertoast.showToast(
            msg: tr('no_available_updates'),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        }
      }
    } catch (e) {
      print('Error checking for updates: $e');
      Fluttertoast.showToast(
        msg: tr('update_error'),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }
}
