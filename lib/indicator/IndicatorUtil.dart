import 'package:flutter/material.dart';
//Created by yangxiaowei at 2018/05/16
//generate indicator item widget
class IndicatorUtil {
    static Widget generateIndicatorItem({bool normal = true, double indicatorSize = 8.0}) {

        return new Container(
            width: indicatorSize,
            height: indicatorSize,
            decoration: new BoxDecoration(
                shape: BoxShape.circle,
                color: normal ? Colors.white : Colors.red,
            ),
        );
    }
}