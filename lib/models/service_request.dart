class ServiceRequest {
  final String id;
  final String service;
  final String name;
  final String email;
  final String mobile;
  final String address;
  final String priority;
  final bool reminder;
  final String description;
  final DateTime? dueDate;
  bool completed;

  ServiceRequest({
    required this.id,
    required this.service,
    required this.name,
    required this.email,
    required this.mobile,
    required this.address,
    required this.priority,
    required this.reminder,
    required this.description,
    this.dueDate,
    this.completed = false,
  });

  ServiceRequest copyWith({
    String? id,
    String? service,
    String? name,
    String? email,
    String? mobile,
    String? address,
    String? priority,
    bool? reminder,
    String? description,
    DateTime? dueDate,
    bool? completed,
  }) {
    return ServiceRequest(
      id: id ?? this.id,
      service: service ?? this.service,
      name: name ?? this.name,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      address: address ?? this.address,
      priority: priority ?? this.priority,
      reminder: reminder ?? this.reminder,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      completed: completed ?? this.completed,
    );
  }
}