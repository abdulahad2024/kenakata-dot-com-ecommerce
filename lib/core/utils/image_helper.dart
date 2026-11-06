import '../constants/app_config.dart';

class ImageHelper {
  static String getImageUrl(String? url) {
    if (url == null || url.trim().isEmpty || url == 'null') {
      return 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500';
    }

    final trimmed = url.trim();

    // Already a full HTTP / HTTPS URL
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }

    // Strip leading slash
    String cleanPath = trimmed.startsWith('/') ? trimmed.substring(1) : trimmed;

    // Normalize storage path to avoid duplicate "storage/app/public/storage/app/public/"
    if (cleanPath.startsWith('storage/app/public/')) {
      return '${AppConfig.appBaseUrl}/$cleanPath';
    } else if (cleanPath.startsWith('storage/')) {
      cleanPath = cleanPath.substring(8); // Strip "storage/"
    } else if (cleanPath.startsWith('public/')) {
      cleanPath = cleanPath.substring(7); // Strip "public/"
    } else if (cleanPath.startsWith('app/public/')) {
      cleanPath = cleanPath.substring(11); // Strip "app/public/"
    }

    // Always form: AppBaseUrl/storage/app/public/$cleanPath
    return '${AppConfig.appBaseUrl}/storage/app/public/$cleanPath';
  }
}
