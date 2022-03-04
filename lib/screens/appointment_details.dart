import 'package:amodeus_api/amodeus_api.dart' show Person, TimetableElement;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/api.dart';
import '../utils/lessons.dart';
import '../widgets/details_tiles.dart';

class AppointmentDetails extends StatefulWidget {
  final TimetableElement appointment;

  const AppointmentDetails({
    Key? key,
    required this.appointment,
  }) : super(key: key);

  @override
  State<AppointmentDetails> createState() => _AppointmentDetailsState();
}

class _AppointmentDetailsState extends State<AppointmentDetails> {
  Iterable<String>? _team;

  Iterable<String> _getSortedPeopleNames(Iterable<Person> people) =>
      (List.of(people)..sort((a, b) => a.fullName.compareTo(b.fullName))).map((p) => p.fullName);

  Future<Iterable<String>> _fetchTeam() async {
    final api = (await getApi()).getTimetableApi();
    final res = await api.getEventTeam(eventId: widget.appointment.id);
    // Remove teachers from team list
    return _getSortedPeopleNames(
        res.data!.where((p) => widget.appointment.teachers.indexWhere((t) => t.id == p.id) == -1));
  }

  @override
  void initState() {
    super.initState();
    _fetchTeam().then((value) => setState(() {
          _team = value;
        }));
  }

  @override
  Widget build(BuildContext context) {
    final teachers = _getSortedPeopleNames(widget.appointment.teachers).toList();
    final teachersMore = ", ещё ${teachers.length - 1}…";
    final teachersSubtitle = "${teachers[0]} ${teachers.length > 1 ? teachersMore : ""}";
    final teachersFull = teachers.join(",\n");

    var teamSubtitle = "Загрузка…";
    var teamFull = "Пожалуйста, подождите…";
    if (_team != null) {
      final team = _team!.toList();
      final teamMore = ", ещё ${team.length - 1}…";
      teamSubtitle = "${team[0]} ${team.length > 1 ? teamMore : ""}";
      teamFull = team.asMap().entries.map((e) => "${e.key + 1}. ${e.value}").join("\n");
    }

    var location = "Место не определено";
    var locationFull = location;
    final locationObj = widget.appointment.location;
    if (locationObj != null) {
      var buildingExtra = "";
      final building = locationObj.building;
      if (building != null) {
        final friendlyName = getFriendlyBuildingName(building.number);
        buildingExtra = "\n\n${building.address}\n${friendlyName ?? ""}";
      }
      location = locationObj.full;
      locationFull = "$location$buildingExtra";
    }

    final address = locationObj?.building?.address;
    final encodedAddress = address != null ? Uri.encodeComponent(address) : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.appointment.lesson.subject.name,
          softWrap: false,
          maxLines: 1,
          overflow: TextOverflow.fade,
        ),
      ),
      body: ListView(
        children: <DetailTile>[
          DetailIconTile(
            icon: Icons.topic,
            title: "Тема занятия",
            subtitle: widget.appointment.lesson.name,
          ),
          DetailIconTile(
            icon: Icons.place,
            title: "Место проведения",
            subtitle: location,
            content: locationFull,
            actions: encodedAddress != null
                ? [
                    TextButton(
                      onPressed: () async =>
                          await launch("https://2gis.ru/tyumen/search/$encodedAddress/"),
                      child: const Text("НА КАРТЕ"),
                    ),
                  ]
                : null,
          ),
          DetailIconTile(
            icon: Icons.access_time,
            title: "Время",
            subtitle: '${DateFormat('HH:mm').format(widget.appointment.start.toLocal())}–'
                '${DateFormat('HH:mm').format(widget.appointment.end.toLocal())}',
          ),
          DetailColorTile(
            color: getLessonColor(widget.appointment.lesson),
            title: "Формат занятия",
            subtitle: getFriendlyLessonType(widget.appointment.lesson),
          ),
          DetailIconTile(
            icon: Icons.person,
            title: "Преподаватели",
            subtitle: teachersSubtitle,
            content: teachersFull,
          ),
          DetailIconTile(
            icon: Icons.people,
            title: "Команда",
            subtitle: teamSubtitle,
            content: teamFull,
          ),
        ],
      ),
    );
  }
}
