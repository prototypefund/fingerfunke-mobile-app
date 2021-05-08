import 'package:cloud_functions/cloud_functions.dart';
import 'package:signup_app/util/models/data_models.dart';

class PostInteractions {
  final Post _post;

  PostInteractions({required Post post}) : this._post = post;

  FirebaseFunctions _functions = FirebaseFunctions.instance;

  ///Subscribe to Post by Calling the Cloud Function
  Future<void> subscribe() {
    HttpsCallable callable = _functions.httpsCallable(
      'posts-subscribeToPost',
    );
    return callable.call(_post.id);
  }

  ///Unsubscribe from Post by Calling the Cloud Function
  Future<void> unsubscribe() {
    HttpsCallable callable = _functions.httpsCallable(
      'posts-unsubscribeFromPost',
    );

    return callable.call(
      _post.id,
    );
  }
}
