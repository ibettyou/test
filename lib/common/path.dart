import 'dart:async';
import 'dart:io';

import 'package:li_clash/common/common.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class SafePathsValidator {
  static List<String>? _cachedSafePaths;

  static List<String> getSafePaths() {
    if (_cachedSafePaths != null) {
      return _cachedSafePaths!;
    }

    final envSafePaths = Platform.environment['SAFE_PATHS'] ?? '';
    if (envSafePaths.isEmpty) {
      _cachedSafePaths = [];
      return [];
    }

    final separator = Platform.isWindows ? ';' : ':';
    _cachedSafePaths = envSafePaths
        .split(separator)
        .map((path) => normalize(absolute(path.trim())))
        .where((path) => path.isNotEmpty)
        .toList();

    return _cachedSafePaths!;
  }

  static bool isPathSafe(String path) {
    final safePaths = getSafePaths();
    if (safePaths.isEmpty) {
      return false;
    }

    final normalizedPath = normalize(absolute(path.trim()));
    return safePaths.any((safePath) =>
        normalizedPath.startsWith(safePath) ||
        normalizedPath.startsWith('$safePath${Platform.pathSeparator}'));
  }

  static String? getDefaultProvidersPath(
    String profileId,
    String type,
    String url,
  ) {
    return null;
  }

  static void clearCache() {
    _cachedSafePaths = null;
  }
}

class AppPath {
  static AppPath? _instance;
  Completer<Directory> dataDir = Completer();
  Completer<Directory> downloadDir = Completer();
  Completer<Directory> tempDir = Completer();
  late String appDirPath;

  AppPath._internal() {
    appDirPath = join(dirname(Platform.resolvedExecutable));
    getApplicationSupportDirectory().then((value) {
      dataDir.complete(value);
    });
    getTemporaryDirectory().then((value) {
      tempDir.complete(value);
    });
    getDownloadsDirectory().then((value) {
      downloadDir.complete(value);
    });
  }

  factory AppPath() {
    _instance ??= AppPath._internal();
    return _instance!;
  }

  String get executableExtension {
    return system.isWindows ? '.exe' : '';
  }

  String get executableDirPath {
    final currentExecutablePath = Platform.resolvedExecutable;
    return dirname(currentExecutablePath);
  }

  String get corePath {
    return join(executableDirPath, 'LiClashCore$executableExtension');
  }

  String get helperPath {
    return join(executableDirPath, '$appHelperService$executableExtension');
  }

  Future<String> get downloadDirPath async {
    final directory = await downloadDir.future;
    return directory.path;
  }

  Future<String> get homeDirPath async {
    final directory = await dataDir.future;
    return directory.path;
  }

  Future<String> get lockFilePath async {
    final directory = await dataDir.future;
    return join(directory.path, 'LiClash.lock');
  }

  Future<String> get sharedPreferencesPath async {
    final directory = await dataDir.future;
    return join(directory.path, 'shared_preferences.json');
  }

  Future<String> get profilesPath async {
    final directory = await dataDir.future;
    return join(directory.path, profilesDirectoryName);
  }

  Future<String> getProfilePath(String id) async {
    final directory = await profilesPath;
    return join(directory, '$id.yaml');
  }

  Future<String> getProvidersDirPath(String id) async {
    final directory = await profilesPath;
    return join(
      directory,
      'providers',
      id,
    );
  }

  Future<String> getProvidersFilePath(
    String id,
    String type,
    String url, {
    String? customPath,
  }) async {
    if (customPath != null && customPath.isNotEmpty) {
      if (SafePathsValidator.isPathSafe(customPath)) {
        return normalize(absolute(customPath.trim()));
      } else {
        commonPrint.log(
          '自定义路径 $customPath 不在 SAFE_PATHS 中，将使用默认路径',
        );
      }
    }
    final directory = await profilesPath;
    return join(
      directory,
      'providers',
      id,
      type,
      url.toMd5(),
    );
  }

  Future<String> get tempPath async {
    final directory = await tempDir.future;
    return directory.path;
  }
}

final appPath = AppPath();
