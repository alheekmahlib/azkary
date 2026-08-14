import 'dart:io';
import 'dart:ui' as ui;

import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import "../../core/themes/app_themes.dart";
import '../../l10n/app_localizations.dart';
import '../widgets/lottie.dart';
import '../widgets/widgets.dart';

ArabicNumbers arabicNumber = ArabicNumbers();

/// Share Ayah
Future<Uint8List> createVerseImage(
    String zkrText, zkrCategory, zkrDescription) async {
  // Set a fixed canvas width
  const canvasWidth = 960.0;
  // const fixedWidth = canvasWidth;

  final textPainter = TextPainter(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$zkrText',
            style: const TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.normal,
              fontFamily: 'uthmanic2',
              color: Color(0xff161f07),
            ),
          ),
          TextSpan(
            text: ' ${arabicNumber.convert(zkrDescription)}\n',
            style: const TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.normal,
              fontFamily: 'uthmanic2',
              color: Color(0xff161f07),
            ),
          ),
        ],
      ),
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.justify);
  textPainter.layout(maxWidth: 800);

  final padding = 32.0;
  // final imagePadding = 20.0;

  // Load the PNG image
  final pngBytes =
      await rootBundle.load('assets/share_images/Sorah_name_ba.png');
  final codec = await ui.instantiateImageCodec(pngBytes.buffer.asUint8List());
  final frameInfo = await codec.getNextFrame();
  final pngImage = frameInfo.image;

  // Load the second PNG image
  final pngBytes2 = await rootBundle.load('assets/app_icon.png');
  final codec2 = await ui.instantiateImageCodec(pngBytes2.buffer.asUint8List());
  final frameInfo2 = await codec2.getNextFrame();
  final pngImage2 = frameInfo2.image;

  // Calculate the image sizes and positions
  final imageWidth = pngImage.width.toDouble() / 1.0;
  final imageHeight = pngImage.height.toDouble() / 1.0;
  final imageX = (canvasWidth - imageWidth) / 2; // Center the first image
  final imageY = padding;

  final image2Width = pngImage2.width.toDouble() / 4.0;
  final image2Height = pngImage2.height.toDouble() / 4.0;
  final image2X = (canvasWidth - image2Width) / 2; // Center the second image
  final image2Y = imageHeight + padding - 90; // Adjust this value as needed

  // Set the text position
  final textX =
      (canvasWidth - textPainter.width) / 2; // Center the text horizontally
  final textY = image2Y +
      image2Height +
      padding +
      20; // Position the text below the second image

  final pngBytes3 = await rootBundle.load('assets/share_images/Logo_line2.png');
  final codec3 = await ui.instantiateImageCodec(pngBytes3.buffer.asUint8List());
  final frameInfo3 = await codec3.getNextFrame();
  final pngImage3 = frameInfo3.image;

  // Calculate the canvas width and height
  double canvasHeight = textPainter.height + imageHeight + 3 * padding;

  // Calculate the new image sizes and positions
  final image3Width = pngImage3.width.toDouble() / 5.0;
  final image3Height = pngImage3.height.toDouble() / 5.0;
  final image3X =
      (canvasWidth - image3Width) / 2; // Center the image horizontally

// Calculate the position of the new image to be below the new text
  final image3Y = textPainter.height + padding + 70;

  // Calculate the minimum height
  final minHeight = imageHeight + image2Height + image3Height + 4 * padding;

  // Set the canvas width and height
  canvasHeight = textPainter.height +
      imageHeight +
      image2Height +
      image3Height +
      5 * padding;

  // Check if the total height is less than the minimum height
  if (canvasHeight < minHeight) {
    canvasHeight = minHeight;
  }

  // Update the canvas height
  canvasHeight += image3Height + textPainter.height + 3 + padding;

  final pictureRecorder = ui.PictureRecorder();
  final canvas = Canvas(
      pictureRecorder,
      Rect.fromLTWH(
          0, 0, canvasWidth, canvasHeight)); // Add Rect to fix the canvas size

  final borderRadius = 25.0;
  final borderPaint = Paint()
    ..color = const Color(0xff91a57d)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 25;

  final backgroundPaint = Paint()..color = const Color(0xffF5EFE7);

  final rRect = RRect.fromLTRBR(
      0, 0, canvasWidth, canvasHeight, Radius.circular(borderRadius));

  canvas.drawRRect(rRect, backgroundPaint);
  canvas.drawRRect(rRect, borderPaint);

  textPainter.paint(canvas, Offset(textX, textY));
  canvas.drawImageRect(
    pngImage,
    Rect.fromLTWH(0, 0, pngImage.width.toDouble(), pngImage.height.toDouble()),
    Rect.fromLTWH(imageX, imageY, imageWidth, imageHeight),
    Paint(),
  );

  canvas.drawImageRect(
    pngImage2,
    Rect.fromLTWH(
        0, 0, pngImage2.width.toDouble(), pngImage2.height.toDouble()),
    Rect.fromLTWH(image2X, image2Y, image2Width, image2Height),
    Paint(),
  );

  canvas.drawImageRect(
    pngImage3,
    Rect.fromLTWH(
        0, 0, pngImage3.width.toDouble(), pngImage3.height.toDouble()),
    Rect.fromLTWH(image3X, image3Y, image3Width, image3Height),
    Paint(),
  );

  final picture = pictureRecorder.endRecording();
  final imgWidth = canvasWidth
      .toInt(); // Use canvasWidth instead of (textPainter.width + 2 * padding)
  final imgHeight =
      (textPainter.height + imageHeight + image3Height + 4 * padding - 90)
          .toInt();
  final imgScaleFactor = 1; // Increase this value for a higher resolution image
  final imgScaled = await picture.toImage(
      imgWidth * imgScaleFactor, imgHeight * imgScaleFactor);

  // Convert the image to PNG bytes
  final pngResultBytes =
      await imgScaled.toByteData(format: ui.ImageByteFormat.png);

  // Decode the PNG bytes to an image object
  final decodedImage = img.decodePng(pngResultBytes!.buffer.asUint8List());

  // Scale down the image to the desired resolution
  final resizedImage =
      img.copyResize(decodedImage!, width: imgWidth, height: imgHeight);

  // Convert the resized image back to PNG bytes
  final resizedPngBytes = img.encodePng(resizedImage);

  return resizedPngBytes;
}

Future<Uint8List> createVerseWithTranslateImage(
    BuildContext context,
    String zkrText,
    zkrCategory,
    zkrDescription,
    zkrCount,
    azkarReference) async {
  // Set a fixed canvas width
  const canvasWidth = 960.0;
  // const fixedWidth = canvasWidth;

  final textZkr = TextPainter(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$zkrText',
            style: TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.normal,
              fontFamily: 'naskh',
              color: ThemeController.instance.currentThemeId.value == 'dark'
                  ? Colors.white
                  : const Color(0xff263A29),
            ),
          ),
          // TextSpan(
          //   text: ' ${arabicNumber.convert(zkrCount)}\n',
          //   style: TextStyle(
          //     fontSize: 50,
          //     fontWeight: FontWeight.normal,
          //     fontFamily: 'kufi',
          //     color: ThemeController.instance.currentThemeId.value == 'dark'
          //         ? Colors.white
          //         : const Color(0xff263A29),
          //   ),
          // ),
        ],
      ),
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.justify);
  textZkr.layout(maxWidth: 800);

  final padding = 32.0;
  // final imagePadding = 20.0;

  // Load the PNG image
  final pngBytes = await rootBundle.load('assets/share_images/frame22.png');
  final codec = await ui.instantiateImageCodec(pngBytes.buffer.asUint8List());
  final frameInfo = await codec.getNextFrame();
  final pngImage = frameInfo.image;

  // Load the second PNG image
  final pngBytes2 = await rootBundle.load('assets/share_images/hisn_icon.png');
  final codec2 = await ui.instantiateImageCodec(pngBytes2.buffer.asUint8List());
  final frameInfo2 = await codec2.getNextFrame();
  final pngImage2 = frameInfo2.image;

  // Calculate the image sizes and positions
  final imageWidth = pngImage.width.toDouble() / 1.0;
  final imageHeight = pngImage.height.toDouble() / 1.0;
  final imageX = (canvasWidth - imageWidth) / 2; // Center the first image
  final imageY = padding - 35;

  final image2Width = pngImage2.width.toDouble() / 4.0;
  final image2Height = pngImage2.height.toDouble() / 4.0;
  final image2X = padding + 770; // Center the second image
  final image2Y = imageHeight + padding - 70; // Adjust this value as needed

  // Set the text position
  final textX =
      (canvasWidth - textZkr.width) / 2; // Center the text horizontally
  final textY = image2Y +
      image2Height +
      padding +
      20; // Position the text below the second image

  final pngBytes3 = await rootBundle.load('assets/share_images/frame2.png');
  final codec3 = await ui.instantiateImageCodec(pngBytes3.buffer.asUint8List());
  final frameInfo3 = await codec3.getNextFrame();
  final pngImage3 = frameInfo3.image;

  // Calculate the canvas width and height
  double canvasHeight = textZkr.height + imageHeight + 3 * padding;

  // Calculate the new image sizes and positions
  final image3Width = pngImage3.width.toDouble() / 1.0;
  final image3Height = pngImage3.height.toDouble() / 1.0;
  final image3X =
      (canvasWidth - image3Width) / 2; // Center the image horizontally

  // String? countZkr;
  // if (cubit.shareTafseerValue == 1) {
  //   countZkr = cubit.radioValue != 3 ? null : AppLocalizations.of(context)!.tafSaadiN;
  // } else if (cubit.shareTafseerValue == 2) {
  //   countZkr = transName[cubit.transIndex!];
  // }
  final countZkr = TextPainter(
      text: TextSpan(
        text: '${arabicNumber.convert(zkrCount)} \n',
        style: TextStyle(
          fontSize: 35,
          fontWeight: FontWeight.normal,
          fontFamily: 'kufi',
          color: ThemeController.instance.currentThemeId.value == 'dark'
              ? Colors.white
              : const Color(0xff263A29),
          backgroundColor: const Color(0xff41644A).withValues(alpha: .2),
        ),
      ),
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.center);
  countZkr.layout(maxWidth: 800);

  final countZkrX = padding + 690;

  final categoryZkr = TextPainter(
      text: TextSpan(
        text: zkrCategory,
        style: TextStyle(
          fontSize: 35,
          fontWeight: FontWeight.normal,
          fontFamily: 'kufi',
          color: ThemeController.instance.currentThemeId.value == 'dark'
              ? Colors.white
              : const Color(0xff263A29),
          backgroundColor: const Color(0xff41644A).withValues(alpha: .2),
        ),
      ),
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.right);
  categoryZkr.layout(maxWidth: 400);

  final categoryZkrX = padding + 10;
  final categoryZkrY = padding + 50;

  // Calculate the position of the new image to be below the new text
  // final image3Y = countZkrY + countZkr.height + padding - 20;

  final referenceZkr = TextPainter(
      text: TextSpan(
        text: '$azkarReference',
        style: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.normal,
            fontFamily: 'kufi',
            color: ThemeController.instance.currentThemeId.value == 'dark'
                ? Colors.white
                : const Color(0xff263A29),
            backgroundColor: const Color(0xff41644A).withValues(alpha: .1)),
      ),
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.right);
  referenceZkr.layout(maxWidth: 800);

  final referenceZkrX = padding + 50;
  final referenceZkrY = textY + textZkr.height + padding - 30;
  // Create the new text painter
  final descriptionZkr = TextPainter(
      text: TextSpan(
        text: '$zkrDescription',
        style: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.normal,
            fontFamily: 'kufi',
            color: ThemeController.instance.currentThemeId.value == 'dark'
                ? Colors.white
                : const Color(0xff263A29),
            backgroundColor: const Color(0xff41644A).withValues(alpha: .3)),
      ),
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.justify);
  descriptionZkr.layout(maxWidth: 800);

  final descriptionZkrX = padding + 50;
  final descriptionZkrY =
      textY + textZkr.height + padding + referenceZkr.height + 10;

  var image3Y;
  // Calculate the position of the new image to be below the new text
  zkrDescription == ""
      ? (image3Y = textY + textZkr.height + referenceZkr.height + 40)
      : image3Y = descriptionZkrY + descriptionZkr.height + referenceZkr.height;

  // Calculate the minimum height
  final minHeight = imageHeight + image2Height + image3Height + 4 * padding;

  // Set the canvas width and height
  canvasHeight = textZkr.height +
      descriptionZkr.height +
      referenceZkr.height +
      imageHeight +
      image2Height +
      image3Height * padding;
  final countZkrY = zkrDescription == ""
      ? textY + textZkr.height + referenceZkr.height + padding + 5
      : textY +
          textZkr.height +
          descriptionZkr.height +
          referenceZkr.height +
          padding +
          40;
  // Check if the total height is less than the minimum height
  if (canvasHeight < minHeight) {
    canvasHeight = minHeight;
  }

  // Update the canvas height
  canvasHeight +=
      image3Height + descriptionZkr.height + referenceZkr.height + 30 + padding;

  final pictureRecorder = ui.PictureRecorder();
  final canvas = Canvas(
      pictureRecorder,
      Rect.fromLTWH(
          0, 0, canvasWidth, canvasHeight)); // Add Rect to fix the canvas size

  final borderRadius = 25.0;
  final borderPaint = Paint()
    ..color = const Color(0xff263A29)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 25;

  final backgroundPaint = Paint()..color = const Color(0xffF5EFE7);

  final rRect = RRect.fromLTRBR(
      0, 0, canvasWidth, canvasHeight, Radius.circular(borderRadius));

  canvas.drawRRect(rRect, backgroundPaint);
  canvas.drawRRect(rRect, borderPaint);
  categoryZkr.paint(canvas, Offset(categoryZkrX, categoryZkrY));
  textZkr.paint(canvas, Offset(textX, textY));
  canvas.drawImageRect(
    pngImage,
    Rect.fromLTWH(0, 0, pngImage.width.toDouble(), pngImage.height.toDouble()),
    Rect.fromLTWH(imageX, imageY, imageWidth, imageHeight),
    Paint(),
  );

  canvas.drawImageRect(
    pngImage2,
    Rect.fromLTWH(
        0, 0, pngImage2.width.toDouble(), pngImage2.height.toDouble()),
    Rect.fromLTWH(image2X, image2Y, image2Width, image2Height),
    Paint(),
  );

  canvas.drawImageRect(
    pngImage3,
    Rect.fromLTWH(
        0, 0, pngImage3.width.toDouble(), pngImage3.height.toDouble()),
    Rect.fromLTWH(image3X, image3Y, image3Width, image3Height),
    Paint(),
  );

  descriptionZkr.paint(canvas, Offset(descriptionZkrX, descriptionZkrY));
  referenceZkr.paint(canvas, Offset(referenceZkrX, referenceZkrY));
  countZkr.paint(canvas, Offset(countZkrX, countZkrY));

  final picture = pictureRecorder.endRecording();
  final imgWidth = canvasWidth
      .toInt(); // Use canvasWidth instead of (textZkr.width + 2 * padding)
  final imgHeight = zkrDescription == ""
      ? (textZkr.height +
              referenceZkr.height +
              imageHeight +
              image3Height +
              5.6 * padding)
          .toInt()
      : (textZkr.height +
              descriptionZkr.height +
              referenceZkr.height +
              imageHeight +
              image3Height +
              7.1 * padding)
          .toInt();

  final imgScaleFactor = 1; // Increase this value for a higher resolution image
  final imgScaled = await picture.toImage(
      imgWidth * imgScaleFactor, imgHeight * imgScaleFactor);

  // Convert the image to PNG bytes
  final pngResultBytes =
      await imgScaled.toByteData(format: ui.ImageByteFormat.png);

  // Decode the PNG bytes to an image object
  final decodedImage = img.decodePng(pngResultBytes!.buffer.asUint8List());

  // Scale down the image to the desired resolution
  final resizedImage =
      img.copyResize(decodedImage!, width: imgWidth, height: imgHeight);

  // Convert the resized image back to PNG bytes
  final resizedPngBytes = img.encodePng(resizedImage);

  return resizedPngBytes;
}

shareText(String zkrText, zkrCategory, zkrDescription, zkrCount) {
  Share.share('${zkrCategory}\n\n'
      '${zkrText}\n\n'
      '| ${zkrDescription}. | (التكرار: ${zkrCount})');
  // Share.share(
  //     '﴿$verseText﴾ '
  //         '[$surahName-'
  //         '$verseNumber]',
  //     subject: '$surahName');
}

Future<void> shareVerseWithTranslate(BuildContext context, String zkrText,
    zkrCategory, zkrDescription, zkrCount, azkarReference) async {
  final imageData = await createVerseWithTranslateImage(
      context, zkrText, zkrCategory, zkrDescription, zkrCount, azkarReference);

  // Save the image to a temporary directory
  final directory = await getTemporaryDirectory();
  final filename = 'verse_${DateTime.now().millisecondsSinceEpoch}.png';
  final imagePath = '${directory.path}/$filename';
  final imageFile = File(imagePath);
  await imageFile.writeAsBytes(imageData);

  if (imageFile.existsSync()) {
    await Share.shareXFiles([XFile((imagePath))],
        text: AppLocalizations.of(context)!.appName);
  } else {
    print('Failed to save and share image');
  }
}

Future<void> shareVerse(
    BuildContext context, String zkrText, zkrCategory, zkrDescription) async {
  final imageData2 =
      await createVerseImage(zkrText, zkrCategory, zkrDescription);

  // Save the image to a temporary directory
  final directory = await getTemporaryDirectory();
  final filename = 'verse_${DateTime.now().millisecondsSinceEpoch}.png';
  final imagePath = '${directory.path}/$filename';
  final imageFile = File(imagePath);
  await imageFile.writeAsBytes(imageData2);

  if (imageFile.existsSync()) {
    await Share.shareXFiles([XFile((imagePath))],
        text: AppLocalizations.of(context)!.appName);
  } else {
    print('Failed to save and share image');
  }
}

void showVerseOptionsBottomSheet(BuildContext context, String zkrText,
    zkrCategory, zkrDescription, zkrCount, azkarReference) async {
  // Call createVerseWithTranslateImage and get the image data
  Uint8List imageData = await createVerseWithTranslateImage(
      context, zkrText, zkrCategory, zkrDescription, zkrCount, azkarReference);

  allModalBottomSheet(
    context,
    Container(
      alignment: Alignment.center,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                height: 30,
                width: 30,
                margin: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(8),
                    ),
                    border: Border.all(
                        width: 2, color: Theme.of(context).dividerColor)),
                child: Icon(
                  Icons.close_outlined,
                  color: Theme.of(context).colorScheme.surface,
                ),
              ),
            ),
          ),
          Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 16.0),
                child: shareLottie(40.0, 40.0),
              )),
          Padding(
            padding: const EdgeInsets.only(top: 70.0),
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SizedBox(
                    width: orientation(
                        context,
                        MediaQuery.sizeOf(context).width * .6,
                        MediaQuery.sizeOf(context).width / 1 / 3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.shareText,
                          style: TextStyle(
                              color: ThemeController
                                          .instance.currentThemeId.value ==
                                      'dark'
                                  ? Theme.of(context).colorScheme.surface
                                  : Theme.of(context).primaryColorDark,
                              fontSize: 16,
                              fontFamily: 'kufi'),
                        ),
                        Container(
                          height: 2,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          width: MediaQuery.sizeOf(context).width / 1 / 3,
                          color: Theme.of(context).dividerColor,
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  child: Container(
                    // height: 60,
                    width: MediaQuery.sizeOf(context).width,
                    padding: const EdgeInsets.all(16.0),
                    margin: const EdgeInsets.only(
                        top: 4.0, bottom: 16.0, right: 16.0, left: 16.0),
                    decoration: BoxDecoration(
                        color: Theme.of(context)
                            .dividerColor
                            .withValues(alpha: .3),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4))),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.text_fields,
                          color: Theme.of(context).colorScheme.surface,
                          size: 24,
                        ),
                        SizedBox(
                          width: orientation(
                              context,
                              MediaQuery.sizeOf(context).width * .7,
                              MediaQuery.sizeOf(context).width / 1 / 3),
                          child: Text(
                            "$zkrText",
                            style: TextStyle(
                                color: ThemeController
                                            .instance.currentThemeId.value ==
                                        'dark'
                                    ? Theme.of(context).colorScheme.surface
                                    : Theme.of(context).primaryColorDark,
                                fontSize: 16,
                                fontFamily: 'naskh'),
                            textDirection: TextDirection.rtl,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    shareText(zkrText, zkrCategory, zkrDescription, zkrCount);
                    Navigator.pop(context);
                  },
                ),
                Container(
                  height: 2,
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 16.0),
                  width: MediaQuery.sizeOf(context).width * .3,
                  color: Theme.of(context).dividerColor,
                ),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: SizedBox(
                          width: orientation(
                              context,
                              MediaQuery.sizeOf(context).width * .6,
                              MediaQuery.sizeOf(context).width / 1 / 3),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.shareImage,
                                style: TextStyle(
                                    color: ThemeController.instance
                                                .currentThemeId.value ==
                                            'dark'
                                        ? Theme.of(context).colorScheme.surface
                                        : Theme.of(context).primaryColorDark,
                                    fontSize: 16,
                                    fontFamily: 'kufi'),
                              ),
                              Container(
                                height: 2,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                width: MediaQuery.sizeOf(context).width * .2,
                                color: Theme.of(context).dividerColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        child: Container(
                          // width: MediaQuery.sizeOf(context).width * .4,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          margin: const EdgeInsets.only(
                              top: 4.0, bottom: 16.0, right: 16.0, left: 16.0),
                          decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .dividerColor
                                  .withValues(alpha: .3),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4))),
                          child: Image.memory(
                            imageData,
                            // height: 150,
                            // width: 150,
                          ),
                        ),
                        onTap: () {
                          shareVerseWithTranslate(context, zkrText, zkrCategory,
                              zkrDescription, zkrCount, azkarReference);
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
