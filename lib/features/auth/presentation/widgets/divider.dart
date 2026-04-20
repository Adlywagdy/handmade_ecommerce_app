import 'package:flutter/material.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child:Divider(
     color: Colors.grey,
     thickness: 1,
    )
     );
  }
}