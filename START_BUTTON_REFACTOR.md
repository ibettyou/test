# Start Button 重构文档

## 需求概述

将 start_button 从浮动按钮重构为普通小部件，具有以下特性：

1. **位置固定**：始终显示在首页仪表盘的最下一行
2. **不可删除**：编辑状态下不显示删除按钮
3. **尺寸统一**：与内网 IP 小部件大小一致（crossAxisCellCount: 4）
4. **状态显示**：
   - 未初始化：显示加载动画
   - 无配置：显示警告图标 + "请检查或添加配置"
   - 就绪状态：显示播放图标 + "服务已就绪"
   - 运行状态：显示暂停图标 + 运行时间（格式：999:59:59）
5. **多语言支持**：中英日俄四种语言

## 实现细节

### 1. 文件修改

#### lib/views/dashboard/widgets/start_button.dart
- 从 `ConsumerStatefulWidget` 改为 `ConsumerWidget`（简化状态管理）
- 移除浮动按钮的动画逻辑
- 使用 `CommonCard` 布局，与其他小部件保持一致
- 使用 `FadeThroughBox` 实现状态切换动画
- 标题：电源图标 + "启动开关"
- 内容区域根据状态显示不同内容：
  - 加载中：`CircularProgressIndicator`
  - 无配置：`Icons.warning_amber_rounded` + 提示文字
  - 就绪：`Icons.play_arrow` + "服务已就绪"
  - 运行中：`Icons.pause` + 运行时间

#### lib/views/dashboard/dashboard.dart
- 移除 `floatingActionButton` 属性
- 在 Grid 和 SuperGrid 的 children 末尾添加 StartButton
- 编辑模式下使用 `_NonDeletableWidget` 包装，隐藏删除按钮
- 调整 `SingleChildScrollView` 的 `bottom padding` 从 88 改为 16

#### lib/views/dashboard/widgets/widgets.dart
- 添加 `export 'start_button.dart';`

#### arb/intl_*.arb（四个语言文件）
添加三个新的国际化字符串：
- `powerSwitch`: 启动开关 / Power Switch / 電源スイッチ / Переключатель питания
- `checkOrAddProfile`: 请检查或添加配置 / Please check or add profile / プロファイルを確認または追加してください / Пожалуйста, проверьте или добавьте профиль
- `serviceReady`: 服务已就绪 / Service ready / サービス準備完了 / Сервис готов

### 2. UI 设计

```
┌─────────────────────────────────┐
│ ⚡ 启动开关                      │
├─────────────────────────────────┤
│                                 │
│ ▶ 服务已就绪                    │  ← 未启动状态
│                                 │
└─────────────────────────────────┘

┌─────────────────────────────────┐
│ ⚡ 启动开关                      │
├─────────────────────────────────┤
│                                 │
│ ⏸ 001:23:45                     │  ← 运行状态
│                                 │
└─────────────────────────────────┘

┌─────────────────────────────────┐
│ ⚡ 启动开关                      │
├─────────────────────────────────┤
│                                 │
│ ⚠ 请检查或添加配置               │  ← 无配置状态
│                                 │
└─────────────────────────────────┘
```

### 3. 运行时间格式

- 格式：`HHH:MM:SS`（小时3位，分钟和秒2位）
- 最大值：`999:59:59`
- 数据源：`runTimeProvider` 返回毫秒时间戳（`int?`）
- 计算逻辑：
  ```dart
  final diff = timeStamp / 1000;  // 转换为秒
  int inHours = (diff / 3600).floor();
  int inMinutes = (diff / 60 % 60).floor();
  int inSeconds = (diff % 60).floor();
  
  // 限制最大值
  if (inHours > 999) {
    inHours = 999;
    inMinutes = 59;
    inSeconds = 59;
  }
  ```

### 4. 编辑模式处理

创建了 `_NonDeletableWidget` 类来包装 StartButton：
- 只显示 `ActivateBox`（激活框）
- 不显示删除按钮（与其他小部件的 `_AddedContainer` 不同）
- 确保 StartButton 在编辑模式下不能被删除

### 5. 状态管理

使用现有的 providers：
- `startButtonSelectorStateProvider`: 检查初始化和配置状态
- `runTimeProvider`: 获取运行时间（毫秒时间戳）
- 点击事件通过 `globalState.appController.updateStatus()` 处理

## UI 一致性检查

✅ 使用 `getWidgetHeight(1)` 设置高度（与 IntranetIP 一致）
✅ 使用 `CommonCard` 布局
✅ 使用 `Info` 设置标题和图标
✅ 使用 `baseInfoEdgeInsets.copyWith(top: 0)` 设置内边距
✅ 使用 `globalState.measure.bodyMediumHeight + 2` 设置内容高度
✅ 使用 `FadeThroughBox` 实现状态切换动画
✅ 使用 `context.textTheme.bodyMedium?.toLight.adjustSize(1)` 设置文字样式
✅ 图标大小统一为 16
✅ 图标和文字间距为 4

## 测试要点

1. **基本功能**
   - [ ] 点击按钮可以启动/停止服务
   - [ ] 运行时间正确显示并实时更新
   - [ ] 运行时间达到 999:59:59 后不再增长

2. **状态显示**
   - [ ] 应用启动时显示加载动画
   - [ ] 无配置时显示警告提示
   - [ ] 有配置未启动时显示"服务已就绪"
   - [ ] 启动后显示运行时间

3. **布局和位置**
   - [ ] StartButton 始终在仪表盘最后一行
   - [ ] 尺寸与内网 IP 小部件一致
   - [ ] 编辑模式下不显示删除按钮
   - [ ] 编辑模式下可以拖动其他小部件，但 StartButton 位置固定

4. **多语言**
   - [ ] 中文显示正确
   - [ ] 英文显示正确
   - [ ] 日文显示正确
   - [ ] 俄文显示正确

5. **UI 一致性**
   - [ ] 与其他小部件的样式保持一致
   - [ ] 状态切换动画流畅
   - [ ] 深色/浅色模式下显示正常

## 注意事项

1. 需要运行代码生成：`dart run build_runner build -d`
2. StartButton 不在 `DashboardWidget` 枚举中，是单独添加到 Grid 的
3. 运行时间会自动更新（通过 `runTimeProvider` 的状态变化触发重建）
4. 点击事件使用了 `debouncer` 防抖，避免频繁触发

## 状态
✅ 重构完成 - 等待测试
