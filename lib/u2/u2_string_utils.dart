import 'u2_dyn_array.dart';
import 'u2_list_strings.dart';
//import 'package:intl/intl.dart';

//
//  funcions per tractar string al estil universe
//
class U2StringUtils {
  static String u2Lower(String cadena) {
    if (cadena == null || cadena.length <= 0) {
      return '';
    }
    List<String> c = cadena.split('');
    int n = c.length;
    for (var i = 0; i < n; i++) {
      if (c[i] == U2RM) {
        c[i] = U2AM;
      } else if (c[i] == U2AM) {
        c[i] = U2VM;
      } else if (c[i] == U2VM) {
        c[i] = U2SVM;
      } else if (c[i] == U2SVM) {
        c[i] = U2TM;
      }
    }
    return c.join('');
  }

  static String u2Raise(String cadena) {
    if (cadena == null || cadena.length <= 0) {
      return '';
    }
    List<String> c = cadena.split('');
    int n = c.length;
    for (int i = 0; i < n; i++) {
      if (c[i] == U2AM) {
        c[i] = U2RM;
      } else if (c[i] == U2VM) {
        c[i] = U2AM;
      } else if (c[i] == U2SVM) {
        c[i] = U2VM;
      } else if (c[i] == U2TM) {
        c[i] = U2SVM;
      }
    }
    return c.join("");
  }

  static String u2Field(String cadena, String separa, int pos, [int num1 = 1]) {
    int pos2 = pos;
    int num2 = num1;
    if (cadena == null || cadena.length <= 0) {
      return '';
    }
    if (separa == null || separa.length <= 0) {
      return '';
    }
    if (pos == null || pos < 1) {
      pos2 = 1;
    }
    if (num1 == null || num1 < 1) {
      num2 = 1;
    }
    U2ListStrings s1 = new U2ListStrings(cadena, separa);
    if (num2 == 1) {
      return s1.field(pos2);
    } else {
      U2ListStrings s2 = new U2ListStrings('', separa);
      int ipos = 0;
      for (int i = pos2; i < pos2 + num2; i++) {
        ipos++;
        s2.fieldStore(s1.field(i), ipos);
      }
      return s2.fieldJoin();
    }
  }

  static String cString(String? valor) {
    if (valor == null) {
      return '';
    }
    return valor;
  }

  static String cStringDef(String? valor, String valorDefecto) {
    if (valor == null) {
      return valorDefecto;
    }
    return valor;
  }

  static int cInt(int? valor) {
    if (valor == null) {
      return 0;
    }
    return (valor);
  }

  static int cIntDef(int? valor, int valorDefecto) {
    if (valor == null) {
      return valorDefecto;
    }
    return (valor);
  }

  static num cNum(num? valor) {
    if (valor == null) {
      return 0;
    }
    return (valor);
  }

  static num cNumDef(num? valor, num valorDefecto) {
    if (valor == null) {
      return valorDefecto;
    }
    return (valor);
  }

  static String u2Substr(String cadena, int pos, int num1) {
    int pos2 = pos;
    int num2 = num1;
    int l = cadena.length;
    if (cadena == null || l <= 0) {
      return '';
    }
    if (pos == null || pos < 1) {
      pos2 = 1;
    }
    if (num1 == null || num1 == 0) {
      num2 = 1;
    }
    if (num1 > 0) {
      int start = pos2 - 1;
      //print("start: ${start.toString()}");
      int end = pos2 - 1 + num2;
      if (start < 0) start = 0;
      if (end > l) end = l;
      if ((start < 0) || (start > l) || (end < 0) || (end > l)) {
        return "";
      }
      return cadena.substring(start, end);
    } else if (num1 < 0) {
      //print("l: ${l.toString()}");
      int start = l - pos2 + 1 + num2;
      //print("start: ${start.toString()}");
      int end = l - pos2 + 1;
      //print("end: ${end.toString()}");
      if (start < 0) start = 0;
      if (end > l) end = l;
      if ((start < 0) || (start > l) || (end < 0) || (end > l)) {
        return "";
      }
      return cadena.substring(start, end);
    }
    return '';
  }

  static String u2Left(String cadena, int num1) {
    int num2 = num1;
    if (cadena == null || cadena.length <= 0) {
      return '';
    }
    if (num1 == null || num1 <= 0) {
      num2 = 1;
    }
    if (num1 > cadena.length) num2 = cadena.length;
    return cadena.substring(0, num2);
  }

  static String u2Rigth(String cadena, int num1) {
    int num2 = num1;
    if (cadena == null || cadena.length <= 0) {
      return '';
    }
    if (num1 == null || num1 <= 0) {
      num2 = 1;
    }
    if (num1 > cadena.length) num2 = cadena.length;
    return cadena.substring(cadena.length - num2, num2);
  }

//
// Tactament data hora uniVerse
//

  static int u2Date() {
    return ((DateTime.now().millisecondsSinceEpoch ~/ 86400000) + 732);
  }

// hora solar
  static num u2Time() {
    return ((DateTime.now().millisecondsSinceEpoch % 86400000) / 1000);
  }

  static int DateTime2u2Date(DateTime dt) {
    //if (dt == null) {
    //  return null;
    //}
    return ((dt.millisecondsSinceEpoch ~/ 86400000) + 732);
  }

// hora solar
  static num DateTime2u2Time(DateTime dt) {
    //if (dt == null) {
    //  return null;
    //}
    return ((dt.millisecondsSinceEpoch % 86400000) / 1000);
  }

  static DateTime u2Date2DateTime(int num1) {
    //if (num1 == null) {
    //throw new Exception('Invalid Date');
    //return null;
    //}
    int v = (num1 - 732) * 86400000;
    return (new DateTime.fromMillisecondsSinceEpoch(v));
  }

  static DateTime u2Time2DateTime(num num1) {
    //if (num1 == null) {
    //throw new Exception('Invalid time');
    // return null;
    //}
    int v = (num1 * 1000).toInt();
    return (new DateTime.fromMillisecondsSinceEpoch(v));
  }

  static String DateTime2u2TADA(DateTime dt) {
    //if (dt == null) {
    //  return null;
    //}
    //DateFormat formatter = new DateFormat('yyyyMMdd');
    //return formatter.format(dt);
    return (dt.year.toString() +
        dt.month.toString().padLeft(2, '0') +
        dt.day.toString().padLeft(2, '0'));
  }

  static String DateTime2u2HHMMSS(DateTime dt) {
    //if (dt==null) {
    //  return null;
    //}
    //DateFormat formatter = new DateFormat('HHmmss');
    //return formatter.format(dt);
    return (dt.hour.toString().padLeft(2, '0') +
        dt.minute.toString().padLeft(2, '0') +
        dt.second.toString().padLeft(2, '0'));
  }

  static int u2Index(String cadena, String subcadena) {
    return (cadena.indexOf(subcadena) + 1);
  }

  static DateTime u2TADA2DateTime(String tada) {
    int vyyyy = 0;
    int vMM = 0;
    int vdd = 0;
    if (tada.length >= 8) {
      vyyyy = int.parse(tada.substring(0, 4));
      vMM = int.parse(tada.substring(4, 6));
      vdd = int.parse(tada.substring(6, 8));
    }
    return new DateTime(vyyyy, vMM, vdd);
  }

  static DateTime u2HHMMSS2DateTime(String sHHmmss) {
    int vHH = 0;
    int vmm = 0;
    int vss = 0;
    if (sHHmmss.length >= 2) vHH = int.parse(sHHmmss.substring(0, 2));
    if (sHHmmss.length >= 4) vmm = int.parse(sHHmmss.substring(2, 4));
    if (sHHmmss.length >= 6) vss = int.parse(sHHmmss.substring(4, 6));
    return new DateTime(0, 0, 0, vHH, vmm, vss);
  }

  static DateTime u2TADAHHMMSS2DateTime(String tada, String sHHmmss) {
    int vyyyy = 0;
    int vMM = 0;
    int vdd = 0;
    if (tada.length >= 8) {
      vyyyy = int.parse(tada.substring(0, 4));
      vMM = int.parse(tada.substring(4, 6));
      vdd = int.parse(tada.substring(6, 8));
    }
    int vHH = 0;
    int vmm = 0;
    int vss = 0;
    if (sHHmmss.length >= 2) vHH = int.parse(sHHmmss.substring(0, 2));
    if (sHHmmss.length >= 4) vmm = int.parse(sHHmmss.substring(2, 4));
    if (sHHmmss.length >= 6) vss = int.parse(sHHmmss.substring(4, 6));
    return new DateTime(vyyyy, vMM, vdd, vHH, vmm, vss);
  }

  static String DateTime2DataS(DateTime dt) {
    return (dt.day.toString().padLeft(2, '0') +
        '/' +
        dt.month.toString().padLeft(2, '0') +
        '/' +
        dt.year.toString());
  }

  static String DateTime2HoraMinS(DateTime dt) {
    return (dt.hour.toString().padLeft(2, '0') + ':' + dt.minute.toString().padLeft(2, '0'));
  }

  static String DateTime2HoraMinSecS(DateTime dt) {
    return (dt.hour.toString().padLeft(2, '0') +
        ':' +
        dt.minute.toString().padLeft(2, '0') +
        ':' +
        dt.second.toString().padLeft(2, '0'));
  }

  static String u2SQuoteEscaped(String cadena) {
    String sortida = cadena;
    if (sortida.indexOf("'") > 0) {
      sortida = sortida.replaceAll("'", "\\'");
    }
    sortida = "'" + sortida + "'";
    return sortida;
  }

  static String u2SQuote(String cadena) {
    String sortida = cadena;
    sortida = "'" + sortida + "'";
    return sortida;
  }

  static String u2DQuote(String cadena) {
    String sortida = cadena;
    sortida = '"' + sortida + '"';
    return sortida;
  }

  static String u2DQuoteEscaped(String cadena) {
    String sortida = cadena;
    if (sortida.indexOf('"') >= 0) {
      sortida = sortida.replaceAll('"', '\\"');
    }
    sortida = '"' + sortida + '"';
    return sortida;
  }

  static String u2Replace(String cadena, String subCadena, String replace) {
    String s = cadena;
    if (s.indexOf(subCadena) >= 0) s = s.replaceAll(subCadena, replace);
    return s;
  }
}
