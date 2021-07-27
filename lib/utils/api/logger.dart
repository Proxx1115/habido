import '../func.dart';

class Logger {
  final String name;
  bool mute = false;
  String _func;

  set func(String f) {
    this._func = f;
  }

  static final Map<String, Logger> _cache = <String, Logger>{};

  factory Logger(String name, {String func = ''}) {
    if (_cache.containsKey(name)) {
      return _cache[name]!;
    } else {
      final logger = Logger._internal(name, func);
      _cache[name] = logger;
      return logger;
    }
  }

  Logger._internal(this.name, this._func);

  void log({String? f, double? s, Object? m, Object? m2, Object? e}) {
    if (mute) return;
    print(Func.toStr(f));
    // var now = new DateTime.now();
    // var formatter = new DateFormat('HH.mm.ssss');

    // print("DB:[${new DateFormat('HH.mm.ss SSS').format(new DateTime.now())}][$name][${f ?? _func}][step-$s][$m][$m2][$e]");
  }

  void log1(String msg) {
    if (!mute) print(msg);
  }

  void log2(String func, {String msg = ''}) {
    if (mute) return;
    print(name + " " + msg);
  }

  void log3(int step, String msg) {
    if (mute) return;
    print("[$name] [func] [$step] [$msg]");
  }
}
