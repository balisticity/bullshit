import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

// ─────────────────────────────────────────────────────────────
// PAYMENT METHOD PAGE
// ─────────────────────────────────────────────────────────────

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? _selectedPayment;

  void _onCashOnDelivery() {
    setState(() => _selectedPayment = 'cod');
    _snack('Cash on Delivery selected');
  }

  void _onEWallets(double total) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _EWalletBottomSheet(
        onGCash: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => GCashPaymentPage(
                amount: total,
                onSuccess: () {
                  context.read<AppProvider>().placeOrder();
                  setState(() => _selectedPayment = 'ewallets');
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PaymentSuccessPage(
                        method: 'GCash',
                        amount: '₱${total.toStringAsFixed(2)}',
                      ),
                    ),
                    (route) => route.isFirst,
                  );
                },
              ),
            ),
          );
        },
        onMaya: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MayaPaymentPage(
                amount: total,
                onSuccess: () {
                  context.read<AppProvider>().placeOrder();
                  setState(() => _selectedPayment = 'ewallets');
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PaymentSuccessPage(
                        method: 'Maya',
                        amount: '₱${total.toStringAsFixed(2)}',
                      ),
                    ),
                    (route) => route.isFirst,
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  void _onCard(double total) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CardPaymentPage(
          amount: total,
          onSuccess: () {
            context.read<AppProvider>().placeOrder();
            setState(() => _selectedPayment = 'card');
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => PaymentSuccessPage(
                  method: 'Card',
                  amount: '₱${total.toStringAsFixed(2)}',
                ),
              ),
              (route) => route.isFirst,
            );
          },
        ),
      ),
    );
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: GoogleFonts.dmSans(color: Colors.white)),
        backgroundColor: Colors.black,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _onPlaceOrder(double total) {
    if (_selectedPayment == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please select a payment method',
            style: GoogleFonts.dmSans(color: Colors.white),
          ),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      return;
    }
    if (_selectedPayment == 'cod') {
      context.read<AppProvider>().placeOrder();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => PaymentSuccessPage(
            method: 'Cash on Delivery',
            amount: '₱${total.toStringAsFixed(2)}',
          ),
        ),
        (route) => route.isFirst,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final total = provider.cartTotal;
    final location = provider.location.isNotEmpty
        ? provider.location
        : 'No address set';
    final formattedTotal =
        '₱ ${total.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]},')}';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.black, size: 28),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Text(
          'Payment Method',
          style: GoogleFonts.dmSans(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 17,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // ── Delivery address bar ─────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 20,
                  color: Colors.black54,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    location,
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      color: provider.location.isNotEmpty
                          ? Colors.black87
                          : Colors.black45,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE0E0E0)),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),

                  // ── Order summary ──────────────────────────────────────
                  Text(
                    'Order summary',
                    style: GoogleFonts.dmSans(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  _SummaryRow(label: 'Product subtotal', value: formattedTotal),
                  const SizedBox(height: 10),
                  _SummaryRow(label: 'Product discount', value: '₱ 0'),
                  const SizedBox(height: 10),
                  _SummaryRow(label: 'Shipping fee', value: '₱ 0'),
                  const SizedBox(height: 16),
                  const Divider(color: Color(0xFFE0E0E0)),
                  const SizedBox(height: 12),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total',
                        style: GoogleFonts.dmSans(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        formattedTotal,
                        style: GoogleFonts.dmSans(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // ── Payment buttons ────────────────────────────────────
                  _PaymentButton(
                    label: 'Cash on Delivery',
                    isSelected: _selectedPayment == 'cod',
                    isFilled: true,
                    onTap: _onCashOnDelivery,
                  ),
                  const SizedBox(height: 12),
                  _PaymentButton(
                    label: 'E-Wallets',
                    isSelected: _selectedPayment == 'ewallets',
                    isFilled: false,
                    onTap: () => _onEWallets(total),
                  ),
                  const SizedBox(height: 12),
                  _PaymentButton(
                    label: 'Card',
                    isSelected: _selectedPayment == 'card',
                    isFilled: false,
                    onTap: () => _onCard(total),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),

          // ── Bottom bar ───────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFE0E0E0))),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Total: $formattedTotal',
                      style: GoogleFonts.dmSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => _onPlaceOrder(total),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Place Order',
                      style: GoogleFonts.dmSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// GCASH PAYMENT PAGE
// ─────────────────────────────────────────────────────────────

class GCashPaymentPage extends StatefulWidget {
  final double amount;
  final VoidCallback onSuccess;
  const GCashPaymentPage({
    super.key,
    required this.amount,
    required this.onSuccess,
  });

  @override
  State<GCashPaymentPage> createState() => _GCashPaymentPageState();
}

class _GCashPaymentPageState extends State<GCashPaymentPage> {
  final _mobileController = TextEditingController(text: '09');
  final _pinControllers = List.generate(6, (_) => TextEditingController());
  final _pinFocusNodes = List.generate(6, (_) => FocusNode());
  bool _isLoading = false;
  bool _showPin = false;
  String _errorMsg = '';

  static const Color gcashBlue = Color(0xFF007DFF);

  void _onNext() {
    if (_mobileController.text.length < 11) {
      setState(() => _errorMsg = 'Enter a valid 11-digit mobile number');
      return;
    }
    setState(() {
      _errorMsg = '';
      _showPin = true;
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      _pinFocusNodes[0].requestFocus();
    });
  }

  void _onPay() {
    final pin = _pinControllers.map((c) => c.text).join();
    if (pin.length < 6) {
      setState(() => _errorMsg = 'Enter your 6-digit MPIN');
      return;
    }
    setState(() {
      _isLoading = true;
      _errorMsg = '';
    });
    Future.delayed(const Duration(seconds: 2), () {
      setState(() => _isLoading = false);
      widget.onSuccess();
    });
  }

  @override
  void dispose() {
    _mobileController.dispose();
    for (final c in _pinControllers) {
      c.dispose();
    }
    for (final f in _pinFocusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: gcashBlue,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Container(
                        width: 34,
                        height: 34,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text(
                            'G',
                            style: TextStyle(
                              color: gcashBlue,
                              fontWeight: FontWeight.w900,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'GCash',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Amount to Pay',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '₱${widget.amount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Gravity Store',
                      style: TextStyle(color: Colors.white60, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!_showPin) ...[
                        const Text(
                          'Mobile Number',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _mobileController,
                          keyboardType: TextInputType.phone,
                          maxLength: 11,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: InputDecoration(
                            counterText: '',
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: gcashBlue.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  '🇵🇭 +63',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: gcashBlue,
                                  ),
                                ),
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFFE0E0E0),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFFE0E0E0),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: gcashBlue,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Enter your registered GCash number',
                          style: TextStyle(fontSize: 12, color: Colors.black38),
                        ),
                      ] else ...[
                        GestureDetector(
                          onTap: () => setState(() {
                            _showPin = false;
                            _errorMsg = '';
                          }),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.arrow_back_ios,
                                size: 16,
                                color: gcashBlue,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _mobileController.text,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Enter MPIN',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(
                            6,
                            (i) => SizedBox(
                              width: 44,
                              height: 52,
                              child: TextField(
                                controller: _pinControllers[i],
                                focusNode: _pinFocusNodes[i],
                                obscureText: true,
                                keyboardType: TextInputType.number,
                                maxLength: 1,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                                decoration: InputDecoration(
                                  counterText: '',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: Color(0xFFE0E0E0),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: Color(0xFFE0E0E0),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: gcashBlue,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                onChanged: (val) {
                                  if (val.isNotEmpty && i < 5) {
                                    _pinFocusNodes[i + 1].requestFocus();
                                  }
                                  if (val.isEmpty && i > 0) {
                                    _pinFocusNodes[i - 1].requestFocus();
                                  }
                                  setState(() {});
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '6-digit Mobile PIN',
                          style: TextStyle(fontSize: 12, color: Colors.black38),
                        ),
                      ],
                      if (_errorMsg.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Text(
                          _errorMsg,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 13,
                          ),
                        ),
                      ],
                      const SizedBox(height: 28),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _isLoading
                              ? null
                              : (_showPin ? _onPay : _onNext),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: gcashBlue,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: gcashBlue.withValues(
                              alpha: 0.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : Text(
                                  _showPin
                                      ? 'Pay ₱${widget.amount.toStringAsFixed(2)}'
                                      : 'Next',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.lock_outline,
                              size: 14,
                              color: Colors.black38,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Secured by GCash',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black38,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// MAYA PAYMENT PAGE
// ─────────────────────────────────────────────────────────────

class MayaPaymentPage extends StatefulWidget {
  final double amount;
  final VoidCallback onSuccess;
  const MayaPaymentPage({
    super.key,
    required this.amount,
    required this.onSuccess,
  });

  @override
  State<MayaPaymentPage> createState() => _MayaPaymentPageState();
}

class _MayaPaymentPageState extends State<MayaPaymentPage> {
  final _mobileController = TextEditingController(text: '09');
  final _otpControllers = List.generate(6, (_) => TextEditingController());
  final _otpFocusNodes = List.generate(6, (_) => FocusNode());
  bool _isLoading = false;
  bool _showOtp = false;
  String _errorMsg = '';
  int _countdown = 30;
  Timer? _timer;

  static const Color mayaGreen = Color(0xFF00C853);
  static const Color mayaDarkGreen = Color(0xFF007B33);
  static const Color mayaNavy = Color(0xFF1A1A2E);

  void _onSendOtp() {
    if (_mobileController.text.length < 11) {
      setState(() => _errorMsg = 'Enter a valid 11-digit mobile number');
      return;
    }
    setState(() {
      _errorMsg = '';
      _showOtp = true;
      _countdown = 30;
    });
    _startTimer();
    Future.delayed(const Duration(milliseconds: 100), () {
      _otpFocusNodes[0].requestFocus();
    });
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_countdown == 0) {
        t.cancel();
      } else {
        setState(() => _countdown--);
      }
    });
  }

  void _onPay() {
    final otp = _otpControllers.map((c) => c.text).join();
    if (otp.length < 6) {
      setState(() => _errorMsg = 'Enter the 6-digit OTP');
      return;
    }
    setState(() {
      _isLoading = true;
      _errorMsg = '';
    });
    Future.delayed(const Duration(seconds: 2), () {
      setState(() => _isLoading = false);
      widget.onSuccess();
    });
  }

  @override
  void dispose() {
    _mobileController.dispose();
    for (final c in _otpControllers) {
      c.dispose();
    }
    for (final f in _otpFocusNodes) {
      f.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mayaNavy,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [mayaGreen, Color(0xFF00E676)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Text(
                            'M',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Maya',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      mayaGreen.withValues(alpha: 0.3),
                      mayaDarkGreen.withValues(alpha: 0.2),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: mayaGreen.withValues(alpha: 0.4)),
                ),
                child: Column(
                  children: [
                    const Text(
                      'You are paying',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '₱${widget.amount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: mayaGreen,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'Gravity Store',
                          style: TextStyle(color: Colors.white60, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!_showOtp) ...[
                        const Text(
                          'Maya Account Number',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _mobileController,
                          keyboardType: TextInputType.phone,
                          maxLength: 11,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: InputDecoration(
                            counterText: '',
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: mayaGreen.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  '🇵🇭 +63',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: mayaDarkGreen,
                                  ),
                                ),
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFFE0E0E0),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFFE0E0E0),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: mayaGreen,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ] else ...[
                        GestureDetector(
                          onTap: () {
                            _timer?.cancel();
                            setState(() {
                              _showOtp = false;
                              _errorMsg = '';
                            });
                          },
                          child: Row(
                            children: [
                              const Icon(
                                Icons.arrow_back_ios,
                                size: 16,
                                color: mayaDarkGreen,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _mobileController.text,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'One-Time Password (OTP)',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'We sent a 6-digit code to your number',
                          style: TextStyle(fontSize: 12, color: Colors.black38),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(
                            6,
                            (i) => SizedBox(
                              width: 44,
                              height: 52,
                              child: TextField(
                                controller: _otpControllers[i],
                                focusNode: _otpFocusNodes[i],
                                keyboardType: TextInputType.number,
                                maxLength: 1,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: mayaNavy,
                                ),
                                decoration: InputDecoration(
                                  counterText: '',
                                  filled: true,
                                  fillColor: const Color(0xFFF5F5F5),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: mayaGreen,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                onChanged: (val) {
                                  if (val.isNotEmpty && i < 5) {
                                    _otpFocusNodes[i + 1].requestFocus();
                                  }
                                  if (val.isEmpty && i > 0) {
                                    _otpFocusNodes[i - 1].requestFocus();
                                  }
                                  setState(() {});
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            _countdown > 0
                                ? Text(
                                    'Resend OTP in ${_countdown}s',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black38,
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      for (final c in _otpControllers) {
                                        c.clear();
                                      }
                                      _startTimer();
                                    },
                                    child: const Text(
                                      'Resend OTP',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: mayaDarkGreen,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ],
                      if (_errorMsg.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Text(
                          _errorMsg,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 13,
                          ),
                        ),
                      ],
                      const SizedBox(height: 28),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _isLoading
                              ? null
                              : (_showOtp ? _onPay : _onSendOtp),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: mayaGreen,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: mayaGreen.withValues(
                              alpha: 0.4,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : Text(
                                  _showOtp
                                      ? 'Pay ₱${widget.amount.toStringAsFixed(2)}'
                                      : 'Send OTP',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.shield_outlined,
                              size: 14,
                              color: mayaDarkGreen,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Protected by Maya',
                              style: TextStyle(
                                fontSize: 12,
                                color: mayaDarkGreen,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// CARD PAYMENT PAGE
// ─────────────────────────────────────────────────────────────

class CardPaymentPage extends StatefulWidget {
  final double amount;
  final VoidCallback onSuccess;
  const CardPaymentPage({
    super.key,
    required this.amount,
    required this.onSuccess,
  });

  @override
  State<CardPaymentPage> createState() => _CardPaymentPageState();
}

class _CardPaymentPageState extends State<CardPaymentPage> {
  final _cardNumberController = TextEditingController();
  final _nameController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  String _selectedType = 'Visa';
  bool _isLoading = false;
  bool _flipCard = false;
  String _errorMsg = '';

  String get _maskedNumber {
    final raw = _cardNumberController.text.replaceAll(' ', '');
    if (raw.isEmpty) return '0000 0000 0000 0000';
    final padded = raw.padRight(16, '0');
    return [
      padded.substring(0, 4),
      padded.substring(4, 8),
      padded.substring(8, 12),
      padded.substring(12, 16),
    ].join(' ');
  }

  String get _displayName => _nameController.text.isEmpty
      ? 'YOUR NAME'
      : _nameController.text.toUpperCase();
  String get _displayExpiry =>
      _expiryController.text.isEmpty ? 'MM/YY' : _expiryController.text;

  Color get _cardColor {
    switch (_selectedType) {
      case 'Mastercard':
        return const Color(0xFFEB001B);
      case 'JCB':
        return const Color(0xFF003087);
      default:
        return const Color(0xFF1A1F71);
    }
  }

  void _formatCardNumber(String val) {
    final digits = val.replaceAll(RegExp(r'\D'), '');
    final buf = StringBuffer();
    for (int i = 0; i < digits.length && i < 16; i++) {
      if (i > 0 && i % 4 == 0) buf.write(' ');
      buf.write(digits[i]);
    }
    _cardNumberController.value = TextEditingValue(
      text: buf.toString(),
      selection: TextSelection.collapsed(offset: buf.length),
    );
    setState(() {});
  }

  void _formatExpiry(String val) {
    final digits = val.replaceAll(RegExp(r'\D'), '');
    String fmt = digits;
    if (digits.length >= 3) {
      fmt =
          '${digits.substring(0, 2)}/${digits.substring(2, digits.length.clamp(0, 4))}';
    } else if (digits.length == 2 && val.length == 2) {
      fmt = '$digits/';
    }
    _expiryController.value = TextEditingValue(
      text: fmt,
      selection: TextSelection.collapsed(offset: fmt.length),
    );
    setState(() {});
  }

  void _onPay() {
    if (_cardNumberController.text.replaceAll(' ', '').length < 16) {
      setState(() => _errorMsg = 'Enter a valid 16-digit card number');
      return;
    }
    if (_nameController.text.isEmpty) {
      setState(() => _errorMsg = 'Enter cardholder name');
      return;
    }
    if (_expiryController.text.length < 5) {
      setState(() => _errorMsg = 'Enter a valid expiry date');
      return;
    }
    if (_cvvController.text.length < 3) {
      setState(() => _errorMsg = 'Enter a valid CVV');
      return;
    }
    setState(() {
      _isLoading = true;
      _errorMsg = '';
    });
    Future.delayed(const Duration(seconds: 2), () {
      setState(() => _isLoading = false);
      widget.onSuccess();
    });
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _nameController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Card Payment',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w700,
            fontSize: 17,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => setState(() => _flipCard = !_flipCard),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: _flipCard ? _buildCardBack() : _buildCardFront(),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Tap card to flip',
              style: TextStyle(fontSize: 11, color: Colors.black38),
            ),
            const SizedBox(height: 16),
            Row(
              children: ['Visa', 'Mastercard', 'JCB'].map((type) {
                final sel = _selectedType == type;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedType = type),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: sel ? Colors.black : Colors.white,
                        border: Border.all(
                          color: sel ? Colors.black : const Color(0xFFDDDDDD),
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        type,
                        style: TextStyle(
                          color: sel ? Colors.white : Colors.black54,
                          fontWeight: sel ? FontWeight.w700 : FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildField(
                    label: 'Card Number',
                    controller: _cardNumberController,
                    hint: '0000 0000 0000 0000',
                    keyboard: TextInputType.number,
                    onChanged: _formatCardNumber,
                    icon: Icons.credit_card,
                  ),
                  const SizedBox(height: 16),
                  _buildField(
                    label: 'Cardholder Name',
                    controller: _nameController,
                    hint: 'Juan Dela Cruz',
                    onChanged: (_) => setState(() {}),
                    icon: Icons.person_outline,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildField(
                          label: 'Expiry',
                          controller: _expiryController,
                          hint: 'MM/YY',
                          keyboard: TextInputType.number,
                          onChanged: _formatExpiry,
                          icon: Icons.calendar_today_outlined,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildField(
                          label: 'CVV',
                          controller: _cvvController,
                          hint: '•••',
                          keyboard: TextInputType.number,
                          obscure: true,
                          maxLen: 3,
                          onChanged: (_) => setState(() => _flipCard = true),
                          icon: Icons.lock_outline,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (_errorMsg.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Text(
                    _errorMsg,
                    style: TextStyle(color: Colors.red.shade700, fontSize: 13),
                  ),
                ),
              ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Amount',
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  Text(
                    '₱${widget.amount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _onPay,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.black38,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : Text(
                        'Pay ₱${widget.amount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.lock_outline, size: 13, color: Colors.black38),
                SizedBox(width: 4),
                Text(
                  '256-bit SSL Encrypted',
                  style: TextStyle(fontSize: 12, color: Colors.black38),
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildCardFront() {
    return Container(
      key: const ValueKey('front'),
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_cardColor, _cardColor.withValues(alpha: 0.6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _cardColor.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _selectedType,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
              Container(
                width: 40,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.wifi, color: Colors.white, size: 18),
              ),
            ],
          ),
          const Spacer(),
          Text(
            _maskedNumber,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'CARDHOLDER',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 9,
                      letterSpacing: 1,
                    ),
                  ),
                  Text(
                    _displayName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'EXPIRES',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 9,
                      letterSpacing: 1,
                    ),
                  ),
                  Text(
                    _displayExpiry,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCardBack() {
    return Container(
      key: const ValueKey('back'),
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_cardColor.withValues(alpha: 0.8), _cardColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _cardColor.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 30),
          Container(height: 42, color: Colors.black),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 36,
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 60,
                  height: 36,
                  color: Colors.white,
                  alignment: Alignment.center,
                  child: Text(
                    _cvvController.text.isEmpty ? 'CVV' : _cvvController.text,
                    style: TextStyle(
                      color: _cardColor,
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required String hint,
    TextInputType keyboard = TextInputType.text,
    bool obscure = false,
    int? maxLen,
    required void Function(String) onChanged,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black54,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboard,
          obscureText: obscure,
          maxLength: maxLen,
          onChanged: onChanged,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            counterText: '',
            hintText: hint,
            hintStyle: const TextStyle(
              color: Colors.black26,
              fontWeight: FontWeight.normal,
            ),
            prefixIcon: Icon(icon, size: 18, color: Colors.black38),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            filled: true,
            fillColor: const Color(0xFFF8F8F8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.black, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// PAYMENT SUCCESS PAGE
// ─────────────────────────────────────────────────────────────

class PaymentSuccessPage extends StatefulWidget {
  final String method;
  final String amount;
  const PaymentSuccessPage({
    super.key,
    required this.method,
    required this.amount,
  });

  @override
  State<PaymentSuccessPage> createState() => _PaymentSuccessPageState();
}

class _PaymentSuccessPageState extends State<PaymentSuccessPage>
    with TickerProviderStateMixin {
  late AnimationController _circleController;
  late AnimationController _checkController;
  late AnimationController _fadeController;
  late Animation<double> _circleAnim;
  late Animation<double> _checkAnim;
  late Animation<double> _fadeAnim;

  final String _refNumber =
      'REF${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';

  Color get _methodColor {
    switch (widget.method) {
      case 'GCash':
        return const Color(0xFF007DFF);
      case 'Maya':
        return const Color(0xFF00C853);
      default:
        return Colors.black;
    }
  }

  @override
  void initState() {
    super.initState();
    _circleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _checkController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _circleAnim = CurvedAnimation(
      parent: _circleController,
      curve: Curves.elasticOut,
    );
    _checkAnim = CurvedAnimation(
      parent: _checkController,
      curve: Curves.easeOut,
    );
    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);

    _circleController.forward().then(
      (_) => _checkController.forward().then((_) => _fadeController.forward()),
    );
  }

  @override
  void dispose() {
    _circleController.dispose();
    _checkController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime dt) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final h = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    final min = dt.minute.toString().padLeft(2, '0');
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year} · $h:$min $ampm';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 60),
              ScaleTransition(
                scale: _circleAnim,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: _methodColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: ScaleTransition(
                      scale: _checkAnim,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: _methodColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 44,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              FadeTransition(
                opacity: _fadeAnim,
                child: Column(
                  children: [
                    const Text(
                      'Payment Successful!',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Your order has been placed',
                      style: TextStyle(fontSize: 15, color: Colors.black54),
                    ),
                    const SizedBox(height: 36),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFEEEEEE)),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                _ReceiptRow(
                                  label: 'Amount Paid',
                                  value: widget.amount,
                                  bold: true,
                                ),
                                const SizedBox(height: 12),
                                _ReceiptRow(
                                  label: 'Payment Method',
                                  value: widget.method,
                                ),
                                const SizedBox(height: 12),
                                _ReceiptRow(
                                  label: 'Reference No.',
                                  value: _refNumber,
                                ),
                                const SizedBox(height: 12),
                                _ReceiptRow(
                                  label: 'Date & Time',
                                  value: _formatDate(DateTime.now()),
                                ),
                                const SizedBox(height: 12),
                                _ReceiptRow(
                                  label: 'Status',
                                  value: 'Completed',
                                  statusColor: _methodColor,
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: List.generate(
                              30,
                              (i) => Expanded(
                                child: Container(
                                  height: 1,
                                  color: i % 2 == 0
                                      ? const Color(0xFFDDDDDD)
                                      : Colors.transparent,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(14),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.store_outlined,
                                  size: 14,
                                  color: Colors.black38,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  'Gravity Store',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black45,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const _DummyHome()),
                          (_) => false,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Back to Home',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: OutlinedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Receipt saved!'),
                              backgroundColor: Colors.black,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFDDDDDD)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Download Receipt',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Dummy home used only by PaymentSuccessPage "Back to Home" ─────────────────
// This routes back to the app's actual first route (MainShell)
class _DummyHome extends StatelessWidget {
  const _DummyHome();

  @override
  Widget build(BuildContext context) {
    // Pop all the way to the root (MainShell)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    });
    return const SizedBox.shrink();
  }
}

// ─────────────────────────────────────────────────────────────
// SHARED WIDGETS
// ─────────────────────────────────────────────────────────────

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.black54),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 14, color: Colors.black54),
        ),
      ],
    );
  }
}

class _PaymentButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool isFilled;
  final VoidCallback onTap;
  const _PaymentButton({
    required this.label,
    required this.isSelected,
    required this.isFilled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final filled = isFilled || isSelected;
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: filled ? Colors.black : Colors.white,
          foregroundColor: filled ? Colors.white : Colors.black,
          side: BorderSide(
            color: isSelected ? Colors.black : const Color(0xFFCCCCCC),
            width: isSelected ? 2 : 1,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: filled ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}

class _EWalletBottomSheet extends StatelessWidget {
  final VoidCallback onGCash;
  final VoidCallback onMaya;
  const _EWalletBottomSheet({required this.onGCash, required this.onMaya});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 36),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select E-Wallet',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          _WalletTile(
            name: 'GCash',
            subtitle: 'Pay via GCash wallet',
            color: const Color(0xFF007DFF),
            icon: Icons.account_balance_wallet_rounded,
            onTap: onGCash,
          ),
          const SizedBox(height: 12),
          _WalletTile(
            name: 'Maya',
            subtitle: 'Pay via Maya wallet',
            color: const Color(0xFF00C853),
            icon: Icons.payment_rounded,
            onTap: onMaya,
          ),
        ],
      ),
    );
  }
}

class _WalletTile extends StatelessWidget {
  final String name;
  final String subtitle;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;
  const _WalletTile({
    required this.name,
    required this.subtitle,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFEEEEEE)),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: Colors.black45),
                ),
              ],
            ),
            const Spacer(),
            const Icon(Icons.chevron_right, color: Colors.black26),
          ],
        ),
      ),
    );
  }
}

class _ReceiptRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  final Color? statusColor;

  const _ReceiptRow({
    required this.label,
    required this.value,
    this.bold = false,
    this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: Colors.black45),
        ),
        statusColor != null
            ? Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: statusColor!.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 12,
                    color: statusColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              )
            : Text(
                value,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
      ],
    );
  }
}
