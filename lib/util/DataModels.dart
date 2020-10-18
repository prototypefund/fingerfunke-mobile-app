/// Author: Robin <constorux@gmail.com>

/// Object that holds information to a single user as saved in the database
///
/// [uid] links a network user to a Firebase-Authentication user
/// [name] name of the user that the user can set himself
class User {
  String name;
  String uid;
}

/// Object that holds information to a group as saved in the database
///
/// [name] Name of the group
/// [about] Text that informs about the group
/// [users] a list of the userIDs of the users that are in the group
class Group {
  String name;
  String about;
  List<String> users = [];
}

/// Class that defines Objects that are created by a user
///
///  [author] the author of the Object
class UserGeneratedContent {
  User author;
}

/// Object that holds information about a Post
///
/// [title] title of the post
/// [geohash] Geohash of where the Post was posted (.60km accuracy, 6 characters)
/// [tags] tags of the post
/// [about] text describing the post
/// [type] is the post an 'event' or an 'offer'
/// [createdDate] the date and time at which the post was created
/// [expireDate] the date and time when the post will expire
/// [groupID] id of the group the post was posted in. (Optional)
class Post implements UserGeneratedContent {
  String title;
  String geohash;
  List<String> tags;
  String about;
  String type;
  int createdDate;
  int expireDate;
  String groupID;

  @override
  User author;
}

/// Object that holds information to a Message from a chat of a post
///
/// [author] user that composed the message
/// [timestamp] the time at which the post was composed
/// [type] indicates if the message is a text or a video message
/// [content] message of the user or reference to the video file
class Message implements UserGeneratedContent {
  int timestamp;
  String type;
  String content;

  @override
  User author;
}

/// Post of the type Event
/// [eventDate] timeAndDate when the post will take place
/// [maxPeople] maximum number of people that can attend the event (-1 if unlimited)
/// [participants] current members of the event. List of User-IDs
/// [location] where the event will start
class Event extends Post {
  int eventDate;
  int maxPeople;
  List<String> participants;
  String location;
}

/// Post of the type events
/// TODO: talk about needed fields
class Buddy extends Post {}
