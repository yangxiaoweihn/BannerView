import 'package:flutter/material.dart';
import 'package:banner_view/banner_view.dart';

import 'Pair.dart';

class BannerViewPage extends StatefulWidget {
    @override
    _BannerViewPageState createState() => new _BannerViewPageState();
}

class _BannerViewPageState extends State<BannerViewPage> {
    @override
    Widget build(BuildContext context) {

        return new Scaffold(
            appBar: new AppBar(),
            body: new Container(
                child: this._listView(),
            ),
        );
    }

    Widget _listView() {

        return new ListView.builder(
            itemBuilder: (context, index) {
                if(index == 0) {

                    return new Container(
                        height: 180.0,
                        child: this._bannerView(),
                    );
                }else if(index == 2) {

                    return new Container(
                        height: 180.0,
                        child: this._bannerView0(),
                    );
                }

                return new ListTile(
                    title: new Text('data $index'),
                );
            },
        );
    }

    BannerView _bannerView0() {

        List<Pair<String, Color>> param = [
            Pair.create('1', Colors.red[100]),
            Pair.create('2', Colors.green[100]),
            Pair.create('3', Colors.blue[100]),
            Pair.create('4', Colors.yellow[100]),
            Pair.create('5', Colors.red[100]),
        ];

        return new BannerView(
            _banners(param),
        );
    }

    BannerView _bannerView() {

        List<Pair<String, Color>> param = [
            Pair.create('1', Colors.red[100]),
            Pair.create('2', Colors.green[100]),
            Pair.create('3', Colors.blue[100]),
            Pair.create('4', Colors.yellow[100]),
            Pair.create('5', Colors.red[100]),
        ];

        return new BannerView(
            _banners(param),
            indicatorMargin: 10.0,
            indicatorNormal: new Container(
                width: 5.0,
                height: 5.0,
                decoration: new BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.rectangle,
                ),
            ),
            indicatorSelected: new Container(
                width: 15.0,
                height: 5.0,
                decoration: new BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.rectangle,
                    borderRadius: new BorderRadius.all(
                        new Radius.circular(5.0),
                    ),
                ),
            ),
            indicatorBuilder: (context, indicator) {
                return new Opacity(
                    opacity: 0.5,
                    child: new Container(
                        padding: new EdgeInsets.symmetric(horizontal: 20.0,),
                        height: 60.0,
                        width: double.infinity,
                        color: Colors.yellow,
                        child: indicator,
                    ),
                );
            },
        );
    }

    List<Widget> _banners(List<Pair<String, Color>> param) {

        TextStyle style = new TextStyle(
            fontSize: 35.0,
            color: Colors.white,
        );
      
        Widget _bannerText(Color color, String text) {

            return new Container(
                alignment: Alignment.center,
                height: double.infinity,
                color: color,
                child: new Text(
                    text,
                    style: style,
                ),
            );
        }

        Widget _bannerImage(Color color, String url) {

            return new Container(
                alignment: Alignment.center,
                height: double.infinity,
                color: color,
                child: new Image.network(url, fit: BoxFit.cover,),
            );
        }


        List<Widget> _renderBannerItem(List<Pair<String, Color>> param) {

            return param.map((item) {

                final text = item.first;
                final color = item.second;
                return text.startsWith('http://') || text.startsWith('https://') ? 
                _bannerImage(color, text) : 
                _bannerText(color, text);
            }).toList();
        }

        return _renderBannerItem(param);
    }
}