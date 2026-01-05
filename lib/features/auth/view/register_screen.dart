
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/register_state.dart';
import '../viewmodel/register_notifier.dart';

class RegisterScreen extends ConsumerWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 🔔 Listen for submit completion: when loading -> data, navigate to documents
    ref.listen<AsyncValue<RegisterState>>(registerProvider, (prev, next) {
      final wasLoading = prev?.isLoading == true;
      final finishedLoading = next.isLoading == false;
      if (wasLoading && finishedLoading && next.hasValue) {
        // Optional: also check validity
        final s = next.value!;
        if (s.isValid && context.mounted) {
          Navigator.pushReplacementNamed(context, '/doc-type');
        }
      }
    });

    final asyncState = ref.watch(registerProvider);
    final notifier = ref.read(registerProvider.notifier);
    final state = asyncState.value ?? const RegisterState();

    // Get location data from your state helpers
    final states = state.getAvailableStates();
    final suggestionCities = state.getAvailableCities();

    // Pre-cache logo for smoother paint
    WidgetsBinding.instance.addPostFrameCallback((_) {
      precacheImage(const AssetImage('assets/images/logo.png'), context);
    });

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D12),
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/register.png',
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              errorBuilder: (context, error, stack) {
                return Container(color: const Color(0xFF0D0D12));
              },
            ),
          ),
          // Dark Overlay
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.75)),
          ),
          // Content
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 375),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Logo
                      SizedBox(
                        height: 28,
                        child: Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stack) {
                            return const Icon(Icons.church, color: Colors.amber, size: 28);
                          },
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Title
                      const Text(
                        'Create Your Account',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Our Faith Connects',
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),

                      const SizedBox(height: 24),

                      // Name Field
                      _field(
                        label: 'Name',
                        hint: 'Enter your name',
                        onChanged: notifier.updateName,
                        keyboardType: TextInputType.name,
                      ),

                      // Email Field
                      _field(
                        label: 'Email Address',
                        hint: 'Enter your email',
                        onChanged: notifier.updateEmail,
                        keyboardType: TextInputType.emailAddress,
                        autofillHints: const [AutofillHints.email],
                      ),

                      // Phone Field
                      _field(
                        label: 'Phone Number',
                        hint: 'Enter your phone number',
                        onChanged: notifier.updatePhone,
                        keyboardType: TextInputType.phone,
                        autofillHints: const [AutofillHints.telephoneNumber],
                      ),

                      // Gender Selection
                      const SizedBox(height: 12),
                      _label('Choose Your Gender'),
                      const SizedBox(height: 8),
                      Row(
                        children: ['Male', 'Female', 'Third Gender'].map((g) {
                          return Expanded(
                            child: RadioListTile<String>(
                              value: g,
                              groupValue: state.gender,
                              activeColor: const Color(0xFFFFC107),
                              contentPadding: EdgeInsets.zero,
                              visualDensity: VisualDensity.compact,
                              title: Text(
                                g,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                              onChanged: (v) {
                                if (v != null) notifier.updateGender(v);
                              },
                            ),
                          );
                        }).toList(),
                      ),

                      // Date of Birth
                      const SizedBox(height: 16),
                      _label('Date of Birth'),
                      const SizedBox(height: 6),
                      _pickerTile(
                        value: state.dob == null
                            ? 'Select Date of Birth'
                            : '${state.dob!.day}/${state.dob!.month}/${state.dob!.year}',
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime(2000),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: const ColorScheme.dark(
                                    primary: Color(0xFFFFC107),
                                    surface: Color(0xFF1B1B24),
                                    onSurface: Colors.white,
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (date != null) notifier.updateDob(date);
                        },
                      ),

                      // Country Dropdown
                      const SizedBox(height: 16),
                      _label('Select Country'),
                      const SizedBox(height: 6),
                      _dropdown<String>(
                        value: state.country.isEmpty ? null : state.country,
                        items: LocationData.countries,
                        hint: 'Select Country',
                        onChanged: (v) {
                          if (v != null) notifier.updateCountry(v);
                        },
                      ),

                      // State and City Row
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          // State Dropdown
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _label('Select State'),
                                const SizedBox(height: 6),
                                _dropdown<String>(
                                  value: state.state.isEmpty ? null : state.state,
                                  items: states,
                                  hint: 'State',
                                  onChanged: states.isEmpty
                                      ? null
                                      : (v) {
                                    if (v != null) notifier.updateState(v);
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),

                          // City Autocomplete
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _label('Select City'),
                                const SizedBox(height: 6),
                                _cityAutocomplete(
                                  context: context,
                                  currentCity: state.city,
                                  suggestions: suggestionCities,
                                  enabled: states.isNotEmpty && state.state.isNotEmpty,
                                  onChanged: notifier.updateCity,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // Submit Button
                      const SizedBox(height: 24),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        curve: Curves.easeOut,
                        width: double.infinity,
                        height: 52,
                        decoration: BoxDecoration(
                          color: state.isValid
                              ? const Color(0xFFFFC107)
                              : const Color(0xFF616161),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.black,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 0,
                          ),
                          onPressed: state.isValid
                              ? () async {
                            await notifier.submit();
                            // Navigation happens in ref.listen above
                          }
                              : null,
                          child: asyncState.isLoading
                              ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.black,
                            ),
                          )
                              : const Text(
                            'Verify Your Identity',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      // Login Link
                      const SizedBox(height: 18),
                      Center(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            'Already have an account? Login',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ========== HELPER WIDGETS ==========

  static Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white70,
        fontSize: 14,
      ),
    );
  }

  static Widget _field({
    required String label,
    required String hint,
    required Function(String) onChanged,
    TextInputType? keyboardType,
    List<String>? autofillHints,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label(label),
          const SizedBox(height: 6),
          TextField(
            onChanged: onChanged,
            keyboardType: keyboardType,
            textCapitalization: TextCapitalization.words,
            style: const TextStyle(color: Colors.white),
            cursorColor: const Color(0xFFFFC107),
            scrollPadding: const EdgeInsets.only(bottom: 80),
            autofillHints: autofillHints,
            decoration: _inputDecoration(hint),
          ),
        ],
      ),
    );
  }

  static Widget _pickerTile({
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF3A3A3A)),
        ),
        alignment: Alignment.centerLeft,
        child: Text(
          value,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  static Widget _dropdown<T>({
    required T? value,
    required List<T> items,
    required String hint,
    required ValueChanged<T?>? onChanged,
  }) {
    return DropdownButtonFormField<T>(
      dropdownColor: const Color(0xFF121219),
      value: value,
      isDense: true,
      hint: Text(
        hint,
        style: const TextStyle(color: Colors.white54, fontSize: 13),
      ),
      items: items.isEmpty
          ? null
          : items
          .map(
            (e) => DropdownMenuItem<T>(
          value: e,
          child: Text(
            '$e',
            style: const TextStyle(color: Colors.white, fontSize: 13),
          ),
        ),
      )
          .toList(),
      onChanged: items.isEmpty ? null : onChanged,
      iconEnabledColor: Colors.white70,
      iconDisabledColor: Colors.white30,
      style: const TextStyle(color: Colors.white),
      decoration: _inputDecoration(),
    );
  }

  static Widget _cityAutocomplete({
    required BuildContext context,
    required String currentCity,
    required List<String> suggestions,
    required bool enabled,
    required ValueChanged<String> onChanged,
  }) {
    return RawAutocomplete<String>(
      textEditingController: TextEditingController(text: currentCity),
      focusNode: FocusNode(),
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (!enabled) return const Iterable<String>.empty();
        final q = textEditingValue.text.trim().toLowerCase();
        if (q.isEmpty) return suggestions;
        return suggestions.where((c) => c.toLowerCase().contains(q)).toList();
      },
      onSelected: (String selection) => onChanged(selection),
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        if (controller.text != currentCity) {
          controller.value = TextEditingValue(
            text: currentCity,
            selection: TextSelection.collapsed(offset: currentCity.length),
          );
        }
        return TextField(
          controller: controller,
          focusNode: focusNode,
          enabled: enabled,
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.words,
          style: TextStyle(
            color: enabled ? Colors.white : Colors.white54,
          ),
          cursorColor: const Color(0xFFFFC107),
          onChanged: enabled ? onChanged : null,
          scrollPadding: const EdgeInsets.only(bottom: 80),
          decoration: _inputDecoration('Type your city'),
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        if (options.isEmpty) return const SizedBox.shrink();
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            color: const Color(0xFF121219),
            elevation: 4,
            borderRadius: BorderRadius.circular(12),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 180),
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 6),
                shrinkWrap: true,
                itemCount: options.length,
                separatorBuilder: (_, __) => const Divider(
                  height: 1,
                  color: Color(0xFF2A2A2A),
                ),
                itemBuilder: (context, index) {
                  final opt = options.elementAt(index);
                  return ListTile(
                    dense: true,
                    title: Text(
                      opt,
                      style: const TextStyle(color: Colors.white),
                    ),
                    onTap: () => onSelected(opt),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  static InputDecoration _inputDecoration([String? hint]) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white54),
      filled: true,
      fillColor: Colors.black54,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF3A3A3A)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Color(0xFFFFC107),
          width: 1.4,
        ),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF2A2A2A)),
      ),
    );
  }
}

