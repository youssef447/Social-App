import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:social_app/addPostScreen.dart';
import 'package:social_app/Cubit/social/socialCubit.dart';
import 'package:flutter/material.dart';
import 'package:social_app/searchUsers.dart';
import 'package:social_app/shared/components.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

import 'Cubit/social/socialStates.dart';
import 'constants.dart';
import 'navigationDrawer.dart';

class Home extends StatefulWidget {

  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    // TODO: implement initState
    socialCubit.get(context).getUser(context);
  }

  @override
  Widget build(BuildContext context) {
    //PreferredSizeWidget appbaa = AppBar();
        topPadding=MediaQuery.of(context).padding.top;

    bottomMobileBarHeight = MediaQuery.of(context).padding.bottom;
    width=MediaQuery.of(context).size.width;
    return homeScreen();
  }

  Widget homeScreen() {
    //final _scaffoldKey = GlobalKey<ScaffoldState>();
    const placeholder = Opacity(
      child: Icon(
        Icons.no_cell,
      ),
      opacity: 0,
    );

    return BlocConsumer<socialCubit, socialStates>(
        listener: ((context, state) {}),
        builder: ((context, state) {
          var cubit = socialCubit.get(context);

          return 
              Scaffold(
                backgroundColor: cubit.isDark?Theme.of(context).scaffoldBackgroundColor:Colors.grey[100],
                  drawer: NavigationDrawer(cubit: cubit),
      
                  floatingActionButton: FloatingActionButton(

                    backgroundColor:cubit.isDark?const Color(0XFF233040) : Theme.of(context).scaffoldBackgroundColor,

                    onPressed: () {
                      cubit.postImage=null;
                      naviagte(
                        context,
                         addPostScreen(),
                      );
                    },
                    child: FittedBox(
                      child: Column(
                        children: [
                          
                           Icon(
                            Icons.post_add_outlined,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          Text('Post',style: Theme.of(context).textTheme.titleSmall!)
                        ],
                      ),
                    ),
                  ),
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.centerDocked,

                 
                  bottomNavigationBar: BottomAppBar(
                    
                    //color: Color.fromARGB(255, 41, 6, 58),
                    notchMargin: 14,
                    shape: const CircularNotchedRectangle(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BottomAppBarTabItem(index: 0, icon: IconBroken.Home),
                        BottomAppBarTabItem(index: 1, icon: IconBroken.Chat),
                        placeholder,
                        BottomAppBarTabItem(
                            index: 2, icon: IconBroken.Location),
                        //BottomAppBarTabItem(index: 3, icon: IconBroken.Profile),
                        InkWell(
                          //to remove onTab Grey Color
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            cubit.changeNavIndex(3);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18.0, vertical: 10),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  backgroundColor: 3 == cubit.currentIndex
                                      ? defaultColor
                                      : Colors.white,
                                  radius: 17,
                                  child: CircleAvatar(
                                    radius: 15,
                                    //ركز ليه مش !...ع ما ال جيت يوزر ترجع عشان ميديش ايرور انه الداتا مجتش وانه يوزر لسه ب نل
                                    backgroundImage: cubit
                                                .user?.profileIimageUrl !=
                                            null
                                        ? NetworkImage(
                                            cubit.user!.profileIimageUrl!)
                                        : const AssetImage('assets/person.png')
                                            as ImageProvider,
                                  ),
                                ),
                                Text(
                                  cubit.titles[3],
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                  appBar: cubit.currentIndex == 0
                      ? AppBar(
                          title: Text(
                            cubit.titles[cubit.currentIndex],
                          ),

                          /*  onPressed: () async {
                        await CacheHelper.removeData(key: "Token");
                        naviagteTo(context, const Login());
                      }, */

                          actions: [
                            IconButton(
                              onPressed: null,
                              icon: Icon(
                                IconBroken.Notification,
                                color:
                                    cubit.isDark ? Colors.white : Colors.black,
                              ),
                            ),
                            IconButton(
                              onPressed: ()=>naviagte(context, const searchUsers()),
                              icon: Icon(
                                IconBroken.Search,
                                color:
                                    cubit.isDark ? Colors.white : Colors.black,
                              ),
                            ),
                          ],
                        )
                      : null,
                  body: state is socialGetDataLoadingState
              ? const Center(
                  child: CircularProgressIndicator(),
                ):SafeArea(child: cubit.screens[cubit.currentIndex]),
                );
        }));
  }

  Widget BottomAppBarTabItem({required int index, required IconData icon}) {
    var cubit = socialCubit.get(context);

    return InkWell(
      //to remove onTab Grey Color
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        cubit.changeNavIndex(index);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconTheme(
                data: IconThemeData(
                    color: index == cubit.currentIndex
                        ? defaultColor
                        : Colors.grey),
                child: Icon(icon)),
            Text(
              cubit.titles[index],
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ],
        ),
      ),
    );
  }
}
