import 'package:flutter/cupertino.dart';

class NoteCard extends StatelessWidget {
  final Color color;
  final int currentIdx;
  final double currentPage;

  NoteCard({required this.color, required this.currentIdx, required this.currentPage});

  @override
  Widget build(BuildContext context) {
    double relativePosition = currentIdx - currentPage;
    return Container(
      width: 250,
      child: Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.003)
          ..scale((1 - relativePosition.abs()).clamp(0.2, 0.6) + 0.4)
          ..rotateY(relativePosition),
        alignment: relativePosition >= 0
            ? Alignment.centerLeft
            : Alignment.centerRight,
        child: Container(
          margin: EdgeInsets.only(top: 20, bottom: 20, left: 5, right: 5),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: color,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage("https://picsum.photos/200"),
              )),
        ),
      ),
    );
  }
}
