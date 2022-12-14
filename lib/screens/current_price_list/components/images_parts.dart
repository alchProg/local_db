import 'package:local_db/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:local_db/models/standart_parts_lib.dart';
import 'package:local_db/models/part_model.dart';
import 'package:local_db/models/screen_part_model.dart';

class ImagesParts extends StatefulWidget {
  final int pID;
  final String carType;
  final Map<String, List<dynamic>> selectedPartsList;

  const ImagesParts({
    Key? key,
    required this.pID,
    required this.carType,
    required this.selectedPartsList,
  }) : super(key: key);

  @override
  State<ImagesParts> createState() => _ImagesPartsState();
}

class _ImagesPartsState extends State<ImagesParts> {
  @override
  void initState() {
    super.initState();
  }

  void _addOrDeleteItem(Part part) {
    final isContain = widget.selectedPartsList.containsKey(part.title);
    if (isContain) {
      setState(() {
        widget.selectedPartsList.remove(part.title);
      });
    } else {
      setState(() {
        widget.selectedPartsList[part.title] = [part, 0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double size = MediaQuery.of(context).size.width;
    final double xScale = size / 390;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SizedBox(
        height: 560 * xScale,
        child: Stack(
          alignment: Alignment.center,
          children: [
            //Left
            ScreenPartWidget(
              nPart: parts[10],
              pID: widget.pID,
              carType: widget.carType,
              isSide: true,
              assetName: Assets.partsOfCarLFrontBumper,
              xScale: xScale,
              left: [parts[4].sWidth! * 0.4],
              top: [parts[10].cHeight! * 1.1],
              getPart: (part) => _addOrDeleteItem(part),
              selectedPartsList: widget.selectedPartsList,
            ),

            ScreenPartWidget(
              nPart: parts[0],
              pID: widget.pID,
              carType: widget.carType,
              isSide: true,
              assetName: Assets.partsOfCarLFrontWing,
              xScale: xScale,
              left: [parts[4].sWidth],
              top: [parts[10].cHeight, parts[10].sHeight! * 0.85],
              getPart: (part) => _addOrDeleteItem(part),
              selectedPartsList: widget.selectedPartsList,
            ),
            ScreenPartWidget(
              nPart: parts[12],
              pID: widget.pID,
              carType: widget.carType,
              isSide: true,
              assetName: Assets.partsOfCarLBonnet,
              xScale: xScale,
              left: [parts[0].sWidth! * 0.9],
              top: [parts[10].cHeight! * 1.1],
              getPart: (part) => _addOrDeleteItem(part),
              selectedPartsList: widget.selectedPartsList,
            ),
            ScreenPartWidget(
              nPart: parts[1],
              pID: widget.pID,
              carType: widget.carType,
              isSide: true,
              assetName: Assets.partsOfCarLRearWing,
              xScale: xScale,
              left: [parts[4].sWidth],
              top: [
                parts[10].cHeight! * 0.85,
                parts[10].sHeight! * 0.85,
                parts[0].sHeight! * 0.85,
              ],
              getPart: (part) => _addOrDeleteItem(part),
              selectedPartsList: widget.selectedPartsList,
            ),
            ScreenPartWidget(
              nPart: parts[2],
              pID: widget.pID,
              carType: widget.carType,
              isSide: true,
              assetName: Assets.partsOfCarLFrontDoor,
              xScale: xScale,
              left: [parts[4].sWidth],
              top: [
                parts[10].cHeight,
                parts[10].sHeight! * 0.92,
                parts[0].sHeight! * 0.88,
              ],
              getPart: (part) => _addOrDeleteItem(part),
              selectedPartsList: widget.selectedPartsList,
            ),
            ScreenPartWidget(
              nPart: parts[3],
              pID: widget.pID,
              carType: widget.carType,
              isSide: true,
              assetName: Assets.partsOfCarLRearDoor,
              xScale: xScale,
              left: [parts[4].sWidth],
              top: [
                parts[10].cHeight,
                parts[10].sHeight! * 0.92,
                parts[0].sHeight!,
                parts[3].sHeight!,
              ],
              getPart: (part) => _addOrDeleteItem(part),
              selectedPartsList: widget.selectedPartsList,
            ),
            ScreenPartWidget(
              nPart: parts[4],
              pID: widget.pID,
              carType: widget.carType,
              isSide: true,
              assetName: Assets.partsOfCarLThreshold,
              xScale: xScale,
              left: const [],
              top: [
                parts[10].cHeight,
                parts[10].sHeight,
                parts[0].sHeight! * 0.8,
              ],
              getPart: (part) => _addOrDeleteItem(part),
              selectedPartsList: widget.selectedPartsList,
            ),
            ScreenPartWidget(
              nPart: parts[13],
              pID: widget.pID,
              carType: widget.carType,
              isSide: true,
              assetName: Assets.partsOfCarLTrunk,
              xScale: xScale,
              left: [
                parts[4].sWidth,
                parts[1].sWidth! * 0.65,
              ],
              top: [
                parts[10].cHeight,
                parts[10].sHeight,
                parts[0].sHeight! * 0.8,
                parts[1].sHeight! * 0.88,
              ],
              getPart: (part) => _addOrDeleteItem(part),
              selectedPartsList: widget.selectedPartsList,
            ),
            ScreenPartWidget(
              nPart: parts[11],
              pID: widget.pID,
              carType: widget.carType,
              isSide: true,
              assetName: Assets.partsOfCarLRearBumper,
              xScale: xScale,
              left: [
                parts[4].sWidth! * 0.4,
              ],
              top: [
                parts[10].cHeight,
                parts[10].sHeight,
                parts[0].sHeight! * 0.8,
                parts[1].sHeight! * 0.81,
              ],
              getPart: (part) => _addOrDeleteItem(part),
              selectedPartsList: widget.selectedPartsList,
            ),

            // //Centre
            ScreenPartWidget(
              nPart: parts[10],
              pID: widget.pID,
              carType: widget.carType,
              isSide: false,
              assetName: Assets.partsOfCarCFrontBumper,
              xScale: xScale,
              top: const [5],
              getPart: (part) => _addOrDeleteItem(part),
              selectedPartsList: widget.selectedPartsList,
            ),
            ScreenPartWidget(
              nPart: parts[12],
              pID: widget.pID,
              carType: widget.carType,
              isSide: false,
              assetName: Assets.partsOfCarCBonnet,
              xScale: xScale,
              top: [parts[10].cHeight! * 1.1],
              getPart: (part) => _addOrDeleteItem(part),
              selectedPartsList: widget.selectedPartsList,
            ),
            ScreenPartWidget(
              nPart: parts[14],
              pID: widget.pID,
              carType: widget.carType,
              isSide: false,
              assetName: Assets.partsOfCarCRoof,
              xScale: xScale,
              top: [
                parts[10].cHeight,
                parts[10].sHeight,
                parts[0].sHeight! * 0.8,
                parts[1].sHeight! * 0.1,
              ],
              getPart: (part) => _addOrDeleteItem(part),
              selectedPartsList: widget.selectedPartsList,
            ),
            ScreenPartWidget(
              nPart: parts[13],
              pID: widget.pID,
              carType: widget.carType,
              isSide: false,
              assetName: Assets.partsOfCarCTrunk,
              xScale: xScale,
              top: [
                parts[10].cHeight,
                parts[10].sHeight,
                parts[0].sHeight! * 0.8,
                parts[1].sHeight! * 0.88,
              ],
              getPart: (part) => _addOrDeleteItem(part),
              selectedPartsList: widget.selectedPartsList,
            ),
            ScreenPartWidget(
              nPart: parts[11],
              pID: widget.pID,
              carType: widget.carType,
              isSide: false,
              assetName: Assets.partsOfCarCRearBumper,
              selectedPartsList: widget.selectedPartsList,
              xScale: xScale,
              top: [
                parts[10].cHeight,
                parts[10].sHeight,
                parts[0].sHeight! * 0.8,
                parts[1].sHeight! * 0.88,
                parts[11].cHeight!,
              ],
              getPart: (part) => _addOrDeleteItem(part),
            ),

            // Right
            ScreenPartWidget(
              nPart: parts[10],
              pID: widget.pID,
              carType: widget.carType,
              isSide: true,
              assetName: Assets.partsOfCarRFrontBumper,
              xScale: xScale,
              right: [parts[4].sWidth! * 0.4],
              top: [parts[10].cHeight! * 1.1],
              getPart: (part) => _addOrDeleteItem(part),
              selectedPartsList: widget.selectedPartsList,
            ),

            ScreenPartWidget(
              nPart: parts[5],
              pID: widget.pID,
              carType: widget.carType,
              isSide: true,
              assetName: Assets.partsOfCarRFrontWing,
              xScale: xScale,
              right: [parts[4].sWidth],
              top: [parts[10].cHeight, parts[10].sHeight! * 0.85],
              getPart: (part) => _addOrDeleteItem(part),
              selectedPartsList: widget.selectedPartsList,
            ),
            ScreenPartWidget(
              nPart: parts[12],
              pID: widget.pID,
              carType: widget.carType,
              isSide: true,
              assetName: Assets.partsOfCarRBonnet,
              xScale: xScale,
              right: [parts[0].sWidth! * 0.9],
              top: [parts[10].cHeight! * 1.1],
              getPart: (part) => _addOrDeleteItem(part),
              selectedPartsList: widget.selectedPartsList,
            ),
            ScreenPartWidget(
              nPart: parts[6],
              pID: widget.pID,
              carType: widget.carType,
              isSide: true,
              assetName: Assets.partsOfCarRRearWing,
              xScale: xScale,
              right: [parts[4].sWidth],
              top: [
                parts[10].cHeight! * 0.85,
                parts[10].sHeight! * 0.85,
                parts[0].sHeight! * 0.85,
              ],
              getPart: (part) => _addOrDeleteItem(part),
              selectedPartsList: widget.selectedPartsList,
            ),
            ScreenPartWidget(
              nPart: parts[7],
              pID: widget.pID,
              carType: widget.carType,
              isSide: true,
              assetName: Assets.partsOfCarRFrontDoor,
              xScale: xScale,
              right: [parts[4].sWidth],
              top: [
                parts[10].cHeight,
                parts[10].sHeight! * 0.92,
                parts[0].sHeight! * 0.88,
              ],
              getPart: (part) => _addOrDeleteItem(part),
              selectedPartsList: widget.selectedPartsList,
            ),
            ScreenPartWidget(
              nPart: parts[8],
              pID: widget.pID,
              carType: widget.carType,
              isSide: true,
              assetName: Assets.partsOfCarRRearDoor,
              xScale: xScale,
              right: [parts[4].sWidth],
              top: [
                parts[10].cHeight,
                parts[10].sHeight! * 0.92,
                parts[0].sHeight!,
                parts[3].sHeight!,
              ],
              getPart: (part) => _addOrDeleteItem(part),
              selectedPartsList: widget.selectedPartsList,
            ),
            ScreenPartWidget(
              nPart: parts[9],
              pID: widget.pID,
              carType: widget.carType,
              isSide: true,
              assetName: Assets.partsOfCarRThreshold,
              xScale: xScale,
              right: const [],
              top: [
                parts[10].cHeight,
                parts[10].sHeight,
                parts[0].sHeight! * 0.8,
              ],
              getPart: (part) => _addOrDeleteItem(part),
              selectedPartsList: widget.selectedPartsList,
            ),
            ScreenPartWidget(
              nPart: parts[13],
              pID: widget.pID,
              carType: widget.carType,
              isSide: true,
              assetName: Assets.partsOfCarRTrunk,
              xScale: xScale,
              right: [
                parts[4].sWidth,
                parts[1].sWidth! * 0.65,
              ],
              top: [
                parts[10].cHeight,
                parts[10].sHeight,
                parts[0].sHeight! * 0.8,
                parts[1].sHeight! * 0.88,
              ],
              getPart: (part) => _addOrDeleteItem(part),
              selectedPartsList: widget.selectedPartsList,
            ),
            ScreenPartWidget(
              nPart: parts[11],
              pID: widget.pID,
              carType: widget.carType,
              isSide: true,
              assetName: Assets.partsOfCarRRearBumper,
              xScale: xScale,
              right: [
                parts[4].sWidth! * 0.4,
              ],
              top: [
                parts[10].cHeight,
                parts[10].sHeight,
                parts[0].sHeight! * 0.8,
                parts[1].sHeight! * 0.81,
              ],
              getPart: (part) => _addOrDeleteItem(part),
              selectedPartsList: widget.selectedPartsList,
            ),
          ],
        ),
      ),
    );
  }
}
