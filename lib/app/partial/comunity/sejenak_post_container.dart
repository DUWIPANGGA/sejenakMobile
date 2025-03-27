import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:selena/app/components/sejenak_text.dart';
import 'package:selena/root/sejenak_color.dart';

class SejenakPostContainer extends StatelessWidget {
  final String title;
  final String text;
  final String name;
  final String date;
  final String postImage;
  final int likes;
  final bool isLike;
  final bool isMe;
  final int comment;
  final VoidCallback commentAction;
  const SejenakPostContainer(
      {super.key,
      required this.title,
      required this.text,
      this.name = 'anonimus',
      this.date = 'jan 1, 2000',
      this.postImage = '',
      this.likes = 0,
      this.comment = 0,
      this.isLike = false,
      required this.commentAction,
      this.isMe = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 5, bottom: 5),
      width: double.maxFinite,
      decoration: BoxDecoration(
          color: SejenakColor.primary,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            width: 1.0,
            color: Colors.grey[900]!,
          ),
          boxShadow: const [
            BoxShadow(
              color: SejenakColor.black,
              spreadRadius: 0.4,
              blurRadius: 0,
              offset: Offset(
                0.3,
                4,
              ),
            ),
          ]),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SejenakText(
                        text: title,
                        type: SejenakTextType.h5,
                        textAlign: TextAlign.left,
                      ),
                      SejenakText(
                        text: text.length > 100
                            ? "${text.substring(0, 100)}..."
                            : text,
                        type: SejenakTextType.small,
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 110,
                width: 113,
                child: Stack(
                  children: [
                    Image.network(
                      postImage,
                      width: 79,
                      height: 78,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: -15,
                      left: -20,
                      child: SvgPicture.asset(
                        'assets/svg/frame_post.svg',
                        width: 119,
                        height: 113,
                        colorFilter: ColorFilter.mode(
                            SejenakColor.primary, BlendMode.srcIn),
                      ),
                    ),
                    Positioned(
                      top: 60,
                      child: SvgPicture.asset(
                        'assets/svg/stample.svg',
                        width: 85,
                        height: 30,
                      ),
                    )
                  ],
                ),
              ),
            ]),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Bagian profil + nama
                  Expanded(
                    child: Row(
                      children: [
                        ClipOval(
                          child: Image.network(
                            postImage,
                            width: 30,
                            height: 30,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SejenakText(
                                text: name,
                                type: SejenakTextType.regular,
                                maxLines: 1,
                              ),
                              SejenakText(
                                text: date,
                                type: SejenakTextType.small,
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        'assets/svg/like.svg',
                        width: 20,
                        height: 20,
                        colorFilter: isLike
                            ? ColorFilter.mode(
                                SejenakColor.secondary, BlendMode.srcIn)
                            : ColorFilter.mode(
                                SejenakColor.stroke, BlendMode.srcIn),
                      ),
                      SizedBox(width: 4),
                      Text(
                        likes.toString(),
                        style: TextStyle(
                            fontFamily: "Exo2",
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),

                  SizedBox(width: 12),

                  // Icon comment

                  GestureDetector(
                    onTap: commentAction,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          'assets/svg/comment.svg',
                          width: 20,
                          height: 20,
                          colorFilter: ColorFilter.mode(
                              SejenakColor.stroke, BlendMode.srcIn),
                        ),
                        SizedBox(width: 4),
                        Text(
                          comment.toString(),
                          style: TextStyle(
                              fontFamily: "Exo2",
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(width: 8),

                  // Hamburger menu
                  SvgPicture.asset(
                    'assets/svg/humberger_menu.svg',
                    width: 23,
                    height: 23,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
