List<StandartPart> parts = [
  /*0 */ StandartPart(
    title: 'Левое переднее крыло',
    side: 'Лево',
    sHeight: 81.67,
    sWidth: 67.68,
    cHeight: 0,
    cWidth: 0,
  ),
  /*1 */ StandartPart(
    title: 'Левое заднее крыло',
    side: 'Лево',
    sHeight: 294.85,
    sWidth: 105.49,
    cHeight: 0,
    cWidth: 0,
  ),
  /*2 */ StandartPart(
    title: 'Левая передняя дверь',
    side: 'Лево',
    sHeight: 103.1,
    sWidth: 66.92,
    cHeight: 0,
    cWidth: 0,
  ),
  /*3 */ StandartPart(
    title: 'Левая задняя дверь',
    side: 'Лево',
    sHeight: 91.37,
    sWidth: 71.84,
    cHeight: 0,
    cWidth: 0,
  ),
  /*4 */ StandartPart(
    title: 'Левый порог',
    side: 'Лево',
    sHeight: 169.39,
    sWidth: 10.02,
    cHeight: 0,
    cWidth: 0,
  ),
  /*5 */ StandartPart(
    title: 'Правое переднее крыло',
    side: 'Право',
    sHeight: 81.67,
    sWidth: 67.68,
    cHeight: 0,
    cWidth: 0,
  ),
  /*6 */ StandartPart(
    title: 'Правое заднее крыло',
    side: 'Право',
    sHeight: 294.85,
    sWidth: 105.49,
    cHeight: 0,
    cWidth: 0,
  ),
  /*7 */ StandartPart(
    title: 'Правая передняя дверь',
    side: 'Право',
    sHeight: 103.1,
    sWidth: 66.92,
    cHeight: 0,
    cWidth: 0,
  ),
  /*8 */ StandartPart(
    title: 'Правая задняя дверь',
    side: 'Право',
    sHeight: 91.37,
    sWidth: 71.84,
    cHeight: 0,
    cWidth: 0,
  ),
  /*9 */ StandartPart(
    title: 'Правый порог',
    side: 'Право',
    sHeight: 169.39,
    sWidth: 10.02,
    cHeight: 0,
    cWidth: 0,
  ),
  /*10*/ StandartPart(
    title: 'Передний бампер',
    side: 'Центр',
    sHeight: 44.62,
    sWidth: 44.62,
    cHeight: 60.52,
    cWidth: 173.34,
  ),
  /*11*/ StandartPart(
    title: 'Задний бампер',
    side: 'Центр',
    sHeight: 56,
    sWidth: 58.23,
    cHeight: 51.4,
    cWidth: 168.63,
  ),
  /*12*/ StandartPart(
    title: 'Капот',
    side: 'Центр',
    sHeight: 93.77,
    sWidth: 28.36,
    cHeight: 96.04,
    cWidth: 161.45,
  ),
  /*13*/ StandartPart(
    title: 'Багажник',
    side: 'Центр',
    sHeight: 33.01,
    sWidth: 10.96,
    cHeight: 74.52,
    cWidth: 125.53,
  ),
  /*14*/ StandartPart(
    title: 'Крыша',
    side: 'Центр',
    sHeight: 0,
    sWidth: 0,
    cHeight: 171.96,
    cWidth: 171.96,
  ),
];

class StandartPart {
  String title;
  String side;
  double? cHeight;
  double? cWidth;
  double? sHeight;
  double? sWidth;

  StandartPart(
      {required this.title,
      required this.side,
      this.cHeight,
      this.cWidth,
      this.sHeight,
      this.sWidth});
}
