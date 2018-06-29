library banner_view;
import 'dart:async';

import 'package:flutter/material.dart';

import 'indicator/IndicatorWidget.dart';
//indicator container builder
///[indicatorWidget] indicator widget, position the indicator widget into container
typedef Widget IndicatorContainerBuilder(BuildContext context, Widget indicatorWidget);

const String TAG = 'BannerView';
/// Created by yangxiaowei
/// BannerView
class BannerView extends StatefulWidget{
    
    final List<Widget> banners;
    //init index
    final int initIndex;
    //switch interval
    final Duration intervalDuration;
    //animation duration
    final Duration animationDuration;
    final IndicatorContainerBuilder indicatorBuilder;
    final Widget indicatorNormal;
    final Widget indicatorSelected;
    //the margin of between indicator items
    final double indicatorMargin;
    final PageController controller;
    //whether cycyle rolling
    final bool cycleRolling;
    //whether auto rolling
    final bool autoRolling;
    final Curve curve;
    final ValueChanged onPageChanged;
    final bool log;

    BannerView(this.banners, {
        Key key,
        this.initIndex = 0, 
        this.intervalDuration = const Duration(seconds: 1),
        this.animationDuration = const Duration(milliseconds: 500),
        this.indicatorBuilder,
        this.indicatorNormal,
        this.indicatorSelected,
        this.indicatorMargin = 5.0,
        this.controller,
        this.cycleRolling = true,
        this.autoRolling = true,
        this.curve = Curves.easeInOut,
        this.onPageChanged,
        this.log = true,
    }): 
        assert(banners?.isNotEmpty ?? true), 
        assert(null != indicatorMargin),
        assert(null != intervalDuration),
        assert(null != animationDuration),
        assert(null != cycleRolling),
        super(key: key);

    @override
    _BannerViewState createState() => new _BannerViewState();
}

/// Created by yangxiaowei
class _BannerViewState extends State<BannerView> {

    List<Widget> _originBanners = [];
    List<Widget> _banners = [];
    Duration _duration;
    PageController _pageController;
    int _currentIndex = 0;

    @override
    void initState() {
        super.initState();
        _Logger.debug = widget.log ?? true;
        
        this._originBanners = widget.banners;
        this._banners = this._banners..addAll(this._originBanners);
        
        if(widget.cycleRolling) {
            Widget first = this._originBanners[0];
            Widget last = this._originBanners[this._originBanners.length - 1];
            
            this._banners.insert(0, last);
            this._banners.add(first);
            this._currentIndex = widget.initIndex + 1;
        }else {
            this._currentIndex = widget.initIndex;
        }

        this._duration = widget.intervalDuration;
        this._pageController = widget.controller ?? PageController(initialPage: this._currentIndex);
        
        this._nextBannerTask();
    }

    Timer _timer;
    void _nextBannerTask() {
        if(!mounted) {
            return;
        }

        if(!widget.autoRolling) {
            return;
        }

        this._cancel(manual: false);

        //security check[for fuck the gesture notification handle]
        if(_seriesUserScrollRecordCount != 0) {
            return ;
        }
        _timer = new Timer(_duration, () {
            this._doChangeIndex();
        });
    }

    bool _canceledByManual = false;
    /// [manual] 是否手动停止
    void _cancel({bool manual = false}) {
        _timer?.cancel();
        if(manual) {
            this._canceledByManual = true;
        }
    }

    void _doChangeIndex({bool increment = true}) {
        if(!mounted) {
            return;
        }
        this._canceledByManual = false;
        if(increment) {
            this._currentIndex++;
        }else{
            this._currentIndex--;
        }
        this._currentIndex = this._currentIndex % this._banners.length;
        if(0 == this._currentIndex) {
            this._pageController.jumpToPage(this._currentIndex);
            this._nextBannerTask();
            setState(() {});
        }else{
            this._pageController.animateToPage(
                this._currentIndex, 
                duration: widget.animationDuration,
                curve: widget.curve,
            ).whenComplete(() {
                if(!mounted) {
                    return;
                }

                // _Logger.d(TAG, '=========animationEnd');
                // this._nextBannerTask();
                // setState(() {});
            });
        }
    }

    @override
    Widget build(BuildContext context) {
        
        return this._generateBody();
    }

    /// compose the body, banner view and indicator view
    Widget _generateBody() {
        return new Stack(
            children: <Widget>[
                this._renderBannerBody(),
                this._renderIndicator(),
            ],
        );
    }

    //tack the user scroll callback count in a series
    int _seriesUserScrollRecordCount = 0;
    /// Banner container
    Widget _renderBannerBody() {

        Widget pageView = new PageView.builder(
            itemBuilder: (context, index) {

                Widget widget = this._banners[index];
                return new GestureDetector(
                    child: widget,
                    onTapDown: (detail) {
                        _Logger.d(TAG, '**********   onTapDown');
                        this._cancel(manual: true);
                    }, 
                );
            },  
            controller: this._pageController,
            itemCount: this._banners.length,  
            onPageChanged: (index) {
                _Logger.d(TAG, '**********   changed  index: $index  cu: $_currentIndex');
                this._currentIndex = index;
                if(!(this._timer?.isActive ?? false)) {
                    this._nextBannerTask();
                }
                setState(() {});
                if(null != widget.onPageChanged) {
                    widget.onPageChanged(index);
                }
            },
            physics: new ClampingScrollPhysics(),
        );

        return new NotificationListener(
            child: pageView,
            onNotification: (notification) {
                this._handleScrollNotification(notification);
            },
        );
    }

    void _handleScrollNotification(Notification notification) {
        void _resetWhenAtEdge(PageMetrics pm) {
            if(null == pm || !pm.atEdge) {
                return;
            }
            if(!widget.cycleRolling) {
                return;
            }
            try{
                if(this._currentIndex == 0) {
                    this._pageController.jumpToPage(this._banners.length - 2);
                }else if(this._currentIndex == this._banners.length - 1) {
                    this._pageController.jumpToPage(1);
                }
            }catch (e){
                print('Exception: ${e?.toString()}');
            }
        }

        void _handleUserScroll(UserScrollNotification notification) {
            UserScrollNotification sn = notification;
                    
            PageMetrics pm = sn.metrics;
            var page = pm.page;
            var depth = sn.depth;
            
            var left = page == .0 ? .0 : page % (page.round());
            
            if(_seriesUserScrollRecordCount == 0) {
                _Logger.d(TAG, '**********   ^^^^  用户手动滑动开始');
                this._cancel(manual: true);
            }
            if(depth == 0) {
                _Logger.d(TAG, '** countP: $_seriesUserScrollRecordCount  page: $page  , left: $left');
                
                if(left == 0) {
                    if (_seriesUserScrollRecordCount != 0) {
                        _Logger.d(TAG, '**********   ^^^^  用户手动滑动结束, at edge: ${pm.atEdge}');
                        setState(() {
                            _seriesUserScrollRecordCount = 0;
                            _canceledByManual = false;
                            _resetWhenAtEdge(pm);
                        });
                        this._nextBannerTask();
                    }else {
                        _seriesUserScrollRecordCount ++;
                    }
                }else {
                    _seriesUserScrollRecordCount ++;
                }
            }
        }

        void _handleOtherScroll(ScrollUpdateNotification notification) {
            ScrollUpdateNotification sn = notification;
            if(widget.cycleRolling && sn.metrics.atEdge) {
                _Logger.d(TAG, '>>>   had at edge  $_currentIndex');
                if(this._canceledByManual) {
                    return;
                }
                _resetWhenAtEdge(sn.metrics);
            }
        }

        if(notification is UserScrollNotification) {

            _handleUserScroll(notification);
        }else if(notification is ScrollUpdateNotification) {

            _handleOtherScroll(notification);
        }
    }

    /// indicator widget
    Widget _renderIndicator() {
        
        int index = widget.cycleRolling ? this._currentIndex - 1 : this._currentIndex;
        index = index <= 0 ? 0 : index;
        return new IndicatorWidget(
            size: this._originBanners.length,
            currentIndex: index,
            indicatorBuilder: this.widget.indicatorBuilder,
            indicatorNormal: this.widget.indicatorNormal,
            indicatorSelected: this.widget.indicatorSelected,
            indicatorMargin: this.widget.indicatorMargin,
        );
    }

    @override
    void dispose() {
        _pageController?.dispose();
        _cancel();
        super.dispose();
    }
}

class _Logger {
    static bool debug = true;
    static void d(String tag, String msg) {
        if(debug) {
            print('$tag - $msg');
        }
    }
}