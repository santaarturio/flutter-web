import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'generated/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MarsApp());
  if (kIsWeb) {
    // TODO: Check how it works on IOS / Android
    SemanticsBinding.instance.ensureSemantics();
  }
}

class MarsApp extends StatelessWidget {
  const MarsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "test",
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        S.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.deepOrange,
        scaffoldBackgroundColor: const Color(0xFF0B0F1A),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(fontSize: 16),
        ),
      ),
      home: const SelectionArea(child: MarsHomePage()),
    );
  }
}

class MarsHomePage extends StatelessWidget {
  const MarsHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = S.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(locale.homeTitle),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(locale.homeMissions, locale: Locale('en')),
          ),
          TextButton(onPressed: () {}, child: Text(locale.homeCrew)),
          TextButton(onPressed: () {}, child: Text(locale.homeContact)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: const [
            HeroSection(),
            MissionsSection(),
            CrewSection(),
            ContactSection(),
            Footer(),
          ],
        ),
      ),
    );
  }
}

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = S.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.black, Colors.deepOrange],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          Text(
            locale.homeHeroTitle,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 16),
          Text(locale.homeHeroSubtitle),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("Done"),
                  content: const Text(
                    "Your request to join Mars 2030 mission was successfully sent",
                  ),
                ),
              );
            },
            child: Text(locale.joinButton),
          ),
        ],
      ),
    );
  }
}

class MissionsSection extends StatelessWidget {
  const MissionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final missions = [
      "Terraforming",
      "Habitat Build",
      "Resource Mining",
      "AI Control",
    ];

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text("Missions", style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = constraints.maxWidth > 800 ? 4 : 2;

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: missions.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemBuilder: (context, index) {
                  return Card(child: Center(child: Text(missions[index])));
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class CrewSection extends StatelessWidget {
  const CrewSection({super.key});

  @override
  Widget build(BuildContext context) {
    final crew = ["Alice", "Bob", "Charlie", "Diana"];

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text("Crew", style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: crew.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: Text(crew[index]),
                trailing: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text(crew[index]),
                        content: const Text("Top Mars specialist."),
                      ),
                    );
                  },
                  child: const Text("Info"),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final _formKey = GlobalKey<FormState>();
  String name = "";
  String message = "";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text("Contact Us", style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 16),
          Form(
            key: _formKey,
            child: Column(
              spacing: 16,
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: "Name"),
                  onSaved: (value) => name = value ?? "",
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Message"),
                  onSaved: (value) => message = value ?? "",
                ),
                ElevatedButton(
                  onPressed: () {
                    _formKey.currentState?.save();
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text("Sent by $name")));
                  },
                  child: const Text("Send"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      width: double.infinity,
      color: Colors.black,
      child: const Center(child: Text("© 2030 Mars Mission")),
    );
  }
}

/* notes */
// accessibility features are activated on mobile by default
// SemanticsBinding.instance.ensureSemantics(); - to explicitly active web accessibility features
// wrap app with SelectionArea - to explicitly active select-copy capabilities
// web search nor working, flutter limitations
// show snack bar on button pressed to provide interaction result
// Safari merge 2-4 grid items into 1 item, 1st one is ok.
