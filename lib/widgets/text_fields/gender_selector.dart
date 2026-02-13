import 'package:flutter/material.dart';

class GenderSelector extends StatefulWidget {
  final Function(String) onChanged;

  const GenderSelector({super.key, required this.onChanged});

  @override
  State<GenderSelector> createState() => _GenderSelectorState();
}

class _GenderSelectorState extends State<GenderSelector> {
  String _selectedGender = "male";

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ToggleButtons(
        borderRadius: BorderRadius.circular(12),
        selectedColor: Colors.white,
        fillColor: Colors.blueAccent,
        borderColor: Colors.grey.shade400,
        selectedBorderColor: Colors.blueAccent,
        splashColor: Colors.blue.withOpacity(0.2),
        isSelected: [_selectedGender == "male", _selectedGender == "female"],
        onPressed: (index) {
          setState(() {
            _selectedGender = index == 0 ? "male" : "female";
          });
          widget.onChanged(_selectedGender);
        },
        children: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Text(
              "مذکر",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Text(
              "مونث",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
