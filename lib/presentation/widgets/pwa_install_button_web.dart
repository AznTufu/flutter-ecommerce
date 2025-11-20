import 'dart:js_interop' as js;

@js.JS('installPWA')
external void installPWAJS();

void callInstallPWA() {
  try {
    installPWAJS();
  } catch (e) {
    // L'installation PWA n'est pas disponible
  }
}
