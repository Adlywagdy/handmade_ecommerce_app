import 'package:flutter/material.dart';

class SocialButton extends StatelessWidget {
  final String text;
  final String value;
  final IconData icon;
  const SocialButton({
    super.key, required this.text, required this.value, required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child:InkWell(
         onTap: () {
        print("$value");
       },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
          color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12)
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,color: Colors.black,),
              Text(text,
              style: TextStyle(fontSize: 14,
              fontWeight: FontWeight.w600,
              ),
              )
            ],
          ),
          
        ),
      ) 
      
      );
  }
}



