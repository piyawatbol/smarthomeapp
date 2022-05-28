// ignore_for_file: non_constant_identifier_names

class Equipment {
  String? e_img;
  String? e_name;

  Equipment({required this.e_img, required this.e_name});
}

class Room {
  String? room_img;
  String? room_name;
  String? equipment;
  Room(
      {required this.room_img,
      required this.room_name,
      required this.equipment});
}

List<Equipment> equipments = [
  Equipment(e_img: 'assets/images/light.png', e_name: 'โคมไฟ'),
  Equipment(e_img: 'assets/images/tv.png', e_name: 'โทรทัศน์'),
];

List<Room> rooms = [
  Room(
      room_name: 'ห้องนั่งเล่น',
      room_img: 'assets/images/livingroom.png',
      equipment: '8'),
  Room(
      room_name: 'ห้องทำงาน',
      room_img: 'assets/images/workingroom.png',
      equipment: '5')
];
