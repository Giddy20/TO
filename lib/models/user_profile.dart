import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class UserProfile {
  String userID;
  String firstName;
  String lastName;
  String profileURL;
  String locationText;
  Timestamp dob;
  String gender;
  String about;
  List<String> interests;
  String phoneNo;
  String height;
  String fatherName;
  String motherName;
  String momsMaiden;
  String parentsMarriage;
  String siblings;
  String rabbiShul;
  String address;
  String openToMoving;
  String religiousLevel;
  String school;
  String work;
  String hobbies;
  String firstRefName;
  String firstRefPhone;
  String firstRefRelation;
  String lastRefName;
  String lastRefPhone;
  String lastRefRelation;
  String lookingFor;
  String lottery;
  String maritialStatus;
  bool cohen;
  UserProfile(
    this.userID,
    this.firstName,
    this.lastName,
    this.profileURL,
    this.locationText,
    this.dob,
    this.gender,
    this.about,
    this.interests,
    this.phoneNo, this.height, this.fatherName, this.motherName, this.momsMaiden, this.parentsMarriage, 
    this.siblings, this.rabbiShul, this.address, this.openToMoving, this.religiousLevel, this.school,
    this.work, this.hobbies, this.firstRefName, this.firstRefPhone, this.firstRefRelation, this.lastRefName,
    this.lastRefPhone, this.lastRefRelation, this.lookingFor, this.lottery,
     this.maritialStatus,
    this.cohen
  );
}
