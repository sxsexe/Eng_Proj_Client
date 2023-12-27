import 'package:flutter/material.dart';
import 'package:my_eng_program/data/word.dart';

class WordDetailCard extends StatelessWidget {
  final Word? word;
  WordDetailCard({super.key, required this.word});

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
          Container(
            padding: EdgeInsets.fromLTRB(40, 5, 40, 5),
            color: Colors.orange,
            child: Text(
              nonName,
              style: TextStyle(fontSize: 48),
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
          child: Text(wordTxt, style: TextStyle(fontSize: 30, color: Colors.black)),
        ),
        SizedBox(width: 6),
        Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Text(
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
              SizedBox(width: 10),
              Text("US"),
              Icon(
                Icons.volume_up,
                size: 32,
              )
            ],
          ),
        if (audioUK.isNotEmpty)
          Row(
            children: [SizedBox(width: 20), Text("UK"), Icon(Icons.volume_up_rounded, size: 32)],
          )
      ],
    );
  }

  Divider _createDividerLine() {
    return Divider(height: 1, color: Colors.orange, thickness: 2);
  }

  Column _createOneDefineWidget(Define oneDef, bool isPhrase) {
    List<Widget> _lstSubWidgets = [];

    String transCH = oneDef.transCh ?? "";
    String transEN = oneDef.transEn ?? "";
    String text = oneDef.text ?? "";

    if (isPhrase) {
      _lstSubWidgets.add(Text(
        text,
        style: TextStyle(color: Colors.cyan, fontSize: 18),
      ));
    }
    _lstSubWidgets.add(SizedBox(height: 20));
    _lstSubWidgets.add(_createDividerLine());
    _lstSubWidgets.add(SizedBox(height: 20));
    _lstSubWidgets.add(Row(
      children: [
        if (transEN.isNotEmpty)
          Expanded(
              child: Text(
            transEN,
            style: TextStyle(fontSize: 18, color: Colors.black),
          ))
      ],
    ));
    _lstSubWidgets.add(SizedBox(height: 8));
    _lstSubWidgets.add(Row(
      children: [
        if (transCH.isNotEmpty)
          Expanded(
            child: Text(
              transCH,
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
          )
      ],
    ));

    if (oneDef.examples!.isNotEmpty) {
      oneDef.examples!.forEach((oneExample) {
        String ch = oneExample.ch ?? "";
        String en = oneExample.en ?? "";
        _lstSubWidgets.add(Container(
          margin: const EdgeInsets.all(18.0),
          color: Colors.grey,
          child: Column(
            children: [
              Row(children: [
                Icon(Icons.point_of_sale_rounded),
                SizedBox(
                  width: 20,
                ),
                Expanded(child: Text(en))
              ]),
              Row(children: [
                Icon(Icons.point_of_sale_rounded),
                SizedBox(
                  width: 20,
                ),
                Expanded(child: Text(ch))
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

      Container container = Container(
        width: double.infinity,
        color: Colors.blue,
        margin: EdgeInsets.all(40),
        child: Column(
          children: _allSubWidgets,
        ),
      );

      children.add(container);
    });

    return children;
  }
}
