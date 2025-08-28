import 'dart:io';

import 'package:flutter/material.dart';

import '../../constants/app_api_url.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_images_path.dart';
import '../../utils/app_all_log/error_log.dart';

class AppImageCircular extends StatelessWidget {
  const AppImageCircular({
    super.key,
    this.color = AppColors.grey,
    this.fit = BoxFit.fill,
    this.height,
    this.path,
    this.url,
    this.width,
    this.filePath,
    this.borderRadius = 100,
    this.decoration,
  });

  final String? path;
  final String? filePath;
  final String? url;
  final BoxFit fit;
  final double? width;
  final double? height;
  final double borderRadius;
  final Color color;
  final Decoration? decoration;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _buildImage(),
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  Widget _buildImage() {
    if (filePath != null) {
      return _buildFileImage();
    } else if (url != null) {
      return NetworkImageWithRetry(
        imageUrl: url!,
        borderRadius: borderRadius,
        fit: fit,
        height: height,
        width: width,
      );
    } else if (path != null) {
      return _buildAssetImage();
    } else {
      return _buildPlaceholder();
    }
  }

  Widget _buildFileImage() {
    return Image.file(
      File(filePath!),
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        errorLog("Error loading file image:", error);
        return _buildPlaceholder();
      },
    );
  }

  Widget _buildAssetImage() {
    return Container(
      width: width,
      height: height,
      decoration: decoration ??
          const BoxDecoration(
            color: AppColors.grey,
          ),
      child: Image.asset(
        path!,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          errorLog("Error loading asset image:", error);
          return _buildPlaceholder();
        },
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: color,
      child: const Icon(Icons.image_not_supported, color: AppColors.grey),
    );
  }
}

class NetworkImageWithRetry extends StatefulWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final double borderRadius;
  final BoxFit fit;

  const NetworkImageWithRetry({
    super.key,
    required this.imageUrl,
    required this.borderRadius,
    this.fit = BoxFit.cover,
    this.height,
    this.width,
  });

  @override
  State createState() => _NetworkImageWithRetryState();
}

class _NetworkImageWithRetryState extends State<NetworkImageWithRetry> {
  int _retryCount = 0;
  final int _maxRetries = 3;
  late String imageUrl;

  @override
  void initState() {
    super.initState();
    _initializeImageUrl();
  }

  void _initializeImageUrl() {
    try {
      if (widget.imageUrl.contains("null")) {
        imageUrl = "";
      } else if (widget.imageUrl.startsWith("http") ||
          widget.imageUrl.startsWith("https")) {
        imageUrl = widget.imageUrl;
      } else {
        imageUrl = "${AppApiUrl.domain}${widget.imageUrl}";
      }
    } catch (e) {
      imageUrl = "";
      errorLog("Error setting image URL:", e);
    }
  }

  void _retry() {
    if (_retryCount < _maxRetries) {
      setState(() {
        _retryCount++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return imageUrl.isNotEmpty
        ? FadeInImage(
            placeholder: const AssetImage(AppImagesPath.placeHolder),
            image: NetworkImage(imageUrl),
            width: widget.width,
            height: widget.height,
            fit: widget.fit,
            fadeInDuration: const Duration(milliseconds: 300),
            fadeOutDuration: const Duration(milliseconds: 300),
            imageErrorBuilder: (context, error, stackTrace) {
              errorLog("Error loading network image:", error);
              return GestureDetector(
                onTap: _retry,
                child: _buildErrorPlaceholder(),
              );
            },
            placeholderErrorBuilder: (context, error, stackTrace) {
              return _buildErrorPlaceholder();
            },
          )
        : _buildErrorPlaceholder();
  }

  Widget _buildErrorPlaceholder() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: Container(
        width: widget.width,
        height: widget.height,
        color: AppColors.grey,
        child: const Icon(Icons.image_not_supported, color: Colors.white),
      ),
    );
  }
}
