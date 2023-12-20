import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text('Profile'),
      ),

      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xFF2a0d2e),
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(50),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 10),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                  title: Text(
                    'Hello Ala!',
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  subtitle: Text(
                    'Good Morning',
                    style: Theme.of(context).textTheme.subtitle1?.copyWith(
                      color: Colors.white54,
                    ),
                  ),
                  trailing: const CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/login.png'),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
          Container(
            color: Color(0xFF2a0d2e),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              decoration: const BoxDecoration(
                color: Color(0xFF2a0d2e),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(200),
                ),
              ),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 40,
                mainAxisSpacing: 30,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/AccountInformation');
                    },
                    child: itemDashboard(
                      'Update Account Information',
                      CupertinoIcons.info,
                      Colors.yellow,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/Chart');
                    },
                    child: itemDashboard(
                      'Statistics',
                      CupertinoIcons.graph_circle,
                      Colors.green,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/ChangePassword');
                    },
                    child: itemDashboard(
                      'Change Password',
                      CupertinoIcons.padlock,
                      Colors.purple,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/BeloteStatisticsPage');
                    },
                    child: itemDashboard(
                      'Historique',
                      CupertinoIcons.square_list,
                      Colors.brown,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/SupportPage');
                    },
                    child: itemDashboard(
                      'Support',
                      CupertinoIcons.chat_bubble_2,
                      Colors.red[900]!,
                    ),
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.question,
                          animType: AnimType.topSlide,
                          showCloseIcon: true,
                          title: 'Logout Confirmation',
                          desc: "Are you sure you want to logout?",
                          descTextStyle: TextStyle(color: Colors.black),
                          btnCancelOnPress: () {
                            // Perform logout logic here
                            Navigator.pushNamed(context, '/logout'); // Replace '/logout' with your logout route
                          },
                          btnOkOnPress: () {
                            // Continue with the current flow, if needed
                            Navigator.pushNamed(context, '/');
                          },
                        ).show();

                      },
                      child: Center(
                        child: itemDashboard(
                          'Logout',
                          CupertinoIcons.arrow_right_square,
                          Colors.indigo,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget itemDashboard(String title, IconData iconData, Color background) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Color(0xFFf43868),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 2),
            color: Color(0xFFf43868).withOpacity(0.4),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: background,
              shape: BoxShape.circle,
            ),
            child: Icon(iconData, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              title.toUpperCase(),
              style: Theme.of(context).textTheme.subtitle1,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }


}
