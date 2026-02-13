import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    this.textDirection,
    this.keyboardType,
    required this.labelText,
    this.fontSize = 18,
    this.maxLines = 1,
    this.minLines = 1,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
    this.readOnly = false,
  });

  final TextEditingController controller;
  final TextDirection? textDirection;
  final TextInputType? keyboardType;
  final String labelText;
  final double fontSize;
  final int? maxLines;
  final int? minLines;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool enabled;
  final bool readOnly;
  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width > 800;
    return Align(
      child: Directionality(
        textDirection: widget.textDirection ?? TextDirection.rtl,
        child: SizedBox(
          width: isDesktop
              ? MediaQuery.of(context).size.width * 0.5
              : MediaQuery.of(context).size.width * 0.85,
          child: TextField(
            enabled: widget.enabled,
            readOnly: widget.readOnly,
            textAlignVertical: TextAlignVertical.top,
            textAlign: TextAlign.justify,
            controller: widget.controller,
            keyboardType: widget.keyboardType,
            maxLines: widget.maxLines,
            minLines: widget.minLines,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontSize: widget.fontSize,
                color: widget.readOnly ? Colors.grey.shade700 : null),
            decoration: InputDecoration(
              labelText: widget.labelText,
              border: OutlineInputBorder(),
              prefix: widget.prefixIcon,
              suffix: widget.suffixIcon,
              alignLabelWithHint: true,
              filled: true,
              fillColor: widget.readOnly
                  ? Colors.grey.shade100
                  : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
