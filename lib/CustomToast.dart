import 'package:flutter/material.dart';
import 'package:staggered_layout/ResponsiveConstraints.dart';

class ToastWidget extends StatelessWidget {
  final String title;
  final String description;
  final String link;
  const ToastWidget({required this.title, required this.description, required this.link});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0,200,0,0),
      child: Align(
        alignment: Alignment.topCenter,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Container(
            width: 250.0,
            height: 70.0,
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Container(
                    height: 50,
                    width: 50,
                    child: Image(
                      image: NetworkImage(link), fit: BoxFit.cover,
                    ),
                  ),
                ),
                // SizedBox(width: Responsive.width(5, context),),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        title,
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        description,
                        style: TextStyle(color: Colors.black,  fontWeight: FontWeight.w900)
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}