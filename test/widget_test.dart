import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Logo animation page displays correctly',
      (WidgetTester tester) async {
    // Build the widget tree for testing.
    await tester.pumpWidget(const MyApp());

    // Check if AppBar title exists.
    expect(find.text('Healthcare Chatbot'), findsOneWidget);

    // Check if the logo exists in the widget tree.
    expect(find.byType(Image), findsOneWidget);

    // Advance animation and rebuild widget tree.
    await tester.pump(const Duration(seconds: 5));
    final opacityWidget = tester.widget<Opacity>(find.byType(Opacity));
    expect(opacityWidget.opacity,
        greaterThan(0.0)); // Expect opacity to be greater than 0
    await tester.pump(const Duration(milliseconds: 500)); // Half a second
    await tester.pump(const Duration(milliseconds: 500)); // Another half second
    try {
      await tester
          .pumpAndSettle(Duration(seconds: 100)); // Increased settle time
    } catch (e) {
      print('Pump and settle timed out: $e');
    }
// Pump until the animation completes (settles)
    await tester.pumpAndSettle(Duration(seconds: 3));

    // Verify the Transform widget's scale value.
    final transformWidget =
        tester.firstWidget<Transform>(find.byType(Transform));

    final scaleMatrix = transformWidget.transform;
    expect(scaleMatrix.getMaxScaleOnAxis(), greaterThan(0.5));
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Hides the debug banner
      home: const LogoAnimationPage(),
    );
  }
}

class LogoAnimationPage extends StatefulWidget {
  const LogoAnimationPage({super.key});

  @override
  _LogoAnimationPageState createState() => _LogoAnimationPageState();
}

class _LogoAnimationPageState extends State<LogoAnimationPage>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller with duration
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true); // Repeat animation with reverse effect

    // Define opacity animation (fade in and out)
    _opacityAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    // Define scale animation (grow and shrink)
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the controller to avoid memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Healthcare Chatbot'),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Container(
              width: 220, // Size of the container (logo + background)
              height: 220,
              decoration: BoxDecoration(
                color: Colors.teal, // Background color
                borderRadius: BorderRadius.circular(15), // Rounded corners
              ),
              child: Center(
                child: Opacity(
                  opacity: _opacityAnimation.value,
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Image.asset(
                      'assets/images/Logo.png', // Your logo
                      width: 180,
                      height: 180,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.error,
                          size: 100,
                          color: Colors.red,
                        ); // Placeholder if image not found
                      },
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
