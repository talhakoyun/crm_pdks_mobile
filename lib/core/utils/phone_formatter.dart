import 'package:flutter/services.dart';

class PhoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (newText.isEmpty) {
      return const TextEditingValue();
    }

    // 11 haneden fazla giriş engelle
    if (newText.length > 11) {
      newText = newText.substring(0, 11);
    }

    String formattedText = '';
    int selectionIndex = newValue.selection.end;

    if (newText.length >= 1) {
      formattedText += '0';
      if (newText.length > 1) {
        formattedText += '(';
        String areaCode = newText.substring(1, newText.length > 4 ? 4 : newText.length);
        formattedText += areaCode;
        
        if (newText.length >= 4) {
          formattedText += ')';
          String firstPart = newText.substring(4, newText.length > 7 ? 7 : newText.length);
          formattedText += firstPart;
          
          if (newText.length >= 7) {
            formattedText += ' ';
            String secondPart = newText.substring(7, newText.length > 9 ? 9 : newText.length);
            formattedText += secondPart;
            
            if (newText.length >= 9) {
              formattedText += ' ';
              String thirdPart = newText.substring(9, newText.length > 11 ? 11 : newText.length);
              formattedText += thirdPart;
            }
          }
        }
      }
    }

    // Cursor pozisyonunu ayarla
    int newSelectionIndex = formattedText.length;
    if (selectionIndex < newValue.text.length) {
      // Kullanıcı ortadan silme yaptıysa
      int digitsBeforeCursor = newValue.text.substring(0, selectionIndex).replaceAll(RegExp(r'[^0-9]'), '').length;
      int currentDigits = 0;
      newSelectionIndex = 0;
      
      for (int i = 0; i < formattedText.length; i++) {
        if (RegExp(r'[0-9]').hasMatch(formattedText[i])) {
          currentDigits++;
          if (currentDigits > digitsBeforeCursor) {
            break;
          }
        }
        newSelectionIndex = i + 1;
      }
    }

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: newSelectionIndex),
    );
  }
}