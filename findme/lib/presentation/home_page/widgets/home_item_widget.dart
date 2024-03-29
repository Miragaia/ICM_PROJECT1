import 'package:flutter/material.dart';

class HomeItemWidget extends StatelessWidget {
  final String roomName;
  final String location;
  final String usersCount;
  final String image;

  const HomeItemWidget({
    Key? key,
    required this.roomName,
    required this.location,
    required this.usersCount,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Image.asset(
            image,
            height: 50,
            width: 50,
          ),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                roomName,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(location),
            ],
          ),
          Spacer(),
          Text(usersCount),
        ],
      ),
    );
  }
}
