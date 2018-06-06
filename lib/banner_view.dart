library banner_view;
import 'dart:async';

import 'package:flutter/material.dart';

import 'indicator/IndicatorWidget.dart';
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
    //the margin of between indicator items
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

    List<Widget> _banners;
    Duration _duration;
    PageController _pageController;
    int _currentIndex = 0;

    @override
    void initState() {
        super.initState();
        this._banners = widget.banners;
        final int initIndex = widget.initIndex;
        this._currentIndex = initIndex;

        this._duration = new Duration(seconds: widget.changeSeconds);
        this._pageController = new PageController(initialPage: initIndex);
        
        this._nextBannerTask();
    }

    void _nextBannerTask() {
        if(!mounted) {
            return;
        }
        new Future.delayed(_duration).whenComplete(() {
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
        this._currentIndex = this._currentIndex % _banners.length;
        if(0 == this._currentIndex) {
            this._pageController.jumpToPage(this._currentIndex);
            this._nextBannerTask();
            setState(() {});
        }else{
            this._pageController.animateToPage(
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

    //Banner container
    Widget _renderBannerBody() {

        return new PageView.builder(
            itemBuilder: (context, index) {
                return _banners[index];
            },  
            controller: this._pageController,
            itemCount: _banners.length,  
            onPageChanged: (index) {
                this._currentIndex = index;
                if(null != widget.onPageChanged) {
                    widget.onPageChanged(index);
                }
            },
        );
    }

    Widget _renderIndicator() {
        
        return new IndicatorWidget(
            size: this._banners.length,
            currentIndex: this._currentIndex,
            indicatorBuilder: this.widget.indicatorBuilder,
            indicatorNormal: this.widget.indicatorNormal,
            indicatorSelected: this.widget.indicatorSelected,
            indicatorMargin: this.widget.indicatorMargin,
        );
    }

    @override
    void dispose() {
        _pageController?.dispose();
        super.dispose();
    }
}