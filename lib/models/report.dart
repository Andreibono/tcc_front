import 'dart:convert';

import 'activity.dart';

class ReportInfo {
  var id;
  String error = "";
  Activity? activity;
  Report? report;
  var name;

  ReportInfo({this.id, this.activity, this.report, this.name});

  factory ReportInfo.fromJson(Map jsonResponse) {
    return jsonResponse['report'] is String
        ? ReportInfo(
            id: jsonResponse['id'].toString(),
            name: jsonResponse['activity']['user']['name'],
            report: Report.fromJson(json.decode(jsonResponse['report'])),
          )
        : ReportInfo(
            id: jsonResponse['id'].toString(),
            report: Report.fromJson(jsonResponse['report']),
            activity: Activity.fromJson(jsonResponse['activity']));
  }
}

class Report {
  var iDid;
  var willDo;
  var difficulty;

  Report({required this.iDid, required this.willDo, required this.difficulty});

  factory Report.fromJson(Map jsonResponse) {
    return Report(
      iDid: jsonResponse['iDid'],
      willDo: jsonResponse['willDo'],
      difficulty: jsonResponse['difficulty'],
    );
  }
}
