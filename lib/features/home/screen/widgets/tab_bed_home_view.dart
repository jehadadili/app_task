import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_task_app/features/home/cubit/home_cubit.dart';
import 'package:flutter_task_app/features/home/cubit/home_state.dart';
import 'package:flutter_task_app/features/home/screen/widgets/game_bottom_sheet.dart';
import 'package:flutter_task_app/features/home/screen/widgets/home_app_bar.dart';
import 'package:flutter_task_app/features/home/screen/widgets/home_page.dart';


class TabBedHomeView extends StatelessWidget {
  const TabBedHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Scaffold(
          appBar: HomeAppBar(tabIndex: state.tabIndex),
          body: HomePages(tabIndex: state.tabIndex),
          floatingActionButton: FloatingActionButton(
            onPressed: () => GameBottomSheet.show(context),
            tooltip: 'Play Games',
            child: const Icon(Icons.gamepad_outlined),
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: state.tabIndex,
            onTap: (index) {
              context.read<HomeCubit>().changeTab(index);
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.article),
                label: 'Posts',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        );
      },
    );
  }
}
