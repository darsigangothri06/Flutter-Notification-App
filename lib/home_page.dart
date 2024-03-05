import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive/hive.dart';

// local imports
import 'notifications.dart';

DateTime scheduleTime = DateTime.now();
String? notifTitle;
String? notifBody;

class MyHomePage extends StatefulWidget{
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>{

  late Box notifBox;

  Future<void> _fetchSharedPreferencesData() async {
    final prefs = await SharedPreferences.getInstance();
    notifTitle = prefs.getString('title');
    notifBody = prefs.getString('body');
  }
  Future<void> initializeNotiHive() async {
    notifBox = await Hive.openBox('server_notifications');
  }
  @override
  void initState() {
    super.initState();
    _fetchSharedPreferencesData();
    initializeNotiHive();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notif Demo"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'Enter notification title',
              ),
              onChanged: (value) {
                setState(() {
                  notifTitle = value;
                });
              },
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Body',
                hintText: 'Enter notification body',
              ),
              onChanged: (value) {
                setState(() {
                  notifBody = value;
                });
              },
            ),
            DatePickerTxt(),
            ScheduleBtn(),
            TextButton(
              onPressed: (){
                var dbNotification = notifBox.get(0);
                print(dbNotification.title);
                print(notifBox);
                NotificationService().showNotification(title: dbNotification.title, body: dbNotification.body);
              },
              child: const Text(
                'Get Latest Notification from DB',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class DatePickerTxt extends StatefulWidget {
  const DatePickerTxt({
    Key? key,
  }) : super(key: key);

  @override
  State<DatePickerTxt> createState() => _DatePickerTxtState();
}

class _DatePickerTxtState extends State<DatePickerTxt> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        scheduleTime = DateTime.now().add(const Duration(seconds: 10));
        // scheduleTime = DateTime(2024,3,5,9,43,40);
      },
      child: const Text(
        'Click To Set Date',
        style: TextStyle(color: Colors.blue),
      ),
    );
  }
}

class ScheduleBtn extends StatelessWidget {
  const ScheduleBtn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: const Text('Schedule notifications'),
      onPressed: () {
        debugPrint('Notification Scheduled for $scheduleTime');
        NotificationService().showNotification(title: 'Great', body: 'This is body');
        NotificationService().scheduleNotification(
            title: notifTitle,
            body: '$scheduleTime, $notifBody',
            scheduledNotificationDateTime: scheduleTime);
      },
    );
  }
}


            // TextButton(
            //   onPressed: (){
            //     const dbNotification = notifBox.get(0);
            //     NotificationService().showNotification(title: dbNotification.title, body: dbNotification.body);
            //   },
            //   child: const Text(
            //     'Get Latest Notification from DB',
            //     style: TextStyle(color: Colors.blue),
            //   ),
            // ),