import 'dart:developer';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kaidzen_app/feedback/MoreFeedbackScreen.dart';
import 'dart:math';

import '../assets/constants.dart';
import '../main.dart';

class EmailSender extends StatefulWidget {
  const EmailSender({Key? key}) : super(key: key);

  @override
  _EmailSenderState createState() => _EmailSenderState();
}

class _EmailSenderState extends State<EmailSender> {
  List<String> attachments = [];
  bool _isSendButtonActive = false;
  late TextEditingController _bodyController;

  @override
  void initState() {
    super.initState();
    _bodyController = TextEditingController();
    _bodyController.addListener(() {
      setState(() {
        _isSendButtonActive = _bodyController.text.isNotEmpty;
      });
    });
  }

  Future<void> send(BuildContext context) async {
    final Email email = Email(
      body: _bodyController.text,
      subject: "Sticky Goals App Feedback",
      recipients: ["funworkstudio.helper@gmail.com"],
      attachmentPaths: attachments,
      isHTML: false,
    );

    try {
      await FlutterEmailSender.send(email);
      if (!mounted) return;
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const MoreFeedbackScreen()));
    } catch (error) {
      showModalBottomSheet<void>(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        builder: (BuildContext context) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: Center(
              child: Column(
                children: <Widget>[
                  Expanded(
                      child: Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Text('Ooops :(',
                              style: Fonts.screenTytleTextStyle)),
                      flex: 1),
                  const Expanded(child: SizedBox(), flex: 1),
                  Expanded(
                      child: Column(children: [
                        Text("Please, send feedback directly to",
                            style: Fonts.largeTextStyle),
                        InkWell(
                          child: Text("funworkstudio.helper@gmail.com",
                              style: Fonts.largeTextStyle.copyWith(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline)),
                          onTap: () async {
                            await FlutterClipboard.copy(
                                "funworkstudio.helper@gmail.com");
                          },
                        )
                      ]),
                      flex: 5)
                ],
              ),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Expanded(
                child: Row(children: [
                  GestureDetector(
                    child: SvgPicture.asset("assets/shevron-left-black.svg"),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  Text('Send feedback', style: Fonts.screenTytleTextStyle),
                  GestureDetector(
                    child: SvgPicture.asset(
                        "assets/settings/close_black_icon.svg"),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomeScreen()));
                    },
                  )
                ], mainAxisAlignment: MainAxisAlignment.spaceBetween),
                flex: 2),
            Expanded(
                child: Padding(
                    child: Align(
                        child: Text(
                            "Your feedback help us make the\napplication better. Any thought matter.",
                            style: Fonts.largeTextStyle),
                        alignment: Alignment.centerLeft),
                    padding: const EdgeInsets.all(8.0)),
                flex: 3),
            Expanded(
                child: TextField(
                  controller: _bodyController,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(117, 30, 132, 1))),
                      hintStyle: Fonts.inputHintTextStyle),
                ),
                flex: 6),
            Expanded(
                child: Column(
                  children: <Widget>[
                    Visibility(
                        visible: attachments.isNotEmpty,
                        child: Expanded(
                            child: ListView.builder(
                                itemCount: attachments.length,
                                itemBuilder: (context, i) {
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Expanded(
                                        child: Text(
                                          attachments[i].split("/").last,
                                          softWrap: false,
                                          overflow: TextOverflow.fade,
                                        ),
                                      ),
                                      IconButton(
                                        icon: Image.asset("assets/delete.png"),
                                        onPressed: () => {_removeAttachment(i)},
                                      )
                                    ],
                                  );
                                }),
                            flex: min(attachments.length + 1, 3))),
                    Expanded(
                        child: Row(children: [
                          IconButton(
                            icon:
                                SvgPicture.asset("assets/settings/attach.svg"),
                            color: Colors.black,
                            onPressed: _openImagePicker,
                          ),
                          InkWell(
                              child: Text('Attach screenshot or video',
                                  style: Fonts.largeTextStyle.copyWith(
                                      decoration: TextDecoration.underline)),
                              onTap: _openImagePicker)
                        ]),
                        flex: max(1, 4 - attachments.length)),
                  ],
                ),
                flex: 6),
            Expanded(
                child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isSendButtonActive
                              ? () async {
                                  await send(context);
                                }
                              : null,
                          child: Text('Send',
                              style: _isSendButtonActive
                                  ? Fonts.largeTextStyle20
                                      .copyWith(color: Colors.white)
                                  : Fonts.largeTextStyle20),
                          style: ElevatedButton.styleFrom(
                              primary: _isSendButtonActive
                                  ? activeButtonColor
                                  : unselectedToggleColor),
                        ))),
                flex: 2)
          ],
        ),
      ),
    );
  }

  void _openImagePicker() async {
    final picker = ImagePicker();
    PickedFile? pick = await picker.getImage(source: ImageSource.gallery);
    if (pick != null) {
      setState(() {
        attachments.add(pick.path);
      });
    }
  }

  void _removeAttachment(int index) {
    setState(() {
      attachments.removeAt(index);
    });
  }
}
