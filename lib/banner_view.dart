library banner_view;
import 'dart:async';

import 'package:flutter/material.dart';
//指示器容器构建器
///[indicatorWidget] 指示器控件，需要指示器容器添加到具体位置
typedef Widget IndicatorContainerBuilder(BuildContext context, Widget indicatorWidget);
class BannerView extends StatefulWidget{
    
    final List<Widget> banners;
    //初始页面索引
    final int initIndex;
    //几秒进行切换
    final int changeSeconds;
    final IndicatorContainerBuilder indicatorBuilder;
    final Widget indicatorNormal;
    final Widget indicatorSelected;
    final double indicatorMargin;
    final ValueChanged onPageChanged;

    BannerView(this.banners, {
        Key key,
        this.initIndex = 0, 
        this.changeSeconds = 1,
        this.indicatorBuilder,
        this.indicatorNormal,
        this.indicatorSelected,
        this.indicatorMargin = 5.0,
        this.onPageChanged,
    }): 
        assert(banners?.isNotEmpty ?? true), 
        assert(null != indicatorMargin),
        super(key: key);

    @override
    _BannerViewState createState() => new _BannerViewState();
}

class _BannerViewState extends State<BannerView> {

    List<Widget> banners;
    Duration duration;
    PageController pageController;
    int _currentIndex = 0;
    @override
    void initState() {
        super.initState();
        this.banners = widget.banners;
        final int initIndex = widget.initIndex;
        this._currentIndex = initIndex;

        this.duration = new Duration(seconds: widget.changeSeconds);
        this.pageController = new PageController(initialPage: initIndex);
        
        this._nextBannerTask();
    }

    void _nextBannerTask() {
        if(!mounted) {
            return;
        }
        new Future.delayed(duration).whenComplete(() {
            this._doChangeIndex();
        });
    }

    void _doChangeIndex({bool increment = true}) {
        if(!mounted) {
            return;
        }
        if(increment) {
            this._currentIndex++;
        }else{
            this._currentIndex--;
        }
        this._currentIndex = this._currentIndex % banners.length;
        if(0 == this._currentIndex) {
            this.pageController.jumpToPage(this._currentIndex);
            this._nextBannerTask();
            setState(() {});
        }else{
            this.pageController.animateToPage(
                this._currentIndex, 
                duration: new Duration(milliseconds: 500),
                curve: Curves.linear
            ).whenComplete(() {
                if(!mounted) {
                    return;
                }
                this._nextBannerTask();
                setState(() {});
            });
        }
    }

    @override
    Widget build(BuildContext context) {
        
        return this._generateBody();
    }

    Widget _generateBody() {
        return new Stack(
            children: <Widget>[
                this._renderBannerBody(),
                this._renderIndicator(),
            ],
        );
    }

    //Banner容器
    Widget _renderBannerBody() {

        return new PageView.builder(
            itemBuilder: (context, index) {
                return banners[index];
            },  
            controller: this.pageController,
            itemCount: banners.length,  
            onPageChanged: (index) {
                this._currentIndex = index;
                if(null != widget.onPageChanged) {
                    widget.onPageChanged(index);
                }
            },
        );
    }

    //指示器容器
    Widget _renderIndicator() {
        
        Widget smallContainer = new Container(
            // color: Colors.purple[100],
            child: new Row(
                mainAxisSize: MainAxisSize.min,
                children: _renderIndicatorTag(),
            ),
        );
        if(null != widget.indicatorBuilder) {
            return widget.indicatorBuilder(context, smallContainer);
        }

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

    //指示器item标签
    List<Widget> _renderIndicatorTag() {
        List<Widget> indicators = [];
        final int len = banners.length;
        Widget selected = widget.indicatorSelected ?? IndicatorUtil.generateIndicatorItem(normal: false);
        Widget normal = widget.indicatorNormal ?? IndicatorUtil.generateIndicatorItem(normal: true);

        for(var index = 0; index < len; index++) {
            indicators.add(index == _currentIndex ? selected : normal);
            if(index != len - 1) {
                indicators.add(new SizedBox(width: widget.indicatorMargin,));
            }
        }

        return indicators;
    }

    @override
    void dispose() {
        pageController?.dispose();
        super.dispose();
    }
}

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
