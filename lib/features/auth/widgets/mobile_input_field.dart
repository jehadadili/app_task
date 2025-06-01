import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MobileInputField extends StatelessWidget {
  final String? initialValue;
  final String? hintText;
  final String? labelText;
  final Function(String) onChanged;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final bool enabled;
  final TextInputAction? textInputAction;
  final Function(String)? onFieldSubmitted;
  final FocusNode? focusNode;

  const MobileInputField({
    super.key,
    this.initialValue,
    this.hintText,
    this.labelText,
    required this.onChanged,
    this.validator,
    this.controller,
    this.enabled = true,
    this.textInputAction,
    this.onFieldSubmitted,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      initialValue: controller == null ? initialValue : null,
      focusNode: focusNode,
      enabled: enabled,
      keyboardType: TextInputType.phone,
      textInputAction: textInputAction ?? TextInputAction.next,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(9), // 9 أرقام بعد +962
        _PhoneNumberFormatter(),
      ],
      decoration: InputDecoration(
        labelText: labelText ?? 'Mobile Number',
        hintText: hintText ?? "",
        prefixIcon: const Icon(Icons.phone),
        prefixText: '+962 ',
        prefixStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
        filled: true,
        fillColor: Color(0xFFC6C6C6),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Color(0xff152e67), width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.red, width: 2.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.red, width: 2.0),
        ),
      ),
      validator: (value) {
        if (validator != null) {
          // إرسال الرقم المنظف للـ validator (بدون +962 أو مسافات)
          String cleanValue = value?.replaceAll(' ', '') ?? '';
          return validator!(cleanValue);
        }
        return null;
      },
      onChanged: (value) {
        // إرسال الرقم المنظف (بدون مسافات)
        String cleanNumber = value.replaceAll(' ', '');
        onChanged(cleanNumber);
      },
      onFieldSubmitted: onFieldSubmitted != null
          ? (value) => onFieldSubmitted!(value.replaceAll(' ', ''))
          : null,
    );
  }
}

// Formatter محدث لتنسيق رقم الهاتف أثناء الكتابة
class _PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String newText = newValue.text;

    // إزالة أي مسافات موجودة
    newText = newText.replaceAll(' ', '');

    // التأكد من أن الطول لا يتجاوز 9 أرقام
    if (newText.length > 9) {
      newText = newText.substring(0, 9);
    }

    // تطبيق التنسيق: 7 9011 9723
    if (newText.isNotEmpty) {
      String formattedText = '';

      // إضافة الرقم الأول (7)
      if (newText.length >= 1) {
        formattedText += newText.substring(0, 1);
      }

      // إضافة مسافة والأرقام التالية (9011)
      if (newText.length >= 2) {
        int endIndex = newText.length >= 5 ? 5 : newText.length;
        formattedText += ' ' + newText.substring(1, endIndex);
      }

      // إضافة مسافة والأرقام الأخيرة (9723)
      if (newText.length >= 6) {
        formattedText += ' ' + newText.substring(5);
      }

      return TextEditingValue(
        text: formattedText,
        selection: TextSelection.collapsed(offset: formattedText.length),
      );
    }

    return newValue;
  }
}
