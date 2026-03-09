import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

class PhotoHero extends StatelessWidget {
  final String photo;
  final VoidCallback onTap;
  final double width;

  const PhotoHero({
    super.key,
    required this.photo,
    required this.onTap,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).primaryColor.withValues(alpha: 0.25),
      child: InkWell(
        onTap: onTap,
        child: Image.network(photo, fit: BoxFit
            .contain),
      ),
    );
  }
}

class HeroAnimation extends StatelessWidget {
  const HeroAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    timeDilation = 3.0;
    return Scaffold(
      appBar: AppBar(title: const Text('Basic Hero Animation')),
      body: Center(
        child: PhotoHero(
          photo: 'https://avatars2.githubusercontent.com/u/20411648?s=460&v=4',
          width: 300.0,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return Scaffold(
                    appBar: AppBar(title: const Text('Flippers Page')),
                    body: Container(
                      color: Colors.lightBlueAccent,
                      padding: EdgeInsets.all(16),
                      alignment: Alignment.topLeft,
                      child: PhotoHero(
                        photo: 'https://avatars2.githubusercontent.com/u/20411648?s=460&v=4',
                        width: 100,
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
