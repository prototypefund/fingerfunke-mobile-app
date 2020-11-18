import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fire;
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:signup_app/repositories/user_repository.dart';
import 'package:signup_app/util/data_models.dart';

part 'create_post_state.dart';

class CreatePostCubit extends Cubit<CreatePostState> {
  CreatePostCubit() : super(CreatePostState.empty());

  void submit() async {
    emit(state.createESubmitting());
    bool abort = false;
    //First Check if all mandatory Field aren't empty
    state.mandatoryFields.forEach((key, value) {
      if (value == null) {
        print("mandatory Field '" + key + "' empty");
        abort = true;
        emit(state.createError());
      }
    });
    if (abort) {
      print("abort");
      return;
    }
    //bring optional Fields in Array Structure
    List<PostDetail> postDetails = [];
    state.optionalFields.forEach((key, value) {
      if (value != null) {
        postDetails.add(PostDetail(id: key, value: value));
      }
    });

    //Create Post
    //!Todo Schauen ob Event oder Buddy und schauen ob mit Gruppe oder nicht
    Event event = Event()
      ..title = state.mandatoryFields['title']
      ..geohash = "ToDoHash"
      ..tags = [...state.mandatoryFields['tags'], 'event']
      ..about = state.mandatoryFields['about']
      ..type = "event"
      ..createdDate = DateTime.now().millisecondsSinceEpoch
      ..expireDate = DateTime.now().millisecondsSinceEpoch
      ..details = postDetails
      ..participants = [fire.FirebaseAuth.instance.currentUser.uid]
      ..maxPeople = state.eventOnlyFields['maxPeople'] as int
      ..author = await UserRepository().getUser()
      ..group = state.mandatoryFields['group'];

    //If Time or Date is ste add it
    //First Add Time if existent
    //Add Time to optional Fields
    if (state.eventDate != null) {
      event.eventDate = state.eventDate.millisecondsSinceEpoch;
    }
    if (state.eventTime != null) {
      //!ToDo what to do with Event Time
    }
    //Write to Firetore
    await FirebaseFirestore.instance.collection('posts').add(event.toJson());
    emit(state.createSuccess());
  }

  void updateDate(DateTime eventDate) {
    emit(state.copyWith(eventDate: eventDate, eventTime: state.eventTime));
  }

  void updateTime(TimeOfDay eventTime) {
    emit(state.copyWith(eventTime: eventTime, eventDate: state.eventDate));
  }

  void setOptionalField(String field, value) {
    state.optionalFields[field] = value;
    emit(state.copyWith());
  }

  void setMandatoryField(String field, value) {
    state.mandatoryFields[field] = value;
    emit(state.copyWith());
  }

  void setEventOnlyField(String field, value) {
    state.eventOnlyFields[field] = value;
    emit(state.copyWith());
  }
}
