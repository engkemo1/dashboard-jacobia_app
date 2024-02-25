
import 'package:flutter/material.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Color(0xfff040915),
        child: Center(
          child: Image.asset('assets/images/box.png',height: 200,),
        ));
  }
}
