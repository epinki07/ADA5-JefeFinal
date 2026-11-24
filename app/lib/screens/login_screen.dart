import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rive/rive.dart';

import 'products_screen.dart';
import 'password_reset_screen.dart';
import 'signup_screen.dart';

const _googleServerClientId = String.fromEnvironment('GOOGLE_SERVER_CLIENT_ID');
const _googleIosClientId = String.fromEnvironment('GOOGLE_IOS_CLIENT_ID');
Future<void>? _googleInitialization;

bool get _canStartGoogleSignIn =>
    kIsWeb ||
    switch (defaultTargetPlatform) {
      TargetPlatform.android => _googleServerClientId.isNotEmpty,
      TargetPlatform.iOS => _googleIosClientId.isNotEmpty,
      _ => true,
    };

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //Control para mostrar/ocultar contraseña
  bool _isObscure = true;

  StateMachineController? _controller;
  SMIBool? _isChecking;
  SMIBool? _isHandsUp;
  SMITrigger? _trigSuccess;
  SMITrigger? _trigFail;
  SMINumber? _numLook;

  //3.2 Timer para detener la mirada al dejar de escribir
  Timer? _typingDebounce;

  //2.1 Crear variables para el focusNode
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  //4.1 Controllers para manipular el texto escrito por el usuario
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  // Login failures use one message without identifying a valid account.
  String? authError;
  bool _isLoading = false;

  Future<void> _completeLogin() async {
    if (!mounted) return;
    _trigSuccess?.fire();
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const ProductsScreen()),
    );
  }

  Future<void> _onGoogleLogin() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
      authError = null;
    });
    try {
      if (kIsWeb) {
        await FirebaseAuth.instance.signInWithPopup(GoogleAuthProvider());
      } else {
        await (_googleInitialization ??= GoogleSignIn.instance.initialize(
          clientId: _googleIosClientId.isEmpty ? null : _googleIosClientId,
          serverClientId: _googleServerClientId.isEmpty
              ? null
              : _googleServerClientId,
        ));
        final googleUser = await GoogleSignIn.instance.authenticate();
        final googleAuth = googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
        );
        await FirebaseAuth.instance.signInWithCredential(credential);
      }
      await _completeLogin();
    } catch (_) {
      if (!mounted) return;
      _trigFail?.fire();
      setState(
        () => authError =
            'No se pudo iniciar sesión con Google. Inténtalo de nuevo.',
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  //4.4 Acción al botón
  Future<void> _onLogin() async {
    if (_isLoading) return;
    // De lo que escribió el usuario, quita los espacios en blanco
    final email = emailCtrl.text.trim();
    final pass = passwordCtrl.text;

    setState(() => authError = null);

    // 4.6 Cerrar el teclado y bajar manos

    FocusScope.of(context).unfocus();
    _typingDebounce?.cancel();
    _isChecking?.change(false);
    _isHandsUp?.change(false);
    _numLook?.value = 50; // mirada neutral

    if (email.isEmpty || pass.isEmpty) {
      setState(() => authError = 'Ingresa tu correo y contraseña.');
      _trigFail?.fire();
      return;
    }

    setState(() => _isLoading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );
      await _completeLogin();
    } on FirebaseAuthException {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        authError = 'Credenciales inválidas. Verifica tu correo y contraseña.';
      });
      _trigFail?.fire();
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        authError = 'No se pudo iniciar sesión. Inténtalo de nuevo.';
      });
      _trigFail?.fire();
    }
  }

  //2.2 Crear los listeners (Oyentes/Chismosos)
  @override
  void initState() {
    super.initState();

    _emailFocusNode.addListener(() {
      //Verificar que no sea nulo.
      if (_emailFocusNode.hasFocus) {
        if (_isHandsUp != null) {
          //Ojos sin cerrar
          _isHandsUp!.change(false);
          _numLook?.value = 50; //mirada neutral
        }
      }
    });
    _passwordFocusNode.addListener(() {
      //manos arriba en password
      _isHandsUp?.change(_passwordFocusNode.hasFocus);
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SizedBox(
                  width: size.width,
                  height: 200,
                  child: RiveAnimation.asset(
                    "assets/login-bear-animation.riv",
                    onInit: (artboard) {
                      _controller = StateMachineController.fromArtboard(
                        artboard,
                        'Login Machine',
                      );
                      if (_controller == null) return;

                      artboard.addController(_controller!);

                      _isChecking = _controller!.findSMI('isChecking');
                      _isHandsUp = _controller!.findSMI('isHandsUp');
                      _trigSuccess = _controller!.findSMI('trigSuccess');
                      _trigFail = _controller!.findSMI('trigFail');
                      _numLook = _controller!.findSMI('numLook');
                    },
                  ),
                ), //SizedBox
                const SizedBox(height: 10),
                TextField(
                  // 4.8 vincular el controller
                  controller: emailCtrl,
                  focusNode: _emailFocusNode,
                  onChanged: (value) {
                    if (_isHandsUp != null) {
                      // No tapes los ojos
                      // _isHandsUp!.change(false);
                    }
                    if (_isChecking == null) return;
                    _isChecking!.change(true);
                    //3.4 Implementar el numLook
                    //Ajustes del 0 al 100
                    // 80 es medida de la calibracion, Clamp es el rango (abrazadera)
                    final look = (value.length / 80 * 100).clamp(0.0, 100.0);
                    _numLook?.value = look;
                    //3.5 debounce: si vuelve a teclear, reinicia el contador
                    _typingDebounce?.cancel(); //cancelamos cualquier timer que este corriendo
                    _typingDebounce = Timer(
                      const Duration(milliseconds: 3000),
                      () {
                        //si se cierra la pantalla (!mounted)
                        if (!mounted) return;
                        _isChecking?.change(false);
                      },
                    );
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: "Email@ejemplo.com",
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  // 4.8 vincular el controller
                  controller: passwordCtrl,
                  focusNode: _passwordFocusNode,
                  onChanged: (value) {
                    if (_isChecking != null) {
                      // No tapes los ojos
                      // _isChecking!.change(false);
                    }
                    if (_isHandsUp == null) return;
                    _isHandsUp!.change(true);
                  },
                  obscureText: _isObscure,
                  decoration: InputDecoration(
                    hintText: "Password",
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isObscure ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _isLoading
                        ? null
                        : () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const PasswordResetScreen(),
                            ),
                          ),
                    child: const Text('¿Olvidaste tu contraseña?'),
                  ),
                ),
                const SizedBox(height: 10),
                MaterialButton(
                  height: 50,
                  color: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onPressed: _isLoading ? null : _onLogin,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Iniciar sesión",
                          style: TextStyle(color: Colors.white),
                        ),
                ),
                const SizedBox(height: 10),
                if (_canStartGoogleSignIn)
                  OutlinedButton.icon(
                    onPressed: _isLoading ? null : _onGoogleLogin,
                    icon: const Icon(Icons.account_circle),
                    label: const Text('Continuar con Google'),
                  ),
                if (authError != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    authError!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
                const SizedBox(height: 20),
                // ¿No tienes cuenta? Creala
                SizedBox(
                  width: size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("¿No tienes cuenta?"),
                      TextButton(
                        onPressed: _isLoading
                            ? null
                            : () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const SignUpScreen(),
                                ),
                              ),
                        child: const Text(
                          "Regístrate",
                          style: TextStyle(
                            color: Colors.black,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    emailCtrl.dispose();
    passwordCtrl.dispose();
    _typingDebounce?.cancel();
    super.dispose();
  }
}
