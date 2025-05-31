import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task_app/features/drag_drop/cubit/drag_drop_cubit.dart';
import 'package:flutter_task_app/features/drag_drop/cubit/drag_drop_state.dart';
import 'package:flutter_task_app/features/drag_drop/screen/widgets/control_buttons_widget.dart';
import 'package:flutter_task_app/features/drag_drop/screen/widgets/drag_options_widget.dart';
import 'package:flutter_task_app/features/drag_drop/screen/widgets/result_message_widget.dart';
import 'package:flutter_task_app/features/drag_drop/screen/widgets/sentence_area_widget.dart';


class DragDropExercisePage extends StatelessWidget {
  const DragDropExercisePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drag and Drop Exercise'),
        backgroundColor: Colors.blue[100],
      ),
      body: BlocBuilder<DragDropCubit, DragDropState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Complete the sentence:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                
                SentenceAreaWidget(state: state),
                
                const SizedBox(height: 40),
                
                ResultMessageWidget(state: state),
                
                const SizedBox(height: 20),
                
                DragOptionsWidget(state: state),
                
                const Spacer(),
                
                ControlButtonsWidget(state: state),
                
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}