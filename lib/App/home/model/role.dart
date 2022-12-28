class Role {
  Role({
    required this.roleName,
  });

  String roleName;

  factory Role.fromMap(Map<String, dynamic> json) => Role(
        roleName: json["role_name"],
      );

  Map<String, dynamic> toMap() => {
        "role_name": roleName,
      };
}
