import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:habido_app/utils/func.dart';

abstract class TextInputControlFormatter extends TextInputFormatter {
  final int precision;

  double numberRealValue(String text);

  String formatUpdate(dynamic value, {bool checkMinMax = false});

  TextInputControlFormatter({this.precision = 2});
}

class MoneyMaskTextInputFormatter extends TextInputControlFormatter {
  final int maxLength;
  final double initialValue;
  final String decimalSeparator;
  final String thousandSeparator;
  final String rightSymbol;
  final String leftSymbol;
  final double min;
  final double max;

  MoneyMaskTextInputFormatter(
      {this.maxLength = 14,
      this.initialValue = 0.0,
      this.decimalSeparator = '.',
      this.thousandSeparator = ',',
      this.rightSymbol = '',
      this.leftSymbol = '',
      int precision = 2,
      this.min = 0,
      this.max = 999999999999})
      : assert(maxLength == -1 || maxLength > 0),
        super(precision: precision) {
    _validateConfig();
//    _formatUpdate(
//        TextEditingValue(),
//        TextEditingValue(
//            text: initialValue?.toString() ?? "0",
//            selection: TextSelection(baseOffset: -1, extentOffset: -1)));
  }

  _validateConfig() {
    bool rightSymbolHasNumbers = _getOnlyNumbers(this.rightSymbol).length > 0;

    if (rightSymbolHasNumbers) {
      throw new ArgumentError("rightSymbol must not have numbers.");
    }
  }

  TextEditingValue lastResValue = TextEditingValue();
  TextEditingValue lastOldValue = TextEditingValue();
  TextEditingValue lastNewValue = TextEditingValue();

  @override
  String formatUpdate(dynamic value, {bool checkMinMax = false}) {
    /// Бутархай орныг format-ын дагуу харуулах
    /// Жишээ нь: Precision = 3 бол 1.5-ыг 1.500 болгоно
    var v;
    double db = 0.0;

    if (value == null || value.toString() == "") {
      value = db;
    }
    if (value is double) {
      /// Double
      v = value.toStringAsFixed(precision);
    } else if (value is String) {
      try {
        v = Func.toDouble(value).toStringAsFixed(precision);
      } catch (e) {
        print(e);
        v = value.toString();
      }
    } else {
      /// String
      v = value.toString();
    }

    String t = _formatUpdate(TextEditingValue(), TextEditingValue(text: v, selection: TextSelection(baseOffset: -1, extentOffset: -1)),
            checkMinMax: checkMinMax)
        .text;
    return t;
  }

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    print('++++++++++++++++++++++');
    print('');
    print('lastResValue >>> $lastResValue');
    print('oldValue     >>> $oldValue');
    print('');
    print('newValue     >>> $newValue');
    print('lastNewValue >>> $lastNewValue');
    print('');

    if (lastResValue == oldValue && newValue == lastNewValue) {
      return lastResValue;
    }

    lastOldValue = oldValue;
    lastNewValue = newValue;

    if (newValue.text == ",000") {
      return TextEditingValue(text: "0");
    }

    lastResValue = _formatUpdate(oldValue, newValue);
    return lastResValue;
  }

  TextEditingValue _formatUpdate(TextEditingValue oldValue, TextEditingValue newValue, {bool checkMinMax = false}) {
    final selectionBefore = oldValue.selection;

    final String textBefore = oldValue.text;
    String textAfter = newValue.text;

    double numberBefore = numberValue(textBefore);
    double numberAfter = numberValue(textAfter);

    print('step-1 numberBefore->$numberBefore numberAfter->$numberAfter');

    ///
    /// check min max
    ///
    if (checkMinMax) {
      if (min != null && min >= 0 && numberAfter < min) {
        print('step-5 tessssssst min');
        textAfter = _numberStrValue(min.toString());
        print('step-6 set min $textAfter');
      }

      if (max != null && max >= 0 && numberAfter > max) {
        print('step-7 tessssssst max');
        textAfter = _numberStrValue(max.toString());
        print('step-8 set max $textAfter');
      }
    }

    final startBefore = selectionBefore.start == -1 ? 0 : selectionBefore.start;
    final countBefore = selectionBefore.start == -1 || selectionBefore.end == -1 ? 0 : selectionBefore.end - selectionBefore.start;

    final after = textAfter.length - (textBefore.length - countBefore);
    final removed = after < 0 ? after.abs() : 0;

    final startAfter = startBefore + (after < 0 ? after : 0);
    final endAfter = startAfter + (after > 0 ? after : 0);

    final replaceStart = startBefore - removed;
    final replaceLength = countBefore + removed;

    print('step-10 [$textBefore][$textAfter]');
    print('step-11 [$startBefore][$countBefore]');
    print('step-12 [$after][$removed]');
    print('step-13 [$startAfter][$endAfter]');
    print('step-14 [$replaceStart][$replaceLength]');

    int cursorPos = endAfter;

    String masked = _applyMask(numberValue(textAfter));

    if (rightSymbol.length > 0) {
      masked += rightSymbol;
    }

    if (leftSymbol.length > 0) {
      masked = leftSymbol + masked;
    }

    if (numberBefore == numberAfter) {
      cursorPos = endAfter;
    } else {
      if (textAfter.length > masked.length) {
        cursorPos = endAfter - (textAfter.length - masked.length);
      } else {
        if (masked.length == 1) //textAfter.length == 1)
          cursorPos = endAfter;
        else
          cursorPos = endAfter + (masked.length - textAfter.length);
      }
    }

    int finalCursorPosition = cursorPos == -1
        ? masked.length
        : cursorPos > masked.length
            ? masked.length
            : cursorPos;

    print('step-15  finalCursorPosition->$finalCursorPosition cursorPos->$cursorPos masked.length->${masked.length}');

    if (maxLength != null && maxLength > 0 && masked.length > maxLength) {
      return lastResValue;
    }

    print('step-16 finalCursorPosition->$finalCursorPosition');

    return TextEditingValue(text: masked, selection: TextSelection(baseOffset: finalCursorPosition, extentOffset: finalCursorPosition));
  }

  /// min max utgiig ehleed zov formatruu oruulah ued ashiglav
  /// for example if precision = 2
  /// 1.0 -> 1.00
  /// 1.001 -> 1.00
  /// 1.00 -> 1.00
  String _numberStrValue(String text) {
    print('stringValueFormatted -> $text');
    text = (text == null || text.isEmpty) ? '0' : text;

    bool b = text.contains(decimalSeparator);

    if (b) {
      List<String> parts2 = text.split('.').toList();
      if (parts2[1].length == precision) {
        text = text;
      } else if (parts2[1].length < precision) {
        text = text.padRight(text.length + precision - parts2[1].length, '0');
      } else {
        text = text.substring(0, text.length - parts2[1].length - precision);
      }
    } else {
      text += decimalSeparator;
      text = text.padRight(text.length + precision, '0');
    }
    print('stringValueFormatted => $text');
    return text;
  }

  double numberValue(String text) {
    print('numberValue -> $text');
    text = (text == null || text.isEmpty) ? '0' : text;

    bool b = text.contains(decimalSeparator);
    if (b && precision == 0) {
      text = text.split(decimalSeparator)[0];
      text = text.isEmpty ? '0' : text;
    }

    List<String> parts = _getOnlyNumbers(text).split('').toList(growable: true);

    if (precision > 0) {
      if (parts.length - precision <= 0) {
        int len = (parts.length - precision).abs() + 1;
        for (var i = 0; i < len; i++) {
          parts.insert(i, '0');
        }
      }
      parts.insert(parts.length - precision, decimalSeparator);
    }

//    if (precision > 0) {
//      //if (b) {
//        parts.insert(parts.length - precision, decimalSeparator);
////      } else {
////        parts.insert(parts.length, decimalSeparator);
////      }
//    }

    print('numberValue --> ${parts.join()}');

    double d = double.parse(parts.join());

    print('numberValue => $d');
    return d;
  }

  double BACKUP_numberValue(String text) {
    print('numberValue -> $text');
    text = (text == null || text.isEmpty) ? '0' : text;

    bool b = text.contains(decimalSeparator);
    if (b && precision == 0) {
      text = text.split(decimalSeparator)[0];
      text = text.isEmpty ? '0' : text;
    }

    List<String> parts = _getOnlyNumbers(text).split('').toList(growable: true);

    if (precision > 0) {
      if (parts.length - precision > 0) {
        parts.insert(parts.length - precision, decimalSeparator);
      } else {
        parts.insert(parts.length, decimalSeparator);
      }
    }

//    if (precision > 0) {
//      //if (b) {
//        parts.insert(parts.length - precision, decimalSeparator);
////      } else {
////        parts.insert(parts.length, decimalSeparator);
////      }
//    }

    print('numberValue --> ${parts.join()}');

    double d = double.parse(parts.join());

    print('numberValue => $d');
    return d;
  }

  ///
  /// prefix surfix iig arilgaad zovhon double amount iig avah
  ///
  ///
  @override
  double numberRealValue(String text) {
//
//    print('numberRealValue -> $text');
//    text = (text == null || text.isEmpty) ? '0' : text;
//
//    text = text
//        .replaceAll(thousandSeparator, '')
//        .replaceAll(rightSymbol, '')
//        .replaceAll(leftSymbol, '');
//
//    double d = double.parse(text);
//
//    print('numberRealValue => $d');
//    return d;

    return Func.moneyToDouble(text, thousandSeparator: thousandSeparator, rightSymbol: rightSymbol, leftSymbol: leftSymbol);
  }

  String _getOnlyNumbers(String text) {
    print('_getOnlyNumbers -> $text');

    String cleanedText = text;

    var onlyNumbersRegex = new RegExp(r'[^\d]');

    cleanedText = cleanedText.replaceAll(onlyNumbersRegex, '');
    print('_getOnlyNumbers => $cleanedText');

    return cleanedText;
  }

  String _applyMask(double value) {
    print('_applyMask -> $value');

    List<String> textRepresentation = value
        .toStringAsFixed(precision)
//        .replaceAll('.', '')
        .replaceAll(thousandSeparator, '')
        .replaceAll(decimalSeparator, '')
        .split('')
        .reversed
        .toList(growable: true);

    if (precision > 0) textRepresentation.insert(precision, decimalSeparator);
    bool first = true;
    for (var i = precision + 4; true; i = i + 4) {
      if (precision == 0 && first) i = 3;
      first = false;
      if (textRepresentation.length > i) {
        textRepresentation.insert(i, thousandSeparator);
      } else {
        break;
      }
    }

    String s = textRepresentation.reversed.join('');
    print('_applyMask => $s');
    return s;
  }
}
