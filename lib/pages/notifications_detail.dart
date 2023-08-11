import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:auto_route/auto_route.dart';
import 'package:http/http.dart' as http;

@RoutePage()
class NotificationDetailPage extends StatefulWidget {
  final String id;
  late Map<String, dynamic>? notification;
  NotificationDetailPage({@PathParam() required this.id, this.notification});

  @override
  State<NotificationDetailPage> createState() => _NotificationDetailPageState();
}

class _NotificationDetailPageState extends State<NotificationDetailPage> {
  late Map<String, dynamic>? notification;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    if (widget.notification != null) {
      setState(() {
        notification = widget.notification;
        loading = false;
      });
    } else {
      fetchNotification();
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Center(
            child: CircularProgressIndicator(color: Colors.yellow.shade400),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text(
                notification?['title'] ?? '',
                style: const TextStyle(color: Colors.black),
              ),
              backgroundColor: Colors.white,
              leading: const BackButton(color: Colors.black),
            ),
            body: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // show image if asset exists
                  notification?['asset'] != null
                      ? Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            Ink.image(
                              image: NetworkImage(
                                notification?['asset'][0]['link'],
                              ),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        notification?['title'] != null &&
                                notification?['title'] != ''
                            ? Text(
                                notification?['title'],
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500),
                              )
                            : Container(),
                        notification?['title'] != null
                            ? const SizedBox(height: 10)
                            : Container(),
                        // show truncated text if text is too long
                        notification?['text'] != null
                            ? Text(
                                notification?['text'],
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Future<void> fetchNotification() async {
    setState(() {
      loading = true;
    });
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json'
    };

    var url =
        Uri.https('api.choparpizza.uz', '/api/mobile_push_events/${widget.id}');
    var response = await http.get(url, headers: requestHeaders);
    if (response.statusCode == 200 || response.statusCode == 201) {
      var json = jsonDecode(response.body);
      setState(() {
        // json data to list of Map<String, dynamic>
        notification = json['data'];
        loading = false;
      });
    }
  }
}
