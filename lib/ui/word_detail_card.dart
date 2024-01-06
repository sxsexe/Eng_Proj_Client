import 'package:flutter/material.dart';
import 'package:my_eng_program/data/word.dart';
import 'package:my_eng_program/util/logger.dart';

// ignore: must_be_immutable
class WordDetailCard extends StatelessWidget {
  final Word? word;

  late BuildContext context;
  WordDetailCard({super.key, required this.context, required this.word});

  @override
  Widget build(BuildContext context) {
    String? name = word!.name;
    String nonName = name ?? "";
    if (word!.ID == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 8),
          if (nonName.isNotEmpty)
            Card(
              color: Theme.of(context).colorScheme.primary,
              shadowColor: Color.fromARGB(255, 181, 166, 155),
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 2, horizontal: 32),
                child: SelectableText(
                  textAlign: TextAlign.center,
                  nonName,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: Theme.of(context).textTheme.displayLarge!.fontSize),
                ),
              ),
            ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _createGenderWrapperWidgetList(),
          )
        ],
        mainAxisAlignment: MainAxisAlignment.start,
      ),
    );
  }

  Row _createGenderTitle(GenderDetail detail) {
    String genderName = detail.genderName ?? "";
    String wordTxt = detail.text ?? "";

    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: SelectableText(wordTxt,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondary,
                  fontSize: Theme.of(context).textTheme.titleLarge!.fontSize)),
        ),
        SizedBox(width: 6),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: SelectableText(
            genderName,
            style: TextStyle(fontSize: 16, color: Colors.black26),
          ),
        )
      ],
    );
  }

  Widget _createAudioWidgets(GenderDetail detail) {
    String audioUK = detail.uKAudio ?? "";
    String audioUS = detail.uSAudio ?? "";

    if (audioUK.isEmpty && audioUS.isEmpty) {
      return SizedBox();
    }

    return Row(
      children: [
        if (audioUS.isNotEmpty)
          Row(
            children: [
              SizedBox(width: 8),
              Text(
                "US",
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
              Icon(
                Icons.volume_up_rounded,
                size: 32,
              )
            ],
          ),
        if (audioUK.isNotEmpty)
          Row(
            children: [
              SizedBox(width: 24),
              Text("UK", style: TextStyle(fontStyle: FontStyle.italic)),
              Icon(Icons.volume_up_rounded, size: 32)
            ],
          )
      ],
    );
  }

  Divider _createDividerLine() {
    return Divider(height: 1, color: Theme.of(context).dividerColor, thickness: 1);
  }

  Column _createOneDefineWidget(Define oneDef, bool isPhrase) {
    List<Widget> _lstSubWidgets = [];

    String transCH = oneDef.transCh ?? "";
    String transEN = oneDef.transEn ?? "";
    String text = oneDef.text ?? "";

    if (isPhrase) {
      _lstSubWidgets.add(SizedBox(height: 16));
      _lstSubWidgets.add(Row(
        children: [
          Icon(
            Icons.keyboard_double_arrow_right,
            color: Colors.red,
          ),
          Text(
            text,
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontSize: 18, fontWeight: FontWeight.w600),
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
          "释义 : ",
          style: TextStyle(fontSize: 18, color: Colors.blueGrey),
        ),
      ],
    ));
    _lstSubWidgets.add(Row(
      children: [
        if (transEN.isNotEmpty)
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
              style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ))
      ],
    ));
    // _lstSubWidgets.add(SizedBox(height: 2));
    _lstSubWidgets.add(Row(
      children: [
        if (transCH.isNotEmpty)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                transCH,
                style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSecondary),
              ),
            ),
          )
      ],
    ));

    if (oneDef.examples!.isNotEmpty) {
      SizedBox margin = SizedBox(width: 4);
      oneDef.examples!.forEach((oneExample) {
        String ch = oneExample.ch ?? "";
        String en = oneExample.en ?? "";
        _lstSubWidgets.add(Card(
          margin: const EdgeInsets.all(18.0),
          color: Color.fromARGB(255, 206, 207, 202),
          child: Column(
            children: [
              Row(children: [
                Icon(Icons.arrow_right),
                margin,
                Expanded(child: Text(en, style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic)))
              ]),
              SizedBox(
                height: 4,
              ),
              Row(children: [
                Icon(Icons.arrow_right),
                margin,
                Expanded(child: Text(ch, style: TextStyle(fontSize: 16, color: Colors.black)))
              ])
            ],
          ),
        ));
      });
    }

    // _lstSubWidgets.add

    return Column(children: _lstSubWidgets);
  }

  List<Widget> _createGenderWrapperWidgetList() {
    List<Widget> children = [];

    word!.listGenderDetails.forEach((genderDetail) {
      List<Widget> _allSubWidgets = [];
      Row _title = _createGenderTitle(genderDetail);
      Widget _audio = _createAudioWidgets(genderDetail);
      _allSubWidgets.add(_title);
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
        color: Theme.of(context).colorScheme.secondary,
        shadowColor: Color.fromARGB(255, 181, 166, 155),
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Column(
          children: _allSubWidgets,
        ),
      ));
    });

    return children;
  }
}
