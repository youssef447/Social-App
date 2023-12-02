import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/Cubit/social/socialCubit.dart';
import 'package:social_app/Cubit/social/socialStates.dart';

import 'constants.dart';
import 'postCard.dart';

class SavedPosts extends StatelessWidget {
  const SavedPosts({super.key});

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height -
        height! -
        kBottomNavigationBarHeight -
        bottomMobileBarHeight!;

    final Orientation orientation = MediaQuery.of(context).orientation;
    final w = MediaQuery.of(context).size.width;

    return BlocConsumer<socialCubit, socialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = socialCubit.get(context);
        return Scaffold(
          body: cubit.savedPosts == null
              ? const Center(
                  child: Text('No Saved Posts yet'),
                )
              : Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: orientation == Orientation.portrait
                          ? w * 0.02
                          : (w - bottomMobileBarHeight!) * 0.02),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: ListView.separated(
                      separatorBuilder: (context, index) => SizedBox(
                        height: h * 0.03,
                      ),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: ((context, index) {
                        return postCard(
                            cubit: cubit,
                            index: index,
                            posts: cubit.savedPosts!);
                      }),
                      itemCount: cubit.savedPosts!.length,
                    ),
                  ),
                ),
        );
      },
    );
  }
}
