class Config {
  final String? company;
  final String? phone;
  final String? email;
  final String? hotline;
  final String? zalo;
  final String? messenger;
  final String? privacy;

  Config({
    this.company,
    this.phone,
    this.email,
    this.hotline,
    this.zalo,
    this.messenger,
    this.privacy,
  });

  factory Config.fromJson(Map<String, dynamic> json) {
    return Config(
      company: json['company'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      hotline: json['hotline'] as String?,
      zalo: json['zalo'] as String?,
      messenger: json['messenger'] as String?,
      privacy: json['privacy'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'company': company,
      'phone': phone,
      'email': email,
      'hotline': hotline,
      'zalo': zalo,
      'messenger': messenger,
      'privacy': privacy,
    };
  }

  Config copyWith({
    String? company,
    String? phone,
    String? email,
    String? hotline,
    String? zalo,
    String? messenger,
    String? privacy,
  }) {
    return Config(
      company: company ?? this.company,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      hotline: hotline ?? this.hotline,
      zalo: zalo ?? this.zalo,
      messenger: messenger ?? this.messenger,
      privacy: privacy ?? this.privacy,
    );
  }
}
