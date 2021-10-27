import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// custom
import 'package:myapp/controller.dart';
import 'package:myapp/utils/time.dart';

class CardNote extends StatelessWidget {
  CardNote({Key? key}) : super(key: key);
  final Controller ctrl = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '연습일지',
          style: TextStyle(
            color: Colors.indigo[900],
          ),
        ),
        Container(
          alignment: Alignment.centerRight,
          child: GetBuilder<Controller>(builder: (_) => Text('${datePrettify(ctrl.selectedDay)}')),
        ),
        Container(
          padding: EdgeInsets.all(10),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.black.withOpacity(0.1),
          ),
          child: CardNoteContent(),
        ),
      ],
    );
  }
}

class CardNoteContent extends StatefulWidget {
  const CardNoteContent({Key? key}) : super(key: key);

  @override
  _CardNoteContentState createState() => _CardNoteContentState();
}

class _CardNoteContentState extends State<CardNoteContent> {
  final Controller ctrl = Get.find();
  final noteTcr = TextEditingController();
  bool isEdit = false;

  get card {
    return ctrl.todayCard;
  }

  @override
  void initState() {
    super.initState();
    noteTcr.text = card['note'];
  }

  @override
  Widget build(BuildContext context) {
    if (isEdit) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: InputDecoration(labelText: '연습일지를 적어보세요!'),
            controller: noteTcr,
            minLines: 1,
            maxLines: 6,
            
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  shape: StadiumBorder(),
                ),
                onPressed: () {
                  noteTcr.text = card['note'];
                  setState(() => isEdit = false);
                },
                child: Text('취소'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  onPrimary: Colors.white,
                  shape: StadiumBorder(),
                ),
                onPressed: () {
                  ctrl.updateCard(note: noteTcr.text);
                  setState(() => isEdit = false);
                },
                child: Text('저장'),
              )
            ],
          )
        ],
      );
    } else {
      return ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: 50,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              alignment: Alignment.center,
              child: Text(noteTcr.text),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: FloatingActionButton.small(
                onPressed: () {
                  setState(() => isEdit = true);
                },
                backgroundColor: Colors.white,
                child: Icon(Icons.edit, size: 30),
              ),
            ),
          ],
        ),
      );
    }
  }
}
