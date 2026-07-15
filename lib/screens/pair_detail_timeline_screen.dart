import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/journal_entry.dart';
import '../providers/navigation_provider.dart';
import '../providers/journal_provider.dart';
import '../providers/pair_provider.dart';
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
  final ScrollController _scrollController = ScrollController();
  late final NavigationProvider _navProvider;
  bool _isTodayExpanded = false;
  int _previousEntryCount = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navProvider = context.read<NavigationProvider>();
      _navProvider.setBottomNavIndex(1);
      _navProvider.addListener(_onNavChanged);
      context.read<JournalProvider>().loadEntriesForPair(widget.pairSymbol);
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients && _scrollController.position.maxScrollExtent > 0) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
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
    _scrollController.dispose();
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
    final journalProvider = context.watch<JournalProvider>();
    final entries = journalProvider.currentPairEntries;

    if (entries.length > _previousEntryCount && _previousEntryCount > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
    _previousEntryCount = entries.length;

    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMarketContext(),
          const SizedBox(height: 24),
          if (entries.isEmpty)
            _buildEmptyState()
          else
            _buildEntriesList(entries),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withAlpha(25),
              ),
              child: const Icon(
                Icons.book_outlined,
                size: 40,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No journal entries yet',
              style: TextStyle(
                fontSize: 20,
                height: 1.4,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tap the + button to write your first entry.',
              style: TextStyle(
                fontSize: 14,
                height: 1.43,
                fontWeight: FontWeight.w400,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
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
                  : Dismissible(
                      key: Key(journalEntry.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 16),
                        decoration: BoxDecoration(
                          color: AppColors.error.withAlpha(30),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.delete, color: AppColors.error),
                      ),
                      confirmDismiss: (_) async {
                        return await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            backgroundColor: AppColors.surfaceContainerHigh,
                            title: const Text('Delete Entry',
                                style: TextStyle(color: AppColors.onSurface)),
                            content: const Text('Are you sure you want to delete this entry?',
                                style: TextStyle(color: AppColors.onSurfaceVariant)),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(ctx).pop(false),
                                child: const Text('Cancel',
                                    style: TextStyle(color: AppColors.onSurfaceVariant)),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(ctx).pop(true),
                                child: const Text('Delete',
                                    style: TextStyle(color: AppColors.error)),
                              ),
                            ],
                          ),
                        );
                      },
                      onDismissed: (_) {
                        context.read<JournalProvider>().deleteEntry(journalEntry.id);
                        context.read<PairProvider>().refreshPairs();
                      },
                      child: _buildLockedCard(journalEntry),
                    ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTodayCard(JournalEntry entry) {
    if (!_isTodayExpanded) {
      return Padding(
        padding: const EdgeInsets.only(left: 48),
        child: GestureDetector(
          onTap: () => setState(() => _isTodayExpanded = true),
          child: Stack(
            children: [
              Positioned(
                left: -36,
                top: 14,
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary.withAlpha(76)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.edit, size: 18, color: AppColors.primary),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Write today\'s entry...',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.outline,
                        ),
                      ),
                    ),
                    const Icon(Icons.chevron_right, size: 18, color: AppColors.outline),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(left: 48),
      child: Stack(
        children: [
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'TODAY',
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.33,
                        letterSpacing: 0.05,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => setState(() => _isTodayExpanded = false),
                      child: const Icon(Icons.close, size: 18, color: AppColors.onSurfaceVariant),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _todayController,
                  maxLines: null,
                  autofocus: true,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.43,
                    fontWeight: FontWeight.w400,
                    color: AppColors.onSurface,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Record your observations...',
                    hintStyle: TextStyle(color: AppColors.outline),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    filled: false,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: _saveTodayEntry,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Text(
                          'SAVE',
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveTodayEntry() async {
    final content = _todayController.text.trim();
    if (content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please write something before saving'),
          backgroundColor: AppColors.errorContainer,
        ),
      );
      return;
    }

    await context.read<JournalProvider>().addEntry(
      pairSymbol: widget.pairSymbol,
      content: content,
    );

    if (mounted) {
      context.read<PairProvider>().refreshPairs();
      _todayController.clear();
      _isTodayExpanded = false;
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Entry saved'),
          backgroundColor: AppColors.secondary,
        ),
      );
    }
  }

  Widget _buildLockedCard(JournalEntry entry) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => LockedHistoricalEntryScreen(entry: entry),
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
            builder: (_) => JournalEditorScreen(pairSymbol: widget.pairSymbol),
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
