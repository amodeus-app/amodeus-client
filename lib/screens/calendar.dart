import 'dart:async';

import 'package:amodeus_api/amodeus_api.dart' show TimetableElement;
import 'package:built_collection/built_collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import './lesson_details.dart';
import './search.dart';
import '../utils/api.dart';
import '../utils/lessons.dart';
import '../utils/storage.dart' as storage;
import '../widgets/lesson_card.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final _controller = CalendarController();
  var _lessons = BuiltList<TimetableElement>();
  final _refresh = GlobalKey<RefreshIndicatorState>();
  Future<void>? _currentProgress;
  DateTimeRange? _cachedRange;

  void _onElementClick(BuildContext context, TimetableElement el) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LessonDetails(key: ObjectKey(el), timetableElement: el),
      ),
    );
  }

  Widget _appointmentBuilder(BuildContext context, CalendarAppointmentDetails details) {
    final TimetableElement el = details.appointments.first;
    final now = DateTime.now();
    if (now.isBefore(el.end.toLocal())) {
      Timer(now.difference(el.end.toLocal()), () => setState(() {}));
    }
    if (details.isMoreAppointmentRegion) {
      return Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(.5),
          borderRadius: BorderRadius.circular(5),
        ),
        width: details.bounds.width,
        height: details.bounds.height,
        child: const Text(
          "...",
          style: TextStyle(fontSize: 10),
        ),
      );
    }
    if (_controller.view != CalendarView.month) {
      return LessonCard(element: el, bounds: details.bounds);
    }
    return MonthLessonCard(element: el, bounds: details.bounds);
  }

  @override
  void initState() {
    super.initState();
    storage.weekView.getNotNull().then((value) {
      if (value) {
        _controller.view = CalendarView.workWeek;
        _controller.displayDate = DateTime.now();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Расписание"),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: "Поиск по ФИО",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchScreen(
                    onSearchFinished: () => _refresh.currentState!.show(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: WillPopScope(
        child: RefreshIndicator(
          key: _refresh,
          child: SfCalendar(
            view: CalendarView.day,
            controller: _controller,
            firstDayOfWeek: DateTime.monday,
            monthViewSettings: const MonthViewSettings(
              showAgenda: true,
              numberOfWeeksInView: 4,
              appointmentDisplayCount: 4,
              dayFormat: "E",
              appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
            ),
            timeSlotViewSettings: const TimeSlotViewSettings(
              startHour: 8,
              endHour: 22,
              nonWorkingDays: <int>[DateTime.sunday],
              minimumAppointmentDuration: lessonDuration,
              timeInterval: Duration(minutes: 30),
              timeFormat: "HH:mm",
              timeIntervalHeight: 30,
              dayFormat: "E",
            ),
            allowedViews: const <CalendarView>[
              CalendarView.day,
              CalendarView.workWeek,
              CalendarView.week,
              CalendarView.month,
            ],
            showNavigationArrow: true,
            showDatePickerButton: true,
            allowViewNavigation: true,
            appointmentBuilder: _appointmentBuilder,
            timeZone: "Asia/Yekaterinburg",
            onViewChanged: (details) {
              _currentProgress = _getTimetable(
                details.visibleDates.first,
                details.visibleDates.last.add(const Duration(days: 1)),
                force: false,
              ).then((_) {
                _currentProgress = null;
              });
            },
            specialRegions: defaultNonWorkingDays + defaultTimetableBreaks,
            dataSource: LessonDataSource(_lessons),
            onTap: (details) {
              if (details.targetElement == CalendarElement.appointment) {
                _onElementClick(context, details.appointments?.first);
                return;
              }
            },
          ),
          onRefresh: () {
            // returns Future<void>, it's not async itself
            final current = _currentProgress;
            if (current != null) {
              return current;
            }
            final displayed = _getCurrentDisplayedDates();
            return _getTimetable(
              displayed.start,
              displayed.end.add(const Duration(days: 1)),
              force: true,
            );
          },
        ),
        onWillPop: () async {
          final defaultMode =
              await storage.weekView.getNotNull() ? CalendarView.workWeek : CalendarView.day;
          if (_controller.view != defaultMode) {
            _controller.view = defaultMode;
            _controller.displayDate = DateTime.now();
            _controller.selectedDate = null;
            return false;
          }
          return true;
        },
      ),
    );
  }

  DateTimeRange _getCurrentDisplayedDates() {
    final ddOrig = _controller.displayDate!;
    final dd = ddOrig.subtract(
      Duration(
        hours: ddOrig.hour,
        minutes: ddOrig.minute,
        seconds: ddOrig.second,
        milliseconds: ddOrig.millisecond,
        microseconds: ddOrig.microsecond,
      ),
    ); // Reset time part to 00:00:00.000000
    switch (_controller.view) {
      case CalendarView.day:
        return DateTimeRange(start: dd, end: dd);
      case CalendarView.week:
      case CalendarView.workWeek:
        return DateTimeRange(
          start: dd.subtract(Duration(days: dd.weekday - 1)),
          end: dd.add(Duration(days: (7 - dd.weekday))),
        );
      case CalendarView.month:
        return DateTimeRange(
          start: dd.subtract(Duration(days: dd.day + 1)),
          end: dd.add(Duration(days: (30 - dd.day))),
        );
      default:
        throw UnsupportedError("${_controller.view} is not handled");
    }
  }

  Future<void> _getTimetable(DateTime start, DateTime end, {bool force = false}) async {
    final uuid = await storage.personUUID.get();
    if (uuid == null) {
      return;
    }
    if (_cachedRange != null) {
      if (start.isAfter(_cachedRange!.start)) {
        start = _cachedRange!.start;
      }
      if (end.isBefore(_cachedRange!.end)) {
        end = _cachedRange!.end;
      }
      if (!force && start == _cachedRange!.start && end == _cachedRange!.end) {
        return;
      }
    }
    _refresh.currentState!.show();
    _cachedRange = DateTimeRange(start: start, end: end);

    debugPrint("start: $start");
    debugPrint("end: $end");

    final resp = await _callApi(uuid, start, end);
    if (resp == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Невозможно получить данные")));
      return;
    }
    setState(() {
      _lessons = resp;
    });
  }

  Future<BuiltList<TimetableElement>?> _callApi(String uuid, DateTime? start, DateTime? end) async {
    final api = (await getApi()).getTimetableApi();
    try {
      final resp = await api.getPersonTimetable(uuid: uuid, from: start?.toUtc(), to: end?.toUtc());
      return resp.data!;
    } on DioError catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
