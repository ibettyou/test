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
      _init();
    }
  }

  void _init() {
    if (widget.src.isEmpty) {
      return;
    }
    if (widget.src.getBase64 != null) {
      return;
    }
    DefaultCacheManager().getSingleFile(widget.src).then((file) {
      if (mounted && widget.src.isNotEmpty) {
        setState(() {
          _file = file;
        });
      }
    });
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
      child: _buildIcon(),
    );
  }
}
