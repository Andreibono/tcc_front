class Activity {
  var id;
  var activity;
  var description;
  bool status;
  var start;
  var end;
  var created_at;
  var updated_at;

  Activity(
      {this.id,
      this.activity,
      this.description,
      required this.status,
      this.start,
      this.end,
      this.created_at,
      this.updated_at});

      factory Activity.fromJson(Map json){
        return Activity(
          id: json['id'].toString(),
          activity: json['activity'].toString(),
          description: json['description'].toString(),
          status: json['status'],
          start: json['start'].toString(),
          end: json['end'].toString(),
          created_at: json['created_at'].toString(),
          updated_at: json['updated_at'].toString(),
        );
      }
}
