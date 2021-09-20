import 'package:habido_app/utils/func.dart';

class ComboItem {
  String txt = '';
  dynamic val;
  String? imageAssetName; // Icon asset name
}

class ComboHelper {
  static String textToValue(List<ComboItem> list, String? value) {
    String text = '';

    if (Func.isNotEmpty(value)) {
      for (var el in list) {
        // if (el.val is DictData) {
        //   /// Dictionary
        //   if ((el.val as DictData).val == value) {
        //     text = (el.val as DictData).txt ?? '';
        //     break;
        //   }
        // } else
        if (el.val == value) {
          /// String
          text = el.txt;
          break;
        }
      }
    }

    return text;
  }

  static ComboItem? valueToComboItem(List<ComboItem>? list, String? value) {
    ComboItem? comboItem;

    try {
      if (Func.isNotEmpty(value)) {
        if (list != null && list.isNotEmpty) {
          for (var el in list) {
            if (Func.toStr(el.val) == value) {
              comboItem = el;
              break;
            }
          }
        }
      }
    } catch (e) {
      print(e);
    }

    return comboItem;
  }

// static List<ComboItem> dictToCombo(List<DictData>? dictList) {
//   var comboItemList = <ComboItem>[];
//   try {
//     if (dictList != null && dictList.isNotEmpty) {
//       for (var el in dictList) {
//         comboItemList.add(ComboItem()
//           ..txt = el.txt ?? ''
//           ..val = el.val);
//       }
//     }
//   } catch (e) {
//     print(e);
//   }
//
//   return comboItemList;
// }

// static List<ComboItem> get logicList => <ComboItem>[
//       ComboItem()
//         ..txt = LocaleKeys.no
//         ..val = 0,
//       ComboItem()
//         ..txt = LocaleKeys.yes
//         ..val = 1
//     ];
//
// static List<ComboItem> get genderComboList => <ComboItem>[
//       ComboItem()
//         ..txt = LocaleKeys.male
//         ..val = 'M',
//       ComboItem()
//         ..txt = LocaleKeys.female
//         ..val = 'F'
//     ];
//
// static List<ComboItem> bankToCombo(List<Bank>? banks) {
//   var comboItemList = <ComboItem>[];
//   try {
//     if (banks != null && banks.isNotEmpty) {
//       for (var el in banks) {
//         comboItemList.add(
//           ComboItem()
//             ..txt = el.paBank?.name ?? ''
//             ..val = el,
//         );
//       }
//     }
//   } catch (e) {
//     print(e);
//   }
//
//   return comboItemList;
// }
}
