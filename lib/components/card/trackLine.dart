import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// custom
import 'package:myapp/controller.dart';
import 'package:myapp/utils/stamp.dart';

class TrackLine extends StatelessWidget {
  final int i;
  TrackLine(int this.i, {Key? key}) : super(key: key) {}
  final Controller ctrl = Get.find();

  get track {
    return ctrl.trackList[i];
  }

  get trackColor {
    final baseColor = Colors.blue;
    if (track['color'] == null || track['color'].isEmpty) {
      return baseColor;
    }
    return Color(int.parse(track['color']));
  }

  get stamps {
    // print('stampname');
    // print(stampName);
    return ctrl.stampDict[track['id']] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(width: 1, color: trackColor),
            bottom: BorderSide(width: 1, color: trackColor),
          ),
        ),
        child: GetBuilder<Controller>(builder: (_) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              for (int i = 0; i < stamps.length; i++)
                Stamp(
                  trackId: track['id'],
                  item: stamps[i],
                  stampName: track['stamp_name'],
                ),
              for (int i = 0; i < track['max_stamp'] - stamps.length; i++)
                Stamp(
                  trackId: track['id'],
                  item: null,
                  stampName: track['stamp_name'],
                ),
            ],
          );
        }));
  }
}

class Stamp extends StatelessWidget {
  final dynamic item;
  final int trackId;
  final String stampName;
  final noteTcr = TextEditingController();

  Stamp({
    required int this.trackId,
    dynamic this.item,
    String this.stampName = 'bear',
    Key? key,
  }) : super(key: key) {
    if (item != null) {
      noteTcr.text = item['note'];
    }
  }

  final Controller ctrl = Get.find();

  void alertModify(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            insetPadding: EdgeInsets.all(30),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${item['created_at']} 에 생성'),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey[200],
                    ),
                    child: Column(
                      children: [
                        Text('연습 노트'),
                        TextField(
                          decoration:
                              InputDecoration(labelText: '연습노트를 적어보세요!'),
                          controller: noteTcr,
                          minLines: 1,
                          maxLines: 6,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton.icon(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          if (item != null)
                            ctrl.deleteStamp(trackId, item['id']);
                          Navigator.of(context).pop();
                        },
                        label: Text('삭제하기'),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: StadiumBorder(),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('취소'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: StadiumBorder(),
                          onPrimary: Colors.white,
                        ),
                        onPressed: () {
                          ctrl.updateStamp(trackId, item['id'],
                              note: noteTcr.text);
                          Navigator.of(context).pop();
                        },
                        child: Text('저장'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget StampImage({String stampName = '', bool isHide = false}) {
    if (stampName.isEmpty) {
      stampName = 'bear';
    }
    return Container(
      margin: EdgeInsets.all(5),
      child: Image.asset(
        animalDict[stampName] ?? '',
        color: isHide ? Colors.grey : null,
        // colorBlendMode: BlendMode.modulate,
        width: 30,
        height: 30,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget Empty(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ctrl.insertStamp(trackId);
      },
      child: StampImage(
        stampName: stampName,
        isHide: true,
      ),
    );
  }

  Widget Filled(BuildContext context) {
    return GestureDetector(
      onTap: () {
        alertModify(context);
      },
      child: Tooltip(
        // message: item['${item['note']}(${item['created_at']})'],
        message: '${item['note']}(${item['created_at']})',
        waitDuration: Duration(),
        child: StampImage(
          stampName: stampName,
          isHide: false,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: item == null ? Empty(context) : Filled(context),
    );
  }
}
