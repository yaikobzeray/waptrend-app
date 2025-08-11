import 'package:foap/helper/imports/common_import.dart';
import 'package:foap/helper/imports/chat_imports.dart';
import '../../components/actionSheets/action_sheet1.dart';
import '../../model/generic_item.dart';
import '../profile/other_user_profile.dart';
import '../settings_menu/settings_controller.dart';

class ChatRoomDetail extends StatefulWidget {
  final ChatRoomModel chatRoom;

  const ChatRoomDetail({super.key, required this.chatRoom});

  @override
  State<ChatRoomDetail> createState() => _ChatRoomDetailState();
}

class _ChatRoomDetailState extends State<ChatRoomDetail> {
  final ChatRoomDetailController _chatRoomDetailController = Get.find();
  final ChatDetailController _chatDetailController = Get.find();
  final SettingsController _settingsController = Get.find();

  @override
  void initState() {
    if (_settingsController.setting.value!.enableStarMessage) {
      _chatRoomDetailController.getStarredMessages(widget.chatRoom);
    }
    _chatDetailController.getUpdatedChatRoomDetail(
        room: widget.chatRoom, callback: () {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: AppColorConstants.backgroundColor,
      body: Column(
        children: [
          // App Bar
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 10,
              bottom: 10,
              left: DesignConstants.horizontalPadding,
              right: DesignConstants.horizontalPadding,
            ),
            child: Row(
              children: [
                ThemeIconWidget(
                  ThemeIcon.backArrow,
                  color: AppColorConstants.iconColor,
                  size: 20,
                ).ripple(() {
                  Get.back();
                }),
                const Spacer(),
                Obx(() => _chatDetailController.chatRoom.value?.amIGroupAdmin ==
                            true &&
                        _chatDetailController.chatRoom.value?.isGroupChat ==
                            true
                    ? ThemeIconWidget(
                        ThemeIcon.edit,
                        color: AppColorConstants.iconColor,
                        size: 20,
                      ).ripple(() {
                        Get.to(() => UpdateGroupInfo(
                                group: _chatDetailController.chatRoom.value!))!
                            .then((value) {
                          _chatDetailController.getUpdatedChatRoomDetail(
                              room: widget.chatRoom, callback: () {});
                        });
                      })
                    : const SizedBox(width: 20)),
              ],
            ),
          ),

          // Content
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(bottom: 20),
              children: [
                const SizedBox(height: 20),
                widget.chatRoom.isGroupChat ? groupInfo() : opponentInfo(),
                const SizedBox(height: 30),
                if (!widget.chatRoom.isGroupChat) ...[
                  callWidgets(),
                  const SizedBox(height: 30),
                ],
                Obx(() =>
                    (_chatDetailController.chatRoom.value?.description ?? '')
                            .isNotEmpty
                        ? Column(
                            children: [
                              descriptionWidget(),
                              const SizedBox(height: 30),
                            ],
                          )
                        : Container()),
                commonOptionsWidget(),
                const SizedBox(height: 30),
                Obx(() => _chatDetailController.chatRoom.value?.isGroupChat ==
                            true &&
                        _chatDetailController.chatRoom.value?.amIGroupAdmin ==
                            true
                    ? Column(
                        children: [
                          groupSettingWidget(),
                          const SizedBox(height: 30),
                        ],
                      )
                    : Container()),
                if (widget.chatRoom.isGroupChat) ...[
                  participantsWidget(),
                  const SizedBox(height: 30),
                ],
                if (_chatDetailController.messages.isNotEmpty) ...[
                  extraOptionsWidget(),
                  const SizedBox(height: 30),
                ],
                if (widget.chatRoom.isGroupChat) ...[
                  exitAndDeleteGroup(),
                  const SizedBox(height: 20),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget descriptionWidget() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin:
          EdgeInsets.symmetric(horizontal: DesignConstants.horizontalPadding),
      decoration: BoxDecoration(
        color: AppColorConstants.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        _chatDetailController.chatRoom.value!.description!,
        style: TextStyle(
          fontSize: 14,
          color: AppColorConstants.mainTextColor,
        ),
      ),
    );
  }

  Widget groupSettingWidget() {
    return Container(
      margin:
          EdgeInsets.symmetric(horizontal: DesignConstants.horizontalPadding),
      decoration: BoxDecoration(
        color: AppColorConstants.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColorConstants.themeColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.settings,
            color: AppColorConstants.themeColor,
            size: 20,
          ),
        ),
        title: Text(
          groupSettingsString.tr,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColorConstants.mainTextColor,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: AppColorConstants.iconColor,
        ),
        onTap: () {
          Get.to(() => const GroupSettings());
        },
      ),
    );
  }

  Widget commonOptionsWidget() {
    return Container(
      margin:
          EdgeInsets.symmetric(horizontal: DesignConstants.horizontalPadding),
      decoration: BoxDecoration(
        color: AppColorConstants.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            leading: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColorConstants.themeColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.photo_library,
                color: AppColorConstants.themeColor,
                size: 20,
              ),
            ),
            title: Text(
              mediaString.tr,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColorConstants.mainTextColor,
              ),
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: AppColorConstants.iconColor,
            ),
            onTap: () {
              Get.to(() => ChatMediaList(chatRoom: widget.chatRoom));
            },
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          ListTile(
            leading: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColorConstants.themeColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.wallpaper,
                color: AppColorConstants.themeColor,
                size: 20,
              ),
            ),
            title: Text(
              wallpaperString.tr,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColorConstants.mainTextColor,
              ),
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: AppColorConstants.iconColor,
            ),
            onTap: () {
              Get.to(
                  () => WallpaperForChatBackground(roomId: widget.chatRoom.id));
            },
          ),
          if (_chatRoomDetailController.starredMessages.isNotEmpty &&
              _settingsController.setting.value!.enableStarMessage)
            Obx(() => Column(
                  children: [
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    ListTile(
                      leading: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColorConstants.themeColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.star,
                          color: AppColorConstants.themeColor,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        starredMessagesString.tr,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColorConstants.mainTextColor,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '(${_chatRoomDetailController.starredMessages.length})',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColorConstants.cardColor,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.chevron_right,
                            color: AppColorConstants.iconColor,
                          ),
                        ],
                      ),
                      onTap: () {
                        Get.to(
                            () => StarredMessages(chatRoom: widget.chatRoom));
                      },
                    ),
                  ],
                )),
        ],
      ),
    );
  }

  Widget extraOptionsWidget() {
    return Container(
      margin:
          EdgeInsets.symmetric(horizontal: DesignConstants.horizontalPadding),
      decoration: BoxDecoration(
        color: AppColorConstants.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(
              exportChatString.tr,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColorConstants.mainTextColor,
              ),
            ),
            onTap: exportChatActionPopup,
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          ListTile(
            title: Text(
              deleteChatString.tr,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColorConstants.red,
              ),
            ),
            onTap: () {
              _chatRoomDetailController.deleteRoomChat(widget.chatRoom);
              _chatDetailController.deleteChat(widget.chatRoom.id);
              AppUtil.showToast(message: chatDeletedString.tr, isSuccess: true);
            },
          ),
        ],
      ),
    );
  }

  Widget exitAndDeleteGroup() {
    return Container(
      margin:
          EdgeInsets.symmetric(horizontal: DesignConstants.horizontalPadding),
      decoration: BoxDecoration(
        color: AppColorConstants.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        title: Text(
          widget.chatRoom.amIMember
              ? leaveGroupString.tr
              : deleteGroupString.tr,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColorConstants.red,
          ),
        ),
        onTap: () {
          if (widget.chatRoom.amIMember) {
            AppUtil.showNewConfirmationAlert(
              title: leaveGroupString.tr,
              subTitle: leaveGroupConfirmationString.tr,
              okHandler: () {
                _chatRoomDetailController.leaveGroup(widget.chatRoom);
              },
              cancelHandler: () {},
            );
          } else {
            _chatRoomDetailController.deleteGroup(widget.chatRoom);
          }
          Get.back();
        },
      ),
    );
  }

  Widget callWidgets() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (_settingsController.setting.value!.enableAudioCalling)
          ElevatedButton.icon(
            icon: Icon(
              Icons.call,
              size: 20,
              color: Colors.white,
            ),
            label: Text(
              audioString.tr,
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColorConstants.themeColor,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: audioCall,
          ),
        if (_settingsController.setting.value!.enableAudioCalling &&
            _settingsController.setting.value!.enableVideoCalling)
          const SizedBox(width: 20),
        if (_settingsController.setting.value!.enableVideoCalling)
          ElevatedButton.icon(
            icon: Icon(
              Icons.videocam,
              size: 20,
              color: Colors.white,
            ),
            label: Text(
              videoString.tr,
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColorConstants.themeColor,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: videoCall,
          ),
      ],
    );
  }

  Widget groupInfo() {
    return Obx(() => _chatDetailController.chatRoom.value == null
        ? Container()
        : Column(
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColorConstants.themeColor.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child:
                      _chatDetailController.chatRoom.value!.image?.isNotEmpty ==
                              true
                          ? CachedNetworkImage(
                              imageUrl:
                                  _chatDetailController.chatRoom.value!.image!,
                              fit: BoxFit.cover,
                            )
                          : Center(
                              child: Text(
                                _chatDetailController.chatRoom.value!.name!
                                    .substring(0, 1)
                                    .toUpperCase(),
                                style: TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: AppColorConstants.themeColor,
                                ),
                              ),
                            ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _chatDetailController.chatRoom.value!.name!,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColorConstants.mainTextColor,
                ),
              ),
            ],
          ));
  }

  Widget opponentInfo() {
    return Obx(() => _chatDetailController.chatRoom.value == null
        ? Container()
        : Column(
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColorConstants.themeColor.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: _chatDetailController.chatRoom.value!.opponent!
                              .userDetail.picture?.isNotEmpty ==
                          true
                      ? CachedNetworkImage(
                          imageUrl: _chatDetailController
                              .chatRoom.value!.opponent!.userDetail.picture!,
                          fit: BoxFit.cover,
                        )
                      : Center(
                          child: Text(
                            _chatDetailController
                                .chatRoom.value!.opponent!.userDetail.userName
                                .substring(0, 1)
                                .toUpperCase(),
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: AppColorConstants.themeColor,
                            ),
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _chatDetailController
                    .chatRoom.value!.opponent!.userDetail.userName,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColorConstants.mainTextColor,
                ),
              ),
            ],
          ));
  }

  void exportChatActionPopup() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (
        context,
      ) =>
          SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.photo_library,
                  color: AppColorConstants.themeColor),
              title: Text(exportChatWithMediaString.tr),
              onTap: () async {
                Get.back();
                exportChatWithMedia();
              },
            ),
            const Divider(height: 1),
            ListTile(
              leading:
                  Icon(Icons.text_snippet, color: AppColorConstants.themeColor),
              title: Text(exportChatWithoutMediaString.tr),
              onTap: () async {
                Get.back();
                exportChatWithoutMedia();
              },
            ),
            const Divider(height: 1),
            ListTile(
              leading: Icon(Icons.close, color: AppColorConstants.red),
              title: Text(cancelString.tr),
              onTap: () => Get.back(),
            ),
          ],
        ),
      ),
    );
  }

  Widget participantsWidget() {
    return Obx(() => _chatDetailController.chatRoom.value == null
        ? Container()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: DesignConstants.horizontalPadding),
                child: Text(
                  '${_chatDetailController.chatRoom.value!.roomMembers.length} ${participantsString.tr}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColorConstants.mainTextColor,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                margin: EdgeInsets.symmetric(
                    horizontal: DesignConstants.horizontalPadding),
                decoration: BoxDecoration(
                  color: AppColorConstants.cardColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount:
                      _chatDetailController.chatRoom.value!.roomMembers.length +
                          (_chatDetailController.chatRoom.value!.amIGroupAdmin
                              ? 1
                              : 0),
                  itemBuilder: (ctx, index) {
                    if (index == 0 &&
                        _chatDetailController.chatRoom.value!.amIGroupAdmin) {
                      return ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color:
                                AppColorConstants.themeColor.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.add,
                            color: AppColorConstants.themeColor,
                          ),
                        ),
                        title: Text(
                          addParticipantsString.tr,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: AppColorConstants.mainTextColor,
                          ),
                        ),
                        onTap: () {
                          showModalBottomSheet(
                            backgroundColor: Colors.transparent,
                            context: context,
                            isScrollControlled: true,
                            builder: (context) => FractionallySizedBox(
                              heightFactor: 0.9,
                              child: SelectUserForGroupChat(
                                group: _chatDetailController.chatRoom.value!,
                                invitedUserCallback: () {
                                  _chatDetailController
                                      .getUpdatedChatRoomDetail(
                                          room: widget.chatRoom,
                                          callback: () {});
                                },
                              ),
                            ),
                          );
                        },
                      );
                    }
                    ChatRoomMember member = _chatDetailController
                            .chatRoom.value!.roomMembers[
                        index -
                            (_chatDetailController.chatRoom.value!.amIGroupAdmin
                                ? 1
                                : 0)];
                    return ListTile(
                      leading: UserAvatarView(
                        user: member.userDetail,
                        size: 40,
                      ),
                      title: Row(
                        children: [
                          Text(
                            member.userDetail.isMe
                                ? youString.tr
                                : member.userDetail.userName,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: AppColorConstants.mainTextColor,
                            ),
                          ),
                          if (member.userDetail.isVerified)
                            Icon(
                              Icons.verified,
                              color: AppColorConstants.themeColor,
                              size: 16,
                            ),
                        ],
                      ),
                      subtitle: member.userDetail.country != null
                          ? Text(
                              '${member.userDetail.city ?? ''}, ${member.userDetail.country ?? ''}'
                                  .replaceAll(RegExp(r'^,\s*|\s*,\s*$'), ''),
                              style: TextStyle(
                                color: AppColorConstants.cardColor,
                              ),
                            )
                          : null,
                      trailing: member.isAdmin == 1
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColorConstants.themeColor
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                adminString.tr,
                                style: TextStyle(
                                  color: AppColorConstants.themeColor,
                                  fontSize: 12,
                                ),
                              ),
                            )
                          : null,
                      onTap: () {
                        if (!member.userDetail.isMe) {
                          openActionOptionsForParticipant(member);
                        }
                      },
                    );
                  },
                  separatorBuilder: (ctx, index) {
                    return const Divider(height: 1, indent: 16, endIndent: 16);
                  },
                ),
              ),
            ],
          ));
  }

  void openActionOptionsForParticipant(ChatRoomMember member) {
    GenericItem userDetail = GenericItem(
      id: '1',
      title: userDetailString.tr,
      subTitle: userDetailString.tr,
    );

    GenericItem makeAdmin = GenericItem(
      id: '2',
      title: makeAdminString.tr,
      subTitle: makeAdminString.tr,
    );

    GenericItem removeAdmin = GenericItem(
      id: '3',
      title: removeAdminString.tr,
      subTitle: removeAdminString.tr,
    );

    GenericItem removeFromGroup = GenericItem(
      id: '4',
      title: removeFromGroupString.tr,
      subTitle: removeFromGroupString.tr,
    );
    GenericItem cancel = GenericItem(
      id: '5',
      title: cancelString.tr,
      subTitle: cancelString.tr,
    );
    List<GenericItem> items = [];
    items.add(userDetail);
    if (member.isAdmin == 1 && widget.chatRoom.amIGroupAdmin) {
      items.add(removeAdmin);
    } else {
      if (widget.chatRoom.amIGroupAdmin) {
        items.add(makeAdmin);
        items.add(removeFromGroup);
      }
    }
    items.add(cancel);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => ActionSheet1(
        items: items,
        itemCallBack: (item) {
          if (item.id == '1') {
            Get.to(() => OtherUserProfile(
                  userId: member.userDetail.id,
                  user: member.userDetail,
                ));
          } else if (item.id == '2') {
            _chatRoomDetailController.makeUserAsAdmin(
                member.userDetail, widget.chatRoom);
          } else if (item.id == '3') {
            _chatRoomDetailController.removeUserAsAdmin(
                member.userDetail, widget.chatRoom);
          } else if (item.id == '4') {
            _chatRoomDetailController.removeUserFormGroup(
                user: member.userDetail, chatRoom: widget.chatRoom);
          }
        },
      ),
    );
  }

  void exportChatWithMedia() {
    _chatRoomDetailController.exportChat(
        roomId: widget.chatRoom.id, includeMedia: true);
  }

  void exportChatWithoutMedia() {
    _chatRoomDetailController.exportChat(
        roomId: widget.chatRoom.id, includeMedia: false);
  }

  void videoCall() {
    _chatDetailController.initiateVideoCall();
  }

  void audioCall() {
    _chatDetailController.initiateAudioCall();
  }
}
