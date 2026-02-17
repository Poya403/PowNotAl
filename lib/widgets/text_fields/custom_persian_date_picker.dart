import 'package:flutter/material.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;

class CustomPersianDateField extends StatefulWidget {
  const CustomPersianDateField({
    super.key,
    this.width = 200,
    required this.labelText,
    required this.controller,
    this.onDateSelected,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.prefixIcon,
    this.helpText,
    this.enabled = true,
  });

  final double width;
  final void Function(String)? onDateSelected;
  final String labelText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool enabled;
  final String? helpText;
  @override
  State<CustomPersianDateField> createState() => _CustomPersianDateFieldState();
}

class _CustomPersianDateFieldState extends State<CustomPersianDateField> {
  String? gregorianDate;

  Future<void> _selectDate(BuildContext context) async {
    if (!widget.enabled) return;

    final picked = await showPersianDatePicker(
      context: context,
      initialDate: Jalali.now(),
      firstDate: Jalali(1370, 1),
      lastDate: Jalali(1450, 12),
      helpText: widget.helpText,
      builder: (context, child) {
        return Localizations.override(
          context: context,
          locale: const Locale('fa', 'IR'),
          delegates: const [
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            PersianMaterialLocalizations.delegate,
            PersianCupertinoLocalizations.delegate,
          ],
          child: Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: Theme.of(context).primaryColor,
                onPrimary: Colors.white,
                onSurface: Colors.black,
              ),
              textTheme: Theme.of(context).textTheme.copyWith(
                titleMedium: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
                bodyMedium: const TextStyle(fontSize: 16),
                labelLarge: const TextStyle(fontSize: 16),
              ),
            ),
            child: child!,
          ),
        );
      },
    );

    if (picked != null) {
      widget.controller.text = picked.formatFullDate();

      final gregorian = picked.toDateTime();
      gregorianDate = DateFormat('yyyy-MM-dd').format(gregorian);

      if (widget.onDateSelected != null) {
        widget.onDateSelected!(gregorianDate!);
      }
      if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Column(
        textDirection: ui.TextDirection.rtl,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${widget.labelText} : ', style: Theme.of(context).textTheme.bodySmall,),
          SizedBox(height: 10),
          InkWell(
            onTap: () => _selectDate(context),
            child: IgnorePointer(
              child: SizedBox(
                width: widget.width,
                height: 38,
                child: TextFormField(
                  textDirection: ui.TextDirection.rtl,
                  controller: widget.controller,
                  style: Theme.of(context).textTheme.bodySmall,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.calendar_month_outlined),
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 12,
                    ),
                    hintText: 'انتخاب کنید',
                    hintStyle: Theme.of(context).textTheme.bodySmall
                        ?.copyWith(color: Colors.grey),
                    border: InputBorder.none,
                    fillColor: Colors.grey[100],
                    filled: true,
                  ),
                  keyboardType: widget.keyboardType,
                  enabled: widget.enabled,
                  textInputAction: TextInputAction.next,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
