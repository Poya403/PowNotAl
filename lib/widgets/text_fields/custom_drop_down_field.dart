import 'package:flutter/material.dart';

class CustomDropdownField extends StatelessWidget {
  final String labelText;
  final List<String> items;
  final String? value;
  final Function(String?) onChanged;
  final VoidCallback? onPressed;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const CustomDropdownField({
    super.key,
    required this.labelText,
    required this.items,
    required this.value,
    required this.onChanged,
    this.prefixIcon,
    this.suffixIcon,
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
        SizedBox(
          width: 250,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Theme.of(context).colorScheme.surfaceContainerHighest),
              ),
              child: SizedBox(
                height: 42.5,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: items.contains(value) ? value : null,
                    hint: Text(
                        "انتخاب کنید",
                        style: TextStyle(color: Theme.of(context).colorScheme.surface))
                    ,
                    style: Theme.of(context).textTheme.titleSmall,
                    items: items.map((String item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                    onChanged: onChanged,
                    icon: value != null ? IconButton(
                      icon: Icon(Icons.cancel_outlined),
                      color: Theme.of(context).colorScheme.surface,
                      onPressed: onPressed,
                    ) : null,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}