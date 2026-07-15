import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/journal_entry.dart';
import '../models/trading_pair.dart';
import '../providers/pair_provider.dart';
import '../providers/journal_provider.dart';
import '../theme/app_colors.dart';
import 'pair_detail_timeline_screen.dart';

class SearchExperienceScreen extends StatefulWidget {
  const SearchExperienceScreen({super.key});

  @override
  State<SearchExperienceScreen> createState() => _SearchExperienceScreenState();
}

class _SearchExperienceScreenState extends State<SearchExperienceScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildSearchHeader(),
          Expanded(
            child: _query.isEmpty ? _buildEmptyState() : _buildResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchHeader() {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      decoration: BoxDecoration(
        color: AppColors.background.withAlpha(220),
        border: const Border(bottom: BorderSide(color: AppColors.outlineVariant)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.search,
                      color: AppColors.onSurfaceVariant,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        focusNode: _searchFocusNode,
                        autofocus: true,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.onSurface,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Search pairs or entries...',
                          hintStyle: TextStyle(color: AppColors.onSurfaceVariant),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          filled: false,
                          contentPadding: EdgeInsets.zero,
                        ),
                        onChanged: (value) {
                          setState(() => _query = value);
                        },
                      ),
                    ),
                    if (_query.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          _searchController.clear();
                          setState(() => _query = '');
                        },
                        child: const Icon(
                          Icons.close,
                          color: AppColors.onSurfaceVariant,
                          size: 18,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 12,
                  height: 1.33,
                  letterSpacing: 0.05,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 192,
              height: 192,
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.search,
                size: 64,
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Search Your Journal',
              style: TextStyle(
                fontSize: 20,
                height: 1.4,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Type to search across your trading pairs and journal entries.',
              style: TextStyle(
                fontSize: 14,
                height: 1.43,
                fontWeight: FontWeight.w400,
                color: AppColors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResults() {
    final pairProvider = context.watch<PairProvider>();
    final journalProvider = context.watch<JournalProvider>();
    final q = _query.toLowerCase();

    final matchedPairs = pairProvider.pairs
        .where((p) => p.symbol.toLowerCase().contains(q))
        .toList();

    final allEntries = journalProvider.entries;
    final matchedEntries = allEntries
        .where((e) =>
            e.content.toLowerCase().contains(q) ||
            (e.title?.toLowerCase().contains(q) ?? false) ||
            e.tags.any((t) => t.toLowerCase().contains(q)))
        .toList();

    final matchedTags = <String>{};
    for (final entry in allEntries) {
      for (final tag in entry.tags) {
        if (tag.toLowerCase().contains(q)) {
          matchedTags.add(tag);
        }
      }
    }

    final hasResults =
        matchedPairs.isNotEmpty || matchedEntries.isNotEmpty || matchedTags.isNotEmpty;

    if (!hasResults) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off, size: 48, color: AppColors.onSurfaceVariant),
            const SizedBox(height: 16),
            const Text(
              'No Results Found',
              style: TextStyle(
                fontSize: 20,
                height: 1.4,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'No matches for "$_query"',
              style: const TextStyle(
                fontSize: 14,
                height: 1.43,
                fontWeight: FontWeight.w400,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (matchedPairs.isNotEmpty) ...[
            _buildSectionHeader(
              title: 'TRADING PAIRS',
              trailing: '${matchedPairs.length} found',
            ),
            const SizedBox(height: 12),
            ...matchedPairs.map((pair) => _buildPairResult(pair)),
          ],
          if (matchedEntries.isNotEmpty) ...[
            const SizedBox(height: 24),
            _buildSectionHeader(
              title: 'JOURNAL ENTRIES',
              trailing: '${matchedEntries.length} found',
            ),
            const SizedBox(height: 12),
            ...matchedEntries.map((entry) => _buildEntryResult(entry)),
          ],
          if (matchedTags.isNotEmpty) ...[
            const SizedBox(height: 24),
            _buildSectionHeader(title: 'TAGS'),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: matchedTags.map((tag) => _buildTagChip(tag)).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    String? trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              height: 1.33,
              letterSpacing: 0.05,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          if (trailing != null)
            Text(
              trailing,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPairResult(TradingPair pair) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => PairDetailTimelineScreen(pairSymbol: pair.symbol),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryContainer.withAlpha(50),
              ),
              child: const Icon(
                Icons.currency_bitcoin,
                color: AppColors.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pair.symbol,
                    style: const TextStyle(
                      fontSize: 20,
                      height: 1.4,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${pair.journalCount} journal entries',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColors.onSurfaceVariant,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEntryResult(JournalEntry entry) {
    final date = entry.date;
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final dateStr = '${months[date.month - 1]} ${date.day}, ${date.year}';

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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.outlineVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    entry.title ?? entry.pairSymbol,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.4,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurface,
                    ),
                  ),
                ),
                if (statusLabel.isNotEmpty)
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
            const SizedBox(height: 8),
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
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 12, color: AppColors.onSurfaceVariant),
                const SizedBox(width: 4),
                Text(
                  dateStr,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.label, size: 12, color: AppColors.onSurfaceVariant),
                const SizedBox(width: 4),
                Text(
                  entry.pairSymbol,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTagChip(String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.sell, size: 14, color: AppColors.primary),
          const SizedBox(width: 8),
          Text(
            tag,
            style: const TextStyle(
              fontSize: 12,
              height: 1.33,
              letterSpacing: 0.05,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
