import 'package:flutter/material.dart';
import '../models/journal_entry.dart';
import '../theme/app_colors.dart';

class LockedHistoricalEntryScreen extends StatelessWidget {
  final JournalEntry entry;

  const LockedHistoricalEntryScreen({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildTopBar(context),
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
      bottomNavigationBar: _buildFooter(context),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.outlineVariant)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(
                Icons.arrow_back,
                color: AppColors.onSurface,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            const Text(
              'Historical Entry',
              style: TextStyle(
                fontSize: 20,
                height: 1.4,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurface,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: AppColors.outlineVariant),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.lock,
                    size: 14,
                    color: AppColors.primary,
                  ),
                  SizedBox(width: 4),
                  Text(
                    'ARCHIVED',
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.33,
                      letterSpacing: 0.05,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
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

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAssetHeader(),
          const SizedBox(height: 24),
          _buildEntryBody(),
          const SizedBox(height: 16),
          if (entry.tags.isNotEmpty) _buildTags(),
        ],
      ),
    );
  }

  Widget _buildAssetHeader() {
    final date = entry.date;
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final hour = date.hour > 12 ? date.hour - 12 : date.hour == 0 ? 12 : date.hour;
    final minute = date.minute.toString().padLeft(2, '0');
    final ampm = date.hour >= 12 ? 'PM' : 'AM';
    final dateStr = '${months[date.month - 1]} ${date.day}, ${date.year} \u2022 $hour:$minute $ampm';

    Color statusColor;
    String statusLabel;
    switch (entry.status) {
      case EntryStatus.profitable:
        statusColor = AppColors.secondary;
        statusLabel = 'PROFITABLE';
        break;
      case EntryStatus.stopped:
        statusColor = AppColors.error;
        statusLabel = 'STOPPED';
        break;
      case EntryStatus.draft:
        statusColor = AppColors.primary;
        statusLabel = 'DRAFT';
        break;
      case EntryStatus.neutral:
        statusColor = AppColors.onSurfaceVariant;
        statusLabel = '';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dateStr,
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.33,
                    letterSpacing: 0.05,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurfaceVariant.withAlpha(200),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  entry.title ?? entry.pairSymbol,
                  style: const TextStyle(
                    fontSize: 32,
                    height: 1.25,
                    letterSpacing: -0.02,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),
              ],
            ),
            if (statusLabel.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: statusColor.withAlpha(25),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      statusLabel,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          height: 1,
          width: double.infinity,
          color: AppColors.outlineVariant,
        ),
      ],
    );
  }

  Widget _buildEntryBody() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.description,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                entry.title ?? 'Journal Entry',
                style: const TextStyle(
                  fontSize: 20,
                  height: 1.4,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            entry.content,
            style: const TextStyle(
              fontSize: 14,
              height: 1.43,
              fontWeight: FontWeight.w400,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          if (entry.attachmentUrls.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text(
              'ATTACHMENTS',
              style: TextStyle(
                fontSize: 12,
                height: 1.33,
                letterSpacing: 0.05,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            _buildImageGallery(),
          ],
        ],
      ),
    );
  }

  Widget _buildImageGallery() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: entry.attachmentUrls.map((url) {
        return GestureDetector(
          onTap: () {},
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.outlineVariant),
              color: AppColors.surfaceContainerHighest,
            ),
            child: const Center(
              child: Icon(
                Icons.image,
                size: 24,
                color: AppColors.outline,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTags() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: entry.tags.map((tag) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainer,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: AppColors.outlineVariant),
          ),
          child: Text(
            '#$tag',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom + 16,
        left: 16,
        right: 16,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.outlineVariant)),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                // TODO: Share
              },
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: AppColors.outlineVariant),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.share,
                      color: AppColors.onSurface,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Share',
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.33,
                        letterSpacing: 0.05,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: () {
                // TODO: Reply forward
              },
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withAlpha(50),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.forward_to_inbox,
                      color: AppColors.onPrimary,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Reply Forward',
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.33,
                        letterSpacing: 0.05,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
