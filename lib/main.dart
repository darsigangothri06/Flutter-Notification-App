import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:dio/dio.dart';

// local imports
import 'home_page.dart';
import 'notifications.dart';
import 'notification_model.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(NotificationModelAdapter());
  
  NotificationService().initNotification();
  tz.initializeTimeZones();

  var notification_box = await Hive.openBox<NotificationModel>('server_notifications');

  var dio = Dio();
  var response = await dio.get('http://192.168.1.7:8000/notification/');
  print('RESPONSE IS');
  print(response.data);
  if (response.data is List) {
    List<dynamic> dataList = response.data;

    // Use forEach to iterate over the List and add to Hive box
    dataList.forEach((data) {
      notification_box.add(NotificationModel(data['id'],data['title'], data['body']));
    });
  }

  print(notification_box);
  await notification_box.close();
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: "Notif Demo",
      home: MyHomePage(),
    );
  }

}