import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pow_note_ai/utils/app_spacing.dart';

class NumberTextField extends StatefulWidget {
  const NumberTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.maxValue = 100,
    this.minValue = 0,
    this.step = 1,
    this.width = 130,
    this.border,
    this.isInteger = false,
  });

  final TextEditingController controller;
  final String labelText;
  final double maxValue;
  final double minValue;
  final double step;
  final double width;
  final InputBorder? border;
  final bool isInteger;
  @override
  State<NumberTextField> createState() => _NumberTextFieldState();
}

class _NumberTextFieldState extends State<NumberTextField> {
  void increment(){
    double value = double.tryParse(widget.controller.text.trim()) ?? 0;

    if(value < widget.maxValue) {
      value += widget.step;
      widget.controller.text = (value).toString();
    }

    if(widget.isInteger) widget.controller.text = (value).toStringAsFixed(0);
  }
  void decrement(){
    double value = double.tryParse(widget.controller.text.trim()) ?? 0;
    if(value > widget.minValue){
      value-= widget.step;
      widget.controller.text = (value).toString();
    }
    if(widget.isInteger) widget.controller.text = (value).toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 80,
            child: TextFormField(
              style: TextStyle(
                fontSize: 30,
              ),
              textAlign: TextAlign.center,
              controller: widget.controller,
              decoration: InputDecoration(
                labelText: widget.labelText,
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white
              ),
              onChanged: (value){
                double currentValue = double.tryParse(value) ?? 0;
                if(currentValue > widget.maxValue){
                  widget.controller.text = widget.maxValue.toString();
                }
                if(currentValue < widget.minValue){
                  widget.controller.text = widget.minValue.toString();
                }
              },
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
              ],
            ),
          ),
          AppSpacing.height16,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () => increment(),
                icon: Icon(Icons.add_circle),
              ),
              IconButton(
                onPressed: () => decrement(),
                icon: Icon(Icons.remove_circle),
              ),
            ],
          )
        ],
      ),
    );
  }
}
