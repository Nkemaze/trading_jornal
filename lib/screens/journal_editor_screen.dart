import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/journal_entry.dart';
import '../providers/journal_provider.dart';
import '../providers/pair_provider.dart';
import '../theme/app_colors.dart';

class JournalEditorScreen extends StatefulWidget {
  final String pairSymbol;

  const JournalEditorScreen({super.key, required this.pairSymbol});

  @override
  State<JournalEditorScreen> createState() => _JournalEditorScreenState();
}

class _JournalEditorScreenState extends State<JournalEditorScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _tagInputController = TextEditingController();
  final FocusNode _contentFocusNode = FocusNode();
  final List<String> _tags = [];
  final List<String> _attachments = [];
  final EntryStatus _status = EntryStatus.neutral;
  bool _isSaving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _tagInputController.dispose();
    _contentFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: _buildEditor(),
            ),
            _buildBottomToolbar(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
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
            Text(
              widget.pairSymbol,
              style: const TextStyle(
                fontSize: 20,
                height: 1.4,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurface,
              ),
            ),
            const Spacer(),
            if (_isSaving)
              const Padding(
                padding: EdgeInsets.only(right: 16),
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
            GestureDetector(
              onTap: _isSaving ? null : _publishEntry,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: _isSaving ? AppColors.surfaceContainerHighest : AppColors.primary,
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

  Widget _buildEditor() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDateLabel(),
          const SizedBox(height: 8),
          TextField(
            controller: _titleController,
            style: const TextStyle(
              fontSize: 28,
              height: 1.25,
              letterSpacing: -0.02,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurface,
            ),
            decoration: const InputDecoration(
              hintText: 'Entry Title (Optional)',
              hintStyle: TextStyle(color: AppColors.outline, fontSize: 28, fontWeight: FontWeight.w400),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              filled: false,
              contentPadding: EdgeInsets.zero,
            ),
          ),
          const SizedBox(height: 8),
          _buildTags(),
          const SizedBox(height: 16),
          _buildContentEditor(),
          const SizedBox(height: 32),
          _buildAttachmentsSection(),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildDateLabel() {
    final now = DateTime.now();
    final months = [
      'JANUARY', 'FEBRUARY', 'MARCH', 'APRIL', 'MAY', 'JUNE',
      'JULY', 'AUGUST', 'SEPTEMBER', 'OCTOBER', 'NOVEMBER', 'DECEMBER'
    ];
    final hour = now.hour > 12 ? now.hour - 12 : now.hour == 0 ? 12 : now.hour;
    final minute = now.minute.toString().padLeft(2, '0');
    final ampm = now.hour >= 12 ? 'PM' : 'AM';
    return Text(
      '${months[now.month - 1]} ${now.day}, ${now.year} \u2022 $hour:$minute $ampm',
      style: const TextStyle(
        fontSize: 12,
        height: 1.33,
        letterSpacing: 0.05,
        fontWeight: FontWeight.w600,
        color: AppColors.onSurfaceVariant,
      ),
    );
  }

  Widget _buildTags() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ..._tags.map((tag) => _buildTagChip(tag)),
        GestureDetector(
          onTap: _showAddTagDialog,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh.withAlpha(150),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.outlineVariant),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add, size: 12, color: AppColors.onSurfaceVariant),
                SizedBox(width: 4),
                Text(
                  'Add tag',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ),
      ],
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
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.primary),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () => setState(() => _tags.remove(tag)),
            child: const Icon(Icons.close, size: 12, color: AppColors.primary),
          ),
        ],
      ),
    );
  }

  Widget _buildContentEditor() {
    return Container(
      constraints: const BoxConstraints(minHeight: 200),
      child: TextField(
        controller: _contentController,
        focusNode: _contentFocusNode,
        maxLines: null,
        keyboardType: TextInputType.multiline,
        style: const TextStyle(
          fontSize: 16,
          height: 1.5,
          fontWeight: FontWeight.w400,
          color: AppColors.onSurface,
        ),
        decoration: const InputDecoration(
          hintText: 'Start typing your market observations...',
          hintStyle: TextStyle(color: AppColors.outline),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          filled: false,
          contentPadding: EdgeInsets.zero,
        ),
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
            border: Border(top: BorderSide(color: AppColors.outlineVariant)),
          ),
          child: Text(
            'ATTACHED VISUALS (${_attachments.length})',
            style: const TextStyle(
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
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 16 / 9,
          children: [
            ..._attachments.asMap().entries.map((e) => _buildAttachmentCard(e.value, e.key)),
            _buildAddAttachmentButton(),
          ],
        ),
      ],
    );
  }

  Widget _buildAttachmentCard(String fileName, int index) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant),
        color: AppColors.surfaceContainerLow,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          const Center(
            child: Icon(Icons.image, size: 32, color: AppColors.onSurfaceVariant),
          ),
          Positioned(
            top: 6,
            right: 6,
            child: GestureDetector(
              onTap: () => setState(() => _attachments.removeAt(index)),
              child: Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.background.withAlpha(200),
                ),
                child: const Icon(Icons.close, size: 12, color: AppColors.onSurface),
              ),
            ),
          ),
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
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.onSurface),
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
          _attachments.add('chart_${_attachments.length + 1}.png');
        });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.outlineVariant),
          color: AppColors.surfaceContainerLowest,
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_photo_alternate, size: 28, color: AppColors.onSurfaceVariant),
            SizedBox(height: 6),
            Text(
              'Drop chart here',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomToolbar() {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom + 8,
        top: 8,
        left: 12,
        right: 12,
      ),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.outlineVariant)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12),
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
                label: 'Attach',
                onTap: () {
                  setState(() {
                    _attachments.add('chart_${_attachments.length + 1}.png');
                  });
                },
              ),
              _buildDivider(),
              _buildToolbarButton(
                icon: Icons.reply,
                label: 'Reference',
                onTap: () {},
              ),
              _buildDivider(),
              _buildToolbarButton(
                icon: Icons.label,
                label: 'Tag',
                onTap: _showAddTagDialog,
              ),
              _buildDivider(),
              _buildToolbarButton(
                icon: Icons.sentiment_satisfied,
                onTap: () {},
              ),
              _buildDivider(),
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: AppColors.onSurfaceVariant),
            if (label != null) ...[
              const SizedBox(width: 4),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 20,
      color: AppColors.outlineVariant,
    );
  }

  void _showAddTagDialog() {
    _tagInputController.clear();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceContainerHigh,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Add Tag',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.onSurface),
        ),
        content: TextField(
          controller: _tagInputController,
          autofocus: true,
          style: const TextStyle(fontSize: 16, color: AppColors.onSurface),
          decoration: InputDecoration(
            hintText: 'e.g. breakout, scalping',
            hintStyle: const TextStyle(color: AppColors.outline),
            filled: true,
            fillColor: AppColors.surfaceContainer,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.outlineVariant),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.outlineVariant),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
          onSubmitted: (_) => _addTagFromDialog(ctx),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel', style: TextStyle(color: AppColors.onSurfaceVariant)),
          ),
          TextButton(
            onPressed: () => _addTagFromDialog(ctx),
            child: const Text('Add', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  void _addTagFromDialog(BuildContext ctx) {
    final tag = _tagInputController.text.trim();
    if (tag.isNotEmpty && !_tags.contains(tag)) {
      setState(() => _tags.add(tag));
    }
    Navigator.of(ctx).pop();
  }

  Future<void> _publishEntry() async {
    if (_contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please write something before publishing'),
          backgroundColor: AppColors.errorContainer,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    await context.read<JournalProvider>().addEntry(
      pairSymbol: widget.pairSymbol,
      content: _contentController.text.trim(),
      title: _titleController.text.trim().isEmpty ? null : _titleController.text.trim(),
      status: _status,
      tags: _tags,
      attachmentUrls: _attachments,
    );

    if (mounted) {
      context.read<PairProvider>().refreshPairs();
      setState(() => _isSaving = false);
      Navigator.of(context).pop();
    }
  }
}
