import 'package:calendar_scheduler/const/colors.dart';
import 'package:flutter/material.dart';

// ScheduleCard 위젯은 일정의 시작 시간, 종료 시간, 그리고 내용을 표시하는 카드입니다.
class ScheduleCard extends StatelessWidget {
  // startTime은 일정의 시작 시간을 나타냅니다.
  // endTime은 일정의 종료 시간을 나타냅니다.
  // content는 일정의 내용을 나타냅니다.

  final int startTime;
  final int endTime;
  final String content;

  const ScheduleCard({
    required this.startTime,
    required this.endTime,
    required this.content,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: PRIMARY_COLOR,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: IntrinsicHeight(
          // IntrinsicHeight은 자식 위젯의 높이를 최대 높이로 맞춰주는 위젯입니다.
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Time(
                startTime: startTime,
                endTime: endTime,
              ),
              const SizedBox(width: 16.0),
              _Content(
                content: content,
              ),
              const SizedBox(width: 16.0),
            ],
          ),
        ),
      ),
    );
  }
}

class _Time extends StatelessWidget {
  final int startTime;
  final int endTime;

  const _Time({required this.startTime, required this.endTime, super.key});

  @override
  Widget build(BuildContext context) {
    const textStyles = TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 16.0,
      color: PRIMARY_COLOR,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${startTime.toString().padLeft(2, '0')}:00',
          style: textStyles,
        ),
        Text(
          '${endTime.toString().padLeft(2, '0')}:00',
          style: textStyles.copyWith(
            fontSize: 10.0,
          ),
        ),
      ],
    );
  }
}

class _Content extends StatelessWidget {
  final String content;

  const _Content({required this.content, super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        content,
      ),
    );
  }
}
