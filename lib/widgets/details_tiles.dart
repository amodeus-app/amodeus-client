import 'package:flutter/material.dart';

class DetailTile extends StatelessWidget {
  final Widget? leading;
  final String title;
  final String subtitle;
  final String? content;
  final List<Widget>? actions;

  const DetailTile({
    Key? key,
    this.leading,
    required this.title,
    required this.subtitle,
    this.content = "",
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading ?? const SizedBox(),
      title: Text(title),
      subtitle: Text(subtitle, softWrap: false, maxLines: 1, overflow: TextOverflow.fade),
      onTap: content != null
          ? () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(title),
                  content: Text(content != "" ? content! : subtitle),
                  scrollable: true,
                  actions: actions,
                ),
              );
            }
          : null,
    );
  }
}

class DetailIconTile extends DetailTile {
  DetailIconTile({
    Key? key,
    required IconData icon,
    required String title,
    required String subtitle,
    String? content = "",
    List<Widget>? actions,
  }) : super(
          key: key,
          leading: Icon(icon),
          title: title,
          subtitle: subtitle,
          content: content,
          actions: actions,
        );
}

class DetailColorTile extends DetailTile {
  DetailColorTile({
    Key? key,
    required Color color,
    IconData icon = Icons.circle,
    required String title,
    required String subtitle,
    String? content = "",
    List<Widget>? actions,
  }) : super(
          key: key,
          leading: Icon(icon, color: color),
          title: title,
          subtitle: subtitle,
          content: content,
          actions: actions,
        );
}
