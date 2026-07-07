import 'package:flutter/material.dart';
class HourlyForecastItem extends StatelessWidget {
  final String labelTime;
  final String labelTemperature;
  final IconData icon;
  const HourlyForecastItem({
    super.key,
    required this.labelTime,
    required this.icon,
    required this.labelTemperature
  });

  @override
  Widget build(BuildContext context) {
    return Card(
                    elevation: 6,
                    child: Container(
                      width: 100,
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child:Column(
                        children: [
                          Text(labelTime,
                          style:TextStyle(fontSize: 16,fontWeight: FontWeight.bold) ,
                          maxLines: 1,
                          ),
                          SizedBox(height: 8,),
                          Icon(
                            icon,
                            size: 32,
                          ),
                          SizedBox(height: 8,),
                          Text(
                            labelTemperature,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                  );
  }
}