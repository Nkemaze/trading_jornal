import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class ImageGalleryViewerScreen extends StatefulWidget {
  const ImageGalleryViewerScreen({super.key});

  @override
  State<ImageGalleryViewerScreen> createState() =>
      _ImageGalleryViewerScreenState();
}

class _ImageGalleryViewerScreenState extends State<ImageGalleryViewerScreen> {
  bool _uiVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Main image area
          _buildImageCanvas(),
          // Top bar
          AnimatedOpacity(
            opacity: _uiVisible ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: _buildTopBar(),
          ),
          // Info tag
          AnimatedOpacity(
            opacity: _uiVisible ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: _buildInfoTag(),
          ),
          // Bottom bar
          AnimatedOpacity(
            opacity: _uiVisible ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: _buildBottomBar(),
          ),
        ],
      ),
    );
  }

  Widget _buildImageCanvas() {
    return GestureDetector(
      onTap: () {
        setState(() => _uiVisible = !_uiVisible);
      },
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            colors: [Color(0xFF1A1A1A), Colors.black],
          ),
        ),
        child: const Center(
          child: Icon(
            Icons.candlestick_chart,
            size: 120,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
        ),
        decoration: BoxDecoration(
          color: Colors.black.withAlpha(150),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withAlpha(25),
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: AppColors.onSurface,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              const Text(
                'Chart Detail',
                style: TextStyle(
                  fontSize: 20,
                  height: 1.4,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurface,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  // TODO: More options
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withAlpha(25),
                  ),
                  child: const Icon(
                    Icons.more_vert,
                    color: AppColors.onSurface,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTag() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 70,
      left: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black.withAlpha(100),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white.withAlpha(25)),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 4,
              backgroundColor: AppColors.secondary,
            ),
            SizedBox(width: 8),
            Text(
              'BTC / USDT',
              style: TextStyle(
                fontSize: 14,
                height: 1.43,
                letterSpacing: -0.01,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurface,
              ),
            ),
            SizedBox(width: 8),
            Text(
              '\u2022 15m',
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

  Widget _buildBottomBar() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom,
        ),
        decoration: BoxDecoration(
          color: Colors.black.withAlpha(200),
          border: Border(
            top: BorderSide(color: Colors.white.withAlpha(13)),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildBottomBarItem(
                icon: Icons.share,
                label: 'Share',
                onTap: () {},
              ),
              _buildBottomBarItem(
                icon: Icons.download,
                label: 'Save',
                onTap: () {},
              ),
              _buildBottomBarItem(
                icon: Icons.delete,
                label: 'Delete',
                color: AppColors.error.withAlpha(200),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBarItem({
    required IconData icon,
    required String label,
    Color? color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color ?? AppColors.onSurfaceVariant,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              height: 1.33,
              letterSpacing: 0.05,
              fontWeight: FontWeight.w600,
              color: color ?? AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
