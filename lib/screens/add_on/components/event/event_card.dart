import 'package:foap/helper/imports/common_import.dart';
import 'package:foap/helper/imports/event_imports.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../model/create_event_model.dart';

class EventCard extends StatelessWidget {
  final EventModel event;
  final VoidCallback joinBtnClicked;
  final VoidCallback previewBtnClicked;
  final VoidCallback leaveBtnClicked;

  const EventCard({
    super.key,
    required this.event,
    required this.joinBtnClicked,
    required this.leaveBtnClicked,
    required this.previewBtnClicked,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardWidth = MediaQuery.of(context).size.width * 0.45;

    return SizedBox(
      width: cardWidth,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: previewBtnClicked,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image with overlay and text
              _buildImageSection(context, cardWidth),

              // Content section
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Event date
                    Text(
                      event.startAtDateTime,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColorConstants.mainTextColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Event title
                    Text(
                      event.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColorConstants.themeColor),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),

                    // Location row
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            event.placeName,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.8),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection(BuildContext context, double width) {
    final theme = Theme.of(context);

    return SizedBox(
      height: width * 0.8, // Maintain aspect ratio
      width: double.infinity,
      child: Stack(
        children: [
          // Event image
          CachedNetworkImage(
            imageUrl: event.image,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            placeholder: (context, url) => Container(
              color: theme.colorScheme.surfaceVariant,
            ),
            errorWidget: (context, url, error) => Container(
              color: theme.colorScheme.errorContainer,
              child: Center(
                child: Icon(
                  Icons.error_outline,
                  color: theme.colorScheme.onErrorContainer,
                ),
              ),
            ),
          ),

          // Gradient overlay
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.4),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Free badge
          if (event.isFree)
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColorConstants.themeColor.darken(),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  freeString.tr.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

          // Event title on image (optional)
          Positioned(
            left: 12,
            bottom: 12,
            right: 12,
            child: Text(
              event.name,
              style: theme.textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class EventCard2 extends StatelessWidget {
  final EventModel event;
  final VoidCallback joinBtnClicked;
  final VoidCallback previewBtnClicked;
  final VoidCallback leaveBtnClicked;

  const EventCard2({
    super.key,
    required this.event,
    required this.joinBtnClicked,
    required this.leaveBtnClicked,
    required this.previewBtnClicked,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColorConstants.cardColor,
        boxShadow: [
          BoxShadow(
            color: AppColorConstants.shadowColor.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: AppColorConstants.borderColor,
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image with overlay
          _buildImageSection(context),

          // Event details
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Event name
                Text(
                  event.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColorConstants.mainTextColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),

                // Date & time
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 16,
                      color: AppColorConstants.themeColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      event.startAtDateTime.toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColorConstants.themeColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // Location
                Row(
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      size: 16,
                      color: AppColorConstants.themeColor,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        event.placeName,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColorConstants.subHeadingTextColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Action buttons
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: Icon(Icons.remove_red_eye,
                        size: 18, color: AppColorConstants.themeColor),
                    label: Text(
                      previewString.tr,
                      style: TextStyle(color: AppColorConstants.themeColor),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColorConstants.themeColor),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: previewBtnClicked,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColorConstants.themeColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    onPressed: joinBtnClicked,
                    child: Text(joinString.tr),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection(BuildContext context) {
    return Stack(
      children: [
        // Event image
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          child: SizedBox(
            height: 180,
            width: double.infinity,
            child: CachedNetworkImage(
              imageUrl: event.image,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: AppColorConstants.disabledColor,
              ),
              errorWidget: (context, url, error) => Container(
                color: AppColorConstants.disabledColor,
                child: Icon(Icons.error, color: AppColorConstants.iconColor),
              ),
            ),
          ),
        ),

        // Gradient overlay
        Container(
          height: 180,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.black.withOpacity(0.6),
                Colors.transparent,
              ],
            ),
          ),
        ),

        // Free badge
        if (event.isFree)
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColorConstants.themeColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColorConstants.shadowColor.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              child: Text(
                freeString.tr,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class ProviderEventCard2 extends StatelessWidget {
  final CreateEventModel event;
  final VoidCallback editBtnClicked;
  final VoidCallback previewBtnClicked;
  final VoidCallback addTicketsBtnClicked;
  final VoidCallback viewTicketsBtnClicked;

  const ProviderEventCard2({
    super.key,
    required this.event,
    required this.editBtnClicked,
    required this.addTicketsBtnClicked,
    required this.previewBtnClicked,
    required this.viewTicketsBtnClicked,
  });

  @override
  Widget build(BuildContext context) {
    // Safe values with defaults
    final eventName = event.name ?? 'Untitled Event';
    final eventImage = event.image;
    final placeName = event.placeName ?? 'Location not specified';
    final startDate = event.startAtDateTimeString ?? 'Date not specified';
    final isFree = event.isFree ?? false;
    final statusType = event.statusType;

    // Localized strings with fallbacks
    final freeLabel = freeString.tr;
    final cancelledLabel = cancelledString.tr;
    final completedLabel = upcomingString.tr;
    final editLabel = editString.tr;
    final previewLabel = previewString.tr;
    final addTicketsLabel = addTicketsString.tr;
    final viewTicketsLabel = viewTicketsString.tr;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image Section
          _buildImageSection(
            eventImage: eventImage,
            isFree: isFree,
            statusType: statusType,
            freeLabel: freeLabel,
            cancelledLabel: cancelledLabel,
            completedLabel: completedLabel,
          ),

          // Details Section
          _buildDetailsSection(
            eventName: eventName,
            placeName: placeName,
            startDate: startDate,
          ),

          // Buttons Section
          if (statusType == EventStatus.active || !isFree)
            _buildButtonsSection(
              statusType: statusType,
              isFree: isFree,
              editLabel: editLabel,
              previewLabel: previewLabel,
              addTicketsLabel: addTicketsLabel,
              viewTicketsLabel: viewTicketsLabel,
            ),
        ],
      ),
    );
  }

  Widget _buildImageSection({
    required String? eventImage,
    required bool isFree,
    required EventStatus? statusType,
    required String freeLabel,
    required String cancelledLabel,
    required String completedLabel,
  }) {
    return SizedBox(
      height: 160,
      child: Stack(
        children: [
          // Event Image
          eventImage != null && eventImage.isNotEmpty
              ? ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: eventImage,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[200],
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.error),
                    ),
                  ).ripple(previewBtnClicked),
                )
              : Container(
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: const Center(
                    child: Icon(Icons.event, size: 50, color: Colors.white),
                  ),
                ),

          // Free Badge
          if (isFree)
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromARGB(255, 0, 100, 15),
                      Color.fromARGB(255, 128, 252, 115)
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  freeLabel,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),

          // Status Badge
          if (statusType != null)
            Positioned(
              bottom: 12,
              left: 12,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusType == EventStatus.cancelled
                      ? const Color(0xFFE74C3C)
                      : const Color(0xFF2ECC71),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  statusType == EventStatus.cancelled
                      ? cancelledLabel
                      : completedLabel,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailsSection({
    required String eventName,
    required String placeName,
    required String startDate,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            eventName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 16,
                color: AppColorConstants.themeColor,
              ),
              const SizedBox(width: 6),
              Text(
                startDate.toUpperCase(),
                style: TextStyle(
                  fontSize: 13,
                  color: AppColorConstants.themeColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(
                Icons.location_on,
                size: 16,
                color: AppColorConstants.themeColor,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  placeName,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF666666),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButtonsSection({
    required EventStatus? statusType,
    required bool isFree,
    required String editLabel,
    required String previewLabel,
    required String addTicketsLabel,
    required String viewTicketsLabel,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFFF8F9FA),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: statusType == EventStatus.active
          ? _buildActiveButtons(editLabel, previewLabel)
          : _buildTicketButtons(addTicketsLabel, viewTicketsLabel),
    );
  }

  Widget _buildActiveButtons(String editLabel, String previewLabel) {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            text: editLabel,
            icon: Icons.edit,
            onPressed: editBtnClicked,
            color: const Color(0xFF6C757D),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildActionButton(
            text: previewLabel,
            icon: Icons.remove_red_eye,
            onPressed: previewBtnClicked,
            color: AppColorConstants.themeColor,
          ),
        ),
      ],
    );
  }

  Widget _buildTicketButtons(String addTicketsLabel, String viewTicketsLabel) {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            text: addTicketsLabel,
            icon: Icons.add_circle,
            onPressed: addTicketsBtnClicked,
            color: const Color(0xFF28A745),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildActionButton(
            text: viewTicketsLabel,
            icon: Icons.list_alt,
            onPressed: viewTicketsBtnClicked,
            color: const Color(0xFF17A2B8),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10),
        elevation: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
