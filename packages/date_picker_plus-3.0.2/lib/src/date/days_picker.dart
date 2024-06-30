import 'package:date_picker_plus/src/shared/utils.dart';
import 'package:flutter/material.dart';

import 'days_view.dart';
import '../shared/header.dart';
import 'show_date_picker_dialog.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
/// Displays a grid of days for a given month and allows the user to select a
/// date.
///
/// Days are arranged in a rectangular grid with one column for each day of the
/// week. Controls are provided to change the month that the grid is
/// showing.
///
/// The date picker widget is rarely used directly. Instead, consider using
/// [showDatePickerDialog], which will create a dialog that uses this.
///
/// See also:
///
///  * [showDatePickerDialog], which creates a Dialog that contains a
///    [DatePicker].
///
class DaysPicker extends StatefulWidget {
  /// Creates a days picker.
  ///
  /// It will display a grid of days for the [initialDate]'s month. If [initialDate]
  /// is null, `DateTime.now()` will be used. If `DateTime.now()` does not fall within
  /// the valid range of [minDate] and [maxDate], it will fall back to the nearest
  /// valid date from `DateTime.now()`, selecting the [maxDate] if `DateTime.now()` is
  /// after the valid range, or [minDate] if before.
  ///
  /// The day indicated by [selectedDate] will be selected if provided.
  ///
  /// The optional [onDateSelected] callback will be called if provided when a date
  /// is selected.
  ///
  /// The [minDate] is the earliest allowable date. The [maxDate] is the latest
  /// allowable date. [initialDate] and [selectedDate] must either fall between
  /// these dates, or be equal to one of them.
  ///
  /// The [currentDate] represents the current day (i.e. today). This
  /// date will be highlighted in the day grid. If null, the date of
  /// `DateTime.now()` will be used.
  ///
  /// For each of these [DateTime] parameters, only
  /// their dates are considered. Their time fields are ignored.
  DaysPicker({
    super.key,
    required this.maxDate,
    required this.minDate,
    this.initialDate,
    this.currentDate,
    this.selectedDate,
    this.daysOfTheWeekTextStyle,
    this.enabledCellsTextStyle,
    this.enabledCellsDecoration = const BoxDecoration(),
    this.disabledCellsTextStyle,
    this.disabledCellsDecoration = const BoxDecoration(),
    this.currentDateTextStyle,
    this.currentDateDecoration,
    this.selectedCellTextStyle,
    this.selectedCellDecoration,
    this.onLeadingDateTap,
    this.onDateSelected,
    this.leadingDateTextStyle,
    this.slidersColor,
    this.slidersSize,
    this.highlightColor,
    this.splashColor,
    this.splashRadius,
    this.centerLeadingDate = false,
    this.previousPageSemanticLabel = 'Previous Day',
    this.nextPageSemanticLabel = 'Next Day',
  }) {
    assert(!minDate.isAfter(maxDate), "minDate can't be after maxDate");
    assert(
        () {
      if (initialDate == null) return true;
      final init =
      DateTime(initialDate!.year, initialDate!.month, initialDate!.day);

      final min = DateTime(minDate.year, minDate.month, minDate.day);

      return init.isAfter(min) || init.isAtSameMomentAs(min);
    }(),
    'initialDate $initialDate must be on or after minDate $minDate.',
    );
    assert(
        () {
      if (initialDate == null) return true;
      final init =
      DateTime(initialDate!.year, initialDate!.month, initialDate!.day);

      final max = DateTime(maxDate.year, maxDate.month, maxDate.day);
      return init.isBefore(max) || init.isAtSameMomentAs(max);
    }(),
    'initialDate $initialDate must be on or before maxDate $maxDate.',
    );
  }

  /// The date which will be displayed on first opening. If not specified, the picker
  /// will default to `DateTime.now()`. If `DateTime.now()` does not fall within the
  /// valid range of [minDate] and [maxDate], it will automatically adjust to the nearest
  /// valid date, selecting [maxDate] if `DateTime.now()` is after the valid range, or
  /// [minDate] if it is before.
  ///
  /// Note that only dates are considered. time fields are ignored.
  final DateTime? initialDate;

  /// The date to which the picker will consider as current date. e.g (today).
  /// If not specified, the picker will default to `DateTime.now()` date.
  ///
  /// Note that only dates are considered. time fields are ignored.
  final DateTime? currentDate;

  /// The initially selected date when the picker is first opened.
  ///
  /// Note that only dates are considered. time fields are ignored.
  final DateTime? selectedDate;

  /// Called when the user picks a date.
  final ValueChanged<DateTime>? onDateSelected;

  /// The earliest date the user is permitted to pick.
  ///
  /// This date must be on or before the [maxDate].
  ///
  /// Note that only dates are considered. time fields are ignored.
  final DateTime minDate;

  /// The latest date the user is permitted to pick.
  ///
  /// This date must be on or after the [minDate].
  ///
  /// Note that only dates are considered. time fields are ignored.
  final DateTime maxDate;

  /// Called when the user tap on the leading date.
  final VoidCallback? onLeadingDateTap;

  /// The text style of the days of the week in the header.
  ///
  /// defaults to [TextTheme.titleSmall] with a [FontWeight.bold],
  /// a `14` font size, and a [ColorScheme.onSurface] with 30% opacity.
  final TextStyle? daysOfTheWeekTextStyle;

  /// The text style of cells which are selectable.
  ///
  /// defaults to [TextTheme.titleLarge] with a [FontWeight.normal]
  /// and [ColorScheme.onSurface] color.
  final TextStyle? enabledCellsTextStyle;

  /// The cell decoration of cells which are selectable.
  ///
  /// defaults to empty [BoxDecoration].
  final BoxDecoration enabledCellsDecoration;

  /// The text style of cells which are not selectable.
  ///
  /// defaults to [TextTheme.titleLarge] with a [FontWeight.normal]
  /// and [ColorScheme.onSurface] color with 30% opacity.
  final TextStyle? disabledCellsTextStyle;

  /// The cell decoration of cells which are not selectable.
  ///
  /// defaults to empty [BoxDecoration].
  final BoxDecoration disabledCellsDecoration;

  /// The text style of the current date.
  ///
  /// defaults to [TextTheme.titleLarge] with a [FontWeight.normal]
  /// and [ColorScheme.primary] color.
  final TextStyle? currentDateTextStyle;

  /// The cell decoration of the current date.
  ///
  /// defaults to circle stroke border with [ColorScheme.primary] color.
  final BoxDecoration? currentDateDecoration;

  /// The text style of selected cell.
  ///
  /// defaults to [TextTheme.titleLarge] with a [FontWeight.normal]
  /// and [ColorScheme.onPrimary] color.
  final TextStyle? selectedCellTextStyle;

  /// The cell decoration of selected cell.
  ///
  /// defaults to circle with [ColorScheme.primary] color.
  final BoxDecoration? selectedCellDecoration;

  /// The text style of leading date showing in the header.
  ///
  /// defaults to `18px` with a [FontWeight.bold]
  /// and [ColorScheme.primary] color.
  final TextStyle? leadingDateTextStyle;

  /// The color of the page sliders.
  ///
  /// defaults to [ColorScheme.primary] color.
  final Color? slidersColor;

  /// The size of the page sliders.
  ///
  /// defaults to `20px`.
  final double? slidersSize;

  /// The splash color of the ink response.
  ///
  /// defaults to the color of [selectedCellDecoration] with 30% opacity,
  /// if [selectedCellDecoration] is null will fall back to
  /// [ColorScheme.onPrimary] with 30% opacity.
  final Color? splashColor;

  /// The highlight color of the ink response when pressed.
  ///
  /// defaults to [Theme.highlightColor].
  final Color? highlightColor;

  /// The radius of the ink splash.
  final double? splashRadius;

  /// Centring the leading date. e.g:
  ///
  /// <       December 2023      >
  ///
  final bool centerLeadingDate;

  /// Semantic label for button to go to the previous page.
  final String? previousPageSemanticLabel;

  /// Semantic label for button to go to the next page.
  final String? nextPageSemanticLabel;

  @override
  State<DaysPicker> createState() => _DaysPickerState();
}

class _DaysPickerState extends State<DaysPicker> {
  DateTime? _displayedMonth;
  DateTime? _selectedDate;
  final GlobalKey _pageViewKey = GlobalKey();
  late final PageController _pageController;
//   String getFormattedDate(Locale locale) {
//     var now = DateTime.now();
//     // Set the locale
//     Intl.defaultLocale = locale.toString();
//     // Create a DateFormat with the name of the day, numeric day, and month name
//     var formatter = DateFormat('EEEE dd MMMM', locale.toString());
//
//     return formatter.format(now);
//   }
// //
//   final Locale appLocale = Locale(
//       'en', ''
//   ); // 'en' for English, 'ar' for Arabic
//
//   String formatCurrentDate(Locale locale) {
//     DateTime now = DateTime.now();
//     return '${dayOfWeek(now.weekday, locale)}, ${now.day}, ${monthName(
//         now.month, locale)}';
//   }
//
//   String dayOfWeek(int day, Locale locale) {
//     List<String> daysEn = [
//       'Monday',
//       'Tuesday',
//       'Wednesday',
//       'Thursday',
//       'Friday',
//       'Saturday',
//       'Sunday'
//     ];
//     List<String> daysAr = [
//       'الاثنين',
//       'الثلاثاء',
//       'الأربعاء',
//       'الخميس',
//       'الجمعة',
//       'السبت',
//       'الأحد'
//     ];
//
//     if (locale.languageCode == 'ar') {
//       return daysAr[day - 1];
//     } else {
//       return daysEn[day - 1];
//     }
//   }
//
//   String monthName(int month, Locale locale) {
//     List<String> monthsEn = [
//       'January',
//       'February',
//       'March',
//       'April',
//       'May',
//       'June',
//       'July',
//       'August',
//       'September',
//       'October',
//       'November',
//       'December'
//     ];
//     List<String> monthsAr = [
//       'يناير',
//       'فبراير',
//       'مارس',
//       'أبريل',
//       'مايو',
//       'يونيو',
//       'يوليو',
//       'أغسطس',
//       'سبتمبر',
//       'أكتوبر',
//       'نوفمبر',
//       'ديسمبر'
//     ];
//
//     if (locale.languageCode == 'ar') {
//       return monthsAr[month - 1];
//     } else {
//       return monthsEn[month - 1];
//     }
//   }


  // Represents the maximum height for a calendar with 6 weeks.
  // In scenarios where a month starts on the last day of a week,
  // it may extend into the first day of the sixth week to
  // accommodate the full month.
  double maxHeight = 52 * 7;

  @override
  void initState() {
    final clampedInitailDate = DateUtilsX.clampDateToRange(
        max: widget.maxDate, min: widget.minDate, date: DateTime.now());
    _displayedMonth =
        DateUtils.dateOnly(widget.initialDate ?? clampedInitailDate);
    _selectedDate = widget.selectedDate != null
        ? DateUtils.dateOnly(widget.selectedDate!)
        : null;
    _pageController = PageController(
      initialPage: DateUtils.monthDelta(widget.minDate, _displayedMonth!),
    );
    super.initState();
  }

  @override
  void didUpdateWidget(covariant DaysPicker oldWidget) {
    // there is no need to check for the displayed month because it changes via
    // page view and not the initial date.
    // but for makeing debuging easy, we will navigate to the initial date again
    // if it changes.
    if (oldWidget.initialDate != widget.initialDate) {
      final clampedInitailDate = DateUtilsX.clampDateToRange(
          max: widget.maxDate, min: widget.minDate, date: DateTime.now());
      _displayedMonth =
          DateUtils.dateOnly(widget.initialDate ?? clampedInitailDate);

      _pageController.jumpToPage(
        DateUtils.monthDelta(widget.minDate, _displayedMonth!),
      );
    }

    if (oldWidget.selectedDate != widget.selectedDate) {
      _selectedDate = widget.selectedDate != null
          ? DateUtils.dateOnly(widget.selectedDate!)
          : null;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme
        .of(context)
        .colorScheme;
    final TextTheme textTheme = Theme
        .of(context)
        .textTheme;

    //
    //! days of the week
    //
    //
    final TextStyle daysOfTheWeekTextStyle = widget.daysOfTheWeekTextStyle ??
        textTheme.titleSmall!.copyWith(
          color: colorScheme.onSurface.withOpacity(0.30),
          fontWeight: FontWeight.bold,
          fontSize: 14,
        );

    //
    //! enabled
    //
    //

    final TextStyle enabledCellsTextStyle = widget.enabledCellsTextStyle ??
        textTheme.titleLarge!.copyWith(
          fontWeight: FontWeight.normal,
          color: colorScheme.onSurface,
        );

    final BoxDecoration enabledCellsDecoration = widget.enabledCellsDecoration;

    //
    //! disabled
    //
    //

    final TextStyle disabledCellsTextStyle = widget.disabledCellsTextStyle ??
        textTheme.titleLarge!.copyWith(
          fontWeight: FontWeight.normal,
          color: colorScheme.onSurface.withOpacity(0.30),
        );

    final BoxDecoration disbaledCellsDecoration =
        widget.disabledCellsDecoration;

    //
    //! current
    //
    //

    final TextStyle currentDateTextStyle = widget.currentDateTextStyle ??
        textTheme.titleLarge!.copyWith(
          fontWeight: FontWeight.normal,
          color: colorScheme.primary,
        );

    final BoxDecoration currentDateDecoration = widget.currentDateDecoration ??
        BoxDecoration(
          border: Border.all(color: colorScheme.primary),
          shape: BoxShape.circle,
        );

    //
    //! selected.
    //
    //

    final TextStyle selectedCellTextStyle = widget.selectedCellTextStyle ??
        textTheme.titleLarge!.copyWith(
          fontWeight: FontWeight.normal,
          color: colorScheme.onPrimary,
        );

    final BoxDecoration selectedCellDecoration =
        widget.selectedCellDecoration ??
            BoxDecoration(
              color: colorScheme.primary,
              shape: BoxShape.circle,
            );

    //
    //
    //
    //! header
    final leadingDateTextStyle = widget.leadingDateTextStyle ??
        TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: colorScheme.primary,
        );

    final slidersColor = widget.slidersColor ?? colorScheme.primary;

    final slidersSize = widget.slidersSize ?? 20;

    //
    //! splash
    final splashColor = widget.splashColor ??
        selectedCellDecoration.color?.withOpacity(0.3) ??
        colorScheme.primary.withOpacity(0.3);

    final highlightColor =
        widget.highlightColor ?? Theme
            .of(context)
            .highlightColor;
    //
    //
    Locale locale = Localizations.localeOf(context);
    Intl.defaultLocale = locale.toString();
    var now = DateTime.now();
    var formatter = DateFormat('EEEE dd MMMM', locale.toString());
    String formattedDate = formatter.format(now);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          color: Color.fromRGBO(207, 0, 54, 1.0),
          height: 52,
          width: double.infinity,

          child: Padding(
            padding: EdgeInsets.only(left: 8,right: 8,top: 8), child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "2024",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontFamily: "Montserratbold"
                ),
              ),
              Text(
                formattedDate,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontFamily: "Montserratbold"
                ),
              ),
            ],
          ),
          ),

        ),
        Container(
          color: Color.fromRGBO(244, 244, 244, 1.0),
          height: 50,
          child: Header(
            centerLeadingDate: widget.centerLeadingDate,
            leadingDateTextStyle: leadingDateTextStyle,
            slidersColor: slidersColor,
            slidersSize: slidersSize,
            onDateTap: () => widget.onLeadingDateTap?.call(),
            displayedDate: MaterialLocalizations.of(context)
                .formatMonthYear(_displayedMonth!)
                .replaceAll('٩', '9')
                .replaceAll('٨', '8')
                .replaceAll('٧', '7')
                .replaceAll('٦', '6')
                .replaceAll('٥', '5')
                .replaceAll('٤', '4')
                .replaceAll('٣', '3')
                .replaceAll('٢', '2')
                .replaceAll('١', '1')
                .replaceAll('٠', '0'),
            onNextPage: () {
              _pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.ease,
              );
            },
            onPreviousPage: () {
              _pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.ease,
              );
            },
            previousPageSemanticLabel: widget.previousPageSemanticLabel,
            nextPageSemanticLabel: widget.nextPageSemanticLabel,
          ),
        ),

        const SizedBox(height: 10),
        SizedBox(
          key: ValueKey(maxHeight),
          height: maxHeight,
          child: PageView.builder(
            scrollDirection: Axis.horizontal,
            key: _pageViewKey,
            controller: _pageController,
            itemCount: DateUtils.monthDelta(widget.minDate, widget.maxDate) + 1,
            onPageChanged: (monthPage) {
              final DateTime monthDate =
              DateUtils.addMonthsToMonthDate(widget.minDate, monthPage);

              setState(() {
                _displayedMonth = monthDate;
              });
            },
            itemBuilder: (context, index) {
              final DateTime month =
              DateUtils.addMonthsToMonthDate(widget.minDate, index);

              return DaysView(
                key: ValueKey<DateTime>(month),
                currentDate:
                DateUtils.dateOnly(widget.currentDate ?? DateTime.now()),
                maxDate: DateUtils.dateOnly(widget.maxDate),
                minDate: DateUtils.dateOnly(widget.minDate),
                displayedMonth: month,
                selectedDate: _selectedDate,
                daysOfTheWeekTextStyle: daysOfTheWeekTextStyle,
                enabledCellsTextStyle: enabledCellsTextStyle,
                enabledCellsDecoration: enabledCellsDecoration,
                disabledCellsTextStyle: disabledCellsTextStyle,
                disabledCellsDecoration: disbaledCellsDecoration,
                currentDateDecoration: currentDateDecoration,
                currentDateTextStyle: currentDateTextStyle,
                selectedDayDecoration: selectedCellDecoration,
                selectedDayTextStyle: selectedCellTextStyle,
                highlightColor: highlightColor,
                splashColor: splashColor,
                splashRadius: widget.splashRadius,
                onChanged: (value) {
                  setState(() {
                    _selectedDate = value;
                  });
                  widget.onDateSelected?.call(value);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
