class attendance_history {
  bool? success;
  String? message;
  List<Data>? data;

  attendance_history({this.success, this.message, this.data});

  attendance_history.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];

    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['success'] = success;
    map['message'] = message;
    if (data != null) {
      map['data'] = data!.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Data {
  int? id;
  String? date;
  String? punchInTime;
  String? punchOutTime;
  String? status;
  String? workedHours;
  String? notes;
  String? punchInSource;
  String? punchOutSource;
  String? attendanceType;
  String? workingStatus;

  Data({
    this.id,
    this.date,
    this.punchInTime,
    this.punchOutTime,
    this.status,
    this.workedHours,
    this.notes,
    this.punchInSource,
    this.punchOutSource,
    this.attendanceType,
    this.workingStatus,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];

    punchInTime = json['punch_in_time']?.toString();
    punchOutTime = json['punch_out_time']?.toString();

    status = json['status'];
    workedHours = json['worked_hours']?.toString();
    notes = json['notes']?.toString();
    punchInSource = json['punch_in_source']?.toString();
    punchOutSource = json['punch_out_source']?.toString();
    attendanceType = json['attendance_type']?.toString();
    workingStatus = json['working_status']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['id'] = id;
    map['date'] = date;
    map['punch_in_time'] = punchInTime;
    map['punch_out_time'] = punchOutTime;
    map['status'] = status;
    map['worked_hours'] = workedHours;
    map['notes'] = notes;
    map['punch_in_source'] = punchInSource;
    map['punch_out_source'] = punchOutSource;
    map['attendance_type'] = attendanceType;
    map['working_status'] = workingStatus;
    return map;
  }
}
