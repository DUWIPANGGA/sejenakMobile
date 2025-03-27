import 'package:flutter/material.dart';
import 'package:selena/app/components/sejenak_primary_button.dart';
import 'package:selena/app/components/sejenak_text.dart';
import 'package:selena/app/components/sejenak_text_field.dart';
import 'package:selena/app/partial/comunity/sejenak_comment_container.dart';
import 'package:selena/root/sejenak_color.dart';

class SejenakDetailPost {
  final int id;
  TextEditingController commentInput = TextEditingController();
  SejenakDetailPost({
    required this.id,
  });
  void showDetail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.3,
          maxChildSize: 1,
          builder: (_, controller) {
            return Stack(children: [
              Container(
                decoration: BoxDecoration(
                  color: SejenakColor.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: ListView(
                    controller: controller,
                    children: [
                      SizedBox(height: 18),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Icon(
                                Icons.cancel_outlined,
                                color: SejenakColor.secondary,
                              ),
                            )
                          ]),
                      SejenakText(
                        text: "lmao ini judul",
                        type: SejenakTextType.h4,
                        textAlign: TextAlign.left,
                      ),
                      Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, bottom: 8.0),
                            child: Expanded(
                              child: Row(
                                children: [
                                  ClipOval(
                                    child: Image.network(
                                      "https://images.unsplash.com/photo-1533050487297-09b450131914?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80",
                                      width: 35,
                                      height: 35,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SejenakText(
                                          text: "name",
                                          type: SejenakTextType.regular,
                                          maxLines: 1,
                                        ),
                                        SejenakText(
                                          text: "date",
                                          type: SejenakTextType.small,
                                          maxLines: 1,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          AspectRatio(
                            aspectRatio:
                                2 / 1.5, // 1:1 → tinggi sama dengan lebar
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                    "https://images.unsplash.com/photo-1533050487297-09b450131914?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80",
                                  ),
                                  fit: BoxFit.cover,
                                ),
                                border: Border.all(
                                    color: SejenakColor.dark, width: 2),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12.0)),
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          SejenakText(
                            text:
                                "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(height: 8),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SejenakCommentContainer(
                              postImage:
                                  "https://images.unsplash.com/photo-1533050487297-09b450131914?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80",
                              text:
                                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
                              name: "john sekejap",
                              date: "jan 9, 2022",
                              likes: 10,
                              comment: 0,
                              isLike: false,
                              isMe: false,
                              child: Column(
                                children: [
                                  SejenakCommentContainer(
                                    postImage:
                                        "https://images.unsplash.com/photo-1533050487297-09b450131914?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80",
                                    text:
                                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
                                    name: "john sekejap",
                                    date: "jan 9, 2022",
                                    likes: 10,
                                    comment: 0,
                                    isLike: false,
                                    isMe: false,
                                  ),
                                  SejenakCommentContainer(
                                    postImage:
                                        "https://images.unsplash.com/photo-1533050487297-09b450131914?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80",
                                    text:
                                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
                                    name: "john sekejap",
                                    date: "jan 9, 2022",
                                    likes: 10,
                                    comment: 0,
                                    isLike: false,
                                    isMe: false,
                                  ),
                                ],
                              ))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 0,
                    right: 0,
                    top: 0,
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Material(
                      elevation: 8,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        decoration: BoxDecoration(
                            color: SejenakColor.white,
                            border: Border(
                              top: BorderSide(
                                width: 1.0,
                                color: Colors.grey[900]!,
                              ),
                            )),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              bottom: 30.0, top: 15.0, left: 15.0, right: 15.0),
                          child: Row(
                            children: [
                              Expanded(
                                  child: SejenakTextField(
                                      text: 'tanggapi post',
                                      controller: commentInput)),
                              SizedBox(
                                width: 5,
                              ),
                              SejenakPrimaryButton(
                                text: "",
                                icon: "assets/svg/pen.svg",
                                action: () async {},
                              )
                            ],
                          ),
                        ),
                      )),
                ),
              ),
            ]);
          },
        );
      },
    );
  }
}
