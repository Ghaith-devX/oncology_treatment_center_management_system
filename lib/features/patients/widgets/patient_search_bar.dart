import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';

class PatientSearchBar extends StatelessWidget {
  final String query;
  final ValueChanged<String> onChanged;

  const PatientSearchBar({
    super.key,
    required this.query,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: TextEditingController.fromValue(
          TextEditingValue(
            text: query,
            selection: TextSelection.collapsed(offset: query.length),
          ),
        ),
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: AppStrings.search,
          prefixIcon: const Icon(Icons.search),
          suffixIcon: query.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => onChanged(''),
                )
              : null,
        ),
      ),
    );
  }
}
