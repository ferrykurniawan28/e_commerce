import 'package:flutter/material.dart';

class ProductSearchField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String) onChanged;
  final VoidCallback onClear;
  final VoidCallback? onSubmitted;
  final bool isSearchFocused;

  const ProductSearchField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onClear,
    required this.isSearchFocused,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSearchFocused ? Colors.blue : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Search products, brands...',
          hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
          prefixIcon: Icon(
            Icons.search,
            color: isSearchFocused ? Colors.blue : Colors.grey.shade500,
            size: 20,
          ),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: Colors.grey.shade500,
                    size: 18,
                  ),
                  onPressed: onClear,
                )
              : Icon(Icons.mic, color: Colors.grey.shade500, size: 18),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
        ),
        style: const TextStyle(fontSize: 14),
        textInputAction: TextInputAction.search,
        onSubmitted: (value) {
          if (value.isNotEmpty && onSubmitted != null) {
            onSubmitted!();
            focusNode.unfocus();
          }
        },
      ),
    );
  }
}
