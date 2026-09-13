import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:localserve/main.dart';

void main() {
      testWidgets(
            'LocalServe displays Add Service Request button',
                (WidgetTester tester) async {
                  // Build LocalServe apps
                  await tester.pumpWidget(
                        const LocalServeApp(),
                  );

                  // Wait for the app to settle
                  await tester.pumpAndSettle();

                  // Check LocalServe title
                  expect(
                        find.text('LocalServe'),
                        findsOneWidget,
                  );

                  // Check Request a Service button
                  expect(
                        find.text('Request a Service'),
                        findsOneWidget,
                  );
            },
      );

      testWidgets(
            'LocalServe displays empty state',
                (WidgetTester tester) async {
                  // Build LocalServe app
                  await tester.pumpWidget(
                        const LocalServeApp(),
                  );

                  await tester.pumpAndSettle();

                  // Check empty request message
                  expect(
                        find.text(
                              'No service requests yet.',
                        ),
                        findsOneWidget,
                  );

                  // Check create first request button
                  expect(
                        find.text(
                              'Create First Request',
                        ),
                        findsOneWidget,
                  );
            },
      );
}