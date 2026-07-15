import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color accentColor;
  final String? heroImagePath;

  const OnboardingPage({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.accentColor,
    this.heroImagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const Spacer(),
          _buildIllustration(),
          const SizedBox(height: 48),
          _buildTextContent(),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildIllustration() {
    return SizedBox(
      width: double.infinity,
      height: 400,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Ambient glow
          Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  accentColor.withAlpha(26),
                  accentColor.withAlpha(0),
                ],
              ),
            ),
          ),
          // Glass card
          Container(
            width: 320,
            height: 360,
            decoration: BoxDecoration(
              color: const Color(0x991E1E1E),
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: AppColors.outlineVariant.withAlpha(77)),
            ),
            child: Center(
              child: Container(
                width: 280,
                height: 320,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.outlineVariant),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Top decorative bars
                    Positioned(
                      top: 16,
                      left: 16,
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 8,
                            decoration: BoxDecoration(
                              color: accentColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 32,
                            height: 8,
                            decoration: BoxDecoration(
                              color: AppColors.outline,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Central icon
                    Icon(
                      icon,
                      size: 80,
                      color: accentColor,
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

  Widget _buildTextContent() {
    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 32,
            height: 1.25,
            letterSpacing: -0.02,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurface,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          description,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            height: 1.5,
            fontWeight: FontWeight.w400,
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
