import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TodayText extends StatelessWidget {
  const TodayText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var tarih = DateFormat.yMMMEd('tr_TR').format(DateTime.now());
    return Container(
      constraints: const BoxConstraints(maxWidth: 200),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Bugün",
            style: Theme.of(context).textTheme.caption,
          ),
          Text(
            tarih
          )
        ],
      ),
    );
  }
}
