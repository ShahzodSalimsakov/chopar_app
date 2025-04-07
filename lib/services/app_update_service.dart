import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:chopar_app/widgets/profile/PagesList.dart'; // Import PagesList for the global flag
import 'package:flutter/foundation.dart'; // Add this import for kDebugMode

class AppUpdateService {
  static final AppUpdateService _instance = AppUpdateService._internal();

  // Flag to track if the restart dialog is currently showing
  bool _isRestartDialogShowing = false;

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

  /// Shows a dialog to suggest app restart after update
  void showRestartDialog(BuildContext context) {
    // If a dialog is already showing, don't show another one
    if (_isRestartDialogShowing) return;

    _isRestartDialogShowing = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.system_update, color: Colors.green, size: 28),
              SizedBox(width: 8),
              Flexible(
                child: Text(tr('update_downloaded'),
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(tr('update_downloaded_restart_to_install')),
              SizedBox(height: 16),
              Text(tr('current_version_remains_until_restart'),
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 12,
                      color: Colors.grey[700])),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text(tr('language_cancel')),
              onPressed: () {
                Navigator.of(context).pop();
                _isRestartDialogShowing = false;
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: Text(tr('restart')),
              onPressed: () {
                Navigator.of(context).pop();
                _isRestartDialogShowing = false;
                InAppUpdate.completeFlexibleUpdate();
              },
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 24,
        );
      },
    ).then((_) {
      // In case dialog is dismissed some other way
      _isRestartDialogShowing = false;
    });
  }

  /// Emulates an update download and shows the restart dialog
  /// This is for testing purposes only - only available in debug mode
  void emulateUpdate(BuildContext context) {
    // This method should never be called in production
    if (!kDebugMode) {
      print("Emulation not available in production");
      return;
    }

    // Show toast indicating the emulation started
    Fluttertoast.showToast(
      msg: "Emulating update download...",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );

    // Set the global update flag to true
    globalUpdateDownloaded = true;

    // Simulate download progress with a short delay
    Future.delayed(Duration(seconds: 1), () {
      // Show a toast that the "update" is downloaded
      Fluttertoast.showToast(
        msg: tr('update_downloaded'),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );

      // Ensure UI is updated
      _updateProfilePageFlag(context);

      // Force the dialog on the main thread after a short delay
      Future.delayed(Duration(milliseconds: 500), () {
        _showEmulatedRestartDialog(context);
      });
    });
  }

  /// Shows a guaranteed restart dialog for the emulation
  void _showEmulatedRestartDialog(BuildContext context) {
    // Only available in debug mode
    if (!kDebugMode) return;

    // If a dialog is already showing, don't show another one
    if (_isRestartDialogShowing) return;

    _isRestartDialogShowing = true;

    // Make sure we're on the main thread
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: Row(
              children: [
                Icon(Icons.system_update, color: Colors.green, size: 28),
                SizedBox(width: 8),
                Flexible(
                  child: Text(tr('update_downloaded'),
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tr('update_downloaded_restart_to_install')),
                SizedBox(height: 16),
                Text(tr('current_version_remains_until_restart'),
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 12,
                        color: Colors.grey[700])),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text(tr('language_cancel')),
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  _isRestartDialogShowing = false;

                  // Show a snackbar as a reminder
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(tr('update_downloaded_restart_to_install')),
                      action: SnackBarAction(
                        label: tr('restart'),
                        onPressed: () {
                          showRestartingToast(context);
                        },
                      ),
                      duration: Duration(seconds: 5),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: Text(tr('restart')),
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  _isRestartDialogShowing = false;
                  showRestartingToast(context);
                },
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 24,
          );
        },
      ).then((_) {
        // In case dialog is dismissed some other way
        _isRestartDialogShowing = false;
      });
    });
  }

  /// Shows a toast indicating app is restarting (for simulation)
  void showRestartingToast(BuildContext context) {
    // Only available in debug mode for emulation
    if (!kDebugMode && globalUpdateDownloaded) {
      // In production, just call the real update completion
      InAppUpdate.completeFlexibleUpdate();
      return;
    }

    // If we're already showing the dialog, don't show another one
    if (_isRestartDialogShowing) return;

    _isRestartDialogShowing = true;

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    // Show a dialog instead of just a toast to make it more visible
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.refresh, color: Colors.green, size: 28),
              SizedBox(width: 8),
              Flexible(
                child: Text("Restarting...",
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 60,
                width: 60,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  strokeWidth: 6,
                ),
              ),
              SizedBox(height: 24),
              Text("Simulating app restart for the update...",
                  textAlign: TextAlign.center),
            ],
          ),
        );
      },
    );

    // Simulate a "restart" with a short delay
    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pop(); // Close the progress dialog
      _isRestartDialogShowing = false;

      // If another dialog might be shown now, set a small delay
      Future.delayed(Duration(milliseconds: 100), () {
        // If a dialog is already showing again, don't show this one
        if (_isRestartDialogShowing) return;

        _isRestartDialogShowing = true;

        // Show completion dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 28),
                  SizedBox(width: 8),
                  Flexible(
                    child: Text("Update Complete",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              content: Text(
                  "In a real update, the app would have restarted and installed the update by now."),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _isRestartDialogShowing = false;

                    // Reset the update status for testing purposes
                    // In a real app, this would not be needed
                    Future.delayed(Duration(seconds: 5), () {
                      globalUpdateDownloaded = false;
                    });
                  },
                ),
              ],
            );
          },
        ).then((_) {
          // In case dialog is dismissed some other way
          _isRestartDialogShowing = false;
        });
      });
    });
  }

  /// Updates the profile page flag to show the update banner
  void _updateProfilePageFlag(BuildContext context) {
    // Update the global flag for consistent state across the app
    globalUpdateDownloaded = true;

    // For a real implementation, we would broadcast an event or use a state management
    // solution to notify components about the update status
    print("Update flag set to true");
  }

  /// Starts a flexible update if available
  void startFlexibleUpdate(BuildContext context) async {
    try {
      await InAppUpdate.startFlexibleUpdate();

      // Set global state to indicate an update has been downloaded
      globalUpdateDownloaded = true;

      // Show a dialog to suggest restart after update
      showRestartDialog(context);

      // Only show snackbar if dialog is dismissed
      Future.delayed(Duration(seconds: 1), () {
        // If dialog was closed, show a persistent snackbar
        if (!_isRestartDialogShowing) {
          // Show a persistent snackbar that doesn't disappear automatically
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(tr('update_downloaded_restart_to_install')),
              action: SnackBarAction(
                label: tr('restart'),
                onPressed: () {
                  InAppUpdate.completeFlexibleUpdate();
                },
              ),
              duration: Duration(
                  days: 1), // Essentially makes it persistent until dismissed
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.all(8),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              backgroundColor: Colors.green,
            ),
          );
        }
      });
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
