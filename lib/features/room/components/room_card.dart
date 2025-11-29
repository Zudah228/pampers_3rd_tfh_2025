import 'package:app/core/app/components/snack_bar.dart';
import 'package:app/features/room/models/room.dart';
import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

class RoomCard extends StatelessWidget {
  const RoomCard({super.key, required this.room});

  final Room room;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final textTheme = themeData.textTheme;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (room.name case final name?) ...[
                Text(
                  name,
                  style: textTheme.titleMedium,
                ),
                SizedBox(height: 8),
              ],
              Text(DateFormat.yMEd().format(room.createdAt ?? clock.now())),
              SizedBox(height: 8),
              TextFormField(
                initialValue: room.id,
                readOnly: true,
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                spacing: 8,
                children: [
                  IconButton(
                    onPressed: () async {
                      await Clipboard.setData(ClipboardData(text: room.id));

                      showSnackBar(message: 'コピーしました');
                    },
                    icon: Icon(Icons.copy),
                  ),
                  Builder(
                    builder: (context) {
                      return IconButton(
                        onPressed: () {
                          final sharePositionOrigin =
                              (context.findRenderObject() as RenderBox)
                                  .paintBounds;
                          SharePlus.instance.share(
                            ShareParams(
                              text: room.id,
                              sharePositionOrigin: sharePositionOrigin,
                            ),
                          );
                        },
                        icon: Icon(Icons.share),
                      );
                    },
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
