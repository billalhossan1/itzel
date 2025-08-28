import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../constants/app_colors.dart';
import '../../../../widgets/space_widget/space_widget.dart';
import '../../../../widgets/text_widget/text_widgets.dart';

class DatePickerWidget extends StatefulWidget {
  final String label;
  final Function(DateTime) onDateSelected;
  final DateTime? initialDate;

  const DatePickerWidget({
    super.key,
    required this.label,
    required this.onDateSelected,
    this.initialDate,
  });

  @override
  State<DatePickerWidget> createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue, // header background color
              onPrimary: Colors.white, // header text color
              onSurface: Colors.black, // body text color
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      widget.onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidget(
          text: widget.label,
          fontColor: AppColors.grey900,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        const SpaceWidget(spaceHeight: 4),
        GestureDetector(
          onTap: () => _selectDate(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedDate != null
                      ? DateFormat('dd/MM/yyyy').format(selectedDate!)
                      : '',
                  style: TextStyle(
                    color: selectedDate != null ? Colors.black87 : Colors.grey,
                    fontSize: 16,
                  ),
                ),
                const Icon(
                  Icons.calendar_today_outlined,
                  color: Colors.grey,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
