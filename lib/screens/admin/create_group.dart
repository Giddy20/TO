import 'package:app/constants.dart';
import 'package:app/screens/admin/admin_side_nav.dart';
import 'package:app/widgets/button_icon_less.dart';
import 'package:app/widgets/new_entry_field.dart';
import 'package:flutter/material.dart';

class CreateGroup extends StatefulWidget {
  const CreateGroup({Key? key}) : super(key: key);

  @override
  _CreateGroupState createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController groupNameController = TextEditingController();
  var cont = false;
  var formattedDate;
  var formattedDateTo;
  TimeOfDay time = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    formattedDate = 'From';
  }

  abc() {}
  DateTime currentDate = DateTime.now();
  DateTime? pickedDate;
  Future<void> _selectDate(BuildContext context) async {
    pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(DateTime.now().day - 1),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != currentDate) {
      setState(() {
        var date = DateTime.parse(pickedDate.toString());
        formattedDate = "${date.day}-${date.month}-${date.year}";

        currentDate = pickedDate!;
      });
    }
  }

  Future<void> _selectDateTo(BuildContext context) async {
    pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(DateTime.now().day - 1),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != currentDate) {
      setState(() {
        var date = DateTime.parse(pickedDate.toString());
        formattedDateTo = "${date.day}-${date.month}-${date.year}";

        currentDate = pickedDate!;
      });
    }
  }

  Future pickTime(BuildContext context) async {
    final newTime = await showTimePicker(context: context, initialTime: time);
    if (newTime == null) return;
    setState(() {
      time = newTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        drawer: const AdminSideNav(),
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    const SizedBox(height: 30),
                    Center(
                      child: Container(
                        height: MediaQuery.of(context).size.height / 16,
                        width: MediaQuery.of(context).size.width / 1.1,
                        decoration: BoxDecoration(
                            color: Colors.purple,
                            borderRadius: BorderRadius.circular(14)),
                        child: Row(
                          children: [
                            const SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                _scaffoldKey.currentState!.openDrawer();
                              },
                              child: const Icon(Icons.menu, color: whiteColor),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Create a group for an upcoming event',
                              style: TextStyle(
                                  color: whiteColor,
                                  fontWeight: FontWeight.w800),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    CircleAvatar(
                      backgroundColor: Colors.grey,
                      radius: 87,
                      child: CircleAvatar(
                        backgroundColor: whiteColor,
                        radius: 85,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.add,
                              size: 85,
                              color: Colors.grey,
                            ),
                            Text(
                              'ADD GROUP ICON',
                              style: TextStyle(color: Colors.grey),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    // NewEntryField(
                    //     'Group name',
                    //     Colors.deepPurple,
                    //     TextInputType.emailAddress,
                    //     groupNameController,
                    //     false,
                    //     Icons.mail,
                    //     Colors.transparent,
                    //     Colors.deepPurple,
                    //     false,
                    //     1,
                    //     1.1),
                    const SizedBox(height: 10),
                    // NewEntryField(
                    //     'Event name',
                    //     Colors.deepPurple,
                    //     TextInputType.emailAddress,
                    //     groupNameController,
                    //     false,
                    //     Icons.mail,
                    //     Colors.transparent,
                    //     Colors.deepPurple,
                    //     false,
                    //     1,
                    //     1.1),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () => _selectDate(context),
                            child: Container(
                              width: MediaQuery.of(context).size.width / 2.3,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: Colors.deepPurple)),
                              child: ListTile(
                                  leading: Text(
                                    formattedDate.toString(),
                                    style: const TextStyle(
                                        color: Colors.deepPurple),
                                  ),
                                  trailing: const Icon(Icons.calendar_today,
                                      color: Colors.deepPurple)),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _selectDateTo(context),
                            child: Container(
                              width: MediaQuery.of(context).size.width / 2.3,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: Colors.deepPurple)),
                              child: ListTile(
                                  leading: Text(
                                    formattedDateTo.toString(),
                                    style: const TextStyle(
                                        color: Colors.deepPurple),
                                  ),
                                  trailing: const Icon(Icons.calendar_today,
                                      color: Colors.deepPurple)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                       const Text(
                          'Start At :      ',
                          style:
                              TextStyle(color: Colors.deepPurple, fontSize: 18),
                        ),
                        GestureDetector(
                          onTap: () => pickTime(context),
                          child: Container(
                            width: MediaQuery.of(context).size.width / 2.3,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: Colors.deepPurple)),
                            child: ListTile(
                                leading: Text(
                                  time.toString(),
                                  style:
                                      const TextStyle(color: Colors.deepPurple),
                                ),
                                trailing: const Text('AM',
                                    style:
                                        TextStyle(color: Colors.deepPurple))),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // NewEntryField(
                    //     'Event location',
                    //     Colors.deepPurple,
                    //     TextInputType.emailAddress,
                    //     groupNameController,
                    //     false,
                    //     Icons.mail,
                    //     Colors.transparent,
                    //     Colors.deepPurple,
                    //     false,
                    //     1,
                    //     1.1),
                    // const SizedBox(height: 10),
                    // NewEntryField(
                    //     'Ticket Price',
                    //     Colors.deepPurple,
                    //     TextInputType.emailAddress,
                    //     groupNameController,
                    //     false,
                    //     Icons.mail,
                    //     Colors.transparent,
                    //     Colors.deepPurple,
                    //     false,
                    //     1,
                    //     1.1),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: ButtonIconLess('CONTINUE', Colors.deepPurple,
                      Colors.deepPurple, whiteColor, 1.2, 14, 16, abc),
                ),
              ],
            ),
          ),
        ));
  }
}
