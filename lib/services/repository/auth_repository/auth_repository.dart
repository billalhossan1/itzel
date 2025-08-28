import 'package:jwt_decoder/jwt_decoder.dart';

import '../../../constants/app_api_url.dart';
import '../../../utils/app_all_log/error_log.dart';
import '../../../widgets/app_snack_bar/app_snack_bar.dart';
import '../../api/api_post_services.dart';
import '../../storage_services/app_auth_storage.dart';

String? extractRoleFromToken(String token) {
  Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
  String? role = decodedToken['role'];
  print('Role: $role'); // Print the role
  return role;
}

class AuthRepository {
  ////////////  object
  ApiPostServices apiPostServices = ApiPostServices();
  AppAuthStorage appAuthStorage = AppAuthStorage();

  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      var response = await apiPostServices.apiPostServices(
          url: AppApiUrl.login, body: {"email": email, "password": password});
      if (response != null && response["success"] == true) {
        if (response["data"] != null && response["data"] is String) {
          await appAuthStorage.setToken(response["data"]);
          String? role = extractRoleFromToken(response["data"]);
          if (role != null) {
            await appAuthStorage.setRole(role);
          }
          return role;
        }
      }
      return null;
    } catch (e) {
      errorLog("sign in repo function", e);
      return null;
    }
  }

  Future<bool> createUser({
    required String email,
    required String password,
    required String name,
    required String role,
  }) async {
    try {
      var response = await apiPostServices.apiPostServices(
        url: AppApiUrl.createUser,
        body: {
          "name": name,
          "email": email,
          "password": password,
          "role": "USER"
        },
      );
      if (response != null) {
        if (response["message"].runtimeType != Null) {
          AppSnackBar.message(response["message"].toString());
        }
        return true;
      }
      return false;
    } catch (e) {
      errorLog("sign up repo provider  function ", e);
      return false;
    }
  }

  Future<bool> createCreator({
    required String email,
    required String password,
    required String name,
    required String role,
  }) async {
    try {
      var response = await apiPostServices.apiPostServices(
        url: AppApiUrl.createCreator,
        body: {
          "name": name,
          "email": email,
          "password": password,
          "role": "CREATOR"
        },
      );
      if (response != null) {
        if (response["message"].runtimeType != Null) {
          AppSnackBar.message(response["message"].toString());
        }
        return true;
      }
      return false;
    } catch (e) {
      errorLog("sign up employee repo  function ", e);
      return false;
    }
  }

  Future<bool> registrationVerifyEmail({
    required String email,
    required String otp,
  }) async {
    try {
      var response = await apiPostServices.apiPostServices(
          url: AppApiUrl.registrationVerifyEmail,
          body: {"email": email, "oneTimeCode": int.parse(otp)});
      if (response != null) {
        return true;
      }
      return false;
    } catch (e) {
      errorLog("verify email repo", e);
      return false;
    }
  }

  Future<bool> resentOtp({required String email}) async {
    try {
      var response = await apiPostServices
          .apiPostServices(url: AppApiUrl.resentOtp, body: {"email": email});
      if (response != null) {
        return true;
      }
      return false;
    } catch (e) {
      errorLog("resent otp repo", e);
      return false;
    }
  }

  Future<bool> forgotPassword({required String email}) async {
    try {
      var response = await apiPostServices.apiPostServices(
          url: AppApiUrl.forgotPassword, body: {"email": email});
      if (response != null) {
        return true;
      }
      return false;
    } catch (e) {
      errorLog("forgot password repo", e);
      return false;
    }
  }

  Future<String?> forgotVerifyEmail({
    required String email,
    required String otp,
  }) async {
    try {
      var response = await apiPostServices.apiPostServices(
          url: AppApiUrl.verifyEmail,
          body: {"email": email, "oneTimeCode": int.parse(otp)});
      if (response != null && response["data"] != null) {
        return response["data"].toString();
      }
      return null;
    } catch (e) {
      errorLog("verify email repo", e);
      return null;
    }
  }

  Future<bool> resetPassword({
    required String newPassword,
    required String confirmPassword,
    required String token,
  }) async {
    try {
      var response = await apiPostServices.apiPostServices(
          url: AppApiUrl.resetPassword,
          token: token,
          body: {
            "newPassword": newPassword,
            "confirmPassword": confirmPassword
          });
      if (response != null) {
        return true;
      }
      return false;
    } catch (e) {
      errorLog("reset password repo", e);
      return false;
    }
  }

  Future<bool> changePassword(
      {required String newPassword,
      required String confirmPassword,
      required String currentPassword}) async {
    try {
      var response = await apiPostServices
          .apiPostServices(url: AppApiUrl.changePassword, body: {
        "currentPassword": currentPassword,
        "newPassword": newPassword,
        "confirmPassword": confirmPassword
      });
      if (response != null) {
        return true;
      }
      return false;
    } catch (e) {
      errorLog("change password password repo", e);
      return false;
    }
  }
}
