import 'package:flutter/material.dart';

class Loadingwidget extends StatefulWidget {
  const Loadingwidget({super.key});

  @override
  State<Loadingwidget> createState() => _LoadingwidgetState();
}

class _LoadingwidgetState extends State<Loadingwidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        color: Colors.black.withOpacity(0.4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              'در حال تولید متن...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
