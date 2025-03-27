import 'package:flutter/material.dart';
import 'package:selena/app/component/sejenak_text.dart';
import 'package:selena/root/sejenak_color.dart';

class SejenakJournalList extends StatefulWidget {
  final String title;
  final String text;
  final String fontStyle;
  final String image;
  final Color color;
  final double fontSize;
  final Future<void> Function() action;

  const SejenakJournalList({
    super.key,
    required this.title,
    required this.text,
    required this.action,
    this.image = '',
    this.color = SejenakColor.primary,
    this.fontStyle = 'Lexend',
    this.fontSize = 14.24,
  });

  @override
  _SejenakJournalListState createState() => _SejenakJournalListState();
}

class _SejenakJournalListState extends State<SejenakJournalList> {
  bool click = false;
  double opacity = 1.0;
  double offsetY = 0.0;

  Future<void> _onclick() async {
    setState(() {
      click = true;
      opacity = 0.6;
      offsetY = 4.0;
    });

    await Future.delayed(const Duration(milliseconds: 200));

    setState(() {
      click = false;
      opacity = 1.0;
      offsetY = 0.0;
    });
    await widget.action();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onclick,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 150),
        opacity: opacity,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: Transform.translate(
            offset: Offset(0, offsetY),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1.0,
                  color: Colors.grey[900]!,
                ),
                color: widget.color,
                borderRadius: BorderRadius.circular(10),
                boxShadow: !click
                    ? [
                        const BoxShadow(
                          color: SejenakColor.black,
                          spreadRadius: 0.2,
                          blurRadius: 0,
                          offset: Offset(0.1, 4),
                        ),
                      ]
                    : [],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SejenakText(
                          text: widget.title,
                          type: SejenakTextType.h5,
                          maxLines: 1,
                        ),
                        SejenakText(
                          text: widget.text,
                          type: SejenakTextType.regular,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                        color: widget.color,
                        image: DecorationImage(
                          image: NetworkImage(
                            widget.image,
                          ),
                          fit: BoxFit.cover,
                        ),
                        border:
                            Border.all(width: 2.0, color: SejenakColor.stroke),
                        borderRadius: BorderRadius.circular(5)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
