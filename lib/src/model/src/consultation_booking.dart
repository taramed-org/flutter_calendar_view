/// {@template consultation_booking}
/// A class that represents a consultation booking.
/// {@endtemplate}
class ConsultationBooking {
  /// Creates a new [ConsultationBooking] instance.
  ConsultationBooking({
    required this.doctorName,
    required this.consultationDuration,
    this.patientEmail,
    this.patientPhoneNumber,
    this.patientId,
    this.patientName,
    this.startTime,
    this.endTime,
    this.doctorId,
    this.consultationPrice,
  });

  /// Creates a new [ConsultationBooking] instance from a JSON object.
  ConsultationBooking.fromJson(Map<String, dynamic> json)
      : patientEmail = json['userEmail'] as String?,
        patientPhoneNumber = json['userPhoneNumber'] as String?,
        patientId = json['userId'] as String?,
        patientName = json['userName'] as String?,
        startTime = DateTime.parse(json['bookingStart'] as String),
        endTime = DateTime.parse(json['bookingEnd'] as String),
        doctorId = json['serviceId'] as String?,
        doctorName = json['serviceName'] as String,
        consultationDuration = json['serviceDuration'] as int,
        consultationPrice = json['servicePrice'] as int?;

  /// The id of the currently logged user which is the patient.
  final String? patientId;

  /// The name of the currently logged user which is the patient.
  final String? patientName;

  /// The userEmail of the currently logged user
  /// who will start the new booking
  final String? patientEmail;

  /// The userPhoneNumber of the currently logged user
  /// who will start the new booking
  final String? patientPhoneNumber;

  /// This is the id of the doctor that the patient will book a consultation
  ///  with
  final String? doctorId;

  ///The name of the currently selected Service
  final String doctorName;

  ///The duration of the currently selected Service
  final int consultationDuration;

  ///The price of the currently selected Service

  final int? consultationPrice;

  ///The selected booking slot's starting time
  DateTime? startTime;

  ///The selected booking slot's ending time
  DateTime? endTime;

  /// Creates a new [ConsultationBooking] instance from a JSON object.
  Map<String, dynamic> toJson() => {
        'userId': patientId,
        'userName': patientName,
        'userEmail': patientEmail,
        'userPhoneNumber': patientPhoneNumber,
        'serviceId': doctorId,
        'serviceName': doctorName,
        'serviceDuration': consultationDuration,
        'servicePrice': consultationPrice,
        'bookingStart': startTime?.toIso8601String(),
        'bookingEnd': endTime?.toIso8601String(),
      };
}
