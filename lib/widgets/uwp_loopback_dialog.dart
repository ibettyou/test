import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'uwp_loopback_state.dart';
import '../common/modern_dialog.dart';
import '../common/modern_switch.dart';
import '../widgets/modern_toast.dart';
import '../common/uwp_loopback_manager.dart';

// UWP 回环管理对话框
class UwpLoopbackDialog extends StatefulWidget {
  const UwpLoopbackDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => ChangeNotifierProvider(
        create: (_) => UwpLoopbackState()..loadApps(),
        child: const UwpLoopbackDialog(),
      ),
    );
  }

  @override
  State<UwpLoopbackDialog> createState() => _UwpLoopbackDialogState();
}

class _UwpLoopbackDialogState extends State<UwpLoopbackDialog> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final state = context.read<UwpLoopbackState>();
    state.setSearchQuery(_searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    return ModernDialog(
      title: 'UWP Loopback Manager',
      titleIcon: Icons.apps,
      width: screenSize.width * 0.7,
      height: screenSize.height * 0.8,
      searchHint: 'Search applications...',
      searchController: _searchController,
      customActions: [
        TextButton.icon(
          onPressed: () {
            context.read<UwpLoopbackState>().selectAll();
          },
          icon: const Icon(Icons.select_all),
          label: const Text('Select All'),
        ),
        TextButton.icon(
          onPressed: () {
            context.read<UwpLoopbackState>().invertSelection();
          },
          icon: const Icon(Icons.flip),
          label: const Text('Invert Selection'),
        ),
        FilledButton(
          onPressed: _isSaving ? null : _saveConfiguration,
          child: _isSaving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Save'),
        ),
      ],
      child: Consumer<UwpLoopbackState>(
        builder: (context, state, _) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.errorMessage != null) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48,
                    color: theme.colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${state.errorMessage}',
                    style: TextStyle(color: theme.colorScheme.error),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => state.loadApps(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final apps = state.filteredApps;
          
          if (apps.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.apps, size: 48, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No applications found',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: apps.length,
            itemBuilder: (context, index) {
              final app = apps[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: CheckboxListTile(
                  title: Text(
                    app.displayName.isNotEmpty ? app.displayName : app.packageFamilyName,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    app.packageFamilyName,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                  ),
                  value: app.isLoopbackEnabled,
                  onChanged: (value) async {
                    if (value != null) {
                      await state.toggleApp(app, value);
                    }
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _saveConfiguration() async {
    setState(() {
      _isSaving = true;
    });

    try {
      final state = context.read<UwpLoopbackState>();
      final allApps = state.apps;
      
      // 获取当前已启用的应用
      final currentlyEnabled = await UwpLoopbackHelper.getLoopbackExemptApps();
      
      // 启用应该启用的应用
      for (final app in allApps) {
        if (app.isLoopbackEnabled) {
          await UwpLoopbackHelper.enableLoopbackForApp(app.packageFamilyName);
        } else {
          // 检查这个应用是否当前已被豁免，如果是则禁用
          if (currentlyEnabled.any((exempt) => exempt.contains(app.packageFamilyName))) {
            await UwpLoopbackHelper.disableLoopbackForApp(app.packageFamilyName);
          }
        }
      }
      
      ModernToast.success('Configuration saved successfully');
    } catch (e) {
      ModernToast.error('Failed to save configuration: $e');
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }
}