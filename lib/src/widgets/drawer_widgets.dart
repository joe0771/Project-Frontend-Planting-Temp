import 'package:flutter/material.dart';

 drawerWidgets(
  Function onPressRealtime,
  Function onPressChart,
  Function onPressAverage,
  Function onPressSetting,
) {
  return Drawer(
    backgroundColor: Colors.grey.shade200,
    child: Column(
      children: [
        SizedBox(
          height: 500,
          child: DrawerHeader(
            child: ListTile(
              trailing: IconButton(
                icon: const Icon(
                  Icons.close_rounded,
                  size: 50,
                  color: Colors.white,
                ),
                onPressed: () => onPressRealtime(),
              ),
            ),
            decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage("assets/images/bg_jinpao.png"), fit: BoxFit.cover),
            ),
          ),
        ),
        ListTile(
          contentPadding: const EdgeInsets.all(20),
          leading: const Icon(
            Icons.thermostat_rounded,
            color: Colors.black87,
            size: 50,
          ),
          title: const Padding(
            padding: EdgeInsets.only(left: 60),
            child: Text(
              'Realtime Temperature Data',
              style: TextStyle(
                fontSize: 30,
                color: Colors.black87,
              ),
            ),
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 40,
          ),
          onTap: () => onPressRealtime(),
        ),
        const Divider(),
        ListTile(
          contentPadding: const EdgeInsets.all(20),
          leading: const Icon(
            Icons.stacked_line_chart_rounded,
            color: Colors.black87,
            size: 50,
          ),
          title: const Padding(
            padding: EdgeInsets.only(left: 60),
            child: Text(
              'Chart Temperature',
              style: TextStyle(
                fontSize: 30,
                color: Colors.black87,
              ),
            ),
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 40,
          ),
          onTap: () => onPressChart(),
        ),
        const Divider(),
        ListTile(
          contentPadding: const EdgeInsets.all(20),
          leading: const Icon(
            Icons.percent_rounded,
            color: Colors.black87,
            size: 50,
          ),
          title: const Padding(
            padding: EdgeInsets.only(left: 60),
            child: Text(
              'Average Temperature',
              style: TextStyle(
                fontSize: 30,
                color: Colors.black87,
              ),
            ),
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 40,
          ),
          onTap: () => onPressAverage(),
        ),
        const Divider(),
        const Spacer(),
        const Divider(),
        ListTile(
          contentPadding: const EdgeInsets.all(20),
          leading: const Icon(
            Icons.settings,
            color: Colors.black87,
            size: 50,
          ),
          title: const Padding(
            padding: EdgeInsets.only(left: 60),
            child: Text(
              'Setting',
              style: TextStyle(
                fontSize: 30,
                color: Colors.black87,
              ),
            ),
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 40,
          ),
          onTap: () => onPressSetting(),
        ),
      ],
    ),
  );
}
