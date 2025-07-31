import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TripCustomizationPage extends StatefulWidget {
  final String placeName;

  const TripCustomizationPage({super.key, required this.placeName});

  @override
  State<TripCustomizationPage> createState() => _TripCustomizationPageState();
}

class _TripCustomizationPageState extends State<TripCustomizationPage> {
  final TextEditingController _budgetController = TextEditingController();
  DateTimeRange? _selectedDateRange;

  int _selectedDays = 3;
  String _selectedTravelMode = 'Train';

  final List<String> _travelModes = ['Train', 'Bus', 'Car', 'Flight'];
  final List<int> _durationOptions = [2, 3, 4, 5, 6, 7];

  bool _isSubmitting = false;

  Future<void> _submitCustomization() async {
    if (_budgetController.text.isEmpty || _selectedDateRange == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    final customizationData = {
      'place': widget.placeName,
      'budget': int.tryParse(_budgetController.text),
      'days': _selectedDays,
      'travel_mode': _selectedTravelMode,
      'start_date': _selectedDateRange!.start.toIso8601String(),
      'end_date': _selectedDateRange!.end.toIso8601String(),
    };

    print('Submitting: $customizationData');

    setState(() => _isSubmitting = true);

    // TODO: Call your backend API here using ApiService.customizeTripPlan(customizationData)

    await Future.delayed(const Duration(seconds: 1)); // simulate API

    setState(() => _isSubmitting = false);

    Navigator.pop(context); // or navigate to PlaceDetailsPage with updated data
  }

  Future<void> _pickDateRange() async {
    final now = DateTime.now();
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      initialDateRange: _selectedDateRange,
    );

    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Customize Trip to ${widget.placeName}"),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _budgetController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Budget (₹)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Duration dropdown
            DropdownButtonFormField<int>(
              value: _selectedDays,
              decoration: const InputDecoration(
                labelText: 'Duration (days)',
                border: OutlineInputBorder(),
              ),
              items: _durationOptions
                  .map(
                    (d) => DropdownMenuItem(value: d, child: Text('$d days')),
                  )
                  .toList(),
              onChanged: (value) => setState(() => _selectedDays = value!),
            ),
            const SizedBox(height: 20),

            // Travel mode dropdown
            DropdownButtonFormField<String>(
              value: _selectedTravelMode,
              decoration: const InputDecoration(
                labelText: 'Travel Mode',
                border: OutlineInputBorder(),
              ),
              items: _travelModes
                  .map(
                    (mode) => DropdownMenuItem(value: mode, child: Text(mode)),
                  )
                  .toList(),
              onChanged: (value) =>
                  setState(() => _selectedTravelMode = value!),
            ),
            const SizedBox(height: 20),

            // Date picker
            ListTile(
              title: const Text('Select Dates'),
              subtitle: Text(
                _selectedDateRange == null
                    ? 'No date selected'
                    : '${DateFormat.yMMMd().format(_selectedDateRange!.start)} - ${DateFormat.yMMMd().format(_selectedDateRange!.end)}',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: _pickDateRange,
            ),
            const SizedBox(height: 30),

            // Submit button
            ElevatedButton(
              onPressed: _isSubmitting ? null : _submitCustomization,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: _isSubmitting
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Generate Trip Plan'),
            ),
          ],
        ),
      ),
    );
  }
}
