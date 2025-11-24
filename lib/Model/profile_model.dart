class Profile {
  bool? success;
  String? message;
  ProfileData? data;

  Profile({this.success, this.message, this.data});

  Profile.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? ProfileData.fromJson(json['data']) : null;
  }
}

class ProfileData {
  int? id;
  String? employeeId;
  String? firstName;
  String? middleName;
  String? lastName;
  String? fullName;
  String? gender;
  String? address;
  String? maritalStatus;
  String? dob;
  String? phone;
  String? email;
  String? department;
  String? type;
  String? position;
  String? startDate;
  String? onroleDate;
  String? probationStartDate;
  String? probationEndDate;
  String? probationStatus;
  String? photo;
  String? aadhaarNumber;
  String? wfhPin;
  String? loginEmail;
  String? lastLoginAt;
  int? loginAttempts;

  ProfileData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    employeeId = json['employee_id']?.toString();
    firstName = json['first_name'];
    middleName = json['middle_name'];
    lastName = json['last_name'];
    fullName = json['full_name'];
    gender = json['gender'];
    address = json['address'];
    maritalStatus = json['marital_status'];
    dob = json['dob']?.toString();
    phone = json['phone'];
    email = json['email'];
    department = json['department'];
    type = json['type'];
    position = json['position'];
    startDate = json['start_date']?.toString();
    onroleDate = json['onrole_date']?.toString();
    probationStartDate = json['probation_start_date']?.toString();
    probationEndDate = json['probation_end_date']?.toString();
    probationStatus = json['probation_status'];
    photo = json['photo']?.toString();
    aadhaarNumber = json['aadhaar_number']?.toString();
    wfhPin = json['wfh_pin']?.toString();
    loginEmail = json['login_email'];
    lastLoginAt = json['last_login_at']?.toString();
    loginAttempts = json['login_attempts'];
  }
}
