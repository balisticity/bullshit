import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import 'payment_screen.dart';

enum AddressScreenMode { fromAccount, fromCheckout }

class AddressScreen extends StatefulWidget {
  final AddressScreenMode mode;

  const AddressScreen({super.key, this.mode = AddressScreenMode.fromAccount});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final _numberCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();

  final List<String> _phCities = [
    'Manila',
    'Quezon City',
    'Caloocan',
    'Las Piñas',
    'Makati',
    'Malabon',
    'Mandaluyong',
    'Marikina',
    'Muntinlupa',
    'Navotas',
    'Parañaque',
    'Pasay',
    'Pasig',
    'Pateros',
    'San Juan',
    'Taguig',
    'Valenzuela',
    'Cebu City',
    'Mandaue',
    'Lapu-Lapu',
    'Davao City',
    'Cagayan de Oro',
    'Zamboanga City',
    'Iloilo City',
    'Bacolod',
    'General Santos',
    'Antipolo',
    'Baguio',
    'Tarlac City',
    'San Fernando',
    'Angeles City',
    'Olongapo',
    'Batangas City',
    'Lipa',
    'Lucena',
    'Cabanatuan',
    'San Jose del Monte',
    'Biñan',
    'Santa Rosa',
    'Bacoor',
    'Imus',
    'Dasmarinas',
    'Tagaytay',
    'Naga',
    'Legazpi',
    'Puerto Princesa',
    'Butuan',
    'Iligan',
    'Cotabato City',
    'Tacloban',
    'Ormoc',
  ];

  String? _selectedCity;

  @override
  void initState() {
    super.initState();
    final provider = context.read<AppProvider>();
    _numberCtrl.text = provider.phone;
    _addressCtrl.text = provider.address;
    final saved = provider.city;
    if (_phCities.contains(saved)) _selectedCity = saved;
  }

  @override
  void dispose() {
    _numberCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    final number = _numberCtrl.text.trim();
    final address = _addressCtrl.text.trim();
    final city = _selectedCity ?? '';

    if (number.isEmpty) {
      _snack('Please enter your number.');
      return;
    }
    if (address.isEmpty) {
      _snack('Please enter your address.');
      return;
    }
    if (city.isEmpty) {
      _snack('Please select your city.');
      return;
    }

    final provider = context.read<AppProvider>();
    provider.setPhone(number);
    provider.setAddress(address);
    provider.setCity(city);
    provider.setLocation('$address, $city');

    if (widget.mode == AddressScreenMode.fromCheckout) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const PaymentScreen()),
      );
    } else {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Address saved!',
            style: GoogleFonts.dmSans(color: Colors.white),
          ),
          backgroundColor: Colors.black,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: GoogleFonts.dmSans(color: Colors.white)),
        backgroundColor: Colors.black87,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.black, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Add your address',
          style: GoogleFonts.dmSans(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),

              _label('Number'),
              const SizedBox(height: 8),
              _field(
                controller: _numberCtrl,
                hint: 'Enter your number',
                keyboardType: TextInputType.phone,
              ),

              const SizedBox(height: 20),

              _label('Address'),
              const SizedBox(height: 8),
              _field(controller: _addressCtrl, hint: 'Enter your address'),

              const SizedBox(height: 20),

              _label('City'),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFD0D0D0)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedCity,
                    hint: Text(
                      'Enter your City',
                      style: GoogleFonts.dmSans(
                        fontSize: 15,
                        color: Colors.black38,
                      ),
                    ),
                    isExpanded: true,
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.black45,
                    ),
                    style: GoogleFonts.dmSans(
                      fontSize: 15,
                      color: Colors.black87,
                    ),
                    items: _phCities
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (val) => setState(() => _selectedCity = val),
                  ),
                ),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Submit',
                    style: GoogleFonts.dmSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Text(
    text,
    style: GoogleFonts.dmSans(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
  );

  Widget _field({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) => TextField(
    controller: controller,
    keyboardType: keyboardType,
    style: GoogleFonts.dmSans(fontSize: 15, color: Colors.black87),
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.dmSans(fontSize: 15, color: Colors.black38),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFD0D0D0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.black, width: 1.5),
      ),
    ),
  );
}
