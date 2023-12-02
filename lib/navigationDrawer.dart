import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/Cubit/social/socialCubit.dart';
import 'package:social_app/Cubit/social/socialStates.dart';
import 'package:social_app/constants.dart';
import 'package:social_app/editProfileScreen.dart';
import 'package:social_app/shared/components.dart';

class NavigationDrawer extends StatelessWidget {
  final socialCubit cubit;
  const NavigationDrawer({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      //backgroundColor: const Color(0Xff1c242f),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            _buildMenuItems(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    var h = MediaQuery.of(context).size.height;

    return Container(
      //  dark 233040
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      /* decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: cubit.user!.coverImageUrl != null
              ? NetworkImage(
                  cubit.user!.coverImageUrl!,
                )
              : const AssetImage('assets/noCover.jpg') as ImageProvider,
        ),
      ), */
      child: _profileHeader(context),
      width: double.infinity,
      color: cubit.isDark ? const Color(0XFF233040) : defaultColor,

      //   color:defaultColor,
      //  height: h * 0.3,
    );
  }

  Widget _buildMenuItems(BuildContext context) {
    //dark 1c242f

    return Column(
      children: [
        //const Divider(thickness: 1,),
        InkWell(
          onTap: () {
            Navigator.of(context).pop();
            cubit.changeNavIndex(3);
          },
          child: ListTile(
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: Theme.of(context).iconTheme.color,
            ),
            leading: CircleAvatar(
              radius: 16,
              backgroundColor: defaultColor,
              child: CircleAvatar(
                  radius: 15,
                  backgroundImage: cubit.user!.profileIimageUrl != null
                      ? NetworkImage(
                          cubit.user!.profileIimageUrl!,
                        )
                      : const AssetImage('assets/person.png') as ImageProvider),
            ),
            title: Text(
              'Profile',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            // horizontalTitleGap: 50,
          ),
        ),
        ExpansionTile(
          leading: Icon(
            Icons.person_outline,
            color: Theme.of(context).iconTheme.color,
          ),
          collapsedIconColor: Theme.of(context).iconTheme.color,
          title: Text(
            'profile info',
            style: Theme.of(context).textTheme.subtitle1,
          ),
          children: [
            ListTile(
              leading: Text(
                'Email:',
                style: Theme.of(context).textTheme.subtitle2,
              ),
              title: FittedBox(
                child: Text(
                  cubit.user!.email,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2!
                      .copyWith(color: Colors.blueGrey),
                ),
              ),
            ),
            ListTile(
              leading: Text(
                'Username:',
                style: Theme.of(context).textTheme.subtitle2,
              ),
              title: Text(
                cubit.user!.username,
                style: Theme.of(context)
                    .textTheme
                    .subtitle2!
                    .copyWith(color: Colors.blueGrey),
              ),
            ),
            ListTile(
              leading: Text(
                'Phone:',
                style: Theme.of(context).textTheme.subtitle2,
              ),
              title: Text(
                cubit.user!.phone!.isEmpty ? 'not set' : cubit.user!.phone!,
                style: Theme.of(context)
                    .textTheme
                    .subtitle2!
                    .copyWith(color: Colors.blueGrey),
              ),
            ),
            ListTile(
              leading: Text(
                'Location:',
                style: Theme.of(context).textTheme.subtitle2,
              ),
              title: Text(
                cubit.user!.getLocation!.isEmpty
                    ? 'not set'
                    : cubit.user!.getLocation!,
                style: Theme.of(context)
                    .textTheme
                    .subtitle2!
                    .copyWith(color: Colors.blueGrey),
              ),
            ),
          ],
        ),
        InkWell(
          onTap: () {},
          child: ListTile(
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: Theme.of(context).iconTheme.color,
            ),
            leading: Icon(
              Icons.bookmark_outline,
              color: Theme.of(context).iconTheme.color,
            ),
            title: Text(
              'Saved posts',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
        ),

        ExpansionTile(
          collapsedIconColor: Theme.of(context).iconTheme.color,
          leading: Icon(
            Icons.sunny,
            color: Theme.of(context).iconTheme.color,
          ),
          title: Text(
            'Theme Mode',
            style: Theme.of(context).textTheme.subtitle1,
          ),
          children: [
            InkWell(
              onTap: () {
                cubit.changeRadioValue(1);
                //change to light mode
                cubit.toLightMode();
              },
              child: ListTile(
                leading: Radio(
                  value: 1,
                  groupValue: cubit.groupValue,
                  onChanged: (index) {
                    cubit.changeRadioValue(index);
                    //change to light mode
                    cubit.toLightMode();
                  },
                ),
                title: Text('Light Mode',
                    style: Theme.of(context).textTheme.subtitle2),
              ),
            ),
            InkWell(
              onTap: () {
                cubit.changeRadioValue(2);
                //change to dark mode
                cubit.toDarkMode();
              },
              child: ListTile(
                leading: Radio(
                  value: 2,
                  groupValue: cubit.groupValue,
                  onChanged: (index) {
                    cubit.changeRadioValue(index);
                    //change to dark mode
                    cubit.toDarkMode();
                  },
                ),
                title: Text('Dark Mode',
                    style: Theme.of(context).textTheme.subtitle2),
              ),
            ),
          ],
        ),
        InkWell(
          onTap: (() {
            Navigator.of(context).pop();
            naviagte(context, editProfileScreen());
          }),
          child: ListTile(
            leading: Icon(
              Icons.settings_outlined,
              color: Theme.of(context).iconTheme.color,
            ),
            title: Text(
              'Settings',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
        ),
        const Divider(
          indent: 20,
          endIndent: 20,
        ),
        InkWell(
          onTap: () => Logout(context),
          child: ListTile(
            leading: Icon(
              Icons.power_settings_new_outlined,
              color: Theme.of(context).iconTheme.color,
            ),
            title: Text(
              'Logout',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
        ),
        InkWell(
          onTap: () => deleteAccount(context: context, userId: uID),
          child: ListTile(
            leading: Icon(
              Icons.remove_circle_outline,
              color: Theme.of(context).iconTheme.color,
            ),
            title: Text(
              'Delete Account',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
        ),
      ],
    );
  }

  _profileHeader(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 40, bottom: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    //نبقي نظهر الصورة
                  },
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 37,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: cubit.user!.profileIimageUrl != null
                          ? NetworkImage(cubit.user!.profileIimageUrl!)
                          : const AssetImage('assets/person.png')
                              as ImageProvider,
                    ),
                  ),
                ),
                Text(
                  cubit.user!.username,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                Text(
                  cubit.user!.email,
                  style: Theme.of(context)
                      .textTheme
                      .caption!
                      .copyWith(color: Colors.blueGrey),
                ),
              ],
            ),
          ),
        ),
        IconButton(
            onPressed: () => cubit.switchThemeMode(),
            icon: Icon(
              cubit.isDark ? Icons.sunny : Icons.mode_night_outlined,
              color: Theme.of(context).iconTheme.color,
            )),
      ],
    );
  }
}
