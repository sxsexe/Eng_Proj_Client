import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_eng_program/data/word.dart';
import 'package:my_eng_program/util/audio_player.dart';
import 'package:my_eng_program/util/logger.dart';
import 'package:my_eng_program/util/strings.dart';

class WordDetailCard extends StatefulWidget {
  final Word word;
  WordDetailCard({super.key, required this.word});

  @override
  State<StatefulWidget> createState() => _WordDetailState();
}

class _WordDetailState extends State<WordDetailCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: SingleChildScrollView(
                child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _createGenderWrapperWidgetList(),
        ))),
        _createOpButtons(),
      ],
    );
  }

  Widget _createOpButtons() {
    var btnTxtStyle = Theme.of(context).textTheme.displaySmall!.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.primary,
        );
    return Container(
      color: Theme.of(context).colorScheme.tertiaryContainer,
      height: 80,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        ElevatedButton(
          onPressed: () {},
          style: Theme.of(context).elevatedButtonTheme.style,
          child: Container(
            child: Text("不记得了", style: btnTxtStyle),
            padding: EdgeInsets.symmetric(vertical: 12),
          ),
        ),
        ElevatedButton(
          onPressed: () {},
          style: Theme.of(context).elevatedButtonTheme.style,
          child: Container(
            child: Text("模模糊糊", style: btnTxtStyle),
            padding: EdgeInsets.symmetric(vertical: 12),
          ),
        ),
        ElevatedButton(
          onPressed: () {},
          style: Theme.of(context).elevatedButtonTheme.style,
          child: Container(
            child: Text("So Easy", style: btnTxtStyle),
            padding: EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ]),
    );
  }

  Row _createGenderTitle(GenderDetail detail) {
    String genderName = detail.genderName ?? "";
    String wordTxt = detail.text ?? "";

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(width: 6),
        Text(
          wordTxt,
          style: Theme.of(context).textTheme.displayLarge!.copyWith(color: Theme.of(context).colorScheme.primary),
        ),
        SizedBox(width: 12),
        Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Text(
            genderName,
            style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.secondary),
          ),
        )
      ],
    );
  }

  Widget _createAudioWidgets(GenderDetail detail) {
    String audioUK = detail.uKAudio ?? "";
    String audioUS = detail.uSAudio ?? "";

    const double iconSize = 20;

    if (audioUK.isEmpty && audioUS.isEmpty) {
      return SizedBox();
    }

    return Row(
      children: [
        if (audioUS.isNotEmpty)
          InkWell(
            onTap: () {
              //FIXME
              Logger.debug("WordDetailCard", "audioUS=$audioUS");
              if (Platform.isAndroid || Platform.isIOS) {
                AudioPlayerUtil.getInstance()
                    .play(audioUS)
                    .then((value) => Logger.debug("WordDetail", "play mp3 value=$value"));
              }
            },
            child: Row(
              children: [
                SizedBox(width: 8),
                Text("US",
                    style:
                        Theme.of(context).textTheme.labelSmall!.copyWith(color: Theme.of(context).colorScheme.primary)),
                Icon(Icons.volume_up_rounded, size: iconSize)
              ],
            ),
          ),
        if (audioUK.isNotEmpty)
          InkWell(
            onTap: () {
              //FIXME
              Logger.debug("WordDetailCard", "audioUK=$audioUK");
              if (Platform.isAndroid || Platform.isIOS) {
                AudioPlayerUtil.getInstance()
                    .play(audioUS)
                    .then((value) => Logger.debug("WordDetail", "play mp3 value=$value"));
              }
            },
            child: Row(
              children: [
                SizedBox(width: 24),
                Text("UK",
                    style:
                        Theme.of(context).textTheme.labelSmall!.copyWith(color: Theme.of(context).colorScheme.primary)),
                Icon(Icons.volume_up_rounded, size: iconSize)
              ],
            ),
          )
      ],
    );
  }

  Divider _createDividerLine() {
    return Divider(height: 1, color: Theme.of(context).colorScheme.secondaryContainer, thickness: 1);
  }

  Column _createOneDefineWidget(Define oneDef, bool isPhrase) {
    List<Widget> _lstSubWidgets = [];

    String transCH = oneDef.transCh ?? "";
    String transEN = oneDef.transEn ?? "";
    String text = oneDef.text ?? "";

    if (isPhrase) {
      _lstSubWidgets.add(SizedBox(height: 16));
      _lstSubWidgets.add(Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.keyboard_double_arrow_right,
            color: Theme.of(context).colorScheme.secondary,
          ),
          SizedBox(width: 10),
          SelectableText(
            text,
            style: TextStyle(
              color: Theme.of(context).indicatorColor,
              fontSize: 20,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ));
    }
    _lstSubWidgets.add(SizedBox(height: 12));
    _lstSubWidgets.add(_createDividerLine());
    _lstSubWidgets.add(SizedBox(height: 8));
    _lstSubWidgets.add(Row(
      children: [
        SizedBox(width: 8),
        Text(
          Strings.LABEL_WORD_DEFINE,
          style: Theme.of(context).textTheme.labelSmall!.copyWith(color: Theme.of(context).colorScheme.secondary),
        ),
      ],
    ));

    if (transEN.isNotEmpty) {
      _lstSubWidgets.add(Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SelectableText(
                transEN,
                contextMenuBuilder: (context, state) {
                  final List<ContextMenuButtonItem> buttonItems = state.contextMenuButtonItems;
                  buttonItems.insert(
                      0,
                      ContextMenuButtonItem(
                        label: 'Send email',
                        onPressed: () => Logger.debug("tag", "message"),
                      ));

                  return AdaptiveTextSelectionToolbar.buttonItems(
                      buttonItems: buttonItems, anchors: state.contextMenuAnchors);
                },
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic),
              ),
            ),
          )
        ],
      ));
    }

    if (transCH.isNotEmpty) {
      _lstSubWidgets.add(SizedBox(height: 6));
      _lstSubWidgets.add(
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  transCH,
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                ),
              ),
            )
          ],
        ),
      );
    }

    if (oneDef.examples!.isNotEmpty) {
      SizedBox margin = SizedBox(width: 4);
      oneDef.examples!.forEach((oneExample) {
        String ch = oneExample.ch ?? "";
        String en = oneExample.en ?? "";
        _lstSubWidgets.add(Card(
          margin: const EdgeInsets.all(18.0),
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Column(
            children: [
              SizedBox(height: 10),
              Row(children: [
                Icon(Icons.arrow_right),
                margin,
                Expanded(
                    child: SelectableText(en,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                            )))
              ]),
              SizedBox(height: 8),
              Row(children: [
                Icon(Icons.arrow_right),
                margin,
                Expanded(
                    child: Text(ch,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 16,
                            )))
              ]),
              SizedBox(height: 10),
            ],
          ),
        ));
      });
    }

    _lstSubWidgets.add(SizedBox(height: 20));

    return Column(children: _lstSubWidgets);
  }

  List<Widget> _createGenderWrapperWidgetList() {
    List<Widget> children = [];

    widget.word.listGenderDetails.forEach((genderDetail) {
      List<Widget> _allSubWidgets = [];
      Row _title = _createGenderTitle(genderDetail);
      Widget _audio = _createAudioWidgets(genderDetail);
      _allSubWidgets.add(_title);
      _allSubWidgets.add(SizedBox(height: 20));
      _allSubWidgets.add(_audio);

      //TODO alters

      // defines
      if (genderDetail.defines!.isNotEmpty) {
        genderDetail.defines!.forEach((oneDef) {
          _allSubWidgets.add(_createOneDefineWidget(oneDef, false));
        });
      }

      // Phrases
      if (genderDetail.phrases!.isNotEmpty) {
        genderDetail.phrases!.forEach((oneDef) {
          _allSubWidgets.add(_createOneDefineWidget(oneDef, true));
        });
      }

      children.add(Card(
        color: Theme.of(context).colorScheme.background,
        // shadowColor: Color.fromARGB(255, 226, 2, 2),
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        margin: EdgeInsets.all(12),
        child: Column(
          children: _allSubWidgets,
        ),
      ));
    });

    return children;
  }
}
