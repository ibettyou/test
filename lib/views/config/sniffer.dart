import 'package:li_clash/common/common.dart';
import 'package:li_clash/models/clash_config.dart';
import 'package:li_clash/providers/config.dart';
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
      subtitle: Text(appLocalizations.forceDnsMappingDesc),
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
      subtitle: Text(appLocalizations.parsePureIpDesc),
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
      subtitle: Text(appLocalizations.overrideDestinationDesc),
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

class ForceDomainItem extends ConsumerWidget {
  const ForceDomainItem({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final forceDomain = ref.watch(patchClashConfigProvider
        .select((state) => state.sniffer.forceDomain));
    final value = forceDomain.join('\n');

    return ListItem.input(
      title: Text(appLocalizations.forceDomain),
      subtitle: Text(forceDomain.isEmpty ? appLocalizations.snifferDomainHint : '${forceDomain.length}'),
      delegate: InputDelegate(
        title: appLocalizations.forceDomain,
        value: value,
        onChanged: (String? value) {
          if (value == null) return;
          final newList = value.split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
          ref.read(patchClashConfigProvider.notifier).updateState(
              (state) => state.copyWith.sniffer(forceDomain: newList));
        },
      ),
    );
  }
}

class SkipDomainItem extends ConsumerWidget {
  const SkipDomainItem({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final skipDomain = ref.watch(patchClashConfigProvider
        .select((state) => state.sniffer.skipDomain));
    final value = skipDomain.join('\n');

    return ListItem.input(
      title: Text(appLocalizations.skipDomain),
      subtitle: Text(skipDomain.isEmpty ? appLocalizations.snifferDomainHint : '${skipDomain.length}'),
      delegate: InputDelegate(
        title: appLocalizations.skipDomain,
        value: value,
        onChanged: (String? value) {
          if (value == null) return;
          final newList = value.split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
          ref.read(patchClashConfigProvider.notifier).updateState(
              (state) => state.copyWith.sniffer(skipDomain: newList));
        },
      ),
    );
  }
}

class SkipSrcAddressItem extends ConsumerWidget {
  const SkipSrcAddressItem({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final skipSrcAddress = ref.watch(patchClashConfigProvider
        .select((state) => state.sniffer.skipSrcAddress));
    final value = skipSrcAddress.join('\n');

    return ListItem.input(
      title: Text(appLocalizations.skipSrcAddress),
      subtitle: Text(skipSrcAddress.isEmpty ? appLocalizations.snifferAddressHint : '${skipSrcAddress.length}'),
      delegate: InputDelegate(
        title: appLocalizations.skipSrcAddress,
        value: value,
        onChanged: (String? value) {
          if (value == null) return;
          final newList = value.split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
          ref.read(patchClashConfigProvider.notifier).updateState(
              (state) => state.copyWith.sniffer(skipSrcAddress: newList));
        },
      ),
    );
  }
}

class SkipDstAddressItem extends ConsumerWidget {
  const SkipDstAddressItem({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final skipDstAddress = ref.watch(patchClashConfigProvider
        .select((state) => state.sniffer.skipDstAddress));
    final value = skipDstAddress.join('\n');

    return ListItem.input(
      title: Text(appLocalizations.skipDstAddress),
      subtitle: Text(skipDstAddress.isEmpty ? appLocalizations.snifferAddressHint : '${skipDstAddress.length}'),
      delegate: InputDelegate(
        title: appLocalizations.skipDstAddress,
        value: value,
        onChanged: (String? value) {
          if (value == null) return;
          final newList = value.split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
          ref.read(patchClashConfigProvider.notifier).updateState(
              (state) => state.copyWith.sniffer(skipDstAddress: newList));
        },
      ),
    );
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
          const ForceDomainItem(),
          const SkipDomainItem(),
          const SkipSrcAddressItem(),
          const SkipDstAddressItem(),
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
    return generateListView(
      snifferItems,
    );
  }
}
