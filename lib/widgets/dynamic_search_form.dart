import 'package:flutter/material.dart';

import '../config/search_config.dart';
import 'dynamic_field.dart';

/// Configuration-driven search form.
///
/// Builds fields from [orderedSearchConfig]. Controllers and focus nodes
/// are owned and disposed by this StatefulWidget (lifecycle-safe).
class DynamicSearchForm extends StatefulWidget {
  final void Function(Map<String, String> criteria) onSearch;
  final VoidCallback? onClear;
  final bool isLoading;

  const DynamicSearchForm({
    super.key,
    required this.onSearch,
    this.onClear,
    this.isLoading = false,
  });

  @override
  State<DynamicSearchForm> createState() => _DynamicSearchFormState();
}

class _DynamicSearchFormState extends State<DynamicSearchForm> {
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, FocusNode> _focusNodes = {};
  final _formKey = GlobalKey<FormState>();

  late final List<FieldConfig> _fields;

  @override
  void initState() {
    super.initState();
    _fields = orderedSearchConfig;
    for (final field in _fields) {
      _controllers[field.key] = TextEditingController();
      _focusNodes[field.key] = FocusNode();
    }
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    for (final f in _focusNodes.values) {
      f.dispose();
    }
    super.dispose();
  }

  Map<String, String> _collectCriteria() {
    final map = <String, String>{};
    for (final entry in _controllers.entries) {
      map[entry.key] = entry.value.text.trim();
    }
    return map;
  }

  void _submit() {
    // Dismiss keyboard
    FocusScope.of(context).unfocus();
    widget.onSearch(_collectCriteria());
  }

  void _clear() {
    for (final c in _controllers.values) {
      c.clear();
    }
    setState(() {});
    widget.onClear?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ..._fields.asMap().entries.map((entry) {
            final index = entry.key;
            final config = entry.value;
            final isLast = index == _fields.length - 1;
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: DynamicField(
                config: config,
                controller: _controllers[config.key]!,
                focusNode: _focusNodes[config.key],
                textInputAction:
                    isLast ? TextInputAction.search : TextInputAction.next,
                onSubmitted: isLast ? _submit : null,
              ),
            );
          }),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: widget.isLoading ? null : _clear,
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Clear'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: widget.isLoading ? null : _submit,
                  icon: widget.isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.search_rounded),
                  label: Text(widget.isLoading ? 'Searching…' : 'Search'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
