import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:signup_app/create_post/cubit/create_post_cubit.dart';
import 'package:signup_app/create_post/tags/cubit/tag_cubit.dart';
import 'package:signup_app/create_post/tags/view/tag-widget.dart';
import 'package:signup_app/util/data_models.dart';
import 'package:signup_app/util/presets.dart';

import '../../util/presets.dart';

class CreatePostForm extends StatelessWidget {
  final Group group;
  CreatePostForm({this.group}) {
    if (group != null) {
      mandatoryFields['group'] = GroupInfo(id: group.id, name: group.name);
    }
  }
  //Ich glaube das ist eine schöne Lösung um um alle Text Ediding Controller rumzukommen
  final Map<String, dynamic> mandatoryFields = {
    'title': null,
    'about': null,
    'tags': []
  };

  final Map<String, dynamic> optionalFields = {
    'treffpunkt': null,
    'kosten': null,
  };

  final Map<String, dynamic> eventOnlyFields = {
    'maxPeople': -1,
  };

  final Map<String, dynamic> buddyOnlyFields = {};

  Future _showDialog(
      {@required context,
      @required Widget child,
      @required String title,
      @required Function onOkay}) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0.0,
              backgroundColor: AppThemeData.colorBase,
              child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Wrap(
                    children: [
                      Text(
                        title,
                        style: AppThemeData.textHeading3(),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 10, top: 10),
                        child: child,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          FlatButton(
                              onPressed: () => {Navigator.pop(context, null)},
                              child: Text("Abbrechen")),
                          FlatButton(onPressed: onOkay, child: Text("Ok"))
                        ],
                      )
                    ],
                  )));
        });
  }

  Future _showTextInputDialog(
      {@required context,
      String currentValue = "",
      List<TextInputFormatter> formatters}) {
    Function onOkay = () {
      print(currentValue);
      Navigator.pop(context, currentValue);
    };

    return _showDialog(
        context: context,
        title: "Maximale Teilmehmerzahl",
        child: Wrap(
          children: [
            TextFormField(
              initialValue: currentValue,
              onChanged: (text) {
                currentValue = text;
              },
              keyboardType: TextInputType.number,
              inputFormatters: formatters,
              decoration: Presets.getTextFieldDecorationHintStyle(),
            ),
          ],
        ),
        onOkay: onOkay);
  }

  Future _showCostDialog({@required context, @required int currentValue}) {
    return _showDialog(
        context: context,
        child: Text("Hallo"),
        title: "Kosten pro Person",
        onOkay: () => {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppThemeData.colorCard),
        backgroundColor: AppThemeData.colorPrimaryLight,
        title: Text(
          "Neuen Post erstellen",
          style: TextStyle(color: AppThemeData.colorTextInverted),
        ),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<CreatePostCubit, CreatePostState>(
            listener: (context, state) {
              //When Logged In -> Call Authetication Bloc with Logged in
              if (state.isSubmitted) {
                // !TODO navigate to the next screen
                Navigator.of(context).pop();
              }
              //In Error Case or name invalid Show Error Snackbar
              else if (state.isError) {
                Scaffold.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(const SnackBar(
                    content: Text('Bitte alle Felder ausfüllen'),
                  ));
              }
              //Show is Loading Snackbar
              else if (state.isSubmitting) {
                Scaffold.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(const SnackBar(
                    content: Text('wird veröffentlicht'),
                  ));
              }
            },
          ),
          BlocListener<TagCubit, TagState>(listener: (context, state) {
            List<String> tagList = [];
            state.tagMap.forEach(
              (key, value) {
                if (value == true) tagList.add(key);
              },
            );
            mandatoryFields['tags'] = tagList;
          })
        ],
        child: BlocBuilder<CreatePostCubit, CreatePostState>(
            builder: (context, state) {
          return SafeArea(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: 10),
                  color: AppThemeData.colorPrimaryLight,
                  child: Wrap(
                    runSpacing: 10,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: TextField(
                          onChanged: (text) {
                            mandatoryFields['title'] =
                                (text != null && text.length > 0) ? text : null;
                          },
                          decoration: Presets.getTextFieldDecorationHintStyle(
                              hintText: "Titel"),
                        ),
                      ),
                      // TODO change this to a 'chip'-style input
                      /* new TextFormField(
                        maxLines: null,
                        style: TextStyle(color: Colors.white),
                        decoration: Presets.getTextFieldDecorationHintStyle(
                            hintText: "Tags / Kategorien",
                            fillColor: AppThemeData.colorBlackTrans,
                            hintColor: AppThemeData.colorCard),
                      ),*/
                      TagWidget(),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Wrap(
                          runSpacing: 10,
                          children: [
                            FractionallySizedBox(
                              widthFactor: 0.5,
                              child: FlatButton.icon(
                                textColor: AppThemeData.colorFormField,
                                onPressed: () {
                                  showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2025),
                                  ).then((value) {
                                    BlocProvider.of<CreatePostCubit>(context)
                                        .updateDate(value);
                                  });
                                },
                                icon: Icon(Icons.calendar_today),
                                label: Expanded(
                                  child: Text(
                                      state.eventDate != null
                                          ? DateFormat('dd.MM.yyyy')
                                              .format(state.eventDate)
                                          : "Datum",
                                      style: AppThemeData.textFormField()),
                                ),
                              ),
                            ),
                            FractionallySizedBox(
                              widthFactor: 0.5,
                              child: FlatButton.icon(
                                textColor: AppThemeData.colorFormField,
                                onPressed: () {
                                  showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now())
                                      .then((value) {
                                    BlocProvider.of<CreatePostCubit>(context)
                                        .updateTime(value);
                                  });
                                },
                                icon: Icon(Icons.access_time),
                                label: Expanded(
                                  child: Text(
                                    state.eventTime != null
                                        ? state.eventTime.format(context)
                                        : "Startzeit",
                                    style: AppThemeData.textFormField(),
                                  ),
                                ),
                              ),
                            ),
                            new TextFormField(
                              onChanged: (text) {
                                mandatoryFields['about'] =
                                    (text != null && text.length > 0)
                                        ? text
                                        : null;
                              },
                              minLines: 3,
                              maxLines: null,
                              decoration:
                                  Presets.getTextFieldDecorationHintStyle(
                                      hintText: "Beschreibung:"),
                            ),
                            SizedBox(
                              height: 80,
                            ),
                            /*Text("Weitere Freiwillige Angaben"),*/
                            new TextFormField(
                              onChanged: (text) {
                                optionalFields['treffpunkt'] =
                                    (text != null && text.length > 0)
                                        ? text
                                        : null;
                              },
                              decoration:
                                  Presets.getTextFieldDecorationLabelStyle(
                                      labelText: "Treffpunkt"),
                            ),
                            FractionallySizedBox(
                              widthFactor: 0.5,
                              child: FlatButton.icon(
                                textColor: eventOnlyFields['maxPeople'] >= 0
                                    ? AppThemeData.colorControls
                                    : AppThemeData.colorControlsDisabled,
                                onPressed: () {
                                  _showTextInputDialog(
                                      context: context,
                                      formatters: [
                                        WhitelistingTextInputFormatter
                                            .digitsOnly
                                      ]).then((value) {
                                    print(value + "value");
                                    eventOnlyFields['maxPeople'] =
                                        (value != null && value.length > 0)
                                            ? int.parse(value)
                                            : -1;
                                  });
                                },
                                icon: Icon(Icons.group),
                                label: Expanded(
                                  child: Text(
                                    eventOnlyFields["maxPeople"] < 0
                                        ? "unbegrenzt"
                                        : eventOnlyFields["maxPeople"]
                                            .toString(),
                                    style:
                                        AppThemeData.textFormField(color: null),
                                  ),
                                ),
                              ),
                            ),
                            FractionallySizedBox(
                              widthFactor: 0.5,
                              child: FlatButton.icon(
                                textColor: AppThemeData.colorFormField,
                                onPressed: () {
                                  _showCostDialog(
                                      context: context, currentValue: -1);
                                },
                                icon: Icon(Icons.euro_symbol),
                                label: Expanded(
                                  child: Text(
                                      optionalFields["kosten"] == null
                                          ? "keine Kosten"
                                          : optionalFields["kosten"].toString(),
                                      style: AppThemeData.textFormField()),
                                ),
                              ),
                            ),
                            /*new TextFormField(
                              onChanged: (text) {
                                eventOnlyFields['maxPeople'] =
                                    (text != null && text.length > 0)
                                        ? int.parse(text)
                                        : -1;
                              },
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: Presets.getTextFieldDecorationLabelStyle(
                                  labelText:
                                      "max. Anzahl (leer lassen für unbegrenzt)"),
                            ),*/

                            /*new TextFormField(
                              onChanged: (text) {
                                optionalFields['kosten'] =
                                    (text != null && text.length > 0)
                                        ? text
                                        : null;
                              },
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration:
                                  Presets.getTextFieldDecorationLabelStyle(
                                      labelText: "Kosten"),
                            ),*/
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("submit pressed");
          BlocProvider.of<CreatePostCubit>(context).submit(
              mandatoryFields: mandatoryFields,
              optionalFields: optionalFields,
              eventOnlyFields: eventOnlyFields);
        },
        child: Icon(
          Icons.send,
          color: AppThemeData.colorCard,
        ),
      ),
    );
  }
}
