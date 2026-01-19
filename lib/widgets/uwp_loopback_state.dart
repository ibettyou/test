import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:uni_links_desktop/uni_links_desktop.dart';

// UWP 应用数据模型
class UwpApp {
  final String appContainerName;
  final String displayName;
  final String packageFamilyName;
  final List<int> sid;
  final String sidString;
  bool isLoopbackEnabled;

  UwpApp({
    required this.appContainerName,
    required this.displayName,
    required this.packageFamilyName,
    required this.sid,
    required this.sidString,
    required this.isLoopbackEnabled,
  });
}

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:li_clash/common/uwp_loopback_manager.dart';

// UWP 应用数据模型
class UwpApp {
  final String appContainerName;
  final String displayName;
  final String packageFamilyName;
  final List<int> sid;
  final String sidString;
  bool isLoopbackEnabled;

  UwpApp({
    required this.appContainerName,
    required this.displayName,
    required this.packageFamilyName,
    required this.sid,
    required this.sidString,
    required this.isLoopbackEnabled,
  });
}

// UWP 回环对话框状态管理器
class UwpLoopbackState extends ChangeNotifier {
  List<UwpApp> _apps = [];
  bool _isLoading = true;
  String? _errorMessage;
  String _searchQuery = '';

  // Getters
  List<UwpApp> get apps => _apps;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;

  // 获取过滤后的应用列表
  List<UwpApp> get filteredApps {
    if (_searchQuery.isEmpty) {
      return _apps;
    }
    return _apps.where((app) {
      return app.displayName.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          app.packageFamilyName.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          );
    }).toList();
  }

  // 设置搜索查询
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // 从系统加载 UWP 应用列表
  Future<void> loadApps() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // 获取所有UWP应用包信息
      final packages = await UwpLoopbackHelper.getAllUwpPackages();
      
      // 获取当前具有回环豁免的应用
      final loopbackExemptApps = await UwpLoopbackHelper.getLoopbackExemptApps();

      _apps = packages.map((pkg) {
        final name = pkg['Name'] ?? '';
        final packageFamilyName = pkg['PackageFamilyName'] ?? '';
        // 这里我们可以根据获取到的SID信息来判断是否已启用回环
        // 但目前我们简化处理，基于包名匹配
        final isLoopbackEnabled = packageFamilyName.isNotEmpty && 
            loopbackExemptApps.any((exempt) => exempt.contains(packageFamilyName));
        
        return UwpApp(
          appContainerName: name,
          displayName: name,
          packageFamilyName: packageFamilyName,
          sid: [], // 在实际应用中我们可能需要获取SID
          sidString: '', // 在实际应用中我们可能需要获取SID字符串
          isLoopbackEnabled: isLoopbackEnabled,
        );
      }).toList();
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = '加载失败: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  // 全选
  void selectAll() {
    for (var app in _apps) {
      app.isLoopbackEnabled = true;
    }
    notifyListeners();
  }

  // 反选
  void invertSelection() {
    for (var app in _apps) {
      app.isLoopbackEnabled = !app.isLoopbackEnabled;
    }
    notifyListeners();
  }

  // 切换单个应用的回环状态
  Future<void> toggleApp(UwpApp app, bool value) async {
    app.isLoopbackEnabled = value;
    
    // 立即更新UI
    notifyListeners();
    
    // 异步更新系统设置
    try {
      if (value) {
        await UwpLoopbackHelper.enableLoopbackForApp(app.packageFamilyName);
      } else {
        await UwpLoopbackHelper.disableLoopbackForApp(app.packageFamilyName);
      }
    } catch (e) {
      // 如果操作失败，恢复原始状态
      app.isLoopbackEnabled = !value;
      notifyListeners();
      rethrow; // 重新抛出异常让上层处理
    }
  }

  // 获取启用回环的应用包家族名称列表
  List<String> getEnabledPackageFamilyNames() {
    return _apps
        .where((app) => app.isLoopbackEnabled)
        .map((app) => app.packageFamilyName)
        .toList();
  }
}