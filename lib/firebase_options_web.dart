import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

const FirebaseOptions webOptions = FirebaseOptions(
  apiKey: "AIzaSyCxDrTim9FBTYM_4ZYjGcb5tL-F64tgSbk",
  authDomain: "safekey-app.firebaseapp.com",
  projectId: "safekey-app",
  storageBucket: "safekey-app.firebasestorage.app",
  messagingSenderId: "984634796948",
  appId: "1:984634796948:web:bcc704ee096e5e160cfd81"
);


const FirebaseOptions androidOptions = FirebaseOptions(
  apiKey: "AIza...",
  appId: "1:...",
  messagingSenderId: "...",
  projectId: "safekey-app",
  storageBucket: "safekey-app.appspot.com",
);

const FirebaseOptions iosOptions = FirebaseOptions(
   apiKey: "AIza...", 
   appId: "1:...",
   messagingSenderId: "...",
   projectId: "safekey-app",
   storageBucket: "safekey-app.appspot.com",
   iosBundleId: "com.example.safekeyApp",
);


class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return webOptions;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return androidOptions;
      case TargetPlatform.iOS:
        return iosOptions;
      case TargetPlatform.macOS:

        throw UnsupportedError("Plataforma não suportada");
      case TargetPlatform.windows:

        throw UnsupportedError("Plataforma não suportada");
      case TargetPlatform.linux:
        throw UnsupportedError("Plataforma não suportada");
      default:
        throw UnsupportedError("Plataforma não suportada");
    }
  }
}