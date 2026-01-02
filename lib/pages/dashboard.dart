import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/widgets/customappbar.dart';
import 'package:todo_list/widgets/custombody.dart';
import 'package:todo_list/services/todo_service.dart';
import 'package:todo_list/services/data_seeder.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final GlobalKey<CustomBodyState> _customBodyKey =
      GlobalKey<CustomBodyState>();
  late ValueNotifier<Color> appBarColorNotifier;

  @override
  void initState() {
    super.initState();
    appBarColorNotifier = ValueNotifier<Color>(Colors.transparent);
    // Initialize the todo service and seed data if needed
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final todoService = Provider.of<TodoService>(context, listen: false);

        // Initialize the service first
        await todoService.initialize();

        // Check if database is empty and seed if needed
        final dataSeeder = DataSeeder();
        final isEmpty = await dataSeeder.isDatabaseEmpty();

        if (isEmpty) {
          await dataSeeder.seedDatabase();
          await todoService.loadAllData();
        }
      } catch (e) {
        debugPrint('Error in dashboard initialization: $e');
        // Don't crash the app, just log the error
      }
    });
  }

  @override
  void dispose() {
    appBarColorNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        customBodyKey: _customBodyKey,
        colorNotifier: appBarColorNotifier,
      ),
      body: CustomBody(
        key: _customBodyKey,
        appBarColorNotifier: appBarColorNotifier,
      ),
    );
  }
}
