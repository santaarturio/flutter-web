import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'generated/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    // CRITICAL for WCAG: Forces the creation of the accessibility tree
    // without requiring the user to find the "Enable Accessibility" button.
    SemanticsBinding.instance.ensureSemantics();
  }

  runApp(const MarsApp());
}

class MarsApp extends StatelessWidget {
  const MarsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Mars 2030 Mission",
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
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepOrange,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0B0F1A),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          headlineMedium: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          bodyMedium: TextStyle(fontSize: 16, color: Colors.white70),
        ),
      ),
      // SelectionArea allows mouse users to highlight text (standard web behavior)
      home: const SelectionArea(child: MarsHomePage()),
    );
  }
}

class MarsHomePage extends StatelessWidget {
  const MarsHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mars 2030"),
        actions: [
          _NavBarLink(label: "Missions", onPressed: () {}),
          _NavBarLink(label: "Crew", onPressed: () {}),
          _NavBarLink(label: "Contact", onPressed: () {}),
        ],
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            HeroSection(),
            MissionsSection(),
            ResourceTableSection(), // New: Data Relationships (WCAG 1.3.1)
            CrewSection(),
            FAQSection(), // New: Interactive Accordions
            ContactSection(),
            Footer(),
          ],
        ),
      ),
    );
  }
}

/// Helper for Accessible Navigation Links
class _NavBarLink extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  const _NavBarLink({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      link: true,
      label: "Navigate to $label",
      child: TextButton(
        onPressed: onPressed,
        child: Text(label, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 24),
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
          // WCAG 1.1.1: Non-text Content must have text alternatives
          Semantics(
            image: true,
            label: "Mission logo: A rocket launching from the red planet",
            child: const Icon(
              Icons.rocket_launch,
              size: 80,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          Semantics(
            header: true, // Marks this as an H1 equivalent
            child: Text(
              "Expedition Mars 2030",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "The first human steps on another world.",
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              // WCAG 4.1.3: Status Messages (Announce changes without moving focus)
              SemanticsService.sendAnnouncement(
                View.of(context),
                "Application window opened",
                TextDirection.ltr,
              );
            },
            child: const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text("Apply for the Mission"),
            ),
          ),
        ],
      ),
    );
  }
}

class ResourceTableSection extends StatelessWidget {
  const ResourceTableSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Survival Resources",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          // DataTables are naturally semantic in Flutter, but ensure contrast
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Resource')),
                DataColumn(label: Text('Status')),
                DataColumn(label: Text('Location')),
              ],
              rows: const [
                DataRow(
                  cells: [
                    DataCell(Text('Oxygen')),
                    DataCell(Text('98%')),
                    DataCell(Text('Sector A')),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text('Water Ice')),
                    DataCell(Text('40%')),
                    DataCell(Text('North Pole')),
                  ],
                ),
              ],
            ),
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
    final missions = ["Terraforming", "Habitat Build", "Mining", "AI Systems"];

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Semantics(
            header: true,
            child: Text(
              "Core Missions",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
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
                  return Card(
                    color: Colors.white10,
                    child: Center(
                      child: Text(
                        missions[index],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class FAQSection extends StatelessWidget {
  const FAQSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            "Common Questions",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const ExpansionTile(
            title: Text("How long is the journey?"),
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Approximately 7 to 9 months depending on planetary alignment.",
                ),
              ),
            ],
          ),
          const ExpansionTile(
            title: Text("Is internet available?"),
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text("Yes, but with a 3 to 22 minute delay each way."),
              ),
            ],
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
    final crew = ["Alice (Commander)", "Bob (Engineer)", "Charlie (Medic)"];

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            "Meet the Crew",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: crew.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.deepOrange,
                  child: Icon(Icons.person),
                ),
                title: Text(crew[index]),
                trailing: OutlinedButton(
                  onPressed: () {},
                  child: const Text("View Bio"),
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            "Contact Base Command",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          Form(
            key: _formKey,
            child: Column(
              children: [
                // WCAG 3.3.2: Labels and instructions
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Full Name",
                    hintText: "Enter your name for the manifest",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: "Message",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(200, 50),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Transmission Sent to Mars Orbit"),
                      ),
                    );
                  },
                  child: const Text("Transmit Message"),
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
    return Semantics(
      container: true,
      label: "Page Footer",
      child: Container(
        padding: const EdgeInsets.all(40),
        width: double.infinity,
        color: Colors.black,
        child: const Column(
          children: [
            Text("© 2030 Mars Mission"),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Icon(Icons.public, semanticLabel: "Global Site")],
            ),
          ],
        ),
      ),
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
// use SemanticsService.sendAnnouncement & ScaffoldMessenger.showSnackBar on button pressed
