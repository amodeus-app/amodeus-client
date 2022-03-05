import 'package:amodeus_api/amodeus_api.dart' show TimetableElement;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../utils/lessons.dart';
import '../utils/theme.dart';

class LessonCard extends StatelessWidget {
  final Rect bounds;
  final TimetableElement element;

  const LessonCard({
    Key? key,
    required this.element,
    required this.bounds,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cardText =
        (bounds.width < 100) ? element.lesson.subject.nameShort : element.lesson.subject.name;
    final now = DateTime.now();
    final isHeld = now.isAfter(element.end.toLocal());

    return Column(
      children: [
        Consumer<ThemeNotifier>(
          builder: (context, theme, _) => Container(
            padding: const EdgeInsets.all(3),
            height: bounds.height,
            alignment: Alignment.topLeft,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(5),
              color: getLessonColor(
                element.lesson,
                dark: theme.isEffectivelyDark,
                isHeld: isHeld,
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cardText,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    ),
                    maxLines: 3,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    element.location?.full ?? "Не определено",
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.normal,
                    ),
                    maxLines: 3,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class MonthLessonCard extends StatelessWidget {
  final Rect bounds;
  final TimetableElement element;

  const MonthLessonCard({
    Key? key,
    required this.element,
    required this.bounds,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cardText =
        (bounds.width < 100) ? element.lesson.subject.nameShort : element.lesson.subject.name;
    final isDetailedMonthCard = bounds.height >= 30;

    return Consumer<ThemeNotifier>(
      builder: (context, theme, _) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        height: bounds.height,
        alignment: Alignment.topLeft,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(5),
          color: getLessonColor(
            element.lesson,
            dark: theme.isEffectivelyDark,
            isHeld: DateTime.now().isAfter(element.end.toLocal()),
          ),
        ),
        child: isDetailedMonthCard
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cardText,
                    style: TextStyle(fontSize: !isDetailedMonthCard ? 10 : null),
                    overflow: TextOverflow.fade,
                    maxLines: 2,
                  ),
                  if (isDetailedMonthCard)
                    Text(
                      "${DateFormat('HH:mm').format(element.start.toLocal())}–"
                      "${DateFormat('HH:mm').format(element.end.toLocal())}",
                      style: const TextStyle(fontSize: 12),
                    )
                ],
              )
            : Text(
                cardText,
                style: const TextStyle(fontSize: 10),
                overflow: TextOverflow.clip,
                maxLines: 1,
              ),
      ),
    );
  }
}
