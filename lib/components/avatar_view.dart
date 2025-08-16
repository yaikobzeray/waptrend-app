import 'package:foap/helper/imports/common_import.dart';

class AvatarView extends StatelessWidget {
  final String? url;
  final String? name;
  final double? size;
  final Color? borderColor;

  const AvatarView({
    super.key,
    this.url,
    this.size = 60,
    this.borderColor,
    this.name,
  });

  @override
  Widget build(BuildContext context) {
    final initials = _getInitialsFromName();

    return SizedBox(
      height: size ?? 60,
      width: size ?? 60,
      child: _buildAvatarContent(initials),
    ).borderWithRadius(
      value: 2,
      radius: size ?? 60,
      color: borderColor ?? AppColorConstants.themeColor,
    );
  }

  String _getInitialsFromName() {
    if (name == null) return '';

    final nameParts = name!.trim().split(' ');
    var initials = '';

    for (final part in nameParts) {
      if (part.isNotEmpty) {
        initials += part[0].toUpperCase();
        if (initials.length >= 2) break;
      }
    }

    return initials;
  }

  Widget _buildAvatarContent(String initials) {
    return url != null && url!.isNotEmpty
        ? CachedNetworkImage(
            imageUrl: url!,
            fit: BoxFit.cover,
            placeholder: (context, url) => SizedBox(
              height: 20,
              width: 20,
              child: const CircularProgressIndicator().p16,
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ).round(size ?? 60)
        : Container(
            color: AppColorConstants.backgroundColor,
            child: userNameInitialView(initials, size ?? 60),
          );
  }
}

class UserAvatarView extends StatelessWidget {
  final UserModel user;
  final double? size;
  final VoidCallback? onTapHandler;
  final bool hideLiveIndicator;
  final bool hideOnlineIndicator;
  final bool hideBorder;

  const UserAvatarView({
    super.key,
    required this.user,
    this.size = 60,
    this.onTapHandler,
    this.hideLiveIndicator = false,
    this.hideOnlineIndicator = false,
    this.hideBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    final userProfileManager = Get.find<UserProfileManager>();

    return SizedBox(
      height: size ?? 60,
      width: size ?? 60,
      child: Stack(
        children: [
          _buildMainAvatar(),
          if (_shouldShowOnlineIndicator(userProfileManager))
            _buildOnlineIndicator(),
          if (user.isVIPUser) _buildVIPBadge(),
        ],
      ),
    ).ripple(() => onTapHandler?.call());
  }

  Widget _buildMainAvatar() {
    return user.liveCallDetail != null && !hideLiveIndicator
        ? _buildLiveUserWidget()
        : _buildUserPictureView();
  }

  Widget _buildLiveUserWidget() {
    return Stack(
      children: [
        _buildUserPictureView(),
        Positioned(
          right: 0,
          left: 0,
          bottom: 0,
          child: Container(
            height: 15,
            color: AppColorConstants.themeColor,
            child: Center(
              child: BodyExtraSmallText(
                liveString.tr,
                color: Colors.white,
              ),
            ),
          ).round(5),
        ),
      ],
    );
  }

  Widget _buildUserPictureView() {
    return user.picture != null && user.picture != 'null'
        ? CachedNetworkImage(
            imageUrl: user.picture!,
            fit: BoxFit.cover,
            height: size,
            width: size,
            placeholder: (context, url) => SizedBox(
              height: 20,
              width: 20,
              child: const CircularProgressIndicator().p16,
            ),
            errorWidget: (context, url, error) => SizedBox(
              height: size,
              width: size,
              child: Icon(Icons.error, size: size! / 2),
            ),
          ).borderWithRadius(
            value: hideBorder ? 0 : 1,
            radius: size ?? 60,
            color: AppColorConstants.themeColor,
          )
        : userNameInitialView(user.getInitials, size ?? 60).borderWithRadius(
            value: hideBorder ? 0 : 1,
            radius: size ?? 60,
            color: AppColorConstants.themeColor,
          );
  }

  bool _shouldShowOnlineIndicator(UserProfileManager userProfileManager) {
    return (user.liveCallDetail == null || hideLiveIndicator) &&
        !hideOnlineIndicator &&
        user.isShareOnlineStatus &&
        userProfileManager.user.value!.isShareOnlineStatus;
  }

  Widget _buildOnlineIndicator() {
    return Positioned(
      right: 0,
      bottom: 0,
      child: Container(
        height: 15,
        width: 15,
        color:
            user.isOnline ? AppColorConstants.themeColor : Colors.transparent,
      ).circular,
    );
  }

  Widget _buildVIPBadge() {
    return Positioned(
      right: 0,
      top: 0,
      child: Image.asset(
        'assets/vip.png',
        height: (size ?? 60) * 0.4,
        width: (size ?? 60) * 0.4,
      ),
    );
  }
}

class UserPlaneImageView extends StatelessWidget {
  final UserModel user;
  final double? size;

  const UserPlaneImageView({
    super.key,
    required this.user,
    this.size = 60,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size ?? 60,
      width: size ?? 60,
      child: _buildUserPictureView(),
    );
  }

  Widget _buildUserPictureView() {
    return user.picture != null
        ? CachedNetworkImage(
            imageUrl: user.picture!,
            fit: BoxFit.cover,
            height: size,
            width: size,
            placeholder: (context, url) => SizedBox(
              height: 20,
              width: 20,
              child: const CircularProgressIndicator().p16,
            ),
            errorWidget: (context, url, error) => SizedBox(
              height: size,
              width: size,
              child: Icon(Icons.error, size: size! / 2),
            ),
          ).round(20)
        : userNameInitialView(user.getInitials, size ?? 60)
            .borderWithRadius(value: 1, radius: 20);
  }
}

Widget userNameInitialView(String initials, double size) {
  return SizedBox(
    height: double.infinity,
    width: double.infinity,
    child: Center(
      child: _getTextWidgetForSize(initials, size),
    ),
  );
}

Widget _getTextWidgetForSize(String initials, double size) {
  if (size < 40) {
    return BodySmallText(initials, weight: TextWeight.medium);
  } else if (size < 60) {
    return BodyMediumText(initials, weight: TextWeight.medium);
  } else if (size < 80) {
    return BodyExtraLargeText(initials, weight: TextWeight.medium);
  } else {
    return Heading2Text(initials, weight: TextWeight.medium);
  }
}
