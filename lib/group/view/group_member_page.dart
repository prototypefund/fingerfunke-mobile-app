import 'package:flutter/material.dart';
import 'package:signup_app/create_post/view/create_post_page.dart';
import 'package:signup_app/group/cubit/group_cubit.dart';
import 'package:signup_app/group/groupSettings/view/group_settings_page.dart';
import 'package:signup_app/postList/baseClass/post_list_widget.dart';
import 'package:signup_app/postList/implementations/filterablePostList.dart';
import 'package:signup_app/util/presets.dart';

///This is the view for actual Members of the Group
///Only Member can post and see posts
class GroupMemberPage extends StatelessWidget {
  final GroupMember state;
  GroupMemberPage({@required this.state});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppThemeData.colorControls),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
              icon: Icon(
                Icons.settings,
                color: AppThemeData.colorControls,
              ),
              onPressed: () {
                Navigator.push(
                    context, GroupSettingsPage.route(group: state.group));
              })
        ],
      ),
      body: SafeArea(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Center(
                    child: CircleAvatar(
                      backgroundColor: AppThemeData.colorPlaceholder,
                      backgroundImage:
                          AssetImage("assets/img/logo_light_text_trans.png"),
                      maxRadius: 50,
                      minRadius: 50,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(AppThemeData.varPaddingEdges),
                  child: Container(
                    width: double.infinity,
                    padding:
                        EdgeInsets.only(top: 4, left: 8, right: 8, bottom: 4),
                    decoration: BoxDecoration(
                        color: AppThemeData.colorCard,
                        border: Border.all(
                          color: Colors.transparent,
                        ),
                        borderRadius:
                            BorderRadius.all(AppThemeData.varCardRadius)),
                    child: Column(
                      children: [
                        Text(
                          state.group.name,
                          style: AppThemeData.textHeading1(),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 5),
                        Text(state.group.about,
                            style: AppThemeData.textNormal()),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FilterablePostList(
              group: state.group,
            ),
          ),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, CreatePostPage.route(group: state.group));
        },
        child: Icon(
          Icons.add,
          color: AppThemeData.colorCard,
        ),
        backgroundColor: AppThemeData.colorPrimary,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
