//DIGUNAKAN UNTUK FORM LOGIN
class LoginInput {
  final String username;
  final String password;
  LoginInput({
    required this.username,
    required this.password,
  });
  Map<String, dynamic> toJson() => {
        "username": username,
        "password": password,
      };
}

//DIGUNAKAN UNTUK RESPONSE
class LoginResponse {
  final String message;
  final int status;
  final String token; // Tambahkan token
  LoginResponse({
    required this.message,
    required this.status,
    required this.token, // Tambahkan token
  });
  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        message: json["message"],
        status: json["status"],
        token: json["token"], // Ambil token dari JSON response
      );
}
