class Login {
  bool? success;
  String? message;
  Data? data;

  Login({this.success, this.message, this.data});

  Login.fromJson(Map<String, dynamic> json) {
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
  String? token;
  Employee? employee;
  LoginInfo? loginInfo;

  Data({this.token, this.employee, this.loginInfo});

  Data.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    employee = json['employee'] != null
        ? new Employee.fromJson(json['employee'])
        : null;
    loginInfo = json['login_info'] != null
        ? new LoginInfo.fromJson(json['login_info'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    if (this.employee != null) {
      data['employee'] = this.employee!.toJson();
    }
    if (this.loginInfo != null) {
      data['login_info'] = this.loginInfo!.toJson();
    }
    return data;
  }
}

class Employee {
  int? id;
  String? employeeId;
  String? name;
  String? email;
  String? department;
  String? type;
  String? position;

  Employee(
      {this.id,
      this.employeeId,
      this.name,
      this.email,
      this.department,
      this.type,
      this.position});

  Employee.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    employeeId = json['employee_id'];
    name = json['name'];
    email = json['email'];
    department = json['department'];
    type = json['type'];
    position = json['position'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['employee_id'] = this.employeeId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['department'] = this.department;
    data['type'] = this.type;
    data['position'] = this.position;
    return data;
  }
}

class LoginInfo {
  String? email;
  String? lastLoginAt;
  int? loginAttempts;

  LoginInfo({this.email, this.lastLoginAt, this.loginAttempts});

  LoginInfo.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    lastLoginAt = json['last_login_at'];
    loginAttempts = json['login_attempts'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['last_login_at'] = this.lastLoginAt;
    data['login_attempts'] = this.loginAttempts;
    return data;
  }
}
