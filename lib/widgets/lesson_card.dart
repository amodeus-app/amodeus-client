import 'dart:async';

import 'package:amodeus_api/amodeus_api.dart' show TimetableElement;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../utils/lessons.dart';
import '../utils/theme.dart';

class LessonCard extends StatefulWidget {
  final Rect bounds;
  final TimetableElement element;

  const LessonCard({
    Key? key,
    required this.element,
    required this.bounds,
  }) : super(key: key);

  @override
  State<LessonCard> createState() => _LessonCardState();
}

class _LessonCardState extends State<LessonCard> {
  var _isHeld = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final end = widget.element.end.toLocal();
    _isHeld = now.isAfter(end);
    if (!_isHeld) {
      Timer(
        end.difference(now),
        () => setState(() {
          _isHeld = true;
        }),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cardText = (widget.bounds.width < 100)
        ? widget.element.lesson.subject.nameShort
        : widget.element.lesson.subject.name;

    return Column(
      children: [
        Consumer<ThemeNotifier>(
          builder: (context, theme, _) => Container(
            padding: const EdgeInsets.all(3),
            height: widget.bounds.height,
            alignment: Alignment.topLeft,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(5),
              color: getLessonColor(
                widget.element.lesson,
                dark: theme.isEffectivelyDark,
                isHeld: _isHeld,
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
                    widget.element.location?.full ?? "Не определено",
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

class MonthLessonCard extends StatefulWidget {
  final Rect bounds;
  final TimetableElement element;

  const MonthLessonCard({
    Key? key,
    required this.element,
    required this.bounds,
  }) : super(key: key);

  @override
  State<MonthLessonCard> createState() => _MonthLessonCardState();
}

class _MonthLessonCardState extends State<MonthLessonCard> {
  var _isHeld = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final end = widget.element.end.toLocal();
    _isHeld = now.isAfter(end);
    if (!_isHeld) {
      Timer(
        end.difference(now),
        () => setState(() {
          _isHeld = true;
        }),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cardText = (widget.bounds.width < 100)
        ? widget.element.lesson.subject.nameShort
        : widget.element.lesson.subject.name;
    final isDetailedMonthCard = widget.bounds.height >= 30;

    return Consumer<ThemeNotifier>(
      builder: (context, theme, _) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        height: widget.bounds.height,
        alignment: Alignment.topLeft,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(5),
          color: getLessonColor(
            widget.element.lesson,
            dark: theme.isEffectivelyDark,
            isHeld: _isHeld,
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
                      "${DateFormat('HH:mm').format(widget.element.start.toLocal())}–"
                      "${DateFormat('HH:mm').format(widget.element.end.toLocal())}",
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
