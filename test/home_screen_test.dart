import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:todoapp/controllers/task_controller.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/views/home_screen.dart';

void main() {
  testWidgets('HomeScreen displays tasks correctly', (WidgetTester tester) async {
    // 1. Inject the controller
    final TaskController controller = Get.put(TaskController());

    // 2. Add a sample task
    controller.tasks.add(TaskModel(title: 'Task 1', description: 'Desc 1'));

    // 3. Build HomeScreen
    await tester.pumpWidget(
      GetMaterialApp(home: HomeScreen()),
    );

    // 4. Rebuild to ensure Obx updates
    await tester.pumpAndSettle();

    // 5. Verify task title and description exist
    expect(find.text('Task 1'), findsOneWidget);
    expect(find.text('Desc 1'), findsOneWidget);

    // 6. Verify FAB exists
    expect(find.byIcon(Icons.add), findsOneWidget);
  });
}
