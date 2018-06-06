import 'package:flutter/material.dart';

import '../banner_view.dart';
import 'IndicatorUtil.dart';
//Created by yangxiaowei at 2018/06/06
//indicator view of banner
class IndicatorWidget extends StatelessWidget {
    final IndicatorContainerBuilder indicatorBuilder;
    final Widget indicatorNormal;
    final Widget indicatorSelected;
    final double indicatorMargin;
    final int size;
    final int currentIndex;
    
    IndicatorWidget({
        Key key,
        this.size,
        this.currentIndex,
        this.indicatorBuilder,
        this.indicatorNormal,
        this.indicatorSelected,
        this.indicatorMargin = 5.0,
    }): 
        assert(indicatorMargin != null),
        assert(size != null && size > 0),
        assert(currentIndex != null && currentIndex >= 0),
        super(key: key);
    
    @override
    Widget build(BuildContext context) {

        return this._renderIndicator(context);
    }

    //indicator container
    Widget _renderIndicator(BuildContext context) {
        
        Widget smallContainer = new Container(
            // color: Colors.purple[100],
            child: new Row(
                mainAxisSize: MainAxisSize.min,
                children: _renderIndicatorTag(),
            ),
        );

        if(null != this.indicatorBuilder) {
            return this.indicatorBuilder(context, smallContainer);
        }

        //default implement
        return new Align(
            alignment: Alignment.bottomCenter,
            child: new Opacity(
                opacity: 0.5,
                child: new Container(
                    height: 40.0,
                    padding: new EdgeInsets.symmetric(horizontal: 16.0),
                    color: Colors.black45,
                    alignment: Alignment.centerRight,
                    child: smallContainer,
                ),
            ),
        );
    }

    //generate every indicator item
    List<Widget> _renderIndicatorTag() {
        List<Widget> indicators = [];
        final int len = this.size;
        Widget selected = this.indicatorSelected ?? IndicatorUtil.generateIndicatorItem(normal: false);
        Widget normal = this.indicatorNormal ?? IndicatorUtil.generateIndicatorItem(normal: true);

        for(var index = 0; index < len; index++) {
            indicators.add(index == this.currentIndex ? selected : normal);
            if(index != len - 1) {
                indicators.add(new SizedBox(width: this.indicatorMargin,));
            }
        }

        return indicators;
    }
}