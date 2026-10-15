import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../config/search_config.dart';

/// Generic field renderer driven by [FieldConfig].
///
/// Supports text and date types. Adding a new FieldType only requires
/// extending the switch — the parent form stays untouched.
class DynamicField extends StatelessWidget {
  final FieldConfig config;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onSubmitted;
  final TextInputAction textInputAction;

  const DynamicField({
    super.key,
    required this.config,
    required this.controller,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    this.textInputAction = TextInputAction.next,
  });

  @override
  Widget build(BuildContext context) {
    switch (config.type) {
      case FieldType.text:
        return _buildTextField(context);
      case FieldType.date:
        return _buildDateField(context);
    }
  }

  Widget _buildTextField(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      textInputAction: textInputAction,
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        labelText: config.label,
        hintText: config.placeholder,
        prefixIcon: Icon(
          Icons.person_outline_rounded,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      onChanged: onChanged,
      onFieldSubmitted: (_) => onSubmitted?.call(),
    );
  }

  Widget _buildDateField(BuildContext context) {
    return GestureDetector(
      onTap: () => _pickDate(context),
      child: AbsorbPointer(
        child: TextFormField(
          controller: controller,
          focusNode: focusNode,
          readOnly: true,
          decoration: InputDecoration(
            labelText: config.label,
            hintText: config.placeholder,
            prefixIcon: Icon(
              Icons.calendar_today_rounded,
              color: Theme.of(context).colorScheme.primary,
            ),
            suffixIcon: controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear_rounded, size: 20),
                    onPressed: () {
                      controller.clear();
                      onChanged?.call('');
                    },
                  )
                : null,
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final initial = _parseDate(controller.text) ??
        DateTime(now.year - 30, now.month, now.day);

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1900),
      lastDate: now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: Theme.of(context).colorScheme.primary,
                ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final formatted = DateFormat('yyyy-MM-dd').format(picked);
      controller.text = formatted;
      onChanged?.call(formatted);
    }
  }

  DateTime? _parseDate(String value) {
    if (value.isEmpty) return null;
    try {
      return DateFormat('yyyy-MM-dd').parse(value);
    } catch (_) {
      return null;
    }
  }
}
