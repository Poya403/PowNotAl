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
    this.filled = true,
    this.borderRadius
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
  final bool filled;
  final BorderRadius? borderRadius;
  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width > 800;
    double width = isDesktop ? 400 : MediaQuery.of(context).size.width * 0.85;

    return Align(
      child: Directionality(
        textDirection: widget.textDirection ?? TextDirection.rtl,
        child: SizedBox(
          width: width,
          child: TextField(
            enabled: widget.enabled,
            readOnly: widget.readOnly,
            textAlignVertical: TextAlignVertical.center,
            textAlign: TextAlign.start,
            controller: widget.controller,
            keyboardType: widget.keyboardType,
            maxLines: widget.maxLines,
            minLines: widget.minLines,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: isDesktop ? widget.fontSize : widget.fontSize * 0.9,
              color: widget.readOnly ? Colors.grey.shade600 : Colors.black,
            ),
            decoration: InputDecoration(
              labelText: widget.labelText,
              border: OutlineInputBorder(
                borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.blue, width: 2),
              ),
              prefixIcon: widget.prefixIcon,
              suffixIcon: widget.suffixIcon,
              alignLabelWithHint: true,
              filled: widget.filled,
              fillColor: widget.readOnly ? Colors.grey.shade100 : Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            ),
          ),
        ),
      ),
    );
  }
}
