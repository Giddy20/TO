class CreateGroupEvent {
  String iconURL;
  String eventID;
  String groupName;
  String eventName;
  DateTime startDate;
  DateTime endDate;
  String startsAt;
  String eventLocation;
  String ticketPrice;
  String minAge;
  String maxAge;
  String country;
  String gender;
  List<String> interest;
  CreateGroupEvent(
    this.iconURL,
    this.eventID,
    this.groupName,
    this.eventName,
    this.startDate,
    this.endDate,
    this.startsAt,
    this.eventLocation,
    this.ticketPrice,
    this.minAge,
    this.maxAge,
    this.country,
    this.gender,
    this.interest,
  );
}
