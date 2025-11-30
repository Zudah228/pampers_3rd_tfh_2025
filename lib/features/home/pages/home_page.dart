import 'package:app/core/app/components/layout/layout.dart';
import 'package:app/core/app/theme/app_colors.dart';
import 'package:app/features/photo/components/add_photo.dart';
import 'package:app/features/room/components/room_create_card.dart';
import 'package:app/features/room/components/room_join_card.dart';
import 'package:app/features/room/providers/my_room_provider.dart';
import 'package:app/features/unlock/pages/unlock_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ホームページへの遷移は、HomePageShell を使用
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myRoom = ref.watch(myRoomProvider).value;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (myRoom == null) ...[
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Body(
                        children: [
                          RoomCreateCard(),
                        ],
                      ),

                      Body(children: [RoomJoinCard()]),
                    ],
                  ),
                ),
              ),
            ] else ...[
              Expanded(
                child: SingleChildScrollView(
                  child: Body(
                    children: [
                      AddPhoto(),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.lightBeige,
                            width: 1,
                          ),
                        ),
                        padding: EdgeInsets.all(16),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              UnlockPage.route(),
                            );
                          },
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/app_icons/album_icon.png',
                                width: 24,
                                height: 24,
                              ),
                              const Spacer(),
                              Text(
                                '二人のアルバムを見る',
                                style: TextStyle(
                                  color: AppColors.charcoal,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Spacer(),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: AppColors.sunsetGold,
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
