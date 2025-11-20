import 'package:share_plus/share_plus.dart';
import '../utils/platform_helper.dart';
import '../../domain/entities/product.dart';
class ShareService {
  static Future<void> shareProduct(Product product, {String? url}) async {
    final shareUrl = url ?? 'https://keyboardshop.com/product/${product.id}';
    final shareText = '''
🎹 ${product.title}

${product.description}

💰 ${product.price.toStringAsFixed(2)} €
🔧 Switches: ${product.switches}
⌨️ Keycaps: ${product.keycaps}

Découvrez ce clavier sur KeyboardShop:
$shareUrl
    ''';

    try {
      if (PlatformHelper.isWeb) {
        await Share.share(
          shareText,
          subject: product.title,
        );
      } else if (PlatformHelper.isAndroid || PlatformHelper.isIOS) {
        await Share.share(
          shareText,
          subject: product.title,
        );
      } else {
        await Share.share(shareText);
      }
    } catch (e) {
      print('Erreur lors du partage: $e');
      rethrow;
    }
  }
  static Future<void> shareCatalog() async {
    const shareText = '''
🎹 Découvrez KeyboardShop !

La boutique en ligne de claviers mécaniques custom premium.
Des centaines de modèles, switches et keycaps disponibles.

https://keyboardshop.com
    ''';

    await Share.share(
      shareText,
      subject: 'KeyboardShop - Claviers Mécaniques',
    );
  }
  static bool get isShareAvailable {
    return PlatformHelper.isMobile || PlatformHelper.isWeb;
  }
}
