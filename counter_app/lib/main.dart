
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  // Requirement 1: Initialize Flutter Engine structural bindings
  WidgetsFlutterBinding.ensureInitialized();
  
  // Requirement 1: Load stored shared preference color before launching the UI tree
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String savedColorName = prefs.getString('theme_color') ?? 'Blue'; // Explicit Fallback Default

  runApp(ColorThemeApp(initialColorName: savedColorName));
}

class ColorThemeApp extends StatefulWidget {
  final String initialColorName;

  const ColorThemeApp({super.key, required this.initialColorName});

  @override
  State<ColorThemeApp> createState() => _ColorThemeAppState();
}

class _ColorThemeAppState extends State<ColorThemeApp> {
  late String _currentColorName;

  // Mapping constant names to official Flutter Material SDK Color Objects
  final Map<String, Color> _colorMap = {
    'Blue': Colors.blue,
    'Red': Colors.red,
    'Green': Colors.green,
    'Orange': Colors.orange,
    'Purple': Colors.purple,
    'Amber': Colors.amber,
  };

  @override
  void initState() {
    super.initState();
    _currentColorName = widget.initialColorName;
  }

  // Requirement 2: Asynchronously write to local storage and update local state
  void _updateTheme(String newColorName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme_color', newColorName);

    setState(() {
      _currentColorName = newColorName; // Triggers instant theme rebuild flow
    });
  }

  @override
  Widget build(BuildContext context) {
    Color seedColor = _colorMap[_currentColorName] ?? Colors.blue;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Theme Persistence App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: seedColor),
        useMaterial3: true,
      ),
      home: HomeScreen(
        currentColorName: _currentColorName,
        colorOptions: _colorMap.keys.toList(),
        onColorChanged: _updateTheme,
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final String currentColorName;
  final List<String> colorOptions;
  final ValueChanged<String> onColorChanged;

  const HomeScreen({
    super.key,
    required this.currentColorName,
    required this.colorOptions,
    required this.onColorChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Color Theme Selector'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      const Text(
                        'Select App Seed Color:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      DropdownButton<String>(
                        value: colorOptions.contains(currentColorName) ? currentColorName : colorOptions.first,
                        icon: const Icon(Icons.arrow_drop_down_circle),
                        isExpanded: true,
                        underline: Container(
                          height: 2,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        items: colorOptions.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value, style: const TextStyle(fontSize: 16)),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            onColorChanged(newValue);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.star),
                label: Text('Current Theme: $currentColorName'),
              )
            ],
          ),
        ),
      ),
    );
  }
}