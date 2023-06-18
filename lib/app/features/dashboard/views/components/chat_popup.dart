import 'package:flutter/material.dart';

class ChatPopup extends StatelessWidget {
  final List<String> messages;

  const ChatPopup({required this.messages, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.2, // Genişliği daraltma
          height:MediaQuery.of(context).size.height*0.3 ,
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Okunmayan Mesajlar',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16.0),
              Expanded(
                child: ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    bool isMe = index % 2 == 0; // Sıralı mesaj balonlarını farklı taraflarda yerleştirme
                    return Container(
                      alignment: isMe ? Alignment.center : Alignment.center,
                      margin: EdgeInsets.symmetric(vertical: 4.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.180,
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.blue : Colors.blue,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          messages[index],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
