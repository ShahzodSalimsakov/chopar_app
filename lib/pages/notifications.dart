import 'dart:convert';
import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chopar_app/pages/notifications_detail.dart';
import 'package:chopar_app/routes/router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

@RoutePage()
class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<Map<String, dynamic>> _notifications = [];
  bool isLoading = false;

  Future<void> fetchNotifications() async {
    setState(() {
      isLoading = true;
    });
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json'
    };

    var url = Uri.https('api.choparpizza.uz', '/api/mobile_push_events', {
      'op_<=_start_date': DateFormat('yyyy-MM-dd H:m:s').format(DateTime.now())
    });
    var response = await http.get(url, headers: requestHeaders);
    if (response.statusCode == 200 || response.statusCode == 201) {
      var json = jsonDecode(response.body);
      setState(() {
        // json data to list of Map<String, dynamic>
        _notifications = json['data'].cast<Map<String, dynamic>>();
        isLoading = false;
      });
    }
  }

  // Helper method to get localized text from notification
  String getLocalizedText(Map<String, dynamic> notification, String field) {
    final languageCode = context.locale.languageCode;

    // Check if the field exists in the notification
    if (notification[field] == null) return '';

    // Try to get the localized version based on current language
    if (languageCode == 'uz' &&
        notification['${field}_uz'] != null &&
        notification['${field}_uz'].toString().isNotEmpty) {
      return notification['${field}_uz'];
    }

    // Fallback to the default field (usually Russian)
    return notification[field];
  }

  @override
  initState() {
    super.initState();
    fetchNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Padding(
                padding: EdgeInsets.only(right: 28),
                child: Center(
                    child: Icon(
                  Icons.close,
                  color: Colors.black,
                  size: 30,
                )),
              ))
        ],
        title: Text(tr('news_and_promotions'),
            style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w500)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        color: Colors.grey.shade100,
        child: SafeArea(
          child: isLoading
              ? Center(
                  child:
                      CircularProgressIndicator(color: Colors.yellow.shade400),
                )
              : Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 36),
                  child: ListView.builder(
                      itemCount: _notifications.length,
                      itemBuilder: (BuildContext context, int index) {
                        // Get localized title and text
                        final localizedTitle =
                            getLocalizedText(_notifications[index], 'title');
                        final localizedText =
                            getLocalizedText(_notifications[index], 'text');

                        return Card(
                            clipBehavior: Clip.antiAlias,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            elevation: 0,
                            margin: const EdgeInsets.only(bottom: 20),
                            child: Column(
                              children: [
                                // show image if asset exists
                                _notifications[index]['asset'] != null
                                    ? Stack(
                                        alignment: Alignment.topCenter,
                                        children: [
                                          Ink.image(
                                            image: CachedNetworkImageProvider(
                                                _notifications[index]['asset']
                                                    [0]['link']),
                                            height: 200,
                                            fit: BoxFit.cover,
                                          ),
                                        ],
                                      )
                                    : Container(),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      localizedTitle.isNotEmpty
                                          ? Text(
                                              localizedTitle,
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500),
                                            )
                                          : Container(),
                                      localizedTitle.isNotEmpty
                                          ? const SizedBox(height: 10)
                                          : Container(),
                                      // show truncated text if text is too long
                                      localizedText.isNotEmpty
                                          ? Text(
                                              localizedText,
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500),
                                            )
                                          : Container(),
                                      // router push to detail page widget
                                      localizedTitle.isNotEmpty
                                          ? const SizedBox(height: 10)
                                          : Container(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        NotificationDetailPage(
                                                      id: _notifications[index]
                                                              ['id']
                                                          .toString(),
                                                      notification:
                                                          _notifications[index],
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Text(
                                                tr('read_more'),
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ))
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ));
                      })),
        ),
      ),
    );
  }
}
