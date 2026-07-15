import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/journal_entry.dart';
import '../providers/navigation_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/bottom_nav_bar.dart';
import 'journal_editor_screen.dart';
import 'locked_historical_entry_screen.dart';
import 'add_alert_screen.dart';

class PairDetailTimelineScreen extends StatefulWidget {
  final String pairSymbol;

  const PairDetailTimelineScreen({super.key, required this.pairSymbol});

  @override
  State<PairDetailTimelineScreen> createState() =>
      _PairDetailTimelineScreenState();
}

class _PairDetailTimelineScreenState extends State<PairDetailTimelineScreen> {
  final TextEditingController _todayController = TextEditingController();
  final List<String> _todayImages = [];
  late final NavigationProvider _navProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navProvider = context.read<NavigationProvider>();
      _navProvider.setBottomNavIndex(1);
      _navProvider.addListener(_onNavChanged);
    });
  }

  void _onNavChanged() {
    if (_navProvider.currentBottomNavIndex != 1 && mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _navProvider.removeListener(_onNavChanged);
    _todayController.dispose();
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
            child: _buildTimeline(),
          ),
        ],
      ),
      floatingActionButton: _buildFab(),
      bottomNavigationBar: const BottomNavBar(),
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
                Icons.arrow_back,
                color: AppColors.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
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
            _buildTopBarIcon(
              icon: Icons.notification_add,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AddReminderScreen()),
                );
              },
            ),
            const SizedBox(width: 8),
            _buildTopBarIcon(
              icon: Icons.search,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBarIcon({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Icon(
          icon,
          color: AppColors.primary,
          size: 22,
        ),
      ),
    );
  }

  Widget _buildTimeline() {
    final entries = JournalEntry.sampleData;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMarketContext(),
          const SizedBox(height: 24),
          _buildEntriesList(entries),
        ],
      ),
    );
  }

  Widget _buildMarketContext() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'MARKET CONTEXT',
          style: TextStyle(
            fontSize: 12,
            height: 1.33,
            letterSpacing: 0.05,
            fontWeight: FontWeight.w600,
            color: AppColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            const Text(
              '\$64,281.40',
              style: TextStyle(
                fontSize: 32,
                height: 1.25,
                letterSpacing: -0.02,
                fontWeight: FontWeight.w700,
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '+2.4% Today',
              style: TextStyle(
                fontSize: 14,
                height: 1.43,
                fontWeight: FontWeight.w600,
                color: AppColors.secondary.withAlpha(200),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEntriesList(List<JournalEntry> entries) {
    return Stack(
      children: [
        // Timeline vertical line
        Positioned(
          left: 19,
          top: 8,
          bottom: 0,
          child: Container(
            width: 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primary,
                  AppColors.outlineVariant,
                ],
              ),
            ),
          ),
        ),
        // Entries
        Column(
          children: entries.asMap().entries.map((entry) {
            final index = entry.key;
            final journalEntry = entry.value;
            final isToday = index == 0 && !journalEntry.isLocked;

            return Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: isToday
                  ? _buildTodayCard(journalEntry)
                  : _buildLockedCard(journalEntry),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTodayCard(JournalEntry entry) {
    return Padding(
      padding: const EdgeInsets.only(left: 48),
      child: Stack(
        children: [
          // Timeline dot
          Positioned(
            left: -36,
            top: 20,
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withAlpha(50),
                    blurRadius: 8,
                    spreadRadius: 4,
                  ),
                ],
              ),
            ),
          ),
          // Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primary.withAlpha(76)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(100),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTodayHeader(),
                const SizedBox(height: 16),
                _buildTodayTextarea(),
                const SizedBox(height: 16),
                _buildTodayAttachments(),
                const SizedBox(height: 16),
                _buildTodayActions(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'TODAY \u2022 Oct 24',
          style: TextStyle(
            fontSize: 12,
            height: 1.33,
            letterSpacing: 0.05,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(25),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'DRAFT',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.edit,
              size: 16,
              color: AppColors.onSurfaceVariant,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTodayTextarea() {
    return Container(
      constraints: const BoxConstraints(minHeight: 100),
      child: TextField(
        controller: _todayController,
        maxLines: null,
        style: const TextStyle(
          fontSize: 14,
          height: 1.43,
          fontWeight: FontWeight.w400,
          color: AppColors.onSurface,
        ),
        decoration: const InputDecoration(
          hintText: 'Record your price action observations for BTC/USD today...',
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
    );
  }

  Widget _buildTodayAttachments() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ..._todayImages.map((url) => _buildImageThumbnail(url)),
        _buildAddImageButton(),
      ],
    );
  }

  Widget _buildImageThumbnail(String url) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.outlineVariant),
        color: AppColors.surfaceContainer,
      ),
      child: const Icon(
        Icons.image,
        size: 24,
        color: AppColors.onSurfaceVariant,
      ),
    );
  }

  Widget _buildAddImageButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _todayImages.add('new_image');
        });
      },
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.outlineVariant,
            style: BorderStyle.solid,
          ),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_a_photo,
              size: 20,
              color: AppColors.outline,
            ),
            SizedBox(height: 4),
            Text(
              'ADD',
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: AppColors.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            // TODO: Save entry
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
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
            child: const Text(
              'SAVE ENTRY',
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
        GestureDetector(
          onTap: () {},
          child: const Row(
            children: [
              Icon(
                Icons.reply,
                size: 20,
                color: AppColors.onSurfaceVariant,
              ),
              SizedBox(width: 4),
              Text(
                'REPLY',
                style: TextStyle(
                  fontSize: 12,
                  height: 1.33,
                  letterSpacing: 0.05,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLockedCard(JournalEntry entry) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const LockedHistoricalEntryScreen(),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 48),
        child: Stack(
          children: [
            // Timeline dot
            Positioned(
              left: -32,
              top: 20,
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.outlineVariant,
                ),
              ),
            ),
            // Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.outlineVariant),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLockedHeader(entry),
                  const SizedBox(height: 12),
                  Text(
                    entry.content,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.43,
                      fontWeight: FontWeight.w400,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildLockedFooter(entry),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLockedHeader(JournalEntry entry) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              _formatDate(entry.date),
              style: const TextStyle(
                fontSize: 12,
                height: 1.33,
                letterSpacing: 0.05,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.lock,
              size: 14,
              color: AppColors.outline,
            ),
          ],
        ),
        if (entry.status != EntryStatus.neutral)
          _buildStatusBadge(entry.status),
      ],
    );
  }

  Widget _buildStatusBadge(EntryStatus status) {
    Color bgColor;
    Color textColor;
    String label;

    switch (status) {
      case EntryStatus.profitable:
        bgColor = AppColors.secondary.withAlpha(25);
        textColor = AppColors.secondary;
        label = 'PROFITABLE';
        break;
      case EntryStatus.stopped:
        bgColor = AppColors.error.withAlpha(25);
        textColor = AppColors.error;
        label = 'STOPPED';
        break;
      case EntryStatus.draft:
        bgColor = AppColors.primary.withAlpha(25);
        textColor = AppColors.primary;
        label = 'DRAFT';
        break;
      case EntryStatus.neutral:
        bgColor = AppColors.surfaceContainerHighest;
        textColor = AppColors.onSurfaceVariant;
        label = '';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildLockedFooter(JournalEntry entry) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (entry.attachmentUrls.isNotEmpty)
          Row(
            children: [
              ...entry.attachmentUrls.take(2).map((_) => Container(
                    width: 24,
                    height: 24,
                    margin: const EdgeInsets.only(right: 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: AppColors.background),
                      color: AppColors.surfaceContainerHighest,
                    ),
                    child: const Icon(
                      Icons.image,
                      size: 12,
                      color: AppColors.outline,
                    ),
                  )),
              if (entry.attachmentUrls.length > 2)
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: AppColors.background),
                    color: AppColors.surfaceContainerHighest,
                  ),
                  child: Center(
                    child: Text(
                      '+${entry.attachmentUrls.length - 2}',
                      style: const TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                        color: AppColors.outline,
                      ),
                    ),
                  ),
                ),
            ],
          )
        else ...[
          const Icon(
            Icons.attach_file,
            size: 14,
            color: AppColors.outline,
          ),
          const SizedBox(width: 4),
          const Text(
            'No attachments',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.outline,
            ),
          ),
        ],
        GestureDetector(
          onTap: () {},
          child: const Row(
            children: [
              Icon(
                Icons.reply,
                size: 20,
                color: AppColors.primary,
              ),
              SizedBox(width: 4),
              Text(
                'REPLY',
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
    );
  }

  Widget _buildFab() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const JournalEditorScreen(),
          ),
        );
      },
      child: const Icon(Icons.add, size: 28),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
