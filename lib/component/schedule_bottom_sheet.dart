import 'package:calendar_scheduler/component/custom_text_field.dart';
import 'package:calendar_scheduler/const/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../model/schedule_model.dart';

class ScheduleBottomSheet extends StatefulWidget {
  final DateTime selectedDate;

  const ScheduleBottomSheet({super.key, required this.selectedDate});

  @override
  State<ScheduleBottomSheet> createState() => _ScheduleBottomSheetState();
}

// 이 위젯은 하단 시트의 레이아웃을 구성합니다.
// ScheduleBottomSheet 위젯은 일정을 추가하는 데 사용되는 하단 시트입니다.
class _ScheduleBottomSheetState extends State<ScheduleBottomSheet> {
  // formKey는 Form 위젯의 상태를 관리하는 키입니다.
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // startTime은 일정의 시작 시간을 나타냅니다.
  int? startTime;
  int? endTime;
  String? content;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    // 하단 시트는 시작 시간, 종료 시간, 그리고 내용을 입력할 수 있는 CustomTextField 위젯을 포함하고 있습니다.
    // 하단 시트의 맨 아래에는 'Save' 버튼이 위치하고 있습니다.
    return Form(
      // formKey : Form 위젯의 상태를 관리하는 키입니다. globalKey를 사용하여 Form 위젯의 상태를 관리합니다.
      key: formKey,
      child: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height / 2 + bottomInset,
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.only(left: 8, right: 8, top: 8, bottom: bottomInset),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: 'Start Time',
                        isTime: true,
                        onSaved: (String? val) {
                          startTime = int.parse(val!);
                        },
                        validator: timeValidator,
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: CustomTextField(
                        label: 'End Time',
                        isTime: true,
                        onSaved: (String? val) {
                          endTime = int.parse(val!);
                        },
                        validator: timeValidator,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Expanded(
                  child: CustomTextField(
                    label: 'Content',
                    isTime: false,
                    onSaved: (String? val) {
                      content = val;
                    },
                    validator: contentValidator,
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onSavePressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: PRIMARY_COLOR,
                    ),
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onSavePressed() async {
    // validate가 위의 formkey가 적용된 form의 하위 위젯들의 validator를 호출하여 유효성 검사를 수행합니다.
    // 여기서는 timeValidator와 contentValidator를 호출합니다.
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      final schedule = ScheduleModel(
        id: const Uuid().v4(),
        content: content!,
        startTime: startTime!,
        endTime: endTime!,
        date: widget.selectedDate,
      );

      // 'schedules' 컬렉션에 일정을 json 형태로 add합니다.
      var documentReference = await FirebaseFirestore.instance.collection('schedules').add(schedule.toJson());
      debugPrint('documentReference: $documentReference');
    }

    Navigator.pop(context);
  }

  String? timeValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a time';
    }

    int? number;

    try {
      number = int.parse(value);
    } catch (e) {
      return 'Please enter a number';
    }

    if (number < 0 || number > 23) {
      return 'Please enter 0-23';
    }

    return null;
  }

  String? contentValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a content';
    }

    return null;
  }
}
