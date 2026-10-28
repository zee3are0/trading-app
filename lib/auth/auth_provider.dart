import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'openid'],
    serverClientId: '637972240315-1fri7e108laudvblvksu07tpcgih1fmf.apps.googleusercontent.com',
  );

  GoogleSignInAccount? _user;
  String? _idToken;
  bool _loading = true;

  GoogleSignInAccount? get user => _user;
  String? get idToken => _idToken;
  bool get isSignedIn => _user != null && _idToken != null;
  bool get loading => _loading;

  AuthProvider() {
    _tryRestoreSession();
  }

  Future<void> _tryRestoreSession() async {
    try {
      final account = await _googleSignIn.signInSilently();
      if (account != null) {
        await _refreshToken(account);
      }
    } catch (e) {
      debugPrint('Silent sign-in failed: $e');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> signIn() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account == null) return false;
      await _refreshToken(account);
      return true;
    } catch (e) {
      debugPrint('Sign-in failed: $e');
      return false;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    _user = null;
    _idToken = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('cached_id_token');
    notifyListeners();
  }

  Future<String?> getValidToken() async {
    if (_user == null) return null;
    await _refreshToken(_user!);
    return _idToken;
  }

  Future<void> _refreshToken(GoogleSignInAccount account) async {
    final auth = await account.authentication;
    _user = account;
    _idToken = auth.idToken;
    if (_idToken != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('cached_id_token', _idToken!);
    }
    notifyListeners();
  }
}
