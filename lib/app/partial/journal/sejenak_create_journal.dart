import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:image_picker/image_picker.dart';
import 'package:selena/app/components/sejenak_primary_button.dart';
import 'package:selena/app/components/sejenak_text.dart';
import 'package:selena/root/sejenak_color.dart';

class SejenakCreateJournal {
  final ImagePicker _picker = ImagePicker();
  File? image;
  final TextEditingController data = TextEditingController();
  final headingList = [
    quill.Attribute.h1,
    quill.Attribute.h2,
    quill.Attribute.h3,
    quill.Attribute.h4,
    quill.Attribute.h5,
  ];
  SejenakCreateJournal();

  void showCreateContainer(BuildContext context) {
    final quill.QuillController _quillController =
        quill.QuillController.basic();
    final FocusNode _focusNode = FocusNode();
    final ScrollController _scrollController = ScrollController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            _quillController.addListener(() {
              setState(() {});
            });

            return Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: SejenakColor.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: SafeArea(
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        children: [
                          SizedBox(height: 18),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Icon(
                                  Icons.cancel_outlined,
                                  color: SejenakColor.secondary,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          TextField(
                            controller: data,
                            maxLines: null,
                            decoration: InputDecoration(
                              hintText: "Judul...",
                              hintStyle: TextStyle(
                                fontSize: 28.48,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Exo2',
                                color: SejenakColor.secondary,
                                wordSpacing: 0.4,
                              ),
                              border: InputBorder.none,
                            ),
                            style: TextStyle(
                              fontSize: 28.48,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Exo2',
                              color: SejenakColor.secondary,
                              wordSpacing: 0.4,
                            ),
                          ),
                          SizedBox(height: 10),
                          Stack(
                            children: [
                              quill.QuillEditor(
                                controller: _quillController,
                                focusNode: _focusNode,
                                scrollController: _scrollController,
                              ),
                              IgnorePointer(
                                child: AnimatedOpacity(
                                  opacity: _quillController.document
                                          .toPlainText()
                                          .trim()
                                          .isEmpty
                                      ? 1.0
                                      : 0.0,
                                  duration: Duration(milliseconds: 200),
                                  child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 0, left: 0),
                                      child: SejenakText(
                                        text: "tulis sesuatu",
                                        type: SejenakTextType.regular,
                                      )),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 80),
                        ],
                      ),
                    ),

                    // Bottom toolbar
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                        ),
                        child: Material(
                          elevation: 8,
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            decoration: BoxDecoration(
                              color: SejenakColor.primary,
                              border: Border(
                                top: BorderSide(
                                  width: 1.0,
                                  color: Colors.grey[900]!,
                                ),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 15.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: List.generate(
                                  headingList.length,
                                  (index) => GestureDetector(
                                    onTap: () {
                                      _quillController
                                          .formatSelection(headingList[index]);
                                    },
                                    child: SejenakText(
                                      text: "H${index + 1}",
                                      type: SejenakTextType.regular,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                        bottom: 100,
                        left: 0,
                        right: 5,
                        child: Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  if (image != null)
                                    Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 1.0,
                                          color: Colors.grey[900]!,
                                        ),
                                        color: SejenakColor.secondary,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          const BoxShadow(
                                            color: SejenakColor.black,
                                            spreadRadius: 0.2,
                                            blurRadius: 0,
                                            offset: Offset(0.1, 4),
                                          ),
                                        ],
                                        image: DecorationImage(
                                          image: FileImage(image!),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    child: SejenakPrimaryButton(
                                        width: 60,
                                        height: 60,
                                        text: "",
                                        action: () async {
                                          final pickedFile =
                                              await _picker.pickImage(
                                                  source: ImageSource.gallery);
                                          if (pickedFile != null) {
                                            setState(() {
                                              image = File(pickedFile.path);
                                            });
                                          }
                                        },
                                        icon: "assets/svg/camera.svg"),
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    child: SejenakPrimaryButton(
                                        width: 60,
                                        height: 60,
                                        text: "",
                                        action: () async {},
                                        icon: "assets/svg/pen.svg"),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ))
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
