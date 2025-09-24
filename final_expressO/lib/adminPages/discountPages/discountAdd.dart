import 'package:flutter/material.dart';
import 'package:firebase_nexus/appColors.dart';

class discountAdd extends StatefulWidget {
  const discountAdd({super.key});

  @override
  State<discountAdd> createState() => _discountAddState();
}

class _discountAddState extends State<discountAdd> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _discountValueController =
      TextEditingController();

  final TextEditingController _usageLimitController = TextEditingController();
  String _status = "Active"; // default
  String? _selectedDiscountType;

  DateTime? _startDate;
  DateTime? _endDate;

  // Availability
  bool _isAvailable = true;

  // --- date picker helper
  Future<void> _pickDate(BuildContext context, bool isStart) async {
    final now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  InputDecoration inputStyle(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        color: Colors.brown, // Label text color
        fontFamily: 'Quicksand', // Your global font
        fontWeight: FontWeight.w500, // optional
      ),
      hintText: 'Enter $label',
      hintStyle: const TextStyle(
        color: AppColors.input, // Placeholder color
        fontFamily: 'Quicksand', // Use Quicksand here too
      ),
      prefixIcon: Icon(icon, color: Colors.brown),
      filled: true,
      fillColor: const Color(0xFFFFFFFF),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.brown, width: 2),
      ),
    );
  }

  InputDecoration dropdownStyle(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        color: Colors.brown,
        fontFamily: 'Quicksand',
        fontWeight: FontWeight.w500,
      ),
      hintText: 'Select $label',
      hintStyle: const TextStyle(
        color: AppColors.input, // same placeholder color
        fontFamily: 'Quicksand',
      ),
      prefixIcon: Icon(icon, color: Colors.brown),
      filled: true,
      fillColor: const Color(0xFFFFFFFF),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.brown, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.secondary,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Add Discount",
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Discount Code
              const Text("Discount Code",
                  style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.w600,
                      color: AppColors.secondary)),
              const SizedBox(height: 4),
              TextFormField(
                controller: _codeController,
                decoration: inputStyle("", Icons.sell_outlined),
                validator: (val) =>
                    val == null || val.isEmpty ? "Enter discount code" : null,
              ),
              const SizedBox(height: 16),

              // Description
              const Text("Description",
                  style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.w600,
                      color: AppColors.secondary)),
              const SizedBox(height: 4),
              TextFormField(
                controller: _descController,
                maxLines: 4,
                decoration: inputStyle("", Icons.short_text_outlined),
                validator: (val) =>
                    val == null || val.isEmpty ? "Enter description" : null,
              ),
              const SizedBox(height: 16),

              // Discount Type Dropdown
              const Text("Discount Type",
                  style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.w600,
                      color: AppColors.secondary)),
              const SizedBox(height: 4),
              DropdownButtonFormField<String>(
                decoration: dropdownStyle("", Icons.local_offer),
                value: _selectedDiscountType,
                items: const [
                  DropdownMenuItem(
                    value: "percentage",
                    child: Text("Percentage (10% off)"),
                  ),
                  DropdownMenuItem(
                    value: "fixed",
                    child: Text("Fixed amount (\$50 off)"),
                  ),
                  DropdownMenuItem(
                    value: "codeName",
                    child: Text("Discount Code Name"),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedDiscountType = value;
                  });
                },
                validator: (value) =>
                    value == null ? "Please select a discount type" : null,
              ),
              const SizedBox(height: 16),

              // Discount Value
              const Text("Discount Value",
                  style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.w600,
                      color: AppColors.secondary)),
              const SizedBox(height: 4),
              TextFormField(
                controller: _discountValueController,
                keyboardType: TextInputType.number,
                decoration: inputStyle("", Icons.money_off_csred_outlined),
                validator: (val) =>
                    val == null || val.isEmpty ? "Enter discount value" : null,
              ),
              const SizedBox(height: 16),

              // Usage Limit
              const Text("Usage Limit (Per Customer)",
                  style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.w600,
                      color: AppColors.secondary)),
              const SizedBox(height: 4),
              TextFormField(
                controller: _usageLimitController,
                keyboardType: TextInputType.number,
                decoration: inputStyle("", Icons.person_pin_circle_outlined),
                validator: (val) =>
                    val == null || val.isEmpty ? "Enter usage limit" : null,
              ),
              const SizedBox(height: 16),

              // Validity Period
              const Text("Validity Period",
                  style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.w600,
                      color: AppColors.secondary)),
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _pickDate(context, true),
                      child: AbsorbPointer(
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: "Start Date",
                            suffixIcon: const Icon(Icons.calendar_today,
                                color: Colors.brown),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none, // no border
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none, // no border on focus
                            ),
                          ),
                          controller: TextEditingController(
                              text: _startDate == null
                                  ? ""
                                  : "${_startDate!.toLocal()}".split(' ')[0]),
                          validator: (val) => val == null || val.isEmpty
                              ? "Select start date"
                              : null,
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text("—"),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _pickDate(context, false),
                      child: AbsorbPointer(
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: "End Date",
                            suffixIcon: const Icon(Icons.calendar_today,
                                color: Colors.brown),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          controller: TextEditingController(
                              text: _endDate == null
                                  ? ""
                                  : "${_endDate!.toLocal()}".split(' ')[0]),
                          validator: (val) => val == null || val.isEmpty
                              ? "Select end date"
                              : null,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Availability Switch
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Available by Default",
                      style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.w600,
                        color: AppColors.secondary,
                      ),
                    ),
                    Switch(
                      value: _isAvailable,
                      onChanged: (val) {
                        setState(() {
                          _isAvailable = val;
                        });
                      },
                      activeColor: Colors.white, // thumb color when ON
                      activeTrackColor:
                          AppColors.primary, // track color when ON
                      inactiveThumbColor: Colors.white,
                      inactiveTrackColor: Colors.grey.shade300,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Submit Button
              Row(
                children: [
                  // Cancel Button
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.secondary,
                        backgroundColor: Colors.white, // <-- white background
                        side: const BorderSide(color: Color(0xFFC8A888)),
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(15), // 15px radius
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Cancel",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Finalize Button
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(15), // 15px radius
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Discount added!")),
                          );
                          Navigator.pop(context);
                        }
                      },
                      child: const Text(
                        "Finalize Discount",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
