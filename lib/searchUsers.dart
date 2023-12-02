import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/Cubit/social/socialEvents.dart';
import 'package:social_app/shared/components.dart';
import 'package:social_app/visitProfile.dart';

import 'Cubit/social/socialCubit.dart';
import 'Cubit/social/socialStates.dart';
import 'constants.dart';
import 'settings.dart';

class searchUsers extends StatefulWidget {
  const searchUsers({super.key});

  @override
  State<searchUsers> createState() => _searchUsersState();
}

class _searchUsersState extends State<searchUsers> {
  TextEditingController _searchController = TextEditingController();
  FocusNode node = FocusNode();
  @override
  void initState() {
    // TODO: implement initState
    node.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<socialCubit, socialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        socialCubit cubit = socialCubit.get(context);

        return SafeArea(
          child: Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 22.0, vertical: 15),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: Theme.of(context).iconTheme.color,
                        ),
                      ),
                      Expanded(
                        child: defaultFormField(
                            contoller: _searchController,
                            focusNode: node,
                            context: context,
                            filled: true,
                            radius: 20,
                            borderNone: true,
                            onchanged: (val) {
                              cubit.add(searchEvent(val.toLowerCase()));
                            },
                            suffixWidget: const Icon(
                              Icons.search,
                              color: defaultColor,
                            ),
                            hintText: 'Search'),
                      ),
                    ],
                  ),
                  cubit.searchResults.isEmpty
                      ? const SizedBox()
                      : Expanded(
                          child: ListView.separated(
                              padding: const EdgeInsets.only(top: 20),
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () =>cubit.user!.getToken==cubit.searchResults[index].getToken?
                                  naviagte(
                                      context,
                                      const settingsScreen())
                                  
                                   :naviagte(
                                      context,
                                      visitProifle(
                                          user: cubit.searchResults[index])),
                                  child: Row(children: [
                                    CircleAvatar(
                                      radius: 25,
                                      backgroundColor: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      child: CircleAvatar(
                                        radius: 23,
                                        backgroundImage: cubit
                                                    .searchResults[index]
                                                    .profileIimageUrl ==
                                                null
                                            ? const AssetImage(
                                                    'assets/person.png')
                                                as ImageProvider
                                            : NetworkImage(cubit
                                                .searchResults[index]
                                                .profileIimageUrl!),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      cubit.searchResults[index].username,
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    ),
                                  ]),
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                    height: 18,
                                  ),
                              itemCount: cubit.searchResults.length),
                        ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
