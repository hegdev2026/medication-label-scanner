import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:medicine_lab_reader/core/constants/app_colors.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';
import 'package:medicine_lab_reader/core/theme/app_typography.dart';
import 'package:medicine_lab_reader/features/search/presentation/bloc/search_cubit.dart';

/// Search box. Searches on the keyboard's search key; also follows searches
/// started by tapping a chip.
class SearchField extends StatefulWidget {
  const SearchField({super.key});

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppRadius.xl);
    final cubit = context.read<SearchCubit>();
    return BlocListener<SearchCubit, SearchState>(
      listener: (_, s) {
        if (_controller.text.trim() != s.query) _controller.text = s.query;
      },
      child: TextField(
        controller: _controller,
        textInputAction: TextInputAction.search,
        onSubmitted: cubit.submit,
        style: AppText.bodyMd,
        decoration: InputDecoration(
          hintText: 'search.hint'.tr(),
          hintStyle: AppText.bodyMd.tinted(AppColors.textMuted),
          prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
          suffixIcon: ListenableBuilder(
            listenable: _controller,
            builder: (_, _) => _controller.text.isEmpty
                ? const SizedBox.shrink()
                : IconButton(
                    tooltip: 'search.clear'.tr(),
                    icon: Icon(Icons.close, color: AppColors.textSecondary),
                    onPressed: () {
                      _controller.clear();
                      cubit.clear();
                    },
                  ),
          ),
          filled: true,
          fillColor: AppColors.card,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          border: OutlineInputBorder(
            borderRadius: radius,
            borderSide: BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: radius,
            borderSide: BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: radius,
            borderSide: BorderSide(
              color: AppColors.accentText.withValues(alpha: 0.5),
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}
