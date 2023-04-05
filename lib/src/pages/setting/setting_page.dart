import 'dart:io';

import 'package:flutter/material.dart';
import 'package:temperature/src/services/network_service.dart';
import 'package:temperature/src/pages/realtime/realtime_page.dart';
import 'package:temperature/src/models/response_request_line_model.dart';
import 'package:temperature/src/pages/setting/widget/data_line_widget.dart';
import 'package:temperature/src/widgets/button/button_logout_screen.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late Future future;

  Future<void> refreshFuture() async {
    setState(() {
      future = NetworkService.requestLine();
    });
  }

  @override
  void initState() {
    super.initState();
    future = NetworkService.requestLine();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black87,
      appBar: _buildAppbar(),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 20,
          bottom: 20,
          left: 20,
          right: 20,
        ),
        child: FutureBuilder(
          future: future,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              List<ResponseRequestLineModel>? result = snapshot.data;
              if (result == null || result.isEmpty) {
                return const Center(
                  child: Text(
                    'Not have data !',
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                );
              }
              return RefreshIndicator(
                onRefresh: refreshFuture,
                child: _buildDataSetting(result),
              );
            }
            if (snapshot.hasError) {
              return const Center(
                child: Text(
                  ' Error data !',
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: ButtonLogoutScreen(
        heroTag: 'tag1',
        onPressed: () {
          exit(0);
        },
      ),
    );
  }

  _buildDataSetting(List<ResponseRequestLineModel> result) {
    final tempList = result;
    return SingleChildScrollView(
      child: Column(
        children: [
          for (var item in tempList)
            DataLineWidget(
              line: item.lineId,
              statusP: item.drying.status.toString(),
              tempP: item.drying.pv.toDouble(),
              minP: item.drying.min.toInt(),
              maxP: item.drying.max.toInt(),
              statusC: item.curing.toString(),
              tempC: item.curing.pv.toDouble(),
              minC: item.curing.min.toInt(),
              maxC: item.curing.max.toInt(),
              state: () {
                setState(() {
                  refreshFuture();
                });
              },
            ),
        ],
      ),
    );
  }

  _buildAppbar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(100.0),
      child: AppBar(
        leadingWidth: 100,
        leading: IconButton(
          padding: EdgeInsets.zero,
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 60,
          ),
          onPressed: () {
            Navigator.pushReplacement<void, void>(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => const RealtimePage(),
              ),
            );
          },
        ),
        toolbarHeight: 100,
        title: Text(
          "Setting",
          style: TextStyle(
            fontSize: 35,
            color: Colors.amber.shade700,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          Center(
            child: Row(
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.refresh_outlined,
                    color: Colors.white,
                    size: 60,
                  ),
                  onPressed: () {
                    refreshFuture();
                  },
                ),
                // const SizedBox(width: 100),
                // IconButton(
                //   padding: EdgeInsets.zero,
                //   icon: const Icon(
                //     Icons.logout,
                //     color: Colors.red,
                //     size: 60,
                //   ),
                //   onPressed: () {
                //     //todo
                //
                //   },
                // ),
                const SizedBox(width: 40),
              ],
            ),
          ),
        ],
        backgroundColor: Colors.grey.shade800,
      ),
    );
  }
}
