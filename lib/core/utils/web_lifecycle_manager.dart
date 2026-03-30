import 'dart:html' as html;

class WebLifecycleManager {
  static void registerOnBeforeUnload(void Function() onDispose) {
    html.window.onBeforeUnload.listen((event) {
      onDispose();
    });
  }
}
