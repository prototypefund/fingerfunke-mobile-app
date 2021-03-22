import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:signup_app/util/presets.dart';
import 'package:signup_app/widgets/post_editor/widgets/tags/cubit/tag_cubit.dart';

class Tag extends StatelessWidget {
  final String tagDescription;
  final bool isActive;
  Tag({@required this.tagDescription, @required this.isActive});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Theme(
        data: ThemeData.light(),
        child: Container(
            //color: AppThemeData.colorAccent,
            padding: const EdgeInsets.only(right: 10, bottom: 5, top: 5),
            child: Chip(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              //elevation: 4,
              //shadowColor: Color.fromARGB(100, 170, 170, 170),
              backgroundColor: isActive
                  ? AppThemeData.colorCard
                  : AppThemeData.colorPrimaryLighter,
              label: Text(tagDescription,
                  style: TextStyle(
                      fontSize: 14,
                      color: isActive
                          ? AppThemeData.colorTextRegular
                          : AppThemeData.colorCard)),
            )),
      ),
      onTap: () {
        BlocProvider.of<TagCubit>(context).updateTags(tagDescription);
      },
    );
  }
}
