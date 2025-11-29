import 'package:app/features/room/models/room.dart';
import 'package:flutter/material.dart';

class MyRoomCard extends StatelessWidget {
  const MyRoomCard({super.key, required this.room});

  final Room room;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('ルームID'),
              SizedBox(height: 16),
              Text(room.id),
            ],
          ),
        ),
      ),
    );
  }
}
