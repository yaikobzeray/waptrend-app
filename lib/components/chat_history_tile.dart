import 'package:foap/helper/imports/chat_imports.dart';
import 'package:foap/helper/imports/common_import.dart';
import 'package:foap/helper/string_extension.dart';

class ChatHistoryTile extends StatelessWidget {
  final ChatRoomModel model;

  const ChatHistoryTile({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        border: BorderDirectional(
            bottom: BorderSide(
          color: AppColorConstants.dividerColor.withOpacity(0.2),
          width: 2,
        )),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                model.isGroupChat
                    ? Container(
                        color: AppColorConstants.themeColor,
                        height: 45,
                        width: 45,
                        child:
                            model.image == null || (model.image ?? '').isEmpty
                                ? ThemeIconWidget(
                                    ThemeIcon.group,
                                    color: Colors.white,
                                    size: 35,
                                  )
                                : CachedNetworkImage(
                                    imageUrl: model.image!,
                                    height: 35,
                                    width: 35,
                                    fit: BoxFit.cover,
                                  ),
                      ).circular
                    : UserAvatarView(
                        size: 45,
                        user: model.opponent!.userDetail,
                        onTapHandler: () {},
                      ),
                // AvatarView(size: 50, url: model.opponent.picture),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Spacer(),
                      BodyLargeText(
                        model.isGroupChat
                            ? model.name!
                            : model.opponent!.userDetail.userName,
                        maxLines: 1,
                        weight: TextWeight.bold,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      model.whoIsTyping.isNotEmpty
                          ? BodyMediumText(
                              '${model.whoIsTyping.join(',')} ${typingString.tr}',
                            )
                          : model.lastMessage == null
                              ? Container()
                              : messageTypeShortInfo(
                                  message: model.lastMessage!,
                                ),
                      const Spacer(),
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              model.unreadMessages > 0
                  ? Container(
                      height: 25,
                      width: 25,
                      color: AppColorConstants.themeColor,
                      child: Center(
                        child: BodyLargeText(
                          '${model.unreadMessages}',
                          weight: TextWeight.bold,
                        ),
                      ),
                    ).circular.bP8
                  : Container(),
              model.lastMessage == null
                  ? Container()
                  : BodySmallText(
                      model.lastMessage!.messageTime,
                      weight: TextWeight.semiBold,
                      // color: AppColorConstants.themeColor,
                    ).p4,
            ],
          ),
        ],
      ).hP8,
    );
  }
}

class PublicChatGroupCard extends StatelessWidget {
  final ChatRoomModel room;
  final VoidCallback joinBtnClicked;
  final VoidCallback previewBtnClicked;
  final VoidCallback leaveBtnClicked;

  const PublicChatGroupCard(
      {super.key,
      required this.room,
      required this.joinBtnClicked,
      required this.leaveBtnClicked,
      required this.previewBtnClicked});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColorConstants.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          // BoxShadow(
          //   color: Colors.black.withOpacity(0.1),
          //   blurRadius: 12,
          //   offset: const Offset(0, 4),
          // ),
        ],
      ),
      child: Stack(
        children: [
          // Background image with gradient overlay
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: room.image!.isNotEmpty
                  ? Stack(
                      children: [
                        CachedNetworkImage(
                          imageUrl: room.image!,
                          fit: BoxFit.cover,
                          height: double.infinity,
                          width: double.infinity,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.7),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : Container(
                      color: AppColorConstants.themeColor.withOpacity(0.1),
                      child: Center(
                        child: Heading1Text(
                          room.name!.getInitials,
                          color: AppColorConstants.themeColor,
                        ),
                      ),
                    ),
            ),
          ),

          // Content overlay
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: previewBtnClicked,
                splashColor: Colors.white.withOpacity(0.2),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Group name
                      BodyLargeText(
                        textAlign: TextAlign.start,
                        room.name!,
                        maxLines: 1,
                        weight: TextWeight.bold,
                        color: Colors.white,
                      ),

                      const SizedBox(height: 8),

                      if (!room.amIGroupAdmin)
                        BodySmallText(
                          ' ${room.roomMembers.length}${clubMembersString.tr}',
                          color: Colors.white.withOpacity(0.8),
                        )
                      else
                        Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              // border: Border.all(
                              //   color: AppColorConstants.themeColor,
                              //   width: 1,
                              // ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: BodySmallText(
                              youAreAdminString,
                              color: Colors.white,
                              // weight: TextWeight.bold,
                            ),
                          ),
                        ),

                      // const SizedBox(height: 16),

                      // Join/Leave button
                      if (!room.amIGroupAdmin)
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: room.amIMember == true
                                  ? AppColorConstants.red
                                  : AppColorConstants.themeColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Center(
                              child: ThemeIconWidget(
                                room.amIMember == true
                                    ? ThemeIcon.checkMark
                                    : ThemeIcon.plus,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ).ripple(() {
                            if (room.amIMember == true) {
                              leaveBtnClicked();
                            } else {
                              joinBtnClicked();
                            }
                          }),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
