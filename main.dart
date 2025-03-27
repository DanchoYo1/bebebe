
import 'package:flutter/material.dart';

void main() => runApp(FitHeroApp());

class FitHeroApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitHero',
      theme: ThemeData.dark(),
      home: FitHeroHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class FitHeroHomePage extends StatefulWidget {
  @override
  _FitHeroHomePageState createState() => _FitHeroHomePageState();
}

class _FitHeroHomePageState extends State<FitHeroHomePage>
    with SingleTickerProviderStateMixin {
  int _steps = 1200; // фиксированные шаги для демо
  int _xp = 1200;
  int _level = 2;
  List<String> _inventory = ['Зелье силы'];
  String _currentCostume = 'hero_placeholder.png';
  late AnimationController _levelUpController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _levelUpController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2)
        .chain(CurveTween(curve: Curves.elasticOut))
        .animate(_levelUpController);
    _levelUpController.forward();
  }

  void _addItemToInventory(String item) {
    setState(() {
      _inventory.add(item);
    });
  }

  void _resetProgress() {
    setState(() {
      _steps = 0;
      _xp = 0;
      _level = 1;
      _inventory.clear();
      _currentCostume = 'hero_placeholder.png';
    });
  }

  void _changeCostume(String costumeAsset) {
    setState(() {
      _currentCostume = costumeAsset;
    });
  }

  @override
  void dispose() {
    _levelUpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('FitHero')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _scaleAnimation,
                child: CircleAvatar(
                  radius: 80,
                  backgroundImage: AssetImage('assets/$_currentCostume'),
                ),
              ),
              SizedBox(height: 30),
              Text('Шагов: $_steps', style: TextStyle(fontSize: 24)),
              SizedBox(height: 10),
              Text('XP: $_xp', style: TextStyle(fontSize: 24)),
              SizedBox(height: 10),
              Text('Уровень: $_level',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              LinearProgressIndicator(
                value: (_xp % 1000) / 1000,
                minHeight: 10,
                backgroundColor: Colors.grey,
                color: Colors.amber,
              ),
              SizedBox(height: 10),
              Text('До следующего уровня: ${1000 - (_xp % 1000)} XP'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _addItemToInventory('Зелье ловкости'),
                child: Text('Добавить предмет в инвентарь'),
              ),
              ElevatedButton(
                onPressed: _resetProgress,
                child: Text('Сбросить прогресс'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              ),
              SizedBox(height: 20),
              Text('Инвентарь:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ..._inventory.map((item) => ListTile(
                    leading: Icon(Icons.star),
                    title: Text(item),
                  )),
              SizedBox(height: 20),
              Text('Кастомизация персонажа:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 10,
                children: [
                  ElevatedButton(
                    onPressed: () => _changeCostume('hero_placeholder.png'),
                    child: Text('Обычный'),
                  ),
                  ElevatedButton(
                    onPressed: () => _changeCostume('hero_knight.png'),
                    child: Text('Рыцарь'),
                  ),
                  ElevatedButton(
                    onPressed: () => _changeCostume('hero_ninja.png'),
                    child: Text('Ниндзя'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
