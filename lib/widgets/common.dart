import 'package:flutter/material.dart';

import '../core/app_theme.dart';

/// Titlu de secțiune cu "See All" opțional.
class SectionTitle extends StatelessWidget {
  const SectionTitle(this.title, {super.key, this.trailing, this.onTrailing});

  final String title;
  final String? trailing;
  final VoidCallback? onTrailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: outfit(17, FontWeight.w600, AppColors.dark),
          ),
        ),
        if (trailing != null)
          GestureDetector(
            onTap: onTrailing,
            child: Text(
              trailing!,
              style: outfit(11, FontWeight.w500, AppColors.teal),
            ),
          ),
      ],
    );
  }
}

/// Câmp de căutare cu buton de filtre.
class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
    required this.controller,
    required this.hint,
    required this.onChanged,
    required this.onFilterTap,
    this.filtersActive = false,
  });

  final TextEditingController controller;
  final String hint;
  final ValueChanged<String> onChanged;
  final VoidCallback onFilterTap;
  final bool filtersActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.only(left: 14, right: 4),
      decoration: BoxDecoration(
        color: AppColors.fieldBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, color: Color(0xFF9CA3B8), size: 24),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              textInputAction: TextInputAction.search,
              style: outfit(13, FontWeight.w400, AppColors.dark),
              decoration: InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                hintText: hint,
                hintStyle: outfit(13, FontWeight.w400, AppColors.hint),
              ),
            ),
          ),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (_, value, _) => value.text.isEmpty
                ? const SizedBox.shrink()
                : IconButton(
                    tooltip: 'Clear',
                    icon: const Icon(
                      Icons.close_rounded,
                      size: 20,
                      color: Color(0xFF9CA3B8),
                    ),
                    onPressed: () {
                      controller.clear();
                      onChanged('');
                    },
                  ),
          ),
          IconButton(
            tooltip: 'Filter & sort',
            onPressed: onFilterTap,
            icon: Badge(
              isLabelVisible: filtersActive,
              smallSize: 8,
              backgroundColor: AppColors.teal,
              child: const Icon(
                Icons.tune_rounded,
                color: Color(0xFF9CA3B8),
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Rând orizontal de opțiuni selectabile (ore, date).
class SelectableChips extends StatelessWidget {
  const SelectableChips({
    super.key,
    required this.labels,
    required this.selected,
    required this.onSelected,
  });

  final List<String> labels;
  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: labels.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final isSel = i == selected;
          return GestureDetector(
            onTap: () => onSelected(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 86,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSel ? AppColors.primary : AppColors.chipBg,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                labels[i],
                style: openSans(
                  13,
                  FontWeight.w400,
                  isSel ? Colors.white : const Color(0xFF111111),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Iconiță mică rotundă (mesaj, apel, video).
class RoundIcon extends StatelessWidget {
  const RoundIcon(this.icon, {super.key, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 26,
        height: 26,
        decoration: const BoxDecoration(
          color: AppColors.iconBg,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 14, color: const Color(0xFF111111)),
      ),
    );
  }
}
