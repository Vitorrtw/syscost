import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class DateTextField extends StatefulWidget {
  final void Function(DateTime?) onDateSelected;
  final String label;
  final String? initialDate;
  final bool dateState;

  const DateTextField(
      {required this.onDateSelected,
      required this.label,
      this.initialDate,
      required this.dateState,
      super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SelectDateState createState() => _SelectDateState();
}

class _SelectDateState extends State<DateTextField> {
  DateTime? _selectedDate;
  final maskFormatter = MaskTextInputFormatter(mask: '##/##/####');
  final TextEditingController _dateController = TextEditingController();

  void _fillInitialDate() {
    if (widget.initialDate != null) {
      final parsedDate = _parseDate(widget.initialDate!);
      if (parsedDate != null) {
        setState(() {
          _selectedDate = parsedDate;
          _dateController.text = widget.initialDate!;
        });
      }
    }
  }

  @override
  void initState() {
    _fillInitialDate();
    super.initState();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pecked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365 * 100)),
        locale: const Locale("pt", "BR"),
        keyboardType: TextInputType.datetime);

    if (pecked != null && pecked != _selectedDate) {
      setState(() {
        _selectedDate = pecked;
        _dateController.text = _formatDate(pecked);
        widget.onDateSelected(pecked);
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  DateTime? _parseDate(String input) {
    try {
      final parts = input.split('/');
      if (parts.length == 3) {
        final day = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final year = int.parse(parts[2]);
        return DateTime(year, month, day);
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error parsing date: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _dateController,
      keyboardType: TextInputType.number,
      inputFormatters: [maskFormatter],
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.calendar_month),
        labelText: widget.label,
        suffixIcon: IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: () => _selectDate(context),
        ),
      ),
      onChanged: (value) {
        final parsedDate = _parseDate(value);
        if (parsedDate != null) {
          setState(() {
            _selectedDate = parsedDate;
            widget.onDateSelected(parsedDate);
          });
        }
      },
    );
  }
}
