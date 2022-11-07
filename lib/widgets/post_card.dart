import 'package:flutter/material.dart';
import 'package:instagram_flutter/models/user.dart';
import 'package:instagram_flutter/providers/user_provider.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({super.key, required this.snap});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: mobileBackgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: Column(
        children: [
          topRow(context),

          //IMAGE SECTION
          imageSection(context),

          //LIKE COMMENT SECTION
          likeAndComment(context),

          // DESCRIPTION AND NUMBER OF COMMENTS
          descriptionAndLikes()
        ],
      ),
    );
  }

  Container descriptionAndLikes() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${widget.snap['likes'].length} likes',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            '${widget.snap['username']} ${widget.snap['description']}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            'View all 100 comments',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            DateFormat.yMMMd().format(widget.snap['datePublished'].toDate()),
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Row likeAndComment(context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Row(
      children: [
        LikeAnimation(
          isAnimating: widget.snap['likes'].contains(user.uid),
          child: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.favorite_border),
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.mode_comment_outlined),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.send_outlined),
        ),
        const Spacer(),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.bookmark_border),
        ),
      ],
    );
  }

  GestureDetector imageSection(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () => setState(() {
        isLikeAnimating = true;
      }),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.35,
            width: double.infinity,
            child: Image.network(
              widget.snap['postUrl'],
              fit: BoxFit.cover,
            ),
          ),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 150),
            opacity: isLikeAnimating ? 1 : 0,
            child: LikeAnimation(
              child: Icon(Icons.favorite, color: Colors.white, size: 100),
              isAnimating: isLikeAnimating,
              duration: const Duration(
                milliseconds: 500,
              ),
              onEnd: () {
                setState(() {
                  isLikeAnimating = false;
                });
              },
            ),
          )
        ],
      ),
    );
  }

  Container topRow(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4)
          .copyWith(right: 0),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage(
                'https://images.unsplash.com/photo-1667778679904-9d008f9f22c5?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80'),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 8,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.snap['username'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ),
          IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => Dialog(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shrinkWrap: true,
                      children: [
                        'Delete',
                      ]
                          .map(
                            (e) => InkWell(
                              onTap: () {},
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 16),
                                child: Text(e),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.more_vert))
        ],
      ),
    );
  }
}
