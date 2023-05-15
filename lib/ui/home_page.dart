//This Class Manage the Date Scheduler UI and Controls
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:project1/controllers/task_controller.dart';
import 'package:project1/services/notification_services.dart';
import 'package:project1/services/theme_services.dart';
import 'package:project1/ui/add_task_bar.dart';
import 'package:project1/ui/theme.dart';
import 'package:project1/ui/widgets/button.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDate = DateTime.now();
  final _taskController = Get.put(TaskController());
  var notifyHelper;

  @override
  void initState() {
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
  }

  /*
  * This is the main method that call all the function within the Date Page
  * Functions running inside:
  * 1. App Bar
  * 2. Task Bar
  * 3. Date Bar
  * */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: context.theme.backgroundColor,
      body: Column(
        children: [
          _addTaskBar(),
          _addDateBar(),
          _showTasks(),
        ],
      ),
    );
  }

  //Custom Functions
  _showTasks() {
    return Expanded(
      child: Obx(() {
        return ListView.builder(
          itemCount: _taskController.taskList.length,
          itemBuilder: (_, context) {
            print(_taskController.taskList.length);
            return Container(
              width: 100,
              height: 50,
              color: Colors.green,
            );
          }
        );
      }),
    );
  }
  /*Function that handle the Horizontal Calendar*/
  _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: primaryClr,
        selectedTextColor: Colors.white,
        dateTextStyle: GoogleFonts.lato(
            textStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey
            )
        ),
        dayTextStyle: GoogleFonts.lato(
            textStyle: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.grey
            )
        ),
        monthTextStyle: GoogleFonts.lato(
            textStyle: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey
            )
        ),
        onDateChange: (date){
          _selectedDate = date;
        },
      ),
    );
  }
  /*Function that handles the button and call the Add Task Page*/
  _addTaskBar(){
    return  Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(DateFormat.yMMMMd().format(DateTime.now()),
                  style: subHeadingStyle,
                ) ,
                Text("Today",
                  style: headingStyle,
                )
              ],
            ),
          ),
          MyButton(label: "+ Add Task", onTap: () async {
            await Get.to(()=>AddTaskPage());
          }
          )],
      ),
    );
  }
  /*Function that handle the Header Section including the Theme Mode and User Profile*/
  _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
        onTap: (){
          ThemeService().switchTheme();
          notifyHelper.displayNotification(
            title: "Theme Changed",
            body: Get.isDarkMode?"Activated Light Theme":"Activated Dark Theme"
          );

          notifyHelper.scheduledNotification();
        },
        child: Icon(Get.isDarkMode ? Icons.wb_sunny_outlined:Icons.nightlight_round,
        size: 20,
        color: Get.isDarkMode ? Colors.white:Colors.black),
      ),
      actions: [
        CircleAvatar(
          backgroundImage: AssetImage(
            "images/user.png"
          ),
        ),
        SizedBox(width: 20,),
      ],
    );
  }

}
