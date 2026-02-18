import 'package:flutter/material.dart';

class CustomDropdownField extends StatelessWidget {
  final String labelText;
  final List<String> items;
  final String? value;
  final Function(String?) onChanged;
  final VoidCallback? onPressed;
  final double width;

  const CustomDropdownField({
    super.key,
    required this.labelText,
    required this.items,
    required this.value,
    required this.onChanged,
    this.width = 150,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      textDirection: TextDirection.rtl,
      children: [
        Text(
          '$labelText :',
          style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.primary
          ),
          textDirection: TextDirection.rtl,
        ),
        const SizedBox(height: 8),
        Directionality(
          textDirection: TextDirection.rtl,
          child: SizedBox(
            width: width,
            height: 42.5,
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: items.contains(value) ? value : null,
                hint: Text("انتخاب کنید"),
                style: Theme.of(context).textTheme.bodyLarge,
                items: items.map((String item) {
                  return DropdownMenuItem(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                onChanged: onChanged,
                icon: Icon(Icons.arrow_drop_down, size: 30,)
              ),
            ),
          ),
        ),
      ],
    );
  }
}