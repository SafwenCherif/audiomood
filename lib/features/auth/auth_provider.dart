import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final googleSignInProvider = Provider<GoogleSignIn>((ref) {
  return GoogleSignIn();
});

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<void>>((ref) {
      return AuthController(
        auth: ref.watch(firebaseAuthProvider),
        googleSignIn: ref.watch(googleSignInProvider),
      );
    });

class AuthController extends StateNotifier<AsyncValue<void>> {
  AuthController({required this.auth, required this.googleSignIn})
    : super(const AsyncValue.data(null));

  final FirebaseAuth auth;
  final GoogleSignIn googleSignIn;

  Future<void> signInWithEmail(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      await auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      state = const AsyncValue.data(null);
    } on FirebaseAuthException catch (e, st) {
      state = AsyncValue.error(e, st);
      throw Exception(e.message ?? 'Login failed');
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      throw Exception('Login failed');
    }
  }

  Future<void> registerWithEmail(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      await auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      state = const AsyncValue.data(null);
    } on FirebaseAuthException catch (e, st) {
      state = AsyncValue.error(e, st);
      throw Exception(e.message ?? 'Registration failed');
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      throw Exception('Registration failed');
    }
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncValue.loading();
    try {
      final account = await googleSignIn.signIn();
      if (account == null) {
        state = const AsyncValue.data(null);
        throw Exception('Google sign-in canceled');
      }
      final authData = await account.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: authData.accessToken,
        idToken: authData.idToken,
      );
      await auth.signInWithCredential(credential);
      state = const AsyncValue.data(null);
    } on FirebaseAuthException catch (e, st) {
      state = AsyncValue.error(e, st);
      throw Exception(e.message ?? 'Google sign-in failed');
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      throw Exception('Google sign-in failed');
    }
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    try {
      await googleSignIn.signOut();
      await auth.signOut();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      throw Exception('Sign out failed');
    }
  }
}
