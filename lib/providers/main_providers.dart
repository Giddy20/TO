
// ignore_for_file: body_might_complete_normally_nullable, prefer_const_declarations

import 'package:app/models/new_match.dart';
import 'package:flutter/cupertino.dart';

enum CardStatus {like , review}

class MainProvider with ChangeNotifier {
  int currentProfileIndex = -1;
  //String selectedSub = "";
  List<NewMatch> myMatches = [];
  List<NewMatch1> myMatches1 = [];
  int likesCount = 0;
  bool _isDragging = false;
  double _angle = 0;
  List<String> _urlImages = [];
  List<String> get urlImages => _urlImages; 
 
  bool get isDragging => _isDragging;
  Offset _position = Offset.zero;
  Offset get position => _position;
  Size _screenSize = Size.zero;
  double get angle => _angle;
  
  int likedCount = 0;
  void updatelikedCount(int count) {
    likedCount += count;
    notifyListeners();
  }

  void clearLikedCount() {
    likedCount = 0;
    notifyListeners();
  }

  int messagesCount = 6;
  void updatemessageCount(int count) {
    messagesCount += count;
    notifyListeners();
  }

  void clearmessageCount() {
    messagesCount = 0;
    notifyListeners();
  }

  MainProvider() {
    resetUsers();
  }

  void resetUsers() {
    _urlImages = <String> [
      /*
      'assets/femalepic1.jpg',
      'assets/discover.jpg',
      'assets/femalepic13.jpg',
      'assets/femalepic15.jpg',
      'assets/femalepic20.jpg',
      */
    "https://firebasestorage.googleapis.com/v0/b/dingdong-8f6d6.appspot.com/o/mediaFiles%2F91h7vzM5A1VSvdGu31ut8bgGkaD21642518879233644?alt=media&token=3816988c-f651-4f1b-8806-d92a10b7e20e",
    "https://firebasestorage.googleapis.com/v0/b/dingdong-8f6d6.appspot.com/o/mediaFiles%2FLpacCJFwPgPfhg4DT5GuTUO4ylz21642698341576416?alt=media&token=b2e51439-1650-4589-82ef-76dbae177f75",
    "https://firebasestorage.googleapis.com/v0/b/dingdong-8f6d6.appspot.com/o/mediaFiles%2FMiwIh8rDbWMvxRr2s6l5Zo95knp11642669902969805?alt=media&token=f8471810-a36e-4765-b4fa-a7425c02fea9",
    "https://firebasestorage.googleapis.com/v0/b/dingdong-8f6d6.appspot.com/o/mediaFiles%2FPBQUqYMeFnR0QYa4nKj5lq4oEQB31642770657877352?alt=media&token=dbd1b04c-0e7b-4ab9-ae14-bca55987822d",

    ].reversed.toList();

    notifyListeners();
  }

  void setMatches(List<NewMatch1> nm) {
    myMatches1 = nm;
    notifyListeners();
  }


  void setScreenSize(Size screenSize) => _screenSize = screenSize;


  void startPosition(DragStartDetails details) {
    _isDragging = true;
    notifyListeners();
  }

  void updatePosition(DragUpdateDetails details) {
    _position += details.delta;
    final x =_position.dx;
    _angle = 45 * x / _screenSize.width;
    notifyListeners();
  }

  void endPosition() {
    _isDragging = false;
    notifyListeners();
  final status = getStatus();

    switch (status) {
      case CardStatus.like:
      like();
      break;
      case CardStatus.review:
      review();
      break;
      default:
      resetPosition();
    }
    resetPosition();
  }

  
     CardStatus? getStatus() {
       final x = _position.dx;
       final y = _position.dy;
       final delta = 100;

       if(x >= delta) {
         return CardStatus.like;
       } else if (x <= -delta) {
         return CardStatus.review;
       } 
     }


  void like() {
    _angle = 20;
    _position += Offset(2 * _screenSize.width / 2, 0);
    _nextCard();
    notifyListeners();
  }

  void review() {
    _angle = -20;
    _position -= Offset(2 * _screenSize.width, 0);
    _nextCard();
    notifyListeners();
  }

  Future _nextCard() async {
    if (myMatches1.isEmpty) return;

    await Future.delayed(const Duration(milliseconds: 200));
    myMatches1.removeLast();
    resetPosition();
  }

  void resetPosition(){
    _isDragging = false;
    _position = Offset.zero;
    _angle = 0;
    notifyListeners();
  }

  void nextProfile() {
    if (currentProfileIndex == myMatches1.length - 1) {
      currentProfileIndex = -1;
    } else if (currentProfileIndex < myMatches1.length - 1) {
      currentProfileIndex = currentProfileIndex + 1;
    }
    notifyListeners();
  }

  void removeMatch() {
    myMatches1.removeAt(currentProfileIndex);
    if (currentProfileIndex >= 0 &&
        currentProfileIndex < myMatches1.length - 1) {
      notifyListeners();
    } else {
      currentProfileIndex = -1;
      notifyListeners();
    }
  }

  // void dailyLikes() {
  //   User? user = FirebaseAuth.instance.currentUser;
  //   if (user != null) {
  //     FirebaseFirestore.instance
  //         .collection('Likes')
  //         .where('likedBy', isEqualTo: user.uid)
  //         .orderBy('timeStamp')
  //         .limitToLast(10)
  //         .snapshots()
  //         .listen((event) {
  //       event.docs.forEach((doc) {
  //         DateTime now = DateTime.now();
  //         DateTime today = DateTime(now.year, now.month, now.day);
  //         DateTime ts = (doc.data()['timeStamp'] as Timestamp).toDate();
  //         if (ts.isAfter(today)) {
  //           likesCount++;
  //         }
  //       });
  //     });
  //   }
  // }
}
