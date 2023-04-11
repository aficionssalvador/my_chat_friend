class U2ListStrings {
  String _sep = '';
  List<String> _dades = [];

  U2ListStrings(String valorCadena, String Separador) {
    this._sep = Separador;
    this._dades = valorCadena.split(this._sep);
  }

  int fieldDCount() {
    if ((this._dades == null) || (this._dades == []) || (this._dades.length <= 0)) {
      return 0;
    }
    if ((this._dades.length == 0) && (this._dades[0] == '')) {
      return 0;
    }
    if ((this._dades.length == 1) && (this._dades[0] == '')) {
      return 0;
    }
    return this._dades.length;
  }

  String fieldJoin() {
    if ((this._dades == null) || (this._dades == []) || (this._dades.length <= 0)) {
      return '';
    }
    if ((this._dades.length == 0) && (this._dades[0] == '')) {
      return '';
    }
    return this._dades.join(this._sep);
  }

  String field(int pos) {
    if ((this._dades == null) || (this._dades == []) || (this._dades.length <= 0)) {
      return '';
    }
    if ((this._dades.length == 0) && (this._dades[0] == '')) {
      return '';
    }
    if (pos == 0) {
      return this.fieldJoin();
    }
    if ((pos > 0) && (pos <= this.fieldDCount())) {
      return this._dades[pos - 1];
    }
    //if ((pos > this.fieldDCount()) || (pos < 0)) {
    return '';
    //}
  }

  fieldStore(String valor, int pos) {
    int n = 0;
    if (pos < 0) {
      if ((this._dades.length == 0) && (this._dades[0] == '')) {
        this._dades[0] = valor;
      } else {
        this._dades.add(valor);
      }
    } else if (pos == 0) {
      this._dades = valor.split(this._sep);
    } else {
      n = this.fieldDCount();
      if ((pos > 0) && (pos <= n)) {
        this._dades[pos - 1] = valor;
      } else if (pos > n) {
        for (int i = n; i < (pos - 1); i++) {
          this._dades.add('');
        }
        this._dades.add(valor);
      }
    }
    if (valor.indexOf(this._sep) >= 0) {
      this._dades = this.fieldJoin().split(this._sep);
    }
  }

  int fieldLocate(String cadenaBuscar) {
    if ((this._dades == null) || (this._dades == []) || (this._dades.length <= 0)) {
      return -1;
    }
    if ((this._dades.length == 0) && (this._dades[0] == '')) {
      return -1;
    }
    return this._dades.indexOf(cadenaBuscar) + 1;
  }

  fieldInsert(String valor, int pos) {
    if (pos < 0) {
      this._dades.add(valor);
      return null;
    } else if (pos == 0) {
      this.fieldStore(valor, pos);
    } else if ((pos > 0) && (pos <= this.fieldDCount())) {
      this._dades.insert(pos - 1, valor);
    } else if (pos > this.fieldDCount()) {
      this.fieldStore(valor, pos);
    }
    if (valor.indexOf(this._sep) >= 0) {
      this._dades = this.fieldJoin().split(this._sep);
    }
  }

  fieldDelete(int pos) {
    if ((this._dades == null) || (this._dades == []) || (this._dades.length <= 0)) {
      return null;
    }
    if ((this._dades.length == 0) && (this._dades[0] == '')) {
      return null;
    }
    if ((pos > 0) && (pos <= this.fieldDCount())) {
      this._dades.removeAt(pos - 1);
    }
  }
}
