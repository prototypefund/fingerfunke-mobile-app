import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:signup_app/util/models/data_models.dart';

//ToDo Implement Pagiantion

class GroupPagination {
  ///Return all Groups the current User is part of
  static Stream<List<Group>> getSubscribedGroups() {
    Stream<List<Group>> groupStream = FirebaseFirestore.instance
        .collection('groups')
        .where('users', arrayContains: FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .map((list) => list.docs.map((doc) => (Group.fromDoc(doc))).toList());

    return groupStream;
  }

  ///Return all Groups the current User is not part of
  static Stream<List<Group>> getNewGroups() {
    Stream<List<Group>> groupStream = FirebaseFirestore.instance
        .collection('groups')
        .snapshots()
        .map((list) => list.docs
            .where((doc) {
              Group group = Group.fromDoc(doc);
              return getMemberIDs(group.members)
                  .contains(FirebaseAuth.instance.currentUser!.uid);
            })
            .map((doc) => (Group.fromDoc(doc)))
            .toList());

    return groupStream;
  }

  static List<String> getMemberIDs(List<GroupUserReference> members) {
    List<String> result = [];
    for (GroupUserReference ref in members) {
      result.add(ref.id);
    }
    return result;
  }
}
