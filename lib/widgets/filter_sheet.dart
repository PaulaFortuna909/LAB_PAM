import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/app_theme.dart';
import '../logic/home/home_cubit.dart';
import '../logic/home/home_state.dart';

/// Bottom sheet cu filtrare (specialitate, doar favorite) și sortare.
/// Modificările se aplică imediat prin HomeCubit.
class FilterSheet extends StatelessWidget {
  const FilterSheet({super.key});

  static Future<void> show(BuildContext context) {
    final cubit = context.read<HomeCubit>();
    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.white,
      builder: (_) =>
          BlocProvider.value(value: cubit, child: const FilterSheet()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final cubit = context.read<HomeCubit>();
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Specialty',
                  style: outfit(15, FontWeight.w600, AppColors.dark),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _chip(
                      'All',
                      state.specialty == null,
                      () => cubit.filterBySpecialty(null),
                    ),
                    for (final s in state.specialties)
                      _chip(
                        s,
                        state.specialty == s,
                        () => cubit.filterBySpecialty(s),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Sort by',
                  style: outfit(15, FontWeight.w600, AppColors.dark),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final s in DoctorSort.values)
                      _chip(s.label, state.sort == s, () => cubit.sortBy(s)),
                  ],
                ),
                const SizedBox(height: 8),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  activeTrackColor: AppColors.teal,
                  title: Text(
                    'Favorites only',
                    style: outfit(14, FontWeight.w500, AppColors.dark),
                  ),
                  value: state.favoritesOnly,
                  onChanged: cubit.setFavoritesOnly,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    TextButton(
                      onPressed: cubit.clearFilters,
                      child: Text(
                        'Reset',
                        style: outfit(13, FontWeight.w500, AppColors.grey),
                      ),
                    ),
                    const Spacer(),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.teal,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        'Done',
                        style: outfit(13, FontWeight.w600, Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _chip(String label, bool selected, VoidCallback onTap) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      showCheckmark: false,
      selectedColor: AppColors.teal,
      backgroundColor: AppColors.fieldBg,
      side: BorderSide.none,
      labelStyle: outfit(
        12,
        FontWeight.w500,
        selected ? Colors.white : AppColors.dark,
      ),
    );
  }
}
