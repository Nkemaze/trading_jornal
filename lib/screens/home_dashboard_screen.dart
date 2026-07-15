import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/navigation_provider.dart';
import '../providers/pair_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/trading_pair_card.dart';
import 'home_empty_state_screen.dart';
import 'pair_detail_timeline_screen.dart';
import 'alerts_management_screen.dart';
import 'app_settings_screen.dart';
import 'add_pair_screen.dart';
import 'search_experience_screen.dart';

class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({super.key});

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final navProvider = context.watch<NavigationProvider>();
    final currentTab = navProvider.currentBottomNavIndex;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: _buildTabContent(currentTab),
      floatingActionButton: currentTab == 0 ? _buildFab() : null,
      bottomNavigationBar: const BottomNavBar(),
    );
  }

  Widget _buildTabContent(int tabIndex) {
    switch (tabIndex) {
      case 0:
        return _buildHomeTab();
      case 1:
        return const SizedBox.shrink();
      case 2:
        return const AlertsManagementScreen();
      case 3:
        return const AppSettingsScreen();
      default:
        return _buildHomeTab();
    }
  }

  Widget _buildHomeTab() {
    final pairProvider = context.watch<PairProvider>();

    if (pairProvider.isEmpty) {
      return HomeEmptyStateScreen(
        onAddPair: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AddPairScreen()),
          );
        },
      );
    }

    return Column(
      children: [
        _buildTopBar(context),
        Expanded(
          child: _buildContent(pairProvider),
        ),
      ],
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
            const Icon(
              Icons.menu,
              color: AppColors.primary,
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const SearchExperienceScreen()),
                  );
                },
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.search,
                        color: AppColors.onSurfaceVariant,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Search pairs...',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.outlineVariant),
              ),
              child: const Icon(
                Icons.person,
                size: 20,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(PairProvider pairProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Markets Overview',
            style: TextStyle(
              fontSize: 24,
              height: 1.33,
              letterSpacing: -0.01,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Track your active positions and trade alerts.',
            style: TextStyle(
              fontSize: 14,
              height: 1.43,
              fontWeight: FontWeight.w400,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: pairProvider.pairs.map((pair) {
              return SizedBox(
                width: 340,
                child: Dismissible(
                  key: Key(pair.id),
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
                        title: const Text('Delete Pair',
                            style: TextStyle(color: AppColors.onSurface)),
                        content: Text(
                          'Delete ${pair.symbol} and all its journal entries?',
                          style: const TextStyle(color: AppColors.onSurfaceVariant),
                        ),
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
                    pairProvider.deletePair(pair.id);
                  },
                  child: TradingPairCard(
                    pair: pair,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => PairDetailTimelineScreen(
                            pairSymbol: pair.symbol,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFab() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const AddPairScreen()),
        );
      },
      child: const Icon(Icons.add, size: 28),
    );
  }
}
