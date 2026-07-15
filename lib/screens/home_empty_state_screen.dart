import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class HomeEmptyStateScreen extends StatelessWidget {
  final VoidCallback? onAddPair;

  const HomeEmptyStateScreen({super.key, this.onAddPair});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTopBar(context),
        Expanded(
          child: _buildContent(),
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
            const Expanded(
              child: Text(
                'Trading Journal',
                style: TextStyle(
                  fontSize: 20,
                  height: 1.4,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurface,
                ),
              ),
            ),
            const Icon(
              Icons.search,
              color: AppColors.primary,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildHeroIllustration(),
            const SizedBox(height: 32),
            const Text(
              'No pairs tracked yet',
              style: TextStyle(
                fontSize: 24,
                height: 1.33,
                letterSpacing: -0.01,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Add your first trading pair to start journaling your market analysis.',
              style: TextStyle(
                fontSize: 14,
                height: 1.43,
                fontWeight: FontWeight.w400,
                color: AppColors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            _buildAddPairButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroIllustration() {
    return Container(
      width: 280,
      height: 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppColors.outlineVariant),
        color: AppColors.surfaceContainerLow,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Ambient glow
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withAlpha(25),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withAlpha(25),
                  blurRadius: 60,
                  spreadRadius: 20,
                ),
              ],
            ),
          ),
          // Icon illustration
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.candlestick_chart_outlined,
                size: 80,
                color: AppColors.primary.withAlpha(150),
              ),
              const SizedBox(height: 16),
              Icon(
                Icons.show_chart,
                size: 48,
                color: AppColors.primary.withAlpha(100),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddPairButton() {
    return GestureDetector(
      onTap: onAddPair,
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 32),
        decoration: BoxDecoration(
          color: AppColors.primaryContainer,
          borderRadius: BorderRadius.circular(999),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.add,
              color: AppColors.onPrimaryContainer,
              size: 24,
            ),
            SizedBox(width: 8),
            Text(
              'Add Pair',
              style: TextStyle(
                fontSize: 20,
                height: 1.4,
                fontWeight: FontWeight.w600,
                color: AppColors.onPrimaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
