import 'package:flutter/material.dart';

class HomeSearch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            offset: Offset(-2, 2),
            color: Colors.black54,
          ),
        ],
      ),
      height: 50,
      margin: const EdgeInsets.all(35),
      padding: const EdgeInsets.only(right: 20),
      child: Align(
        alignment: Alignment.center,
        child: TextFormField(
          textAlign: TextAlign.center,
          enableInteractiveSelection: true,
          enableSuggestions: true,
          cursorColor: Colors.black,
          decoration: InputDecoration(
            hintText: "Search a friend",
            focusColor: Colors.black,
            border: InputBorder.none,
            prefixIcon: Container(
              margin: EdgeInsets.symmetric(horizontal: 6),
              padding: EdgeInsets.symmetric(horizontal: 7, vertical: 5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.lightBlue[300],
              ),
              child: Icon(
                Icons.search_outlined,
                color: Colors.white, //Color(0xff)
              ),
            ),
          ),
        ),
      ),
    );
  }
}
