import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ✅ FIXED PATH (no space)
import '../ viewmodel/verification_notifier.dart';
import 'email_otp_screen.dart';

class CompleteProfileScreen extends ConsumerStatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  ConsumerState<CompleteProfileScreen> createState() =>
      _CompleteProfileScreenState();
}

class _CompleteProfileScreenState
    extends ConsumerState<CompleteProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(verificationProvider);
    final notifier = ref.read(verificationProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D12),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D12),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Complete Your Profile',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // PHOTO
                Center(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        width: 110,
                        height: 110,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF1A1A1F),
                        ),
                      ),
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFEDDF99),
                          border: Border.all(color: Colors.black, width: 1),
                        ),
                        child: const Icon(Icons.edit,
                            size: 18, color: Colors.black),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                _label('Name'),
                _darkField(
                  initialValue: state.name,
                  hint: 'Alexa Mate',
                  onChanged: notifier.updateName,
                  validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 12),

                _label('Email Address'),
                _darkField(
                  initialValue: state.email,
                  hint: 'alexa.mate@example.com',
                  keyboardType: TextInputType.emailAddress,
                  onChanged: notifier.updateEmail,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Required';
                    if (!state.isEmailValid) return 'Enter a valid email';
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                _label('Mobile Number'),
                _darkField(
                  initialValue: state.phone,
                  hint: '(808) 555-0111',
                  keyboardType: TextInputType.phone,
                  onChanged: notifier.updatePhone,
                  validator: (v) =>
                  v == null || v.trim().length < 5
                      ? 'Enter a valid number'
                      : null,
                ),
                const SizedBox(height: 12),

                _label('Date of Birth'),
                _darkField(
                  initialValue: state.dob,
                  hint: '2nd September, 1985',
                  readOnly: true,
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                      initialDate: DateTime(1990),
                      builder: (context, child) =>
                          Theme(data: ThemeData.dark(), child: child!),
                    );
                    if (picked != null) {
                      notifier.updateDob(_formatDob(picked));
                    }
                  },
                  validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 12),

                _label('Gender'),
                _darkDropdown(
                  value: state.gender.isEmpty ? null : state.gender,
                  items: const ['Male', 'Female', 'Other'],
                  onChanged: notifier.updateGender,
                  validator: (v) =>
                  v == null || v.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 12),

                _label('Address'),
                _darkField(
                  initialValue: state.address,
                  maxLines: 3,
                  hint: '1234 Sample, San Diego, California, USA',
                  onChanged: notifier.updateAddress,
                  validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Required' : null,
                ),

                const SizedBox(height: 24),

                /// 🔥 CONTINUE BUTTON (NO FIREBASE – MANUAL OTP)
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: state.isProfileComplete
                          ? const Color(0xFFEDDF99)
                          : Colors.grey.shade800,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: state.isProfileComplete
                        ? () async {
                      // ❌ Firebase disabled intentionally
                      // await notifier.sendCode();

                      // ✅ Always navigate to OTP screen
                      // ✅ Predefined OTP = 123456
                      if (!context.mounted) return;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const EmailOtpScreen(),
                        ),
                      );
                    }
                        : null,
                    child: const Text(
                      'Continue',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------- UI HELPERS (UNCHANGED) ----------

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(
      text,
      style: const TextStyle(
          color: Colors.white70, fontWeight: FontWeight.w600),
    ),
  );

  Widget _darkField({
    required String? initialValue,
    required String hint,
    ValueChanged<String>? onChanged,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    bool readOnly = false,
    int maxLines = 1,
    VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF131318),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: TextFormField(
        initialValue: initialValue ?? '',
        onChanged: onChanged,
        validator: validator,
        keyboardType: keyboardType,
        readOnly: readOnly,
        onTap: onTap,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white38),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _darkDropdown({
    required String? value,
    required List<String> items,
    required ValueChanged<String> onChanged,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF131318),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: DropdownButtonFormField<String>(
        value: value,
        validator: validator,
        dropdownColor: const Color(0xFF131318),
        iconEnabledColor: Colors.white70,
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(border: InputBorder.none),
        items: items
            .map((e) => DropdownMenuItem(
          value: e,
          child:
          Text(e, style: const TextStyle(color: Colors.white)),
        ))
            .toList(),
        onChanged: (v) {
          if (v != null) onChanged(v);
        },
      ),
    );
  }

  String _formatDob(DateTime dt) {
    const months = [
      'January','February','March','April','May','June',
      'July','August','September','October','November','December'
    ];
    final day = dt.day;
    final suffix =
    (day >= 11 && day <= 13) ? 'th' : {1: 'st', 2: 'nd', 3: 'rd'}[day % 10] ?? 'th';
    return '$day$suffix ${months[dt.month - 1]}, ${dt.year}';
  }
}
