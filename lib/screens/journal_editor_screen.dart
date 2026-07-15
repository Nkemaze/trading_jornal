import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class JournalEditorScreen extends StatefulWidget {
  const JournalEditorScreen({super.key});

  @override
  State<JournalEditorScreen> createState() => _JournalEditorScreenState();
}

class _JournalEditorScreenState extends State<JournalEditorScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final List<String> _tags = ['nasdaq', 'scalping'];
  final List<String> _attachments = ['nasdaq_rejection_5m.png', 'fomc_sentiment.jpg'];
  final bool _isSaving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildTopBar(),
          Expanded(
            child: _buildEditor(),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomToolbar(),
    );
  }

  Widget _buildTopBar() {
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
                Icons.close,
                color: AppColors.onSurface,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Journal Entry',
              style: TextStyle(
                fontSize: 20,
                height: 1.4,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurface,
              ),
            ),
            const Spacer(),
            _buildAutosaveStatus(),
            const SizedBox(width: 16),
            GestureDetector(
              onTap: () {
                // TODO: Publish entry
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  'Publish',
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.33,
                    letterSpacing: 0.05,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAutosaveStatus() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          _isSaving ? Icons.sync : Icons.cloud_done,
          size: 14,
          color: AppColors.onSurfaceVariant,
        ),
        const SizedBox(width: 4),
        Text(
          _isSaving ? 'Saving...' : 'Autosaved',
          style: const TextStyle(
            fontSize: 12,
            height: 1.33,
            letterSpacing: 0.05,
            fontWeight: FontWeight.w600,
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildEditor() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMetadataHeader(),
          const SizedBox(height: 24),
          _buildContentEditor(),
          const SizedBox(height: 32),
          _buildAttachmentsSection(),
        ],
      ),
    );
  }

  Widget _buildMetadataHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'OCTOBER 24, 2023 \u2022 09:42 AM',
          style: TextStyle(
            fontSize: 12,
            height: 1.33,
            letterSpacing: 0.05,
            fontWeight: FontWeight.w600,
            color: AppColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _titleController,
          style: const TextStyle(
            fontSize: 32,
            height: 1.25,
            letterSpacing: -0.02,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurface,
          ),
          decoration: const InputDecoration(
            hintText: 'Entry Title (Optional)',
            hintStyle: TextStyle(
              color: AppColors.outline,
            ),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            filled: false,
            contentPadding: EdgeInsets.zero,
          ),
        ),
        const SizedBox(height: 8),
        _buildTags(),
      ],
    );
  }

  Widget _buildTags() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _tags.map((tag) => _buildTagChip(tag)).toList(),
    );
  }

  Widget _buildTagChip(String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '#$tag',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () {
              setState(() {
                _tags.remove(tag);
              });
            },
            child: const Icon(
              Icons.close,
              size: 12,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentEditor() {
    return TextField(
      controller: _contentController,
      maxLines: null,
      style: const TextStyle(
        fontSize: 16,
        height: 1.5,
        fontWeight: FontWeight.w400,
        color: AppColors.onSurface,
      ),
      decoration: const InputDecoration(
        hintText: 'Start typing your market observations...',
        hintStyle: TextStyle(
          color: AppColors.outline,
        ),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        filled: false,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildAttachmentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(top: 16),
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(
                color: AppColors.outlineVariant,
                style: BorderStyle.solid,
              ),
            ),
          ),
          child: const Text(
            'ATTACHED VISUALS',
            style: TextStyle(
              fontSize: 12,
              height: 1.33,
              letterSpacing: 0.05,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 16 / 9,
          children: [
            ..._attachments.map((file) => _buildAttachmentCard(file)),
            _buildAddAttachmentButton(),
          ],
        ),
      ],
    );
  }

  Widget _buildAttachmentCard(String fileName) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant),
        color: AppColors.surfaceContainerLow,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Placeholder image area
          const Center(
            child: Icon(
              Icons.image,
              size: 32,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          // Close button
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.background.withAlpha(200),
              ),
              child: const Icon(
                Icons.close,
                size: 14,
                color: AppColors.onSurface,
              ),
            ),
          ),
          // File name
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black87],
                ),
              ),
              child: Text(
                fileName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: AppColors.onSurface,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddAttachmentButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _attachments.add('new_attachment.png');
        });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.outlineVariant,
            style: BorderStyle.solid,
          ),
          color: AppColors.surfaceContainerLowest,
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate,
              size: 32,
              color: AppColors.onSurfaceVariant,
            ),
            SizedBox(height: 8),
            Text(
              'Drop chart here',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomToolbar() {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom + 16,
        left: 16,
        right: 16,
      ),
      child: Center(
        child: Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerHighest.withAlpha(200),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: AppColors.outlineVariant),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildToolbarButton(
                icon: Icons.add_photo_alternate,
                label: 'Attach Image',
                onTap: () {},
              ),
              _buildToolbarDivider(),
              _buildToolbarButton(
                icon: Icons.reply,
                label: 'Reference Entry',
                onTap: () {},
              ),
              _buildToolbarDivider(),
              _buildToolbarButton(
                icon: Icons.label,
                label: 'Add Tag',
                onTap: () {},
              ),
              _buildToolbarDivider(),
              _buildToolbarButton(
                icon: Icons.sentiment_satisfied,
                onTap: () {},
              ),
              const SizedBox(width: 16),
              _buildToolbarButton(
                icon: Icons.more_vert,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToolbarButton({
    required IconData icon,
    String? label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 22,
            color: AppColors.onSurfaceVariant,
          ),
          if (label != null) ...[
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                height: 1.33,
                letterSpacing: 0.05,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildToolbarDivider() {
    return Container(
      width: 1,
      height: 24,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      color: AppColors.outlineVariant,
    );
  }
}
