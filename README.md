# banner_view

A flutter BannerView package project.
## Demo
Visit Demo in <a href="https://github.com/yangxiaoweihn/BannerViewExample">here</a>.
## function
<table> 
    <tr>
        <td><img src="https://raw.githubusercontent.com/yangxiaoweihn/BannerView/master/screenshot/device-s-image-0.jpg" /></td>
        <td><img src="https://raw.githubusercontent.com/yangxiaoweihn/BannerView/master/screenshot/device-s-image-1.jpg" /></td>
    </tr>
    <tr>
        <td><img src="https://raw.githubusercontent.com/yangxiaoweihn/BannerView/master/screenshot/device-s-gif-0.gif" /></td>
    </tr>
</table>

## Getting Started
add in pubspec.yaml
```dart
    banner_view: "^1.1.2"
    or
    banner_view: 
        git: https://github.com/yangxiaoweihn/BannerView.git
```

```dart
    import 'package:banner_view/banner_view.dart';
    new Container(
        alignment: Alignment.center,
        height: 200.0,
        child: new BannerView(
            [...]
        ),
    );
```
support properties:
```dart
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
```
## Flutter QQ group ( 714494675 )
