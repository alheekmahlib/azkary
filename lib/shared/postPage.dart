import 'dart:convert';

import 'package:Azkary/shared/style.dart';
import 'package:Azkary/shared/widgets/widgets.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:theme_provider/theme_provider.dart';

import '../../shared/widgets/lottie.dart';

class PostPage extends StatefulWidget {
  final int postId;

  const PostPage({Key? key, required this.postId}) : super(key: key);

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  Future<BlogPost>? _postFuture;

  @override
  void initState() {
    super.initState();
    _postFuture = fetchPostById(widget.postId);
  }

  Future<BlogPost> fetchPostById(int postId) async {
    final response = await http.get(Uri.parse(
        'https://github.com/alheekmahlib/thegarlanded/blob/master/azkar_noti.json?raw=true'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = jsonDecode(response.body);

      // Find the post with the matching postId
      final postJson = jsonResponse.firstWhere((post) => post['id'] == postId,
          orElse: () => null);

      if (postJson != null) {
        return BlogPost.fromJson(postJson);
      } else {
        throw Exception('Failed to find post with id $postId');
      }
    } else {
      throw Exception('Failed to load post');
    }
  }

  Widget _buildPostBody(BlogPost post) {
    List<Widget> widgets = [];

    // Add the post body text
    widgets.add(Text(
      post.body,
      style: TextStyle(
        color: ThemeProvider.themeOf(context).id == 'dark'
            ? Colors.white
            : Colors.black,
        height: 1.4,
        fontFamily: 'kufi',
        fontSize: 20.sp,
      ),
      textAlign: TextAlign.center,
    ));

    // Add the Lottie animation if present
    if (post.isLottie) {
      widgets.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Lottie.network(
          post.lottie,
          width: MediaQuery.sizeOf(context).width * .7,
        ),
      ));
    }

    // Add the image if present
    if (post.isImage) {
      final imageProvider = Image.network(post.image).image;
      widgets.add(GestureDetector(
        onTap: () {
          showImageViewer(context, imageProvider);
        },
        child: Image.network(
          post.image,
          width: MediaQuery.sizeOf(context).width * .8,
        ),
      ));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: widgets,
    );
  }

  @override
  Widget build(BuildContext context) {
    ColorStyle colorStyle = ColorStyle(context);
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          )),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0).r,
        child: FutureBuilder<BlogPost>(
          future: _postFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: bookLoading(200.0.w, 200.0.h),
              );
            } else if (snapshot.hasError) {
              return SelectableText('Error: ${snapshot.error}');
            } else {
              BlogPost post = snapshot.data!;
              var document = html_parser.parse(post.body);
              return Flex(
                direction: Axis.vertical,
                children: [
                  Align(
                      alignment: Alignment.topRight,
                      child: customClose(context)),
                  Text(
                    post.title,
                    style: TextStyle(
                      color: colorStyle.greenTextColor(),
                      height: 1.4,
                      fontFamily: 'kufi',
                      fontSize: 24.sp,
                    ),
                  ),
                  SvgPicture.asset(
                    'assets/svg/space_line.svg',
                    height: 30.h,
                  ),
                  SizedBox(
                    height: 32.0.h,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: _buildPostBody(post),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

class BlogPost {
  final int id;
  final String title;
  final String body;
  final bool isLottie;
  final String lottie;
  final bool isImage;
  final String image;

  BlogPost({
    required this.id,
    required this.title,
    required this.body,
    required this.isLottie,
    required this.lottie,
    required this.isImage,
    required this.image,
  });

  factory BlogPost.fromJson(Map<String, dynamic> json) {
    return BlogPost(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      isLottie: json['isLottie'],
      lottie: json['lottie'],
      isImage: json['isImage'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'isLottie': isLottie,
      'lottie': lottie,
      'isImage': isImage,
      'image': image,
    };
  }
}
