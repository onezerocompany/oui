import 'package:contour/src/type.dart';

class ContourDate extends ContourType<DateTime> {
  ContourDate();

  ContourDate before(DateTime date, {String? message}) {
    operations.add(
      ContourCheck<DateTime>(
        check: (value) => value.isBefore(date),
        message: message ?? 'Date must be before ${date.toString()}',
      ),
    );
    return this;
  }

  ContourDate after(DateTime date, {String? message}) {
    operations.add(
      ContourCheck<DateTime>(
        check: (value) => value.isAfter(date),
        message: message ?? 'Date must be after ${date.toString()}',
      ),
    );
    return this;
  }

  ContourDate utc() {
    operations.add(ContourTransformation<DateTime>((value) => value.toUtc()));
    return this;
  }

  ContourDate local() {
    operations.add(ContourTransformation<DateTime>((value) => value.toLocal()));
    return this;
  }

  ContourDate between(DateTime start, DateTime end, {String? message}) {
    operations.add(
      ContourCheck<DateTime>(
        check: (value) => value.isAfter(start) && value.isBefore(end),
        message:
            message ??
            'Date must be between ${start.toString()} and ${end.toString()}',
      ),
    );
    return this;
  }

  ContourDate year(int year, {String? message}) {
    operations.add(
      ContourCheck<DateTime>(
        check: (value) => value.year == year,
        message: message ?? 'Year must be $year',
      ),
    );
    return this;
  }

  ContourDate month(int month, {String? message}) {
    operations.add(
      ContourCheck<DateTime>(
        check: (value) => value.month == month,
        message: message ?? 'Month must be $month',
      ),
    );
    return this;
  }

  ContourDate day(int day, {String? message}) {
    operations.add(
      ContourCheck<DateTime>(
        check: (value) => value.day == day,
        message: message ?? 'Day must be $day',
      ),
    );
    return this;
  }

  ContourDate weekday(int weekday, {String? message}) {
    operations.add(
      ContourCheck<DateTime>(
        check: (value) => value.weekday == weekday,
        message: message ?? 'Must be weekday $weekday',
      ),
    );
    return this;
  }
}

ContourDate date() => ContourDate();
