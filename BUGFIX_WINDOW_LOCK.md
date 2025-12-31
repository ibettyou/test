# 窗口锁定功能 Bug 修复

## 问题描述
1. 鼠标移动到锁图标附近时页面白屏（上灰下白）
2. 点击其他区域可以短暂恢复，但鼠标再次移动过去又白屏
3. 锁定功能不生效

## 问题原因
原代码存在以下问题：

1. **使用了不存在的 Provider**：代码中使用了 `windowLockedProvider`，但这个 provider 没有正确定义
2. **复杂的窗口操作逻辑**：尝试通过设置最小/最大尺寸来锁定窗口，这种方式在某些平台上可能导致问题
3. **异步操作处理不当**：在 widget 构建过程中进行复杂的异步操作可能导致状态不一致

## 修复方案

### 1. 简化状态管理
- 直接使用 `windowSettingProvider` 中的 `isLocked` 字段
- 移除了不必要的独立 provider
- 使用 `select` 方法只监听 `isLocked` 字段的变化，避免不必要的重建

### 2. 简化窗口锁定逻辑
- 只使用 `windowManager.setResizable()` 方法
- 移除了复杂的最小/最大尺寸设置逻辑
- 这是最直接、最可靠的方式来控制窗口是否可调整大小

### 3. 改进错误处理
- 添加了 `window == null` 检查，避免在非桌面平台上出错
- 使用 try-catch 捕获可能的异常
- 异常时只记录日志，不影响 UI 状态

### 4. 使用 Consumer Widget
- 将锁按钮包装在 `Consumer` 中
- 确保状态变化时正确重建 widget
- 避免在 `ConsumerWidget` 的 build 方法中直接使用复杂逻辑

## 修改的文件

### lib/manager/app_manager.dart
```dart
// 修改前：使用不存在的 provider 和复杂逻辑
Widget _buildWindowLockButton(BuildContext context, WidgetRef ref) {
  final isLocked = ref.watch(windowLockedProvider); // 问题：provider 不存在
  // ... 复杂的窗口操作逻辑
}

// 修改后：使用现有 provider 和简单逻辑
Consumer(
  builder: (context, ref, _) {
    final isLocked = ref.watch(
      windowSettingProvider.select((state) => state.isLocked),
    );
    return IconButton(
      onPressed: () async {
        if (window == null) return;
        
        try {
          final newLocked = !isLocked;
          
          // 更新状态
          ref.read(windowSettingProvider.notifier).updateState(
                (state) => state.copyWith(
                  isLocked: newLocked,
                ),
              );
          
          // 设置窗口是否可调整大小
          await windowManager.setResizable(!newLocked);
        } catch (e) {
          commonPrint.log('窗口锁定操作失败: $e');
        }
      },
      icon: Icon(
        isLocked ? Icons.lock : Icons.lock_open,
        color: context.colorScheme.onSurfaceVariant,
      ),
      tooltip: isLocked ? '解锁窗口大小' : '锁定窗口大小',
    );
  },
)
```

## 测试要点

1. **基本功能**：
   - 点击锁图标可以切换锁定/解锁状态
   - 锁定后窗口大小无法调整
   - 解锁后窗口大小可以自由调整

2. **UI 稳定性**：
   - 鼠标移动到锁图标附近不会白屏
   - 图标状态正确显示（锁定/解锁）
   - tooltip 正确显示

3. **状态持久化**：
   - 锁定状态保存到配置文件
   - 重启应用后状态保持

4. **跨平台兼容**：
   - Windows 系统正常工作
   - macOS 系统正常工作
   - Linux 系统正常工作

## 注意事项

1. 修改了 `WindowProps` 模型，需要运行代码生成：
   ```bash
   dart run build_runner build -d
   ```

2. 如果仍然遇到问题，请检查：
   - 是否正确运行了代码生成
   - 是否清理了旧的构建缓存：`flutter clean`
   - 是否重新安装了依赖：`flutter pub get`

3. 该功能仅在桌面模式下可用（非移动视图）
