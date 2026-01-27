import 'package:li_clash/common/common.dart';
import 'package:li_clash/models/clash_config.dart';
import 'package:li_clash/providers/config.dart';
import 'package:li_clash/state.dart';
import 'package:li_clash/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OverrideSnifferItem extends ConsumerWidget {
  const OverrideSnifferItem({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final override = ref.watch(overrideSnifferProvider);
    return ListItem.switchItem(
      title: Text(appLocalizations.overrideSniffer),
      subtitle: Text(appLocalizations.overrideSnifferDesc),
      delegate: SwitchDelegate(
        value: override,
        onChanged: (bool value) async {
          ref.read(overrideSnifferProvider.notifier).value = value;
        },
      ),
    );
  }
}

class SnifferStatusItem extends ConsumerWidget {
  const SnifferStatusItem({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final enable = ref.watch(
        patchClashConfigProvider.select((state) => state.sniffer.enable));
    return ListItem.switchItem(
      title: Text(appLocalizations.snifferStatus),
      subtitle: Text(appLocalizations.snifferStatusDesc),
      delegate: SwitchDelegate(
        value: enable,
        onChanged: (bool value) async {
          ref
              .read(patchClashConfigProvider.notifier)
              .updateState((state) => state.copyWith.sniffer(enable: value));
        },
      ),
    );
  }
}

class ForceDnsMappingItem extends ConsumerWidget {
  const ForceDnsMappingItem({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final forceDnsMapping = ref.watch(patchClashConfigProvider
        .select((state) => state.sniffer.forceDnsMapping));
    return ListItem.switchItem(
      title: Text(appLocalizations.forceDnsMapping),
      delegate: SwitchDelegate(
        value: forceDnsMapping,
        onChanged: (bool value) async {
          ref.read(patchClashConfigProvider.notifier).updateState(
              (state) => state.copyWith.sniffer(forceDnsMapping: value));
        },
      ),
    );
  }
}

class ParsePureIpItem extends ConsumerWidget {
  const ParsePureIpItem({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final parsePureIp = ref.watch(patchClashConfigProvider
        .select((state) => state.sniffer.parsePureIp));
    return ListItem.switchItem(
      title: Text(appLocalizations.parsePureIp),
      delegate: SwitchDelegate(
        value: parsePureIp,
        onChanged: (bool value) async {
          ref.read(patchClashConfigProvider.notifier).updateState(
              (state) => state.copyWith.sniffer(parsePureIp: value));
        },
      ),
    );
  }
}

class OverrideDestinationItem extends ConsumerWidget {
  const OverrideDestinationItem({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final overrideDest = ref.watch(patchClashConfigProvider
        .select((state) => state.sniffer.overrideDest));
    return ListItem.switchItem(
      title: Text(appLocalizations.overrideDestination),
      delegate: SwitchDelegate(
        value: overrideDest,
        onChanged: (bool value) async {
          ref.read(patchClashConfigProvider.notifier).updateState(
              (state) => state.copyWith.sniffer(overrideDest: value));
        },
      ),
    );
  }
}

class HttpPortSnifferItem extends ConsumerWidget {
  const HttpPortSnifferItem({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final httpConfig = ref.watch(
        patchClashConfigProvider.select((state) => state.sniffer.sniff['HTTP']));
    final ports = httpConfig?.ports.join(', ') ?? '';
    final overrideDest = httpConfig?.overrideDest ?? false;

    return ListItem.open(
      title: Text(appLocalizations.httpPortSniffer),
      subtitle: Text(ports.isEmpty ? '80, 8080-8880' : ports),
      delegate: OpenDelegate(
        title: appLocalizations.httpPortSniffer,
        widget: Column(
          children: generateSection(
            title: appLocalizations.options,
            items: [
              Consumer(builder: (_, ref, __) {
                return ListItem.input(
                  title: Text(appLocalizations.snifferPorts),
                  subtitle: Text(ports),
                  delegate: InputDelegate(
                    title: appLocalizations.snifferPorts,
                    value: ports,
                    onChanged: (String? value) {
                      if (value == null) return;
                      final newPorts = value.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
                      final newSniff = Map<String, SnifferConfig>.from(
                          ref.read(patchClashConfigProvider).sniffer.sniff);
                      newSniff['HTTP'] = SnifferConfig(
                        ports: newPorts,
                        overrideDest: overrideDest,
                      );
                      ref.read(patchClashConfigProvider.notifier).updateState(
                          (state) => state.copyWith.sniffer(sniff: newSniff));
                    },
                  ),
                );
              }),
              Consumer(builder: (_, ref, __) {
                return ListItem.switchItem(
                  title: Text(appLocalizations.overrideDestination),
                  delegate: SwitchDelegate(
                    value: overrideDest,
                    onChanged: (bool value) {
                      final newSniff = Map<String, SnifferConfig>.from(
                          ref.read(patchClashConfigProvider).sniffer.sniff);
                      newSniff['HTTP'] = SnifferConfig(
                        ports: httpConfig?.ports ?? [],
                        overrideDest: value,
                      );
                      ref.read(patchClashConfigProvider.notifier).updateState(
                          (state) => state.copyWith.sniffer(sniff: newSniff));
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class TlsPortSnifferItem extends ConsumerWidget {
  const TlsPortSnifferItem({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final tlsConfig = ref.watch(
        patchClashConfigProvider.select((state) => state.sniffer.sniff['TLS']));
    final ports = tlsConfig?.ports.join(', ') ?? '';

    return ListItem.input(
      title: Text(appLocalizations.tlsPortSniffer),
      subtitle: Text(ports.isEmpty ? '443, 8443' : ports),
      delegate: InputDelegate(
        title: appLocalizations.tlsPortSniffer,
        value: ports,
        onChanged: (String? value) {
          if (value == null) return;
          final newPorts = value.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
          final newSniff = Map<String, SnifferConfig>.from(
              ref.read(patchClashConfigProvider).sniffer.sniff);
          newSniff['TLS'] = SnifferConfig(ports: newPorts);
          ref.read(patchClashConfigProvider.notifier).updateState(
              (state) => state.copyWith.sniffer(sniff: newSniff));
        },
      ),
    );
  }
}

class QuicPortSnifferItem extends ConsumerWidget {
  const QuicPortSnifferItem({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final quicConfig = ref.watch(
        patchClashConfigProvider.select((state) => state.sniffer.sniff['QUIC']));
    final ports = quicConfig?.ports.join(', ') ?? '';

    return ListItem.input(
      title: Text(appLocalizations.quicPortSniffer),
      subtitle: Text(ports.isEmpty ? '443, 8443' : ports),
      delegate: InputDelegate(
        title: appLocalizations.quicPortSniffer,
        value: ports,
        onChanged: (String? value) {
          if (value == null) return;
          final newPorts = value.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
          final newSniff = Map<String, SnifferConfig>.from(
              ref.read(patchClashConfigProvider).sniffer.sniff);
          newSniff['QUIC'] = SnifferConfig(ports: newPorts);
          ref.read(patchClashConfigProvider.notifier).updateState(
              (state) => state.copyWith.sniffer(sniff: newSniff));
        },
      ),
    );
  }
}

class ForceDomainWidget extends ConsumerWidget {
  const ForceDomainWidget({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final forceDomain = ref.watch(patchClashConfigProvider
        .select((state) => state.sniffer.forceDomain));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            appLocalizations.forceDomain,
            style: context.textTheme.titleMedium?.copyWith(
              color: context.colorScheme.primary,
            ),
          ),
        ),
        if (forceDomain.isNotEmpty)
          ...forceDomain.asMap().entries.map((entry) {
            final index = entry.key;
            final domain = entry.value;
            return ListItem(
              title: Text(domain),
              onTap: () => _showDomainDialog(
                context,
                ref,
                forceDomain,
                title: appLocalizations.forceDomain,
                value: domain,
                index: index,
                onSave: (newList) {
                  ref.read(patchClashConfigProvider.notifier).updateState(
                      (state) => state.copyWith.sniffer(forceDomain: newList));
                },
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _deleteItem(ref, forceDomain, index, (newList) {
                  ref.read(patchClashConfigProvider.notifier).updateState(
                      (state) => state.copyWith.sniffer(forceDomain: newList));
                }),
              ),
            );
          }),
      ],
    );
  }

  void _deleteItem(WidgetRef ref, List<String> list, int index, Function(List<String>) onSave) {
    final newList = List<String>.from(list);
    newList.removeAt(index);
    onSave(newList);
  }

  void _showDomainDialog(
    BuildContext context,
    WidgetRef ref,
    List<String> list, {
    required String title,
    String? value,
    int? index,
    required Function(List<String>) onSave,
  }) async {
    final result = await globalState.showCommonDialog<String>(
      child: InputDialog(
        autofocus: true,
        title: title,
        labelText: appLocalizations.domain,
        value: value ?? '',
        validator: (v) {
          if (v == null || v.isEmpty) {
            return appLocalizations.emptyTip(appLocalizations.domain);
          }
          return null;
        },
      ),
    );
    if (result != null) {
      final newList = List<String>.from(list);
      if (index != null) {
        newList[index] = result;
      } else {
        newList.add(result);
      }
      onSave(newList);
    }
  }
}

class SkipDomainWidget extends ConsumerWidget {
  const SkipDomainWidget({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final skipDomain = ref.watch(patchClashConfigProvider
        .select((state) => state.sniffer.skipDomain));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            appLocalizations.skipDomain,
            style: context.textTheme.titleMedium?.copyWith(
              color: context.colorScheme.primary,
            ),
          ),
        ),
        if (skipDomain.isNotEmpty)
          ...skipDomain.asMap().entries.map((entry) {
            final index = entry.key;
            final domain = entry.value;
            return ListItem(
              title: Text(domain),
              onTap: () => _showDomainDialog(
                context,
                ref,
                skipDomain,
                title: appLocalizations.skipDomain,
                value: domain,
                index: index,
                onSave: (newList) {
                  ref.read(patchClashConfigProvider.notifier).updateState(
                      (state) => state.copyWith.sniffer(skipDomain: newList));
                },
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _deleteItem(ref, skipDomain, index, (newList) {
                  ref.read(patchClashConfigProvider.notifier).updateState(
                      (state) => state.copyWith.sniffer(skipDomain: newList));
                }),
              ),
            );
          }),
      ],
    );
  }

  void _deleteItem(WidgetRef ref, List<String> list, int index, Function(List<String>) onSave) {
    final newList = List<String>.from(list);
    newList.removeAt(index);
    onSave(newList);
  }

  void _showDomainDialog(
    BuildContext context,
    WidgetRef ref,
    List<String> list, {
    required String title,
    String? value,
    int? index,
    required Function(List<String>) onSave,
  }) async {
    final result = await globalState.showCommonDialog<String>(
      child: InputDialog(
        autofocus: true,
        title: title,
        labelText: appLocalizations.domain,
        value: value ?? '',
        validator: (v) {
          if (v == null || v.isEmpty) {
            return appLocalizations.emptyTip(appLocalizations.domain);
          }
          return null;
        },
      ),
    );
    if (result != null) {
      final newList = List<String>.from(list);
      if (index != null) {
        newList[index] = result;
      } else {
        newList.add(result);
      }
      onSave(newList);
    }
  }
}

class SkipSrcAddressWidget extends ConsumerWidget {
  const SkipSrcAddressWidget({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final skipSrcAddress = ref.watch(patchClashConfigProvider
        .select((state) => state.sniffer.skipSrcAddress));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            appLocalizations.skipSrcAddress,
            style: context.textTheme.titleMedium?.copyWith(
              color: context.colorScheme.primary,
            ),
          ),
        ),
        if (skipSrcAddress.isNotEmpty)
          ...skipSrcAddress.asMap().entries.map((entry) {
            final index = entry.key;
            final address = entry.value;
            return ListItem(
              title: Text(address),
              onTap: () => _showAddressDialog(
                context,
                ref,
                skipSrcAddress,
                title: appLocalizations.skipSrcAddress,
                value: address,
                index: index,
                onSave: (newList) {
                  ref.read(patchClashConfigProvider.notifier).updateState(
                      (state) => state.copyWith.sniffer(skipSrcAddress: newList));
                },
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _deleteItem(ref, skipSrcAddress, index, (newList) {
                  ref.read(patchClashConfigProvider.notifier).updateState(
                      (state) => state.copyWith.sniffer(skipSrcAddress: newList));
                }),
              ),
            );
          }),
      ],
    );
  }

  void _deleteItem(WidgetRef ref, List<String> list, int index, Function(List<String>) onSave) {
    final newList = List<String>.from(list);
    newList.removeAt(index);
    onSave(newList);
  }

  void _showAddressDialog(
    BuildContext context,
    WidgetRef ref,
    List<String> list, {
    required String title,
    String? value,
    int? index,
    required Function(List<String>) onSave,
  }) async {
    final result = await globalState.showCommonDialog<String>(
      child: InputDialog(
        autofocus: true,
        title: title,
        labelText: appLocalizations.address,
        value: value ?? '',
        validator: (v) {
          if (v == null || v.isEmpty) {
            return appLocalizations.emptyTip(appLocalizations.address);
          }
          return null;
        },
      ),
    );
    if (result != null) {
      final newList = List<String>.from(list);
      if (index != null) {
        newList[index] = result;
      } else {
        newList.add(result);
      }
      onSave(newList);
    }
  }
}

class SkipDstAddressWidget extends ConsumerWidget {
  const SkipDstAddressWidget({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final skipDstAddress = ref.watch(patchClashConfigProvider
        .select((state) => state.sniffer.skipDstAddress));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            appLocalizations.skipDstAddress,
            style: context.textTheme.titleMedium?.copyWith(
              color: context.colorScheme.primary,
            ),
          ),
        ),
        if (skipDstAddress.isNotEmpty)
          ...skipDstAddress.asMap().entries.map((entry) {
            final index = entry.key;
            final address = entry.value;
            return ListItem(
              title: Text(address),
              onTap: () => _showAddressDialog(
                context,
                ref,
                skipDstAddress,
                title: appLocalizations.skipDstAddress,
                value: address,
                index: index,
                onSave: (newList) {
                  ref.read(patchClashConfigProvider.notifier).updateState(
                      (state) => state.copyWith.sniffer(skipDstAddress: newList));
                },
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _deleteItem(ref, skipDstAddress, index, (newList) {
                  ref.read(patchClashConfigProvider.notifier).updateState(
                      (state) => state.copyWith.sniffer(skipDstAddress: newList));
                }),
              ),
            );
          }),
      ],
    );
  }

  void _deleteItem(WidgetRef ref, List<String> list, int index, Function(List<String>) onSave) {
    final newList = List<String>.from(list);
    newList.removeAt(index);
    onSave(newList);
  }

  void _showAddressDialog(
    BuildContext context,
    WidgetRef ref,
    List<String> list, {
    required String title,
    String? value,
    int? index,
    required Function(List<String>) onSave,
  }) async {
    final result = await globalState.showCommonDialog<String>(
      child: InputDialog(
        autofocus: true,
        title: title,
        labelText: appLocalizations.address,
        value: value ?? '',
        validator: (v) {
          if (v == null || v.isEmpty) {
            return appLocalizations.emptyTip(appLocalizations.address);
          }
          return null;
        },
      ),
    );
    if (result != null) {
      final newList = List<String>.from(list);
      if (index != null) {
        newList[index] = result;
      } else {
        newList.add(result);
      }
      onSave(newList);
    }
  }
}

class SnifferOptions extends StatelessWidget {
  const SnifferOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: generateSection(
        title: appLocalizations.options,
        items: [
          const SnifferStatusItem(),
          const ForceDnsMappingItem(),
          const ParsePureIpItem(),
          const OverrideDestinationItem(),
          const HttpPortSnifferItem(),
          const TlsPortSnifferItem(),
          const QuicPortSnifferItem(),
          const ForceDomainWidget(),
          const SkipDomainWidget(),
          const SkipSrcAddressWidget(),
          const SkipDstAddressWidget(),
        ],
      ),
    );
  }
}

const snifferItems = <Widget>[
  OverrideSnifferItem(),
  SnifferOptions(),
];

class SnifferListView extends ConsumerWidget {
  const SnifferListView({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      body: generateListView(snifferItems),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddMenu(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddMenu(BuildContext context, WidgetRef ref) async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(appLocalizations.add),
        children: [
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, 'forceDomain'),
            child: Text(appLocalizations.forceDomain),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, 'skipDomain'),
            child: Text(appLocalizations.skipDomain),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, 'skipSrcAddress'),
            child: Text(appLocalizations.skipSrcAddress),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, 'skipDstAddress'),
            child: Text(appLocalizations.skipDstAddress),
          ),
        ],
      ),
    );

    if (result == null || !context.mounted) return;

    switch (result) {
      case 'forceDomain':
        _showDomainDialog(context, ref, appLocalizations.forceDomain, (value) {
          final forceDomain = ref.read(patchClashConfigProvider).sniffer.forceDomain;
          final newList = List<String>.from(forceDomain)..add(value);
          ref.read(patchClashConfigProvider.notifier).updateState(
              (state) => state.copyWith.sniffer(forceDomain: newList));
        });
        break;
      case 'skipDomain':
        _showDomainDialog(context, ref, appLocalizations.skipDomain, (value) {
          final skipDomain = ref.read(patchClashConfigProvider).sniffer.skipDomain;
          final newList = List<String>.from(skipDomain)..add(value);
          ref.read(patchClashConfigProvider.notifier).updateState(
              (state) => state.copyWith.sniffer(skipDomain: newList));
        });
        break;
      case 'skipSrcAddress':
        _showAddressDialog(context, ref, appLocalizations.skipSrcAddress, (value) {
          final skipSrcAddress = ref.read(patchClashConfigProvider).sniffer.skipSrcAddress;
          final newList = List<String>.from(skipSrcAddress)..add(value);
          ref.read(patchClashConfigProvider.notifier).updateState(
              (state) => state.copyWith.sniffer(skipSrcAddress: newList));
        });
        break;
      case 'skipDstAddress':
        _showAddressDialog(context, ref, appLocalizations.skipDstAddress, (value) {
          final skipDstAddress = ref.read(patchClashConfigProvider).sniffer.skipDstAddress;
          final newList = List<String>.from(skipDstAddress)..add(value);
          ref.read(patchClashConfigProvider.notifier).updateState(
              (state) => state.copyWith.sniffer(skipDstAddress: newList));
        });
        break;
    }
  }

  void _showDomainDialog(BuildContext context, WidgetRef ref, String title, Function(String) onSave) async {
    final result = await globalState.showCommonDialog<String>(
      child: InputDialog(
        autofocus: true,
        title: title,
        labelText: appLocalizations.domain,
        value: '',
        validator: (v) {
          if (v == null || v.isEmpty) {
            return appLocalizations.emptyTip(appLocalizations.domain);
          }
          return null;
        },
      ),
    );
    if (result != null) {
      onSave(result);
    }
  }

  void _showAddressDialog(BuildContext context, WidgetRef ref, String title, Function(String) onSave) async {
    final result = await globalState.showCommonDialog<String>(
      child: InputDialog(
        autofocus: true,
        title: title,
        labelText: appLocalizations.address,
        value: '',
        validator: (v) {
          if (v == null || v.isEmpty) {
            return appLocalizations.emptyTip(appLocalizations.address);
          }
          return null;
        },
      ),
    );
    if (result != null) {
      onSave(result);
    }
  }
}
