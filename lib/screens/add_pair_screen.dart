import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pair_provider.dart';
import '../theme/app_colors.dart';

class AddPairScreen extends StatefulWidget {
  const AddPairScreen({super.key});

  @override
  State<AddPairScreen> createState() => _AddPairScreenState();
}

class _AddPairScreenState extends State<AddPairScreen> {
  final TextEditingController _symbolController = TextEditingController();

  @override
  void dispose() {
    _symbolController.dispose();
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
            child: _buildForm(),
          ),
        ],
      ),
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
            const SizedBox(width: 16),
            const Text(
              'Add Pair',
              style: TextStyle(
                fontSize: 20,
                height: 1.4,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurface,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: _savePair,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  'Save',
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

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'PAIR NAME',
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
            controller: _symbolController,
            autofocus: true,
            style: const TextStyle(
              fontSize: 24,
              height: 1.33,
              letterSpacing: -0.01,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurface,
            ),
            textCapitalization: TextCapitalization.characters,
            decoration: InputDecoration(
              hintText: 'e.g. BTC/USD, NVDA, EUR/USD',
              hintStyle: const TextStyle(
                color: AppColors.outline,
                fontSize: 24,
                fontWeight: FontWeight.w400,
              ),
              filled: true,
              fillColor: AppColors.surfaceContainerHigh,
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
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            ),
            onSubmitted: (_) => _savePair(),
          ),
          const SizedBox(height: 16),
          const Text(
            'Enter the name of the trading pair or asset you want to journal.',
            style: TextStyle(
              fontSize: 14,
              height: 1.43,
              fontWeight: FontWeight.w400,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 48),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _savePair,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
                elevation: 8,
                shadowColor: AppColors.primary.withAlpha(51),
              ),
              child: const Text(
                'Add Pair',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.05,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _savePair() {
    if (_symbolController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a pair name'),
          backgroundColor: AppColors.errorContainer,
        ),
      );
      return;
    }
    context.read<PairProvider>().addPair(_symbolController.text.trim());
    Navigator.of(context).pop();
  }
}
