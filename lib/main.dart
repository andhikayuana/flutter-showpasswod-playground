import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const FlutterShowPasswordApp());
}

class FlutterShowPasswordApp extends StatelessWidget {
  const FlutterShowPasswordApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Show Password Playground',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool lightOn = false;
  late final AnimationController lightAnimationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  );
  late final Animation<double> lightAnimationOn = CurvedAnimation(
    parent: lightAnimationController,
    curve: Curves.bounceIn,
  );
  late final Animation<double> lightAnimationOff = CurvedAnimation(
    parent: lightAnimationController,
    curve: Curves.ease,
  );

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.black));
    super.initState();
  }

  @override
  void dispose() {
    lightAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Stack(
            alignment: Alignment.topCenter,
            fit: StackFit.expand,
            children: [
              FadeTransition(
                opacity: lightOn ? lightAnimationOn : lightAnimationOff,
                child: CustomPaint(
                  painter: _LightPainter(),
                ),
              ),
              _LightSwitch(
                onVerticalDragEnd: () {
                  setState(() {
                    lightOn = !lightOn;
                  });

                  if (lightOn) {
                    lightAnimationController.forward();
                  } else {
                    lightAnimationController.reverse();
                  }
                },
              ),
              Form(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _InputText(
                      controller: usernameController,
                      hintText: 'Username',
                    ),
                    const SizedBox(height: 20),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 600),
                      switchInCurve: Curves.bounceInOut,
                      child: _InputText(
                        key: ValueKey(lightOn),
                        controller: passwordController,
                        hintText: 'Password',
                        obsecureText: !lightOn,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                          ),
                        ),
                        onPressed: () {
                          showDialog<void>(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Text(
                                    'Hi ${usernameController.text}, welcome home!'),
                              );
                            },
                          );
                        },
                        child: const Text(
                          'Sign In',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
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
    );
  }
}

class _LightPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height / 2.5;
    final path = Path();

    final rect = Offset.zero & Size(width, height);

    Paint paint = Paint();
    paint.shader = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.white60,
        Colors.white30,
        Colors.white10,
        Colors.transparent,
      ],
    ).createShader(rect);

    path.moveTo(width / 2 - 40, 20);
    path.lineTo(0, height);
    path.lineTo(width, height);
    path.lineTo(width / 2 + 40, 20);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class _InputText extends StatelessWidget {
  const _InputText({
    Key? key,
    required this.controller,
    required this.hintText,
    this.obsecureText = false,
  }) : super(key: key);

  final TextEditingController controller;
  final String hintText;
  final bool obsecureText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obsecureText,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
        hintText: hintText,
      ),
      controller: controller,
    );
  }
}

typedef OnVerticalDragEnd = void Function();

class _LightSwitch extends StatefulWidget {
  final OnVerticalDragEnd onVerticalDragEnd;

  const _LightSwitch({
    super.key,
    required this.onVerticalDragEnd,
  });

  @override
  State<_LightSwitch> createState() => _LightSwitchState();
}

class _LightSwitchState extends State<_LightSwitch>
    with TickerProviderStateMixin {
  double switchHeight = 40.0;
  late final AnimationController animationController =
      AnimationController(vsync: this);
  late final Animation<double> animation = CurvedAnimation(
    parent: animationController,
    curve: Curves.bounceInOut,
  );

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: 25,
          width: 120,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              color: Colors.black,
            ),
          ),
        ),
        Column(
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: switchHeight > 40 ? 0 : 500),
              height: switchHeight,
              width: 2,
              color: Colors.white,
              curve: Curves.bounceInOut,
            ),
            GestureDetector(
              onVerticalDragUpdate: (details) {
                setState(() {
                  switchHeight += details.delta.dy.sign + 5;
                });
              },
              onVerticalDragEnd: (details) {
                setState(() {
                  switchHeight = 40;
                });
                widget.onVerticalDragEnd.call();
              },
              child: const SizedBox(
                height: 15,
                width: 15,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
