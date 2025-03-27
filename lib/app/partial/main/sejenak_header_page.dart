import 'package:flutter/material.dart';
import 'package:selena/app/components/sejenak_text.dart';

class SejenakHeaderPage extends StatelessWidget {
  final String? text;
  const SejenakHeaderPage({super.key, this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          SizedBox(
            height: 63,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SejenakText(
                text: this.text ?? "",
                type: SejenakTextType.h3,
              ),
              Builder(
                builder: (context) => GestureDetector(
                  onTap: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.black,
                    child: CircleAvatar(
                      radius: 24,
                      backgroundImage:
                          NetworkImage('https://i.pravatar.cc/150?img=3'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
