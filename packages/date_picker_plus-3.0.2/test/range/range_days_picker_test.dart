import 'package:date_picker_plus/src/range/range_days_picker.dart';
import 'package:date_picker_plus/src/shared/header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RangeDaysPicker', () {
    testWidgets('should show the correct leading header date',
        (WidgetTester tester) async {
      final DateTime initialDate = DateTime(2022, 6, 1);
      final DateTime minDate = DateTime(2022, 1, 1);
      final DateTime maxDate = DateTime(2022, 12, 31);

      await tester.pumpWidget(
        MaterialApp(
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('en', 'GB'),
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: Builder(builder: (context) {
            return Material(
              child: RangeDaysPicker(
                currentDate: initialDate,
                minDate: minDate,
                maxDate: maxDate,
                initialDate: initialDate,
                leadingDateTextStyle: const TextStyle(),
                onLeadingDateTap: null,
                splashRadius: 20,
                currentDateDecoration: const BoxDecoration(),
                currentDateTextStyle: const TextStyle(),
                daysOfTheWeekTextStyle: const TextStyle(),
                disabledCellsDecoration: const BoxDecoration(),
                disabledCellsTextStyle: const TextStyle(),
                enabledCellsDecoration: const BoxDecoration(),
                enabledCellsTextStyle: const TextStyle(),
                onEndDateChanged: (value) {},
                onStartDateChanged: (value) {},
                selectedCellsDecoration: const BoxDecoration(),
                selectedCellsTextStyle: const TextStyle(),
                selectedEndDate: null,
                selectedStartDate: null,
                singelSelectedCellDecoration: const BoxDecoration(),
                singelSelectedCellTextStyle: const TextStyle(),
                slidersColor: Colors.black,
                slidersSize: 20,
                splashColor: Colors.black,
                highlightColor: Colors.black,
              ),
            );
          }),
        ),
      );

      final Finder headerFinder = find.byType(Header);
      expect(headerFinder, findsOneWidget);

      final Text headerTextWidget = tester.widget<Text>(
          find.descendant(of: headerFinder, matching: find.byType(Text)));
      expect(
          headerTextWidget.data,
          MaterialLocalizations.of(tester.element(headerFinder))
              .formatMonthYear(initialDate));
    });

    testWidgets('should change the page forward and backward on drag.',
        (WidgetTester tester) async {
      final DateTime initialDate = DateTime(2020, 6, 1);
      final DateTime minDate = DateTime(2000, 1, 1);
      final DateTime maxDate = DateTime(2030, 12, 31);

      await tester.pumpWidget(
        MaterialApp(
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('en', 'GB'),
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: Material(
            child: Builder(builder: (context) {
              return RangeDaysPicker(
                currentDate: initialDate,
                minDate: minDate,
                maxDate: maxDate,
                initialDate: initialDate,
                leadingDateTextStyle: const TextStyle(),
                onLeadingDateTap: null,
                splashRadius: 20,
                currentDateDecoration: const BoxDecoration(),
                currentDateTextStyle: const TextStyle(),
                daysOfTheWeekTextStyle: const TextStyle(),
                disabledCellsDecoration: const BoxDecoration(),
                disabledCellsTextStyle: const TextStyle(),
                enabledCellsDecoration: const BoxDecoration(),
                enabledCellsTextStyle: const TextStyle(),
                onEndDateChanged: (value) {},
                onStartDateChanged: (value) {},
                selectedCellsDecoration: const BoxDecoration(),
                selectedCellsTextStyle: const TextStyle(),
                selectedEndDate: null,
                selectedStartDate: null,
                singelSelectedCellDecoration: const BoxDecoration(),
                singelSelectedCellTextStyle: const TextStyle(),
                slidersColor: Colors.black,
                slidersSize: 20,
                splashColor: Colors.black,
                highlightColor: Colors.black,
              );
            }),
          ),
        ),
      );

      final Finder pageViewFinder = find.byType(PageView);
      expect(pageViewFinder, findsOneWidget);

      final DateTime newDisplayedMonth = DateTime(2020, 7, 1);

      await tester.drag(
          pageViewFinder, const Offset(-600, 0)); // Drag the page forward
      await tester.pumpAndSettle();

      final Finder headerFinder = find.byType(Header);
      final Text headerTextWidget = tester.widget<Text>(
          find.descendant(of: headerFinder, matching: find.byType(Text)));
      expect(
          headerTextWidget.data,
          MaterialLocalizations.of(tester.element(headerFinder))
              .formatMonthYear(newDisplayedMonth));

      await tester.drag(
          pageViewFinder, const Offset(600, 0)); // Drag the page backward
      await tester.pumpAndSettle();

      final Finder newHeaderFinder = find.byType(Header);
      final Text newHeaderTextWidget = tester.widget<Text>(
          find.descendant(of: newHeaderFinder, matching: find.byType(Text)));
      expect(
          newHeaderTextWidget.data,
          MaterialLocalizations.of(tester.element(newHeaderFinder))
              .formatMonthYear(initialDate));
    });

    testWidgets(
        'should change the page when tapping on the next page icon and update header.',
        (WidgetTester tester) async {
      final DateTime initialDate = DateTime(2022, 6, 1);
      final DateTime minDate = DateTime(2022, 1, 1);
      final DateTime maxDate = DateTime(2022, 12, 31);

      await tester.pumpWidget(
        MaterialApp(
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('en', 'GB'),
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: Material(
            child: Builder(builder: (context) {
              return RangeDaysPicker(
                currentDate: initialDate,
                minDate: minDate,
                maxDate: maxDate,
                initialDate: initialDate,
                leadingDateTextStyle: const TextStyle(),
                onLeadingDateTap: null,
                splashRadius: 20,
                currentDateDecoration: const BoxDecoration(),
                currentDateTextStyle: const TextStyle(),
                daysOfTheWeekTextStyle: const TextStyle(),
                disabledCellsDecoration: const BoxDecoration(),
                disabledCellsTextStyle: const TextStyle(),
                enabledCellsDecoration: const BoxDecoration(),
                enabledCellsTextStyle: const TextStyle(),
                onEndDateChanged: (value) {},
                onStartDateChanged: (value) {},
                selectedCellsDecoration: const BoxDecoration(),
                selectedCellsTextStyle: const TextStyle(),
                selectedEndDate: null,
                selectedStartDate: null,
                singelSelectedCellDecoration: const BoxDecoration(),
                singelSelectedCellTextStyle: const TextStyle(),
                slidersColor: Colors.black,
                slidersSize: 20,
                splashColor: Colors.black,
                highlightColor: Colors.black,
              );
            }),
          ),
        ),
      );

      final Finder pageViewFinder = find.byType(PageView);
      expect(pageViewFinder, findsOneWidget);

      final int initialPage =
          tester.widget<PageView>(pageViewFinder).controller!.initialPage;

      final Finder nextPageIconFinder =
          find.byIcon(CupertinoIcons.chevron_right);
      expect(nextPageIconFinder, findsOneWidget);

      final Finder headerFinder = find.byType(Header);
      final Text headerTextWidget = tester.widget<Text>(
          find.descendant(of: headerFinder, matching: find.byType(Text)));
      expect(
          headerTextWidget.data,
          MaterialLocalizations.of(tester.element(headerFinder))
              .formatMonthYear(initialDate));

      await tester.tap(nextPageIconFinder);
      await tester.pumpAndSettle();

      final int currentPage =
          tester.widget<PageView>(pageViewFinder).controller!.page!.round();

      expect(currentPage, equals(initialPage + 1));

      final DateTime newDisplayedMonth = DateTime(2022, 7, 1);

      final Finder newHeaderFinder = find.byType(Header);
      final Text newHeaderTextWidget = tester.widget<Text>(
          find.descendant(of: newHeaderFinder, matching: find.byType(Text)));
      expect(
          newHeaderTextWidget.data,
          MaterialLocalizations.of(tester.element(newHeaderFinder))
              .formatMonthYear(newDisplayedMonth));
    });

    testWidgets(
        'should change the page when tapping on the previous page icon and update header.',
        (WidgetTester tester) async {
      final DateTime initialDate = DateTime(2022, 6, 1);
      final DateTime minDate = DateTime(2022, 1, 1);
      final DateTime maxDate = DateTime(2022, 12, 31);

      await tester.pumpWidget(
        MaterialApp(
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('en', 'GB'),
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: Material(
            child: Builder(builder: (context) {
              return RangeDaysPicker(
                currentDate: initialDate,
                minDate: minDate,
                maxDate: maxDate,
                initialDate: initialDate,
                leadingDateTextStyle: const TextStyle(),
                onLeadingDateTap: null,
                splashRadius: 20,
                currentDateDecoration: const BoxDecoration(),
                currentDateTextStyle: const TextStyle(),
                daysOfTheWeekTextStyle: const TextStyle(),
                disabledCellsDecoration: const BoxDecoration(),
                disabledCellsTextStyle: const TextStyle(),
                enabledCellsDecoration: const BoxDecoration(),
                enabledCellsTextStyle: const TextStyle(),
                onEndDateChanged: (value) {},
                onStartDateChanged: (value) {},
                selectedCellsDecoration: const BoxDecoration(),
                selectedCellsTextStyle: const TextStyle(),
                selectedEndDate: null,
                selectedStartDate: null,
                singelSelectedCellDecoration: const BoxDecoration(),
                singelSelectedCellTextStyle: const TextStyle(),
                slidersColor: Colors.black,
                slidersSize: 20,
                splashColor: Colors.black,
                highlightColor: Colors.black,
              );
            }),
          ),
        ),
      );

      final Finder pageViewFinder = find.byType(PageView);
      expect(pageViewFinder, findsOneWidget);

      final int initialPage =
          tester.widget<PageView>(pageViewFinder).controller!.initialPage;

      final Finder previousPageIconFinder =
          find.byIcon(CupertinoIcons.chevron_left);
      expect(previousPageIconFinder, findsOneWidget);

      final Finder headerFinder = find.byType(Header);
      final Text headerTextWidget = tester.widget<Text>(
          find.descendant(of: headerFinder, matching: find.byType(Text)));
      expect(
          headerTextWidget.data,
          MaterialLocalizations.of(tester.element(headerFinder))
              .formatMonthYear(initialDate));

      await tester.tap(previousPageIconFinder);
      await tester.pumpAndSettle();

      final int currentPage =
          tester.widget<PageView>(pageViewFinder).controller!.page!.round();

      expect(currentPage, equals(initialPage - 1));

      final DateTime newDisplayedMonth = DateTime(2022, 5, 1);

      final Finder newHeaderFinder = find.byType(Header);
      final Text newHeaderTextWidget = tester.widget<Text>(
          find.descendant(of: newHeaderFinder, matching: find.byType(Text)));
      expect(
          newHeaderTextWidget.data,
          MaterialLocalizations.of(tester.element(newHeaderFinder))
              .formatMonthYear(newDisplayedMonth));
    });

    testWidgets(
      'should NOT change the page when tapping on the previous page icon when the range in max and min date are one year.',
      (WidgetTester tester) async {
        final DateTime initialDate = DateTime(2020, 1, 5);
        final DateTime minDate = DateTime(2020, 1, 1);
        final DateTime maxDate = DateTime(2020, 1, 31);

        await tester.pumpWidget(
          MaterialApp(
            supportedLocales: const [
              Locale('en', 'US'),
              Locale('en', 'GB'),
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: Material(
              child: Builder(builder: (context) {
                return RangeDaysPicker(
                  currentDate: initialDate,
                  minDate: minDate,
                  maxDate: maxDate,
                  initialDate: initialDate,
                  leadingDateTextStyle: const TextStyle(),
                  onLeadingDateTap: null,
                  splashRadius: 20,
                  currentDateDecoration: const BoxDecoration(),
                  currentDateTextStyle: const TextStyle(),
                  daysOfTheWeekTextStyle: const TextStyle(),
                  disabledCellsDecoration: const BoxDecoration(),
                  disabledCellsTextStyle: const TextStyle(),
                  enabledCellsDecoration: const BoxDecoration(),
                  enabledCellsTextStyle: const TextStyle(),
                  onEndDateChanged: (value) {},
                  onStartDateChanged: (value) {},
                  selectedCellsDecoration: const BoxDecoration(),
                  selectedCellsTextStyle: const TextStyle(),
                  selectedEndDate: null,
                  selectedStartDate: null,
                  singelSelectedCellDecoration: const BoxDecoration(),
                  singelSelectedCellTextStyle: const TextStyle(),
                  slidersColor: Colors.black,
                  slidersSize: 20,
                  splashColor: Colors.black,
                  highlightColor: Colors.black,
                );
              }),
            ),
          ),
        );

        final Finder pageViewFinder = find.byType(PageView);
        expect(pageViewFinder, findsOneWidget);

        final int initialPage =
            tester.widget<PageView>(pageViewFinder).controller!.initialPage;

        final Finder previousPageIconFinder =
            find.byIcon(CupertinoIcons.chevron_left);
        expect(previousPageIconFinder, findsOneWidget);

        final Finder headerFinder = find.byType(Header);
        final Text headerTextWidget = tester.widget<Text>(
          find.descendant(
            of: headerFinder,
            matching: find.byType(Text),
          ),
        );
        expect(
          headerTextWidget.data,
          MaterialLocalizations.of(tester.element(headerFinder))
              .formatMonthYear(initialDate),
        );

        await tester.tap(previousPageIconFinder);
        await tester.pumpAndSettle();

        final int currentPage =
            tester.widget<PageView>(pageViewFinder).controller!.page!.round();

        expect(currentPage, equals(initialPage));

        final DateTime newDisplayedYear = DateTime(2020, 1, 1);

        final Finder newHeaderFinder = find.byType(Header);
        final Text newHeaderTextWidget = tester.widget<Text>(
          find.descendant(
            of: newHeaderFinder,
            matching: find.byType(Text),
          ),
        );
        expect(
          newHeaderTextWidget.data,
          MaterialLocalizations.of(tester.element(headerFinder))
              .formatMonthYear(newDisplayedYear),
        );
      },
    );

    testWidgets(
      'should NOT change the page when tapping on the next page icon when the range in max and min date are one year.',
      (WidgetTester tester) async {
        final DateTime initialDate = DateTime(2022, 1, 1);
        final DateTime minDate = DateTime(2022, 1, 1);
        final DateTime maxDate = DateTime(2022, 1, 31);

        await tester.pumpWidget(
          MaterialApp(
            supportedLocales: const [
              Locale('en', 'US'),
              Locale('en', 'GB'),
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: Material(
              child: Builder(builder: (context) {
                return RangeDaysPicker(
                  currentDate: initialDate,
                  minDate: minDate,
                  maxDate: maxDate,
                  initialDate: initialDate,
                  leadingDateTextStyle: const TextStyle(),
                  onLeadingDateTap: null,
                  splashRadius: 20,
                  currentDateDecoration: const BoxDecoration(),
                  currentDateTextStyle: const TextStyle(),
                  daysOfTheWeekTextStyle: const TextStyle(),
                  disabledCellsDecoration: const BoxDecoration(),
                  disabledCellsTextStyle: const TextStyle(),
                  enabledCellsDecoration: const BoxDecoration(),
                  enabledCellsTextStyle: const TextStyle(),
                  onEndDateChanged: (value) {},
                  onStartDateChanged: (value) {},
                  selectedCellsDecoration: const BoxDecoration(),
                  selectedCellsTextStyle: const TextStyle(),
                  selectedEndDate: null,
                  selectedStartDate: null,
                  singelSelectedCellDecoration: const BoxDecoration(),
                  singelSelectedCellTextStyle: const TextStyle(),
                  slidersColor: Colors.black,
                  slidersSize: 20,
                  splashColor: Colors.black,
                  highlightColor: Colors.black,
                );
              }),
            ),
          ),
        );

        final Finder pageViewFinder = find.byType(PageView);
        expect(pageViewFinder, findsOneWidget);

        final int initialPage =
            tester.widget<PageView>(pageViewFinder).controller!.initialPage;

        final Finder nextPageIconFinder =
            find.byIcon(CupertinoIcons.chevron_right);
        expect(nextPageIconFinder, findsOneWidget);

        final Finder headerFinder = find.byType(Header);
        final Text headerTextWidget = tester.widget<Text>(
          find.descendant(
            of: headerFinder,
            matching: find.byType(Text),
          ),
        );
        expect(
          headerTextWidget.data,
          MaterialLocalizations.of(tester.element(headerFinder))
              .formatMonthYear(initialDate),
        );

        await tester.tap(nextPageIconFinder);
        await tester.pumpAndSettle();

        final int currentPage =
            tester.widget<PageView>(pageViewFinder).controller!.page!.round();

        expect(currentPage, equals(initialPage));

        final DateTime newDisplayedYear = DateTime(2022, 1, 1);

        final Finder newHeaderFinder = find.byType(Header);
        final Text newHeaderTextWidget = tester.widget<Text>(
          find.descendant(
            of: newHeaderFinder,
            matching: find.byType(Text),
          ),
        );
        expect(
          newHeaderTextWidget.data,
          MaterialLocalizations.of(tester.element(headerFinder))
              .formatMonthYear(newDisplayedYear),
        );
      },
    );

    testWidgets(
      'should NOT change the page forward and backward on drag when the range in max and min date are one year.',
      (WidgetTester tester) async {
        final DateTime initialDate = DateTime(2020, 1, 1);
        final DateTime minDate = DateTime(2020, 1, 1);
        final DateTime maxDate = DateTime(2020, 1, 31);

        await tester.pumpWidget(
          MaterialApp(
            supportedLocales: const [
              Locale('en', 'US'),
              Locale('en', 'GB'),
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: Material(
              child: Builder(builder: (context) {
                return RangeDaysPicker(
                  currentDate: initialDate,
                  minDate: minDate,
                  maxDate: maxDate,
                  initialDate: initialDate,
                  leadingDateTextStyle: const TextStyle(),
                  onLeadingDateTap: null,
                  splashRadius: 20,
                  currentDateDecoration: const BoxDecoration(),
                  currentDateTextStyle: const TextStyle(),
                  daysOfTheWeekTextStyle: const TextStyle(),
                  disabledCellsDecoration: const BoxDecoration(),
                  disabledCellsTextStyle: const TextStyle(),
                  enabledCellsDecoration: const BoxDecoration(),
                  enabledCellsTextStyle: const TextStyle(),
                  onEndDateChanged: (value) {},
                  onStartDateChanged: (value) {},
                  selectedCellsDecoration: const BoxDecoration(),
                  selectedCellsTextStyle: const TextStyle(),
                  selectedEndDate: null,
                  selectedStartDate: null,
                  singelSelectedCellDecoration: const BoxDecoration(),
                  singelSelectedCellTextStyle: const TextStyle(),
                  slidersColor: Colors.black,
                  slidersSize: 20,
                  splashColor: Colors.black,
                  highlightColor: Colors.black,
                );
              }),
            ),
          ),
        );

        final Finder pageViewFinder = find.byType(PageView);
        expect(pageViewFinder, findsOneWidget);

        final DateTime newDisplayedYear = DateTime(2020, 1, 1);

        await tester.drag(
          pageViewFinder,
          const Offset(-600, 0),
        ); // Drag the page forward
        await tester.pumpAndSettle();

        final Finder headerFinder = find.byType(Header);
        final Text headerTextWidget = tester.widget<Text>(
          find.descendant(
            of: headerFinder,
            matching: find.byType(Text),
          ),
        );
        expect(
          headerTextWidget.data,
          MaterialLocalizations.of(tester.element(headerFinder))
              .formatMonthYear(newDisplayedYear),
        );

        await tester.drag(
          pageViewFinder,
          const Offset(600, 0),
        ); // Drag the page backward
        await tester.pumpAndSettle();

        final Finder newHeaderFinder = find.byType(Header);
        final Text newHeaderTextWidget = tester.widget<Text>(
          find.descendant(
            of: newHeaderFinder,
            matching: find.byType(Text),
          ),
        );
        expect(
          newHeaderTextWidget.data,
          MaterialLocalizations.of(tester.element(headerFinder))
              .formatMonthYear(initialDate),
        );
      },
    );

    testWidgets(
      'Should the height of the sized box be 52 * 7',
      (WidgetTester tester) async {
        final DateTime initialDate = DateTime(2023, 7);
        final DateTime minDate = DateTime(2000);
        final DateTime maxDate = DateTime(2030);

        await tester.pumpWidget(
          MaterialApp(
            supportedLocales: const [
              Locale('en', 'US'),
              Locale('en', 'GB'),
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: Material(
              child: Builder(builder: (context) {
                return RangeDaysPicker(
                  currentDate: initialDate,
                  minDate: minDate,
                  maxDate: maxDate,
                  initialDate: initialDate,
                  leadingDateTextStyle: const TextStyle(),
                  onLeadingDateTap: null,
                  splashRadius: 20,
                  currentDateDecoration: const BoxDecoration(),
                  currentDateTextStyle: const TextStyle(),
                  daysOfTheWeekTextStyle: const TextStyle(),
                  disabledCellsDecoration: const BoxDecoration(),
                  disabledCellsTextStyle: const TextStyle(),
                  enabledCellsDecoration: const BoxDecoration(),
                  enabledCellsTextStyle: const TextStyle(),
                  onEndDateChanged: (value) {},
                  onStartDateChanged: (value) {},
                  selectedCellsDecoration: const BoxDecoration(),
                  selectedCellsTextStyle: const TextStyle(),
                  selectedEndDate: null,
                  selectedStartDate: null,
                  singelSelectedCellDecoration: const BoxDecoration(),
                  singelSelectedCellTextStyle: const TextStyle(),
                  slidersColor: Colors.black,
                  slidersSize: 20,
                  splashColor: Colors.black,
                  highlightColor: Colors.black,
                );
              }),
            ),
          ),
        );

        await tester.pumpAndSettle();

        final Finder sizedBoxFinder =
            find.byKey(const ValueKey<double>(52 * 7));
        expect(sizedBoxFinder, findsOneWidget);

        const height = 52 * 7;

        final SizedBox sizedBoxWidget = tester.widget<SizedBox>(sizedBoxFinder);

        expect(sizedBoxWidget.height, equals(height));
      },
    );

    testWidgets(
      'Should show the correct text style for the leading date',
      (WidgetTester tester) async {
        final DateTime initialDate = DateTime(2010);
        final DateTime minDate = DateTime(2000);
        final DateTime maxDate = DateTime(2011);
        const leadingDayColor = Colors.green;

        await tester.pumpWidget(
          MaterialApp(
            supportedLocales: const [
              Locale('en', 'US'),
              Locale('en', 'GB'),
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: Material(
              child: Builder(builder: (context) {
                return RangeDaysPicker(
                  currentDate: initialDate,
                  minDate: minDate,
                  maxDate: maxDate,
                  initialDate: initialDate,
                  leadingDateTextStyle: const TextStyle(color: leadingDayColor),
                  onLeadingDateTap: null,
                  splashRadius: 20,
                  currentDateDecoration: const BoxDecoration(),
                  currentDateTextStyle: const TextStyle(),
                  daysOfTheWeekTextStyle: const TextStyle(),
                  disabledCellsDecoration: const BoxDecoration(),
                  disabledCellsTextStyle: const TextStyle(),
                  enabledCellsDecoration: const BoxDecoration(),
                  enabledCellsTextStyle: const TextStyle(),
                  onEndDateChanged: (value) {},
                  onStartDateChanged: (value) {},
                  selectedCellsDecoration: const BoxDecoration(),
                  selectedCellsTextStyle: const TextStyle(),
                  selectedEndDate: null,
                  selectedStartDate: null,
                  singelSelectedCellDecoration: const BoxDecoration(),
                  singelSelectedCellTextStyle: const TextStyle(),
                  slidersColor: Colors.black,
                  slidersSize: 20,
                  splashColor: Colors.black,
                  highlightColor: Colors.black,
                );
              }),
            ),
          ),
        );

        final leadingDayFinder = find.byWidgetPredicate((widget) {
          if (widget is Text) {
            return widget.data == 'January 2010' &&
                widget.style?.color == leadingDayColor;
          }
          return false;
        });

        expect(leadingDayFinder, findsOneWidget);
      },
    );

    testWidgets(
      'Should show the correct color and size for page sliders',
      (WidgetTester tester) async {
        final DateTime initialDate = DateTime(2010);
        final DateTime minDate = DateTime(2000);
        final DateTime maxDate = DateTime(2011);
        const slidersColors = Colors.green;
        const slidersSize = 18.0;

        await tester.pumpWidget(
          MaterialApp(
            supportedLocales: const [
              Locale('en', 'US'),
              Locale('en', 'GB'),
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: Material(
              child: Builder(builder: (context) {
                return RangeDaysPicker(
                  currentDate: initialDate,
                  minDate: minDate,
                  maxDate: maxDate,
                  initialDate: initialDate,
                  leadingDateTextStyle: const TextStyle(),
                  onLeadingDateTap: null,
                  splashRadius: 20,
                  currentDateDecoration: const BoxDecoration(),
                  currentDateTextStyle: const TextStyle(),
                  daysOfTheWeekTextStyle: const TextStyle(),
                  disabledCellsDecoration: const BoxDecoration(),
                  disabledCellsTextStyle: const TextStyle(),
                  enabledCellsDecoration: const BoxDecoration(),
                  enabledCellsTextStyle: const TextStyle(),
                  onEndDateChanged: (value) {},
                  onStartDateChanged: (value) {},
                  selectedCellsDecoration: const BoxDecoration(),
                  selectedCellsTextStyle: const TextStyle(),
                  selectedEndDate: null,
                  selectedStartDate: null,
                  singelSelectedCellDecoration: const BoxDecoration(),
                  singelSelectedCellTextStyle: const TextStyle(),
                  slidersColor: slidersColors,
                  slidersSize: slidersSize,
                  splashColor: Colors.black,
                  highlightColor: Colors.black,
                );
              }),
            ),
          ),
        );

        final leftIconFinder = find.byWidgetPredicate((widget) {
          if (widget is Icon) {
            return widget.color == slidersColors &&
                widget.size == slidersSize &&
                widget.icon == CupertinoIcons.chevron_left;
          }
          return false;
        });

        expect(leftIconFinder, findsOneWidget);

        final rightIconFinder = find.byWidgetPredicate((widget) {
          if (widget is Icon) {
            return widget.color == slidersColors &&
                widget.size == slidersSize &&
                widget.icon == CupertinoIcons.chevron_right;
          }
          return false;
        });

        expect(rightIconFinder, findsOneWidget);
      },
    );

    testWidgets(
      'Should not scroll when first open',
      (WidgetTester tester) async {
        final DateTime minDate = DateTime(2000);
        final DateTime maxDate = DateTime(2023);

        int numberOfScrollListenerCalled = 0;

        void scrollListener() => numberOfScrollListenerCalled++;

        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: RangeDaysPicker(
                minDate: minDate,
                maxDate: maxDate,
              ),
            ),
          ),
        );

        final pageViewWidget = tester.widget<PageView>(find.byType(PageView));
        pageViewWidget.controller!.addListener(scrollListener);

        await tester.pumpAndSettle();

        expect(numberOfScrollListenerCalled, equals(0));
      },
    );
  });
}
