import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// https://stackoverflow.com/questions/67963713/how-to-cache-memory-image-using-image-memory-or-memoryimage-flutter

class CacheImageProviderWidget extends ImageProvider<CacheImageProviderWidget> {
  final String tag; //the cache id use to get cache
  final Uint8List img; //the bytes of image to cache

  CacheImageProviderWidget(this.tag, this.img);

  @override
  ImageStreamCompleter load(CacheImageProviderWidget key, DecoderCallback decode) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(decode),
      scale: 1.0,
      debugLabel: tag,
      informationCollector: () sync* {
        yield ErrorDescription('Tag: $tag');
      },
    );
  }

  Future<Codec> _loadAsync(DecoderCallback decode) async {
    // the DefaultCacheManager() encapsulation, it get cache from local storage.
    final Uint8List bytes = img;

    if (bytes.lengthInBytes == 0) {
      // The file may become available later.
      PaintingBinding.instance.imageCache.evict(this);
      throw StateError('$tag is empty and cannot be loaded as an image.');
    }

    return await decode(bytes);
  }

  @override
  Future<CacheImageProviderWidget> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<CacheImageProviderWidget>(this);
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    bool res = other is CacheImageProviderWidget && other.tag == tag;
    return res;
  }

  @override
  int get hashCode => tag.hashCode;

  @override
  String toString() =>
      '${objectRuntimeType(this, 'CacheImageProviderWidget')}("$tag")';
}