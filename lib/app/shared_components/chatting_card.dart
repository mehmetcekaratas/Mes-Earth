import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_management/app/constans/app_constants.dart';

import '../features/dashboard/views/components/chat_popup.dart';

class ChattingCardData {
  final ImageProvider image;
  final bool isOnline;
  final String name;
  final String lastMessage;
  final bool isRead;
  final int totalUnread;

  const ChattingCardData({
    required this.image,
    required this.isOnline,
    required this.name,
    required this.lastMessage,
    required this.isRead,
    required this.totalUnread,
  });
}

class ChattingCard extends StatelessWidget {
  const ChattingCard({required this.data, required this.onPressed, Key? key})
      : super(key: key);

  final ChattingCardData data;
  final Function() onPressed;

  void _showPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pop-up Başlık'),
          content: const Text('Pop-up İçerik'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Pop-up'ı kapatmak için
              },
              child: const Text('Kapat'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: kSpacing),
          leading: Stack(
            children: [
              CircleAvatar(backgroundImage: data.image),
              CircleAvatar(
                backgroundColor: data.isOnline ? Colors.green : Colors.grey,
                radius: 5,
              ),
            ],
          ),
          title: Text(
            data.name,
            style: TextStyle(
              fontSize: 13,
              color: kFontColorPallets[0],
            ),
          ),
          subtitle: Text(
            data.lastMessage,
            style: TextStyle(
              fontSize: 11,
              color: kFontColorPallets[2],
            ),
          ),
          onTap: (){
            // _showPopup(context);
            showDialog(
              context: context,
              builder: (context) => const ChatPopup(
                messages: ['Gerginlik : 40 N', 'Eğim : 0.010', 'Home ID : 123456'],
              ),
            );
          },
          trailing: (!data.isRead && data.totalUnread > 1)
              ? _notif(data.totalUnread)
              : Icon(
                  Icons.check,
                  color: data.isRead ? Colors.grey : Colors.green,
                ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        const Divider(),
      ],
    );
  }

  Widget _notif(int total) {
    return Container(
      width: 30,
      height: 30,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Theme.of(Get.context!).primaryColor,
        borderRadius: BorderRadius.circular(15),
      ),
      alignment: Alignment.center,
      child: Text(
        (total >= 100) ? "99+" : "$total",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
