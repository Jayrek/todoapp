import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/core/service/notification_service.dart';
import 'package:todoapp/shared/widgets/custom_elevated_button_widget.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late NotificationService notificationService;

  final messageController = TextEditingController();
  final tokenController = TextEditingController();

  @override
  void initState() {
    super.initState();
    notificationService = NotificationService();
  }

  @override
  Widget build(BuildContext context) {
    final dynamic message = ModalRoute.of(context)!.settings.arguments;

    final notch = message != null ? jsonDecode(message) : null;

    final title = notch?['notification']?['title'] ?? 'n/a';
    final body = notch?['notification']?['body'] ?? 'n/a';

    return Scaffold(
      appBar: AppBar(title: const Text('Notification')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.grey.shade300,
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Title:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 5),
                        Text(title, style: TextStyle(fontSize: 16)),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Body:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(body, style: TextStyle(fontSize: 16)),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Divider(),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Text(
                'You want to notify a message?',
                style: TextStyle(fontSize: 12),
              ),
              Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Message',
                      hintStyle: TextStyle(fontSize: 12),
                    ),
                    autofocus: true,
                    controller: messageController,
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Recipient Token',
                      hintStyle: TextStyle(fontSize: 12),
                    ),
                    autofocus: true,
                    controller: tokenController,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () {
                        tokenController.text = '';
                      },
                      child: Text(
                        'Clear Token',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  CustomElevatedButtonWidget(
                    backgroundColor: Colors.black87,
                    onPressed: () {
                      // final String recipientToken = deviceReceiptientPixel7Token;
                      sendFCMNotification(
                        tokenController.text,
                        messageController.text,
                      );
                    },
                    childWidget: Text(
                      'Send',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> sendFCMNotification(
    String recipientToken,
    String messageBody,
  ) async {
    final String projectId = 'todo-app-b7751';
    final String accessToken =
        'ya29.a0AeXRPp5lEurKIWub-5jgv9DCK71WMjPwzvN6nWz1yAz6K0z3F2GabWBkIPC2IR-VcpMgEYZal1tPMG3Koxe6WCxrdCn39vXNixiisk2Vatfce7wwo8KX0k19c4lsAMRO6NDxAn00NFBC04EdW58VS2EIpvvx0WbeaCX4oUD5WQaCgYKAd8SARASFQHGX2MijyXJdtztK7-SQXfg9qTKDQ0177';
    final requestUrl =
        'https://fcm.googleapis.com/v1/projects/$projectId/messages:send';

    final Dio dio = Dio();

    dio.options.headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    };

    final response = await dio.post(
      requestUrl,
      data: {
        'message': {
          'token': recipientToken,
          'notification': {'title': 'New Notification', 'body': messageBody},
          'data': {'userId': '1234', 'chatId': 'abcd5678', 'type': 'chat'},
          'android': {'priority': 'high'},
        },
      },
    );

    if (!mounted) return;
    if (response.statusCode == 200) {
      debugPrint('Notification: SUCCESS');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Success sending notification!')));
    } else {
      debugPrint('Notification: FAILED: ${response.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed sending notification: ${response.statusCode}'),
        ),
      );
    }
  }
}
