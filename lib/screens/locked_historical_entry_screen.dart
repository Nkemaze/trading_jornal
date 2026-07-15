import 'package:flutter/material.dart';
import '../models/journal_entry.dart';
import '../theme/app_colors.dart';

class LockedHistoricalEntryScreen extends StatelessWidget {
  const LockedHistoricalEntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final trade = HistoricalTrade.sampleData;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildTopBar(context),
          Expanded(
            child: _buildContent(trade),
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

  Widget _buildContent(HistoricalTrade trade) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAssetHeader(trade),
          const SizedBox(height: 24),
          _buildBentoLayout(trade),
          const SizedBox(height: 16),
          _buildTags(trade),
        ],
      ),
    );
  }

  Widget _buildAssetHeader(HistoricalTrade trade) {
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
                  'Oct 12, 2023 \u2022 14:45 EST',
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.33,
                    letterSpacing: 0.05,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurfaceVariant.withAlpha(200),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'BTC / USD',
                  style: TextStyle(
                    fontSize: 32,
                    height: 1.25,
                    letterSpacing: -0.02,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  trade.pnl,
                  style: const TextStyle(
                    fontSize: 24,
                    height: 1.33,
                    letterSpacing: -0.01,
                    fontWeight: FontWeight.w600,
                    color: AppColors.secondary,
                  ),
                ),
                Text(
                  trade.roi,
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
        const SizedBox(height: 16),
        Container(
          height: 1,
          width: double.infinity,
          color: AppColors.outlineVariant,
        ),
      ],
    );
  }

  Widget _buildBentoLayout(HistoricalTrade trade) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  _buildExecutionDetails(trade),
                  const SizedBox(height: 12),
                  _buildRiskProfile(trade),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: _buildTradeThesis(trade),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildExecutionDetails(HistoricalTrade trade) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'EXECUTION DETAILS',
            style: TextStyle(
              fontSize: 12,
              height: 1.33,
              letterSpacing: 0.05,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          _buildDetailField('Position', trade.position, isHighlighted: true),
          const SizedBox(height: 12),
          _buildDetailField('Entry Price', trade.entryPrice),
          const SizedBox(height: 12),
          _buildDetailField('Exit Price', trade.exitPrice),
          const SizedBox(height: 12),
          _buildDetailField('Total Size', trade.totalSize),
        ],
      ),
    );
  }

  Widget _buildDetailField(String label, String value, {bool isHighlighted = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: AppColors.outline,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            height: 1.43,
            letterSpacing: -0.01,
            fontWeight: FontWeight.w600,
            color: isHighlighted ? AppColors.secondary : AppColors.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildRiskProfile(HistoricalTrade trade) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'RISK PROFILE',
            style: TextStyle(
              fontSize: 12,
              height: 1.33,
              letterSpacing: 0.05,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'R:R RATIO',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: AppColors.outline,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      trade.rrRatio,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.43,
                        letterSpacing: -0.01,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.secondary.withAlpha(76),
                    width: 4,
                  ),
                ),
                child: const Center(
                  child: Text(
                    'A+',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.secondary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTradeThesis(HistoricalTrade trade) {
    return Container(
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
              const Text(
                'Trade Thesis',
                style: TextStyle(
                  fontSize: 20,
                  height: 1.4,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...trade.thesis.split('\n\n').map((paragraph) {
            if (paragraph.startsWith('"')) {
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHighest.withAlpha(76),
                  borderRadius: BorderRadius.circular(8),
                  border: const Border(
                    left: BorderSide(
                      color: AppColors.primary,
                      width: 4,
                    ),
                  ),
                ),
                child: Text(
                  paragraph,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.43,
                    fontWeight: FontWeight.w400,
                    color: AppColors.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                paragraph,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.43,
                  fontWeight: FontWeight.w400,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            );
          }),
          const SizedBox(height: 16),
          const Text(
            'HISTORICAL EVIDENCE',
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
      ),
    );
  }

  Widget _buildImageGallery() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildGalleryThumbnail(120),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildGalleryThumbnail(120),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _buildGalleryThumbnail(80),
      ],
    );
  }

  Widget _buildGalleryThumbnail(double height) {
    return GestureDetector(
      onTap: () {
        // TODO: Navigate to image gallery
      },
      child: Container(
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.outlineVariant),
          color: AppColors.surfaceContainerHighest,
        ),
        child: const Center(
          child: Icon(
            Icons.image,
            size: 32,
            color: AppColors.outline,
          ),
        ),
      ),
    );
  }

  Widget _buildTags(HistoricalTrade trade) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: trade.tags.map((tag) {
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
