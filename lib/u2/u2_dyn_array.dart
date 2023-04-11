import 'u2_list_strings.dart';

final String U2RM = String.fromCharCode(255);
final String U2AM = String.fromCharCode(254);
final String U2VM = String.fromCharCode(253);
final String U2SVM = String.fromCharCode(252);
final String U2TM = String.fromCharCode(251);

class U2DynArray {
  U2ListStrings _dataAM = new U2ListStrings('', U2AM);
  U2ListStrings _dataVM = new U2ListStrings('', U2VM);
  U2ListStrings _dataSVM = new U2ListStrings('', U2SVM);
  int _lastX = -2;
  int _lastY = -2;

  U2DynArray(String valor) {
    if (valor == null) {
      // nada
    } else {
      this._dataAM = new U2ListStrings(valor, U2AM);
    }
  }

  String extractAll() {
    return this._dataAM.fieldJoin();
  }

  String extractField(int x) {
    return this._dataAM.field(x);
  }

  String extractValue(int x, int y) {
    if (this._lastX != x) this._dataVM.fieldStore(this._dataAM.field(x), 0);
    this._lastX = x;
    this._lastY = -2;
    return this._dataVM.field(y);
  }

  String extractSubValue(int x, int y, int z) {
    bool b = false;
    if (this._lastX != x) {
      b = true;
      this._dataVM.fieldStore(this._dataAM.field(x), 0);
    }
    if (b || (this._lastY != y)) {
      this._dataSVM.fieldStore(this._dataVM.field(y), 0);
    }
    this._lastX = x;
    this._lastY = y;
    return this._dataSVM.field(z);
  }

  String extract(int x, int y, int z) {
    if (x == null) {
      return this.extract(0, 0, 0);
    }
    if (y == null) {
      return this.extract(x, 0, 0);
    }
    if (z == null) {
      return this.extract(x, y, 0);
    }
    if (x == 0) return this.extractAll();
    if (y == 0) return this.extractField(x);
    if (z == 0) return this.extractValue(x, y);
    return this.extractSubValue(x, y, z);
  }

  int dcountField() {
    return this._dataAM.fieldDCount();
  }

  int dcountValue(int x) {
    if (this._lastX != x) this._dataVM.fieldStore(this._dataAM.field(x), 0);
    this._lastX = x;
    this._lastY = -2;
    return this._dataVM.fieldDCount();
  }

  int dcountSubValue(int x, int y) {
    bool b = false;
    if (this._lastX != x) {
      b = true;
      this._dataVM.fieldStore(this._dataAM.field(x), 0);
    }
    if ((b) || (this._lastY != y)) this._dataSVM.fieldStore(this._dataVM.field(y), 0);
    this._lastX = x;
    this._lastY = y;
    return this._dataSVM.fieldDCount();
  }

  replaceAll(String valor) {
    this._dataAM.fieldStore(valor, 0);
    this._lastX = -2;
    this._lastY = -2;
  }

  replaceField(String valor, int x) {
    this._dataAM.fieldStore(valor, x);
    this._lastX = -2;
    this._lastY = -2;
  }

  replaceValue(String valor, int x, int y) {
    if (this._lastX != x) this._dataVM.fieldStore(this._dataAM.field(x), 0);
    this._lastX = x;
    this._lastY = -2;
    this._dataVM.fieldStore(valor, y);
    this._dataAM.fieldStore(this._dataVM.fieldJoin(), x);
  }

  replaceSubValue(String valor, int x, int y, int z) {
    bool b = false;
    if (this._lastX != x) {
      b = true;
      this._dataVM.fieldStore(this._dataAM.field(x), 0);
    }
    if ((b) || (this._lastY != y)) this._dataSVM.fieldStore(this._dataVM.field(y), 0);
    this._lastX = x;
    this._lastY = y;
    this._dataSVM.fieldStore(valor, z);
    this._dataVM.fieldStore(this._dataSVM.fieldJoin(), y);
    this._dataAM.fieldStore(this._dataVM.fieldJoin(), x);
  }

  replace(String valor, int x, int y, int z) {
    if (x == null) {
      this.replace(valor, 0, 0, 0);
    } else if (y == null) {
      this.replace(valor, x, 0, 0);
    } else if (z == null) {
      this.replace(valor, x, y, 0);
    } else if (x == 0) {
      this.replaceAll(valor);
    } else if (y == 0) {
      this.replaceField(valor, x);
    } else if (z == 0) {
      this.replaceValue(valor, x, y);
    } else {
      this.replaceSubValue(valor, x, y, z);
    }
  }

  insertField(String valor, int x) {
    this._dataAM.fieldInsert(valor, x);
    this._lastX = -2;
    this._lastY = -2;
  }

  insertValue(String valor, int x, int y) {
    if (this._lastX != x) this._dataVM.fieldStore(this._dataAM.field(x), 0);
    this._lastX = x;
    this._lastY = -2;
    this._dataVM.fieldInsert(valor, y);
    this._dataAM.fieldStore(this._dataVM.fieldJoin(), x);
  }

  insertSubValue(String valor, int x, int y, int z) {
    bool b = false;
    if (this._lastX != x) {
      b = true;
      this._dataVM.fieldStore(this._dataAM.field(x), 0);
    }
    if ((b) || (this._lastY != y)) this._dataSVM.fieldStore(this._dataVM.field(y), 0);
    this._lastX = x;
    this._lastY = y;
    this._dataSVM.fieldInsert(valor, z);
    this._dataVM.fieldStore(this._dataSVM.fieldJoin(), y);
    this._dataAM.fieldStore(this._dataVM.fieldJoin(), x);
  }

  deleteField(int x) {
    this._dataAM.fieldDelete(x);
    this._lastX = -2;
    this._lastY = -2;
  }

  deleteValue(int x, int y) {
    if (this._lastX != x) this._dataVM.fieldStore(this._dataAM.field(x), 0);
    this._lastX = x;
    this._lastY = -2;
    this._dataVM.fieldDelete(y);
    this._dataAM.fieldStore(this._dataVM.fieldJoin(), x);
  }

  deleteSubValue(int x, int y, int z) {
    bool b = false;
    if (this._lastX != x) {
      b = true;
      this._dataVM.fieldStore(this._dataAM.field(x), 0);
    }
    if ((b) || (this._lastY != y)) this._dataSVM.fieldStore(this._dataVM.field(y), 0);
    this._lastX = x;
    this._lastY = y;
    this._dataSVM.fieldDelete(z);
    this._dataVM.fieldStore(this._dataSVM.fieldJoin(), y);
    this._dataAM.fieldStore(this._dataVM.fieldJoin(), x);
  }

  int locateField(String valor) {
    return this._dataAM.fieldLocate(valor);
  }

  int locateValue(String valor, int x) {
    if (this._lastX != x) this._dataVM.fieldStore(this._dataAM.field(x), 0);
    this._lastX = x;
    this._lastY = -2;
    return this._dataVM.fieldLocate(valor);
  }

  int locateSubValue(String valor, int x, int y) {
    bool b = false;
    if (this._lastX != x) {
      b = true;
      this._dataVM.fieldStore(this._dataAM.field(x), 0);
    }
    if ((b) || (this._lastY != y)) this._dataSVM.fieldStore(this._dataVM.field(y), 0);
    this._lastX = x;
    this._lastY = y;
    return this._dataSVM.fieldLocate(valor);
  }
}
