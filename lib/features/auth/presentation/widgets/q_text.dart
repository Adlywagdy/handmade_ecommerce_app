import 'package:flutter/material.dart';

class QText extends StatelessWidget {
  final String text;
  const QText({
    super.key, required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
     mainAxisAlignment:MainAxisAlignment .center,
     children: [
       Text(text,
       style: TextStyle(
         fontSize: 14,
         fontWeight: FontWeight.w400,
         color: Colors.grey,
       ),),
    
     
    ] );
    
  }
}

