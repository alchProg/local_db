import 'package:local_db/db/local_database.dart';
import 'package:local_db/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:local_db/models/normal_parts_lib.dart';
import 'package:local_db/models/price_list_model.dart';
import 'package:local_db/models/screen_part_model.dart';



class ImagesParts extends StatefulWidget {

  final int pID;
  final String carType;

  const ImagesParts({Key? key, required this.pID, required this.carType}) : super(key: key);

  @override
  State<ImagesParts> createState() => _ImagesPartsState();
}

class _ImagesPartsState extends State<ImagesParts> {

  late List<PriceList> priceLists;

  @override
  void initState() {
    _priceListRefresh();
    super.initState();
  }

  _priceListRefresh() async {
    priceLists = await LocalDatabase.instance.readAllPriceLists();
  }

  Color _switchColor (PriceList priceList) {
    Color color1 = Colors.brown.shade700;
    Color color2 = Colors.white.withOpacity(0.4);

    if(priceLists.contains(priceList)){
      return color1;
    }
    return color2;
  }

  @override
  Widget build(BuildContext context) {

    final double size = MediaQuery.of(context).size.width;
    final double xScale = size/390;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SizedBox(
        height: 560*xScale,
        child:  Stack(
          alignment:Alignment.center,
          children: [
            //Left
            ScreenPartWidget(
              nPart: parts[10],
              pID: widget.pID,
              carType: widget.carType,
              isSide: true,
              assetName: Assets.partsOfCarLFrontBumper,
              xScale: xScale,
              left: [parts[4].sWidth!*0.4],
              top: [parts[10].cHeight!*1.1],
              onTap: (){

              },
            ),

            ScreenPartWidget(
              nPart: parts[0],
              pID: widget.pID,
              carType: widget.carType,
              isSide: true,
              assetName: Assets.partsOfCarLFrontWing,
              xScale: xScale,
              left: [parts[4].sWidth],
              top: [
                parts[10].cHeight,
                parts[10].sHeight!*0.85
              ],
              onTap: (){},
            ),
            ScreenPartWidget(
              nPart: parts[12],
              pID: widget.pID,
              carType: widget.carType,
              isSide: true,
              assetName: Assets.partsOfCarLBonnet,
              xScale: xScale,
              left: [parts[0].sWidth!*0.9],
              top: [parts[10].cHeight!*1.1],
              onTap: (){},
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
                parts[10].cHeight!*0.85,
                parts[10].sHeight!*0.85,
                parts[0].sHeight!*0.85,
              ],
              onTap: (){},
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
                parts[10].sHeight!*0.92,
                parts[0].sHeight!*0.88,
              ],
              onTap: (){},
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
                parts[10].sHeight!*0.92,
                parts[0].sHeight!,
                parts[3].sHeight!,
              ],
              onTap: (){},
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
                parts[0].sHeight!*0.8,
              ],
              onTap: (){},
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
                parts[1].sWidth!*0.65,
              ],
              top: [
                parts[10].cHeight,
                parts[10].sHeight,
                parts[0].sHeight!*0.8,
                parts[1].sHeight!*0.88,
              ],
              onTap: (){},
            ),
            ScreenPartWidget(
              nPart: parts[11],
              pID: widget.pID,
              carType: widget.carType,
              isSide: true,
              assetName: Assets.partsOfCarLRearBumper,
              xScale: xScale,
              left: [
                parts[4].sWidth!*0.4,
              ],
              top: [
                parts[10].cHeight,
                parts[10].sHeight,
                parts[0].sHeight!*0.8,
                parts[1].sHeight!*0.81,
              ],
              onTap: (){},
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
              onTap: (){},
            ),
            ScreenPartWidget(
              nPart: parts[12],
              pID: widget.pID,
              carType: widget.carType,
              isSide: false,
              assetName: Assets.partsOfCarCBonnet,
              xScale: xScale,
              top: [parts[10].cHeight!*1.1],
              onTap: (){},
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
                parts[0].sHeight!*0.8,
                parts[1].sHeight!*0.1,
              ],
              onTap: (){},
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
                parts[0].sHeight!*0.8,
                parts[1].sHeight!*0.88,
              ],
              onTap: (){},
            ),
            ScreenPartWidget(
              nPart: parts[11],
              pID: widget.pID,
              carType: widget.carType,
              isSide: false,
              assetName: Assets.partsOfCarCRearBumper,
              xScale: xScale,
              top: [
                parts[10].cHeight,
                parts[10].sHeight,
                parts[0].sHeight!*0.8,
                parts[1].sHeight!*0.88,
                parts[11].cHeight!,
              ],
              onTap: (){},
            ),


            // Right
            ScreenPartWidget(
              nPart: parts[10],
              pID: widget.pID,
              carType: widget.carType,
              isSide: true,
              assetName: Assets.partsOfCarRFrontBumper,
              xScale: xScale,
              right: [parts[4].sWidth!*0.4],
              top: [parts[10].cHeight!*1.1],
              onTap: (){},
            ),

            ScreenPartWidget(
              nPart: parts[5],
              pID: widget.pID,
              carType: widget.carType,
              isSide: true,
              assetName: Assets.partsOfCarRFrontWing,
              xScale: xScale,
              right: [parts[4].sWidth],
              top: [
                parts[10].cHeight,
                parts[10].sHeight!*0.85
              ],
              onTap: (){},
            ),
            ScreenPartWidget(
              nPart: parts[12],
              pID: widget.pID,
              carType: widget.carType,
              isSide: true,
              assetName: Assets.partsOfCarRBonnet,
              xScale: xScale,
              right: [parts[0].sWidth!*0.9],
              top: [parts[10].cHeight!*1.1],
              onTap: (){},
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
                parts[10].cHeight!*0.85,
                parts[10].sHeight!*0.85,
                parts[0].sHeight!*0.85,
              ],
              onTap: (){},
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
                parts[10].sHeight!*0.92,
                parts[0].sHeight!*0.88,
              ],
              onTap: (){},
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
                parts[10].sHeight!*0.92,
                parts[0].sHeight!,
                parts[3].sHeight!,
              ],
              onTap: (){},
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
                parts[0].sHeight!*0.8,
              ],
              onTap: (){},
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
                parts[1].sWidth!*0.65,
              ],
              top: [
                parts[10].cHeight,
                parts[10].sHeight,
                parts[0].sHeight!*0.8,
                parts[1].sHeight!*0.88,
              ],
              onTap: (){},
            ),
            ScreenPartWidget(
              nPart: parts[11],
              pID: widget.pID,
              carType: widget.carType,
              isSide: true,
              assetName: Assets.partsOfCarRRearBumper,
              xScale: xScale,
              right: [
                parts[4].sWidth!*0.4,
              ],
              top: [
                parts[10].cHeight,
                parts[10].sHeight,
                parts[0].sHeight!*0.8,
                parts[1].sHeight!*0.81,
              ],
              onTap: (){},
            ),
          ],
        ),
      ),
    );
  }
}
