import 'package:flutter/material.dart';

import 'note_card.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final PageController _pageCtrl = PageController(viewportFraction: 0.6);
  double currentPage = 0.0;

  @override
  void initState() {
    _pageCtrl.addListener(() {
      setState(() {
        currentPage = _pageCtrl.page!;
      });
    });
    super.initState();
  }

  void _panHandler(DragUpdateDetails d) {
    double radius = 50;
    bool onTop = d.localPosition.dy <= radius;
    bool onLeftSide = d.localPosition.dx <= radius;
    bool onRightSide = !onLeftSide;
    bool onBottom = !onTop;

    bool panUp = d.delta.dy <= 0.0;
    bool panLeft = d.delta.dx <= 0.0;
    bool panRight = !panLeft;
    bool panDown = !panUp;

    double yChange = d.delta.dy.abs();
    double xChange = d.delta.dx.abs();

    double verticalRotation = (onRightSide && panDown) || (onLeftSide && panUp)
        ? yChange
        : yChange * -1;

    double horizontalRotation =
        (onTop && panRight) || (onBottom && panLeft) ? xChange : xChange * -1;

    double rotationalChange =
        (verticalRotation + horizontalRotation) * (d.delta.distance * 0.2);

    _pageCtrl.jumpTo(_pageCtrl.offset + rotationalChange);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Scroll Wheel"),
        ),
        body: Column(
          children: <Widget>[
            Container(
              height: 300,
              color: Colors.black,
              child: PageView.builder(
                controller: _pageCtrl,
                scrollDirection: Axis.horizontal,
                itemCount: 9,
                itemBuilder: (context, int currentIdx) {
                  return NoteCard(
                      color: Colors.accents[currentIdx],
                      currentIdx: currentIdx,
                      currentPage: currentPage);
                },
              ),
            ),
            Spacer(),
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  GestureDetector(
                    onPanUpdate: _panHandler,
                    child: Container(
                      height: 300,
                      width: 300,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                      child: Stack(
                        children: [
                          Container(
                            child: Text(
                              "MENU",
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            alignment: Alignment.topCenter,
                            margin: EdgeInsets.only(top: 36),
                          ),
                          Container(
                              child: IconButton(
                                icon: Icon(Icons.fast_forward),
                                onPressed: () => _pageCtrl.animateToPage(
                                    (_pageCtrl.page! + 1).toInt(),
                                    duration: Duration(microseconds: 300),
                                    curve: Curves.easeIn),
                              ),
                              alignment: Alignment.centerRight,
                              margin: EdgeInsets.only(right: 30))
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white38,
                    ),
                  )
                ],
              ),
            )
          ],
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
