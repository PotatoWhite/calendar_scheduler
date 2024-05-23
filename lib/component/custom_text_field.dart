import 'package:calendar_scheduler/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final bool isTime;

  final FormFieldSetter<String> onSaved; // onSaved는 입력된 값이 저장될 때 호출되는 콜백 함수입니다.
  final FormFieldValidator<String> validator; // validator는 입력된 값이 유효한지 검사하는 함수입니다.

  const CustomTextField({
    required this.label,
    required this.isTime,
    required this.onSaved,
    required this.validator,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: PRIMARY_COLOR,
            fontWeight: FontWeight.w600,
          ),
        ),
        Expanded(
          flex: isTime ? 0 : 1,
          child: TextFormField(
            // onSaved : 입력된 값이 저장될 때 호출되는 콜백 함수입니다.
            onSaved: onSaved,
            // validator : 입력된 값이 유효한지 검사하는 함수입니다.
            validator: validator,
            cursorColor: Colors.grey,
            maxLines: isTime ? 1 : null,
            expands: !isTime,
            keyboardType: isTime ? TextInputType.number : TextInputType.multiline,
            inputFormatters: isTime ? [FilteringTextInputFormatter.digitsOnly] : [],
            decoration: InputDecoration(
              border: InputBorder.none,
              filled: true,
              fillColor: Colors.green[300],
              suffixText: isTime ? 'Hour' : null,
            ),
          ),
        )
      ],
    );
  }
}
