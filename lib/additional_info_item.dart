import 'package:flutter/material.dart';
class AdditionalInfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final double val;
  const AdditionalInfoItem({
    super.key,
    required this.icon,
    required this.label,
    required this.val
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
        icon,size: 32,
        ),
        SizedBox(height: 8,),
        Text(label,),
        SizedBox(height: 8,),
        Text(val.toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
        ],
    );
  }
}