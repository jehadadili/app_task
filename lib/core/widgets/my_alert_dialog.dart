import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task_app/core/widgets/submit_button.dart';

void myAlertDialog({
  required BuildContext context,
  String title = '',
  String text = '',
}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
      ),
      title: Text(
        title,
        style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
      content: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16.sp, color: Colors.black),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: SubmitButton(
            text: 'OK',
            onPressed: () {
              Navigator.of(context).pop(); 
            },
          ),
        ),
      ],
    ),
  );
}
