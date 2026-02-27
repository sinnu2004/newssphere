// lib/presentation/widgets/category_chips.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../providers/app_providers.dart';

class CategoryChips extends ConsumerStatefulWidget {
  final ValueChanged<String>? onCategorySelected;

  const CategoryChips({super.key, this.onCategorySelected});

  @override
  ConsumerState<CategoryChips> createState() => _CategoryChipsState();
}

class _CategoryChipsState extends ConsumerState<CategoryChips> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SizedBox(
      height: 42,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: NewsCategories.categories.length,
        itemBuilder: (context, index) {
          final category = NewsCategories.categories[index];
          final id = category['id'] as String;
          final name = category['name'] as String;
          final icon = category['icon'] as String;
          final isSelected = selectedCategory == id;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              child: GestureDetector(
                onTap: () {
                  ref.read(selectedCategoryProvider.notifier).state = id;
                  widget.onCategorySelected?.call(id);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : (isDark ? AppColors.cardDark : AppColors.backgroundLight),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? theme.colorScheme.primary
                          : (isDark
                              ? AppColors.dividerDark
                              : AppColors.dividerLight),
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: theme.colorScheme.primary.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            )
                          ]
                        : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(icon, style: const TextStyle(fontSize: 14)),
                      const SizedBox(width: 5),
                      Text(
                        name,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: isSelected
                              ? Colors.white
                              : theme.colorScheme.onSurface,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
