import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/stat_card.dart';

class StatGrid extends StatelessWidget {
  final List<StatItem> items;

  const StatGrid({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          for (var i = 0; i < items.length; i += 2)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Expanded(child: items[i]),
                  const SizedBox(width: 12),
                  if (i + 1 < items.length)
                    Expanded(child: items[i + 1])
                  else
                    const Expanded(child: SizedBox()),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? color;

  const StatItem({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return StatCard(
      label: label,
      value: value,
      icon: icon,
      color: color ?? AppColors.primary,
    );
  }
}
