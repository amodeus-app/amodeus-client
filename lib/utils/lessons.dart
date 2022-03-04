import 'package:amodeus_api/amodeus_api.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

const lessonDuration = Duration(hours: 1, minutes: 30);

final _breakColor = Colors.grey.withOpacity(0.2);
final _holidayColor = Colors.grey.withOpacity(0.3);
const _heldLessonOpacity = 0.2;

String getFriendlyLessonType(Lesson lesson) {
  String type;
  switch (lesson.type) {
    case "SEMI":
      type = "Практическое занятие";
      break;
    case "LECT":
      type = "Лекционное занятие";
      break;
    case "LAB":
      type = "Лабораторное занятие";
      break;
    case "CONS":
      type = "Консультация";
      break;
    default:
      switch (lesson.format) {
        case "PRETEST":
          type = "Зачёт";
          break;
        case "EXAMINATION":
          type = "Экзамен";
          break;
        default:
          assert(lesson.type != "MID_CHECK");
          type = "Неизвестный (${lesson.type}, ${lesson.format})";
          break;
      }
  }
  return type;
}

String? getFriendlyBuildingName(int buildingNumber) {
  String? name;
  switch (buildingNumber) {
    case 1:
      name = "Институт филологии и журналистики (ИФиЖ, снесён)";
      break;
    case 3:
      name = "Институт наук о Земле (ИнЗем)";
      break;
    case 4:
      name = "Финансово-экономический институт (ФЭИ)";
      break;
    case 5:
      name = "Институт математики и компьютерных наук (ИМиКН)";
      break;
    case 6:
      name = "Институт биологии (ИнБио)";
      break;
    case 7:
      name = "Институт физической культуры (ИФК) / СК Олимпия";
      break;
    case 9:
      name = "Спортивно-оздоровительный комплекс (СОК)";
      break;
    case 10:
      name = "Институт государства и права (ИГиП)";
      break;
    case 11:
      name = "Институт социально-гуманитарных наук (СоцГум)";
      break;
    case 12:
      name = "Библиотечно-музейный комплекс (БМК)";
      break;
    case 13:
      name = "Центр зимних видов спорта (ЦЗВС)";
      break;
    case 16:
      name = "Институт психологии и педагогики (ИПиП)";
      break;
    case 17:
      name = "ФабЛаб / X-BIO";
      break;
    case 19:
      name = "Школа перспективных исследований (SAS)";
      break;
  }
  return name;
}

Color getLessonColor(Lesson lesson, {bool dark = false, bool isHeld = false}) {
  Color color;
  switch (lesson.type) {
    case "SEMI":
      color = Colors.lightBlue;
      break;
    case "LECT":
      color = Colors.lightGreen;
      break;
    case "LAB":
      color = Colors.orangeAccent;
      break;
    case "CONS":
      color = Colors.deepPurpleAccent;
      break;
    default:
      switch (lesson.format) {
        case "PRETEST":
          color = Colors.pinkAccent;
          break;
        case "EXAMINATION":
          color = Colors.greenAccent;
          break;
        default:
          assert(lesson.type != "MID_CHECK");
          color = Colors.grey;
          break;
      }
  }

  if (dark) {
    final hsl = HSLColor.fromColor(color);
    color = hsl.withLightness((hsl.lightness - .2).clamp(0.0, 1.0)).toColor();
  }
  if (isHeld) {
    // final hsl = HSLColor.fromColor(color);
    // color = hsl.withSaturation((hsl.saturation - .2).clamp(0.0, 1.0)).toColor();
    color = color.withOpacity(_heldLessonOpacity);
  }
  return color;
}

class LessonDataSource extends CalendarDataSource {
  LessonDataSource(BuiltList<TimetableElement> lessons) {
    appointments = List.from(lessons);
  }

  TimetableElement _appointmentAt(int index) => appointments![index];

  @override
  DateTime getStartTime(int index) {
    return _appointmentAt(index).start.toLocal();
  }

  @override
  DateTime getEndTime(int index) {
    return _appointmentAt(index).end.toLocal();
  }

  @override
  bool isAllDay(int index) => false; // Lessons cannot last all day
}

final defaultNonWorkingDays = <TimeRegion>[
  TimeRegion(
    startTime: DateTime(1970, 1, 1),
    endTime: DateTime(1970, 1, 2),
    recurrenceRule: "FREQ=WEEKLY;INTERVAL=1;BYDAY=SUN",
    color: _holidayColor,
  ),
];

final defaultTimetableBreaks = <List<int>>[
  [8, 0, 8, 30],
  [10, 0, 10, 15],
  [11, 45, 12, 0],
  [13, 30, 14, 0],
  [15, 30, 15, 45],
  [17, 15, 17, 30],
  [19, 0, 19, 10],
  [20, 40, 20, 50],
]
    .map((e) => TimeRegion(
          startTime: DateTime(2020, 9, 1, e[0], e[1]),
          endTime: DateTime(2020, 9, 1, e[2], e[3]),
          recurrenceRule: "FREQ=DAILY;INTERVAL=1",
          color: _breakColor,
        ))
    .toList(growable: false);
