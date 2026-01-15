import 'dart:io';
import 'package:li_clash/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/svg.dart';

class CommonTargetIcon extends StatefulWidget {
  final String src;
  final double size;

  const CommonTargetIcon({
    super.key,
    required this.src,
    required this.size,
  });

  @override
  State<CommonTargetIcon> createState() => _CommonTargetIconState();
}

class _CommonTargetIconState extends State<CommonTargetIcon> {
  File? _file;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void didUpdateWidget(covariant CommonTargetIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.src != widget.src) {
      _file = null;
      _init();
    }
  }

  Future<void> _init() async {
    if (widget.src.isEmpty) {
      return;
    }
    if (widget.src.getBase64 != null) {
      return;
    }
    
    // First try to get from cache without making any network calls
    final fileInfo = await DefaultCacheManager().getFileFromCache(widget.src);
    if (fileInfo != null && mounted && widget.src.isNotEmpty) {
      setState(() {
        _file = fileInfo.file;
      });
      return;
    }

    // If not in cache, then fetch (download)
    try {
      final file = await DefaultCacheManager().getSingleFile(widget.src);
      if (mounted && widget.src.isNotEmpty) {
        setState(() {
          _file = file;
        });
      }
    } catch (e) {
      // Handle download error
    }
  }

  Widget _defaultIcon() {
    return Icon(
      IconsExt.target,
      size: widget.size,
    );
  }

  Widget _buildIcon() {
    if (widget.src.isEmpty) {
      return _defaultIcon();
    }
    final base64 = widget.src.getBase64;
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    final cacheSize = (widget.size * devicePixelRatio).ceil();

    if (base64 != null) {
      return Image.memory(
        base64,
        gaplessPlayback: true,
        cacheWidth: cacheSize,
        cacheHeight: cacheSize,
        errorBuilder: (_, error, ___) {
          return _defaultIcon();
        },
      );
    }
    if (_file != null) {
      return widget.src.isSvg
          ? SvgPicture.file(
              _file!,
              width: widget.size,
              height: widget.size,
              errorBuilder: (_, __, ___) => _defaultIcon(),
            )
          : Image.file(
              _file!,
              gaplessPlayback: true,
              cacheWidth: cacheSize,
              cacheHeight: cacheSize,
              errorBuilder: (_, __, ___) => _defaultIcon(),
            );
    }
    return _defaultIcon();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: KeyedSubtree(
          key: ValueKey<String>('${widget.src}_${_file?.path}'),
          child: _buildIcon(),
        ),
      ),
    );
  }
}
