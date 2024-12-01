import 'dart:io';

void main() async {
  // Starting date (2020-01-01 is a Wednesday, adjust accordingly)
  DateTime startDate = DateTime(2021, 1, 10);

  // Design of the "Flutter Dev" words
  // Each 'x' represents a commit, and ' ' represents no commit
  List<String> design = [
    " xxxxxx",
    " x x   ",
    " x x   ",
    " x     ",
    "       ",
    " xxxxxx",
    "       ",
    "   xxxx",
    "      x",
    "   xxxx",
    "       ",
    "  x    ",
    " xxxxxx",
    "  x   x",
    "       ",
    "  x    ",
    " xxxxxx",
    "  x   x ",
    "       ",
    "   xxxx",
    "   xx x",
    "   xx x",
    "       ",
    "   xxxx",
    "    x  ",
    "       ",
    "       ",
    " xxxxxx",
    " x    x",
    "  xxxx ",
    "       ",
    "   xxxx",
    "   xx x",
    "   xx x",
    "       ",
    "   xxx ",
    "      x",
    "   xxx ",
  ];

  // Create and commit changes based on the design
  for (int week = 0; week < design.length; week++) {
    for (int day = 0; day < design[week].length; day++) {
      if (design[week][day] == 'x') {
        // Calculate the date for this commit
        var days = week * 7 + day;
        if (days > 65 && days < 92) days++;
        DateTime commitDate = startDate.add(Duration(days: days));
        String formattedDate = formatDate(commitDate);

        // Create a temporary file to commit
        File tempFile = File('contribution.txt');
        await tempFile.writeAsString("Commit for $formattedDate");

        // Add the file to the repository
        await runCommand(['git', 'add', 'contribution.txt']);

        // Commit with the specific date
        await runCommand([
          'git',
          'commit',
          '--date',
          formattedDate,
          '-m',
          'Commit for $formattedDate'
        ]);
      }
    }
  }
}

// Format the date in ISO 8601 format (yyyy-MM-ddTHH:mm:ss)
String formatDate(DateTime date) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  String year = date.year.toString();
  String month = twoDigits(date.month);
  String day = twoDigits(date.day);
  String hour = twoDigits(date.hour);
  String minute = twoDigits(date.minute);
  String second = twoDigits(date.second);
  return '$year-$month-${day}T$hour:$minute:$second';
}

// Helper function to run shell commands
Future<void> runCommand(List<String> command) async {
  final process = await Process.start(command[0], command.sublist(1));
  await stdout.addStream(process.stdout);
  await stderr.addStream(process.stderr);
  final exitCode = await process.exitCode;

  if (exitCode != 0) {
    print('Command failed: $command');
    exit(exitCode);
  }
}
