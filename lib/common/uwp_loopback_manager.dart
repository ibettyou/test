import 'dart:io';
import 'dart:convert';

/// UWP回环豁免助手类，使用PowerShell命令管理UWP应用的回环访问权限
class UwpLoopbackHelper {
  /// 使用PowerShell命令启用特定应用的回环豁免
  static Future<bool> enableLoopbackForApp(String packageFamilyName) async {
    try {
      final result = await Process.run(
        'powershell', 
        ['-Command', 'CheckNetIsolation LoopbackExempt -a -n="$packageFamilyName"'],
        runInShell: true
      );
      
      // 检查命令是否成功执行（即使有警告信息）
      return result.exitCode == 0;
    } catch (e) {
      print('Error enabling loopback for $packageFamilyName: $e');
      return false;
    }
  }

  /// 使用PowerShell命令禁用特定应用的回环豁免
  static Future<bool> disableLoopbackForApp(String packageFamilyName) async {
    try {
      final result = await Process.run(
        'powershell', 
        ['-Command', 'CheckNetIsolation LoopbackExempt -d -n="$packageFamilyName"'],
        runInShell: true
      );
      
      return result.exitCode == 0;
    } catch (e) {
      print('Error disabling loopback for $packageFamilyName: $e');
      return false;
    }
  }

  /// 获取当前所有具有回环豁免的应用
  static Future<List<String>> getLoopbackExemptApps() async {
    try {
      final result = await Process.run(
        'powershell', 
        ['-Command', 
          '''
          \$output = CheckNetIsolation LoopbackExempt -s 2>&1
          if (\$output -is [System.Management.Automation.ErrorRecord]) {
            # 如果出现错误，仍然尝试解析可用的信息
            \$relevantLines = \$output.Exception.Message -split "`n" | Where-Object { \$_ -match "Package SID:" }
          } else {
            \$relevantLines = \$output | Where-Object { \$_ -match "Package SID:" }
          }
          \$relevantLines | ForEach-Object {
            if (\$_ -match "Package SID:\\s*(S-[^\\s]+)") {
              \$sid = \$matches[1]
              Write-Output \$sid
            }
          }
          '''
        ],
        runInShell: true
      );
      
      if (result.exitCode == 0 || result.stdout.toString().isNotEmpty) {
        // 解析输出并提取SID
        final output = result.stdout.toString();
        if (output.trim().isEmpty) return [];
        
        return output
            .split('\n')
            .map((line) => line.trim())
            .where((line) => line.isNotEmpty && line.startsWith('S-'))
            .toList();
      }
      return [];
    } catch (e) {
      print('Error getting loopback exempt apps: $e');
      return [];
    }
  }

  /// 获取所有UWP应用包信息
  static Future<List<Map<String, String>>> getAllUwpPackages() async {
    try {
      final result = await Process.run(
        'powershell',
        ['-Command', 
          '''
          Get-AppxPackage | Where-Object {\$_.NonRemovable -eq \$false} | 
          Select-Object Name, PackageFamilyName | 
          ConvertTo-Json -Compress
          '''
        ],
        runInShell: true
      );
      
      if (result.exitCode != 0) {
        print('Error getting UWP packages: ${result.stderr}');
        return [];
      }
      
      final stdout = result.stdout.toString().trim();
      if (stdout.isEmpty) {
        return [];
      }
      
      try {
        List<dynamic> packages;
        if (stdout.startsWith('[')) {
          packages = jsonDecode(stdout);
        } else {
          // 单个项目不是数组
          packages = [jsonDecode(stdout)];
        }
        
        return packages.map((pkg) => {
          'Name': pkg['Name'] ?? '',
          'PackageFamilyName': pkg['PackageFamilyName'] ?? ''
        }).toList();
      } catch (e) {
        print('Error parsing UWP packages JSON: $e');
        return [];
      }
    } catch (e) {
      print('Error getting UWP packages: $e');
      return [];
    }
  }

  /// 清除所有回环豁免
  static Future<bool> clearAllLoopbackExemptions() async {
    try {
      final result = await Process.run(
        'powershell', 
        ['-Command', 'CheckNetIsolation LoopbackExempt -c'],
        runInShell: true
      );
      
      return result.exitCode == 0;
    } catch (e) {
      print('Error clearing all loopback exemptions: $e');
      return false;
    }
  }
}