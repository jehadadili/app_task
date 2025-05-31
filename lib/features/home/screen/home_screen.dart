
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task_app/features/home/cubit/home_cubit.dart';
import 'package:flutter_task_app/features/home/screen/widgets/tab_bed_home_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(),
      child: const  TabBedHomeView(),
    );
  }
}
