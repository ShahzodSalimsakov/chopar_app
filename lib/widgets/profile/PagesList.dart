import 'package:chopar_app/pages/about_us.dart';
import 'package:chopar_app/pages/orders.dart';
import 'package:chopar_app/pages/personal_data.dart';
import 'package:chopar_app/services/app_update_service.dart';
import 'package:chopar_app/widgets/profile/LanguageSwitcher.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:flutter/foundation.dart'; // Add this import for kDebugMode

// Global flag to track update status across screens
bool globalUpdateDownloaded = false;

class PagesList extends StatefulWidget {
  const PagesList({Key? key}) : super(key: key);

  @override
  _PagesListState createState() => _PagesListState();
}

class _PagesListState extends State<PagesList> {
  final AppUpdateService _appUpdateService = AppUpdateService();
  bool _updateDownloaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkUpdateStatus();

      // Also use the global flag value
      if (globalUpdateDownloaded) {
        setState(() {
          _updateDownloaded = true;
        });
      }
    });
  }

  Future<void> _checkUpdateStatus() async {
    if (Theme.of(context).platform == TargetPlatform.android) {
      try {
        final updateInfo = await _appUpdateService.checkForUpdateInfo();

        if (updateInfo != null &&
            updateInfo.installStatus == InstallStatus.downloaded) {
          setState(() {
            _updateDownloaded = true;
            globalUpdateDownloaded = true;
          });
        }
      } catch (e) {
        print('Error checking update status: $e');
      }
    }
  }

  // This method is used to set the update flag for testing
  void setUpdateDownloaded(bool value) {
    setState(() {
      _updateDownloaded = value;
      globalUpdateDownloaded = value;
    });
  }

  // Helper method to avoid duplicate code
  void _showDebugEmulationDialog(BuildContext context) {
    if (!kDebugMode) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(tr('no_updates')),
          content: Text(
              'No real updates available. Would you like to emulate an update for testing?'),
          actions: <Widget>[
            TextButton(
              child: Text(tr('language_cancel')),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow.shade700,
                foregroundColor: Colors.white,
              ),
              child: Text('Emulate Update'),
              onPressed: () {
                Navigator.of(context).pop();
                // Emulate an update
                _appUpdateService.emulateUpdate(context);
                // Set the flag to show the update banner in profile
                setUpdateDownloaded(true);
              },
            ),
          ],
        );
      },
    );
  }

  // Helper method to show production "no updates" message
  void _showNoUpdatesMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(tr('no_updates')),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Ensure update downloaded flag is consistent with global state
    if (globalUpdateDownloaded && !_updateDownloaded) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _updateDownloaded = true;
        });
      });
    }

    return Expanded(
        // wrap in Expanded
        child: Column(
      children: [
        // Show update banner at the top when an update has been downloaded
        if (_updateDownloaded)
          Container(
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.green, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.system_update, color: Colors.green, size: 24),
                    SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        tr('update_downloaded'),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.green.shade800,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  tr('update_downloaded_restart_to_install'),
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.refresh),
                    label: Text(tr('restart')),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    onPressed: () {
                      // For testing in debug mode
                      if (kDebugMode) {
                        AppUpdateService().showRestartingToast(context);
                      } else {
                        // In production
                        InAppUpdate.completeFlexibleUpdate();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        Expanded(
          child: ListView(
            shrinkWrap: true,
            children: [
              // ListTile(
              //   contentPadding: EdgeInsets.all(0.00),
              //   leading: Icon(Icons.map),
              //   title: Text('Бонусы'),
              //   trailing: Icon(Icons.keyboard_arrow_right),
              //   onTap: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => Bonuses(),
              //       ),
              //     );
              //   },
              // ),
              ListTile(
                contentPadding: EdgeInsets.all(0.00),
                // leading: FaIcon(FontAwesomeIcons.shoppingBasket),
                leading: Icon(Icons.shopping_basket_outlined),
                title: Text(tr('my_orders')),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrdersPage(),
                    ),
                  );
                },
              ),
              // ListTile(
              //   contentPadding: EdgeInsets.all(0.00),
              //   leading: Icon(Icons.map),
              //   title: Text('Мои адреса'),
              //   trailing: Icon(Icons.keyboard_arrow_right),
              // ),
              ListTile(
                contentPadding: EdgeInsets.all(0.00),
                leading: Icon(Icons.person_outline),
                title: Text(tr('personal_data')),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PersonalDataPage(),
                    ),
                  );
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.all(0.00),
                leading: Icon(Icons.language),
                title: Text(tr('language_app')),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => LanguageSwitcher(),
                  );
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.all(0.00),
                leading: Icon(Icons.info_outline),
                title: Text(tr('about_us')),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AboutUs(),
                    ),
                  );
                },
              ),
              // Only show update button on Android
              if (Theme.of(context).platform == TargetPlatform.android)
                ListTile(
                  contentPadding: EdgeInsets.all(0.00),
                  leading: Icon(Icons.system_update),
                  title: Text(tr('check_updates')),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () async {
                    // Check if flexible update is available
                    final updateInfo =
                        await _appUpdateService.checkForUpdateInfo();

                    if (updateInfo != null &&
                        updateInfo.updateAvailability ==
                            UpdateAvailability.updateAvailable) {
                      if (updateInfo.flexibleUpdateAllowed) {
                        _appUpdateService.startFlexibleUpdate(context);
                      } else if (updateInfo.immediateUpdateAllowed) {
                        _appUpdateService.performImmediateUpdate();
                      } else {
                        // Show a snackbar or dialog based on build mode
                        if (kDebugMode) {
                          // In debug mode, show emulation options
                          _showDebugEmulationDialog(context);
                        } else {
                          // In production, just show a simple "no updates" message
                          _showNoUpdatesMessage(context);
                        }
                      }
                    } else {
                      // Show a snackbar or dialog based on build mode
                      if (kDebugMode) {
                        // In debug mode, show emulation options
                        _showDebugEmulationDialog(context);
                      } else {
                        // In production, just show a simple "no updates" message
                        _showNoUpdatesMessage(context);
                      }
                    }
                  },
                  // Only enable long press emulation in debug mode
                  onLongPress: kDebugMode
                      ? () {
                          // Emulate an update
                          _appUpdateService.emulateUpdate(context);
                          // Set the flag to show the update banner in profile
                          setUpdateDownloaded(true);
                        }
                      : null,
                ),
              // ListTile(
              //   contentPadding: EdgeInsets.all(0.00),
              //   leading: Icon(Icons.info_outline),
              //   title: Text('Оформление заказа'),
              //   trailing: Icon(Icons.keyboard_arrow_right),
              //   onTap: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => OrderRegistration(),
              //       ),
              //     );
              //   },
              // ),
            ],
          ),
        ),
      ],
    ));
  }
}
