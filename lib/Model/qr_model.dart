class QR {
  bool? success;
  String? message;
  Data? data;

  QR({this.success, this.message, this.data});

  QR.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  Attendance? attendance;
  Employee? employee;
  EmployeeLogin? employeeLogin;

  Data({this.attendance, this.employee, this.employeeLogin});

  Data.fromJson(Map<String, dynamic> json) {
    attendance = json['attendance'] != null
        ? new Attendance.fromJson(json['attendance'])
        : null;
    employee = json['employee'] != null
        ? new Employee.fromJson(json['employee'])
        : null;
    employeeLogin = json['employee_login'] != null
        ? new EmployeeLogin.fromJson(json['employee_login'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.attendance != null) {
      data['attendance'] = this.attendance!.toJson();
    }
    if (this.employee != null) {
      data['employee'] = this.employee!.toJson();
    }
    if (this.employeeLogin != null) {
      data['employee_login'] = this.employeeLogin!.toJson();
    }
    return data;
  }
}

class Attendance {
  String? action;
  String? timestamp;
  Null? workedHours;
  String? formattedWorkedHours;
  String? status;
  Null? workingStatus;
  String? attendanceType;

  Attendance({
    this.action,
    this.timestamp,
    this.workedHours,
    this.formattedWorkedHours,
    this.status,
    this.workingStatus,
    this.attendanceType,
  });

  Attendance.fromJson(Map<String, dynamic> json) {
    action = json['action'];
    timestamp = json['timestamp'];
    workedHours = json['worked_hours'];
    formattedWorkedHours = json['formatted_worked_hours'];
    status = json['status'];
    workingStatus = json['working_status'];
    attendanceType = json['attendance_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['action'] = this.action;
    data['timestamp'] = this.timestamp;
    data['worked_hours'] = this.workedHours;
    data['formatted_worked_hours'] = this.formattedWorkedHours;
    data['status'] = this.status;
    data['working_status'] = this.workingStatus;
    data['attendance_type'] = this.attendanceType;
    return data;
  }
}

class Employee {
  int? id;
  String? employeeId;
  String? name;
  String? email;
  String? department;
  String? position;

  Employee({
    this.id,
    this.employeeId,
    this.name,
    this.email,
    this.department,
    this.position,
  });

  Employee.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    employeeId = json['employee_id'];
    name = json['name'];
    email = json['email'];
    department = json['department'];
    position = json['position'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['employee_id'] = this.employeeId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['department'] = this.department;
    data['position'] = this.position;
    return data;
  }
}

class EmployeeLogin {
  int? id;
  int? employeeId;
  String? email;
  bool? isActive;
  String? lastLoginAt;
  int? loginAttempts;
  String? createdAt;
  String? updatedAt;
  String? currentQrIdentifier;
  String? currentQrSecret;
  String? currentQrData;
  String? qrExpiresAt;

  EmployeeLogin({
    this.id,
    this.employeeId,
    this.email,
    this.isActive,
    this.lastLoginAt,
    this.loginAttempts,
    this.createdAt,
    this.updatedAt,
    this.currentQrIdentifier,
    this.currentQrSecret,
    this.currentQrData,
    this.qrExpiresAt,
  });

  EmployeeLogin.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    employeeId = json['employee_id'];
    email = json['email'];
    isActive = json['is_active'];
    lastLoginAt = json['last_login_at'];
    loginAttempts = json['login_attempts'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    currentQrIdentifier = json['current_qr_identifier'];
    currentQrSecret = json['current_qr_secret'];
    currentQrData = json['current_qr_data'];
    qrExpiresAt = json['qr_expires_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['employee_id'] = this.employeeId;
    data['email'] = this.email;
    data['is_active'] = this.isActive;
    data['last_login_at'] = this.lastLoginAt;
    data['login_attempts'] = this.loginAttempts;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['current_qr_identifier'] = this.currentQrIdentifier;
    data['current_qr_secret'] = this.currentQrSecret;
    data['current_qr_data'] = this.currentQrData;
    data['qr_expires_at'] = this.qrExpiresAt;
    return data;
  }
}
