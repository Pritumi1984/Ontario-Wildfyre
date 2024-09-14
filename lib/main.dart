import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ontario Wildfire',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: OntarioWildfireDashboard(),
    );
  }
}

class OntarioWildfireDashboard extends StatefulWidget {
  @override
  OntarioWildfireDashboardState createState() => OntarioWildfireDashboardState();
}

class OntarioWildfireDashboardState extends State<OntarioWildfireDashboard> {
  String selectedTab = 'Current Situation';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ontario Wildfire Dashboard'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedTab = 'Current Situation';
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedTab == 'Current Situation' ? Colors.red : Colors.grey,
                    ),
                    child: Text('Current Situation'),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedTab = 'Totals This Year';
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedTab == 'Totals This Year' ? Colors.red : Colors.grey,
                    ),
                    child: Text('Totals This Year'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16), // Adds spacing between tabs and content
            selectedTab == 'Current Situation'
                ? CurrentSituation()
                : TotalsThisYear(),
            SizedBox(height: 16), // Adds spacing before stages of control
            StagesOfControl(), // This widget is now included and will appear below the selected tab content
          ],
        ),
      ),
    );
  }
}

class CurrentSituation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.red[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.red),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Provincial Situation Report:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, '
                'quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.yellow[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.yellow),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Report a Fire:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                    SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        text: '• To report a forest fire, call ',
                        style: TextStyle(fontSize: 16, color: Colors.black), // Normal text style
                        children: <TextSpan>[
                          TextSpan(
                            text: '310-FIRE (3473)',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black), // Bold and black for 310-FIRE
                          ),
                          TextSpan(
                            text: '.',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 4),
                    RichText(
                      text: TextSpan(
                        text: '• South of the French and Mattawa rivers, please call ',
                        style: TextStyle(fontSize: 16, color: Colors.black), // Normal text style
                        children: <TextSpan>[
                          TextSpan(
                            text: '911',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black), // Bold and black for 911
                          ),
                          TextSpan(
                            text: '.',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        SummaryWidgets(),
      ],
    );
  }
}

class TotalsThisYear extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Totals for the year refers to wildfire activity between April 1, 2024, and today\'s date.',
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            StatsBox(
              icon: Icons.local_fire_department,
              title: 'Wildfires Started',
              number: 50,
            ),
            StatsBox(
              icon: Icons.nature_people,
              title: 'Hectares Burned',
              number: 1200,
            ),
            StatsBox(
              icon: Icons.check_circle_outline,
              title: 'Extinguished Wildfires',
              number: 45,
            ),
          ],
        ),
        SizedBox(height: 16),
        Text(
          'Wildfire Causes',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CauseBox(
              title: 'Lightning',
              number: 25,
              percentage: 50,
            ),
            CauseBox(
              title: 'Human',
              number: 15,
              percentage: 30,
            ),
            CauseBox(
              title: 'Undetermined',
              number: 10,
              percentage: 20,
            ),
          ],
        ),
      ],
    );
  }
}

class SummaryWidgets extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SummaryCard(
          icon: Icons.local_fire_department,
          title: 'Active Wildfires',
          number: 5,
          color: const Color.fromARGB(255, 224, 150, 0),
        ),
        SizedBox(height: 10),
        SummaryCard(
          icon: Icons.access_time,
          title: 'Started in Last 24 Hours',
          number: 2,
          color: Colors.red,
        ),
        SizedBox(height: 10),
        SummaryCard(
          icon: Icons.check_circle_outline,
          title: 'Declared Out in Last 24 Hours',
          number: 3,
          color: Colors.green,
        ),
        SizedBox(height: 10),
        SummaryCard(
          icon: Icons.calendar_today,
          title: 'Declared Out in Last 7 Days',
          number: 4,
          color: Colors.blue,
        ),
      ],
    );
  }
}

class SummaryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final int number;
  final Color color;

  SummaryCard({
    required this.icon,
    required this.title,
    required this.number,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: ListTile(
        leading: Icon(
          icon,
          color: color,
          size: 40,
        ),
        title: Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          number.toString(),
          style: TextStyle(fontSize: 24, color: color, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class StatsBox extends StatelessWidget {
  final IconData icon;
  final String title;
  final int number;

  StatsBox({
    required this.icon,
    required this.title,
    required this.number,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.blue, size: 40),
          SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            number.toString(),
            style: TextStyle(fontSize: 24, color: Colors.blue, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class CauseBox extends StatelessWidget {
  final String title;
  final int number;
  final int percentage;

  CauseBox({
    required this.title,
    required this.number,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green),
      ),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            '$number (${percentage}%)',
            style: TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class StagesOfControl extends StatelessWidget {
  final List<Map<String, dynamic>> stages = [
    {'title': 'Out of Control', 'count': 2, 'total': 5, 'color': Colors.red},
    {'title': 'Being Held', 'count': 1, 'total': 5, 'color': Colors.orange},
    {'title': 'Under Control', 'count': 1, 'total': 5, 'color': Colors.green},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Stages of Control',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          ...stages.map((stage) {
            final percentage = (stage['count'] / stage['total']) * 100;

            return Container(
              margin: EdgeInsets.symmetric(vertical: 8),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey),
              ),
              child: Row(
                children: [
                  CircularPercentageIndicator(
                    percentage: percentage,
                    color: stage['color'],
                  ),
                  SizedBox(width: 16),
                  Text(
                    stage['title'],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}

class CircularPercentageIndicator extends StatelessWidget {
  final double percentage;
  final Color color;

  CircularPercentageIndicator({
    required this.percentage,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: percentage / 100,
            strokeWidth: 6,
            backgroundColor: Colors.grey[200]!,
            color: color,
          ),
          Text(
            '${percentage.toStringAsFixed(0)}%',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
