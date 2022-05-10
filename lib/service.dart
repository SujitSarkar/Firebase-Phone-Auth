import 'dart:convert';
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

class NotificationService{

  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize(){
    const InitializationSettings initializationSettings =
         InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'));
    _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static void display(RemoteMessage message)async{
    try{
      Random random = Random();
      int id = random.nextInt(1000);
      const NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          'mychannel',
          'mychannel',
          importance: Importance.max,
          priority: Priority.high
        ));

      await _flutterLocalNotificationsPlugin.show(
          id,
          message.notification!.title,
          message.notification!.body,
          notificationDetails);
    }catch(e){
      print('Error>>>$e');
    }
  }

  static Future<void> sendNotification()async{
    try{
      final data = <String,dynamic>{
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        'id':'1',
        'status': 'done',
        'message':'Your phone number is verified',
      };

      final FirebaseMessaging fcm = FirebaseMessaging.instance;
      final fcmToken = await fcm.getToken();

      http.Response response = await http.post(
          Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers:<String,String>{
            'Content-Type': 'application/json',
            'Authorization': 'key=AAAAf_t5y3Q:APA91bG7WkRxpfHtFXGlyPsd9wqxgQdOnPJIhniFLwXZspBIgsoPHcYCQWxpTE7L0awDu_6-qvIuqEJ0luY0n1jCIvWpRB5hbBFd4q1L8pduy9px9CKkmdupWB0VQke_Cq73VEF6XaH6'
          },
          body: jsonEncode(<String,dynamic>{
            'notification': <String,dynamic>{
              'title': 'Notification from B2GSOFT',
              'body': 'Your phone number is verified'},
            'priority': 'high',
            'data': data,
            'to': fcmToken
          })
      );
      print('API Response::::::::::::::::::::${response.body}\n\n');
      print('Fcm Token::::::::::::::::::::$fcmToken\n\n');
    }catch(e){
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }
}