// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../clash_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProxyGroupImpl _$$ProxyGroupImplFromJson(Map<String, dynamic> json) =>
    _$ProxyGroupImpl(
      name: json['name'] as String,
      type: GroupType.parseProfileType(json['type'] as String),
      proxies:
          (json['proxies'] as List<dynamic>?)?.map((e) => e as String).toList(),
      use: (json['use'] as List<dynamic>?)?.map((e) => e as String).toList(),
      interval: (json['interval'] as num?)?.toInt(),
      lazy: json['lazy'] as bool?,
      url: json['url'] as String?,
      timeout: (json['timeout'] as num?)?.toInt(),
      maxFailedTimes: (json['max-failed-times'] as num?)?.toInt(),
      filter: json['filter'] as String?,
      excludeFilter: json['expected-filter'] as String?,
      excludeType: json['exclude-type'] as String?,
      expectedStatus: json['expected-status'],
      hidden: json['hidden'] as bool?,
      icon: json['icon'] as String?,
    );

Map<String, dynamic> _$$ProxyGroupImplToJson(_$ProxyGroupImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': _$GroupTypeEnumMap[instance.type]!,
      'proxies': instance.proxies,
      'use': instance.use,
      'interval': instance.interval,
      'lazy': instance.lazy,
      'url': instance.url,
      'timeout': instance.timeout,
      'max-failed-times': instance.maxFailedTimes,
      'filter': instance.filter,
      'expected-filter': instance.excludeFilter,
      'exclude-type': instance.excludeType,
      'expected-status': instance.expectedStatus,
      'hidden': instance.hidden,
      'icon': instance.icon,
    };

const _$GroupTypeEnumMap = {
  GroupType.Selector: 'Selector',
  GroupType.URLTest: 'URLTest',
  GroupType.Fallback: 'Fallback',
  GroupType.LoadBalance: 'LoadBalance',
  GroupType.Relay: 'Relay',
};

_$RuleProviderImpl _$$RuleProviderImplFromJson(Map<String, dynamic> json) =>
    _$RuleProviderImpl(
      name: json['name'] as String,
    );

Map<String, dynamic> _$$RuleProviderImplToJson(_$RuleProviderImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
    };

_$SnifferImpl _$$SnifferImplFromJson(Map<String, dynamic> json) =>
    _$SnifferImpl(
      enable: json['enable'] as bool? ?? true,
      overrideDest: json['override-destination'] as bool? ?? false,
      sniffing: (json['sniffing'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      forceDomain: (json['force-domain'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const ['+.v2ex.com'],
      skipSrcAddress: (json['skip-src-address'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const ['192.168.0.3/32'],
      skipDstAddress: (json['skip-dst-address'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const ['geoip:telegram'],
      skipDomain: (json['skip-domain'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const ['Mijia Cloud', '+.push.apple.com'],
      port: (json['port-whitelist'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      forceDnsMapping: json['force-dns-mapping'] as bool? ?? true,
      parsePureIp: json['parse-pure-ip'] as bool? ?? true,
      sniff: (json['sniff'] as Map<String, dynamic>?)?.map(
            (k, e) =>
                MapEntry(k, SnifferConfig.fromJson(e as Map<String, dynamic>)),
          ) ??
          const {
            'HTTP':
                SnifferConfig(ports: ['80', '8080-8880'], overrideDest: true),
            'TLS': SnifferConfig(ports: ['443', '8443']),
            'QUIC': SnifferConfig(ports: ['443', '8443'])
          },
    );

Map<String, dynamic> _$$SnifferImplToJson(_$SnifferImpl instance) =>
    <String, dynamic>{
      'enable': instance.enable,
      'override-destination': instance.overrideDest,
      'sniffing': instance.sniffing,
      'force-domain': instance.forceDomain,
      'skip-src-address': instance.skipSrcAddress,
      'skip-dst-address': instance.skipDstAddress,
      'skip-domain': instance.skipDomain,
      'port-whitelist': instance.port,
      'force-dns-mapping': instance.forceDnsMapping,
      'parse-pure-ip': instance.parsePureIp,
      'sniff': instance.sniff,
    };

_$TunnelEntryImpl _$$TunnelEntryImplFromJson(Map<String, dynamic> json) =>
    _$TunnelEntryImpl(
      id: json['id'] as String,
      network:
          (json['network'] as List<dynamic>?)?.map((e) => e as String).toList(),
      address: json['address'] as String?,
      target: json['target'] as String?,
      proxyName: json['proxyName'] as String?,
    );

Map<String, dynamic> _$$TunnelEntryImplToJson(_$TunnelEntryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'network': instance.network,
      'address': instance.address,
      'target': instance.target,
      'proxyName': instance.proxyName,
    };

_$SnifferConfigImpl _$$SnifferConfigImplFromJson(Map<String, dynamic> json) =>
    _$SnifferConfigImpl(
      ports: json['ports'] == null
          ? const []
          : _formJsonPorts(json['ports'] as List?),
      overrideDest: json['override-destination'] as bool?,
    );

Map<String, dynamic> _$$SnifferConfigImplToJson(_$SnifferConfigImpl instance) =>
    <String, dynamic>{
      'ports': instance.ports,
      'override-destination': instance.overrideDest,
    };

_$TunImpl _$$TunImplFromJson(Map<String, dynamic> json) => _$TunImpl(
      enable: json['enable'] as bool? ?? false,
      device: json['device'] as String? ?? tunDeviceName,
      autoRoute: json['auto-route'] as bool? ?? false,
      stack: $enumDecodeNullable(_$TunStackEnumMap, json['stack']) ??
          TunStack.system,
      dnsHijack: (json['dns-hijack'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const ['any:53', 'tcp://any:53'],
      routeAddress: (json['route-address'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      disableIcmpForwarding: json['disable-icmp-forwarding'] as bool? ?? true,
      mtu: (json['mtu'] as num?)?.toInt() ?? 1480,
    );

Map<String, dynamic> _$$TunImplToJson(_$TunImpl instance) => <String, dynamic>{
      'enable': instance.enable,
      'device': instance.device,
      'auto-route': instance.autoRoute,
      'stack': _$TunStackEnumMap[instance.stack]!,
      'dns-hijack': instance.dnsHijack,
      'route-address': instance.routeAddress,
      'disable-icmp-forwarding': instance.disableIcmpForwarding,
      'mtu': instance.mtu,
    };

const _$TunStackEnumMap = {
  TunStack.gvisor: 'gvisor',
  TunStack.system: 'system',
  TunStack.mixed: 'mixed',
};

_$FallbackFilterImpl _$$FallbackFilterImplFromJson(Map<String, dynamic> json) =>
    _$FallbackFilterImpl(
      geoip: json['geoip'] as bool? ?? false,
      geoipCode: json['geoip-code'] as String? ?? 'CN',
      geosite: (json['geosite'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      ipcidr: (json['ipcidr'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      domain: (json['domain'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$FallbackFilterImplToJson(
        _$FallbackFilterImpl instance) =>
    <String, dynamic>{
      'geoip': instance.geoip,
      'geoip-code': instance.geoipCode,
      'geosite': instance.geosite,
      'ipcidr': instance.ipcidr,
      'domain': instance.domain,
    };

_$DnsImpl _$$DnsImplFromJson(Map<String, dynamic> json) => _$DnsImpl(
      enable: json['enable'] as bool? ?? true,
      listen: json['listen'] as String? ?? '0.0.0.0:10053',
      preferH3: json['prefer-h3'] as bool? ?? false,
      cacheAlgorithm: $enumDecodeNullable(
              _$CacheAlgorithmEnumMap, json['cache-algorithm']) ??
          CacheAlgorithm.arc,
      useHosts: json['use-hosts'] as bool? ?? true,
      useSystemHosts: json['use-system-hosts'] as bool? ?? true,
      respectRules: json['respect-rules'] as bool? ?? false,
      ipv6: json['ipv6'] as bool? ?? false,
      defaultNameserver: (json['default-nameserver'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const ['114.114.114.114'],
      enhancedMode:
          $enumDecodeNullable(_$DnsModeEnumMap, json['enhanced-mode']) ??
              DnsMode.fakeIp,
      fakeIpRange: json['fake-ip-range'] as String? ?? '198.18.0.1/15',
      fakeIpRangeV6: json['fake-ip-range-v6'] as String? ?? 'fc00::/18',
      fakeIpFilter: (json['fake-ip-filter'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const ['*', 'geosite:private', 'geosite:geolocation-cn'],
      fakeIpTtl: (json['fake-ip-ttl'] as num?)?.toInt() ?? 1,
      nameserverPolicy:
          (json['nameserver-policy'] as Map<String, dynamic>?)?.map(
                (k, e) => MapEntry(k, e as String),
              ) ??
              const {
                '+.internal.crop.com': '10.0.0.1',
                'geosite:private': 'system',
                'geosite:cn': 'system'
              },
      nameserver: (json['nameserver'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const ['1.1.1.1', '1.0.0.1'],
      fallback: (json['fallback'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      proxyServerNameserver: (json['proxy-server-nameserver'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const ['https://doh.pub/dns-query'],
      directNameserver: (json['direct-nameserver'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      directNameserverFollowPolicy:
          json['direct-nameserver-follow-policy'] as bool? ?? false,
      fallbackFilter: json['fallback-filter'] == null
          ? const FallbackFilter()
          : FallbackFilter.fromJson(
              json['fallback-filter'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$DnsImplToJson(_$DnsImpl instance) => <String, dynamic>{
      'enable': instance.enable,
      'listen': instance.listen,
      'prefer-h3': instance.preferH3,
      'cache-algorithm': _$CacheAlgorithmEnumMap[instance.cacheAlgorithm]!,
      'use-hosts': instance.useHosts,
      'use-system-hosts': instance.useSystemHosts,
      'respect-rules': instance.respectRules,
      'ipv6': instance.ipv6,
      'default-nameserver': instance.defaultNameserver,
      'enhanced-mode': _$DnsModeEnumMap[instance.enhancedMode]!,
      'fake-ip-range': instance.fakeIpRange,
      'fake-ip-range-v6': instance.fakeIpRangeV6,
      'fake-ip-filter': instance.fakeIpFilter,
      'fake-ip-ttl': instance.fakeIpTtl,
      'nameserver-policy': instance.nameserverPolicy,
      'nameserver': instance.nameserver,
      'fallback': instance.fallback,
      'proxy-server-nameserver': instance.proxyServerNameserver,
      'direct-nameserver': instance.directNameserver,
      'direct-nameserver-follow-policy': instance.directNameserverFollowPolicy,
      'fallback-filter': instance.fallbackFilter,
    };

const _$CacheAlgorithmEnumMap = {
  CacheAlgorithm.arc: 'arc',
  CacheAlgorithm.lru: 'lru',
};

const _$DnsModeEnumMap = {
  DnsMode.normal: 'normal',
  DnsMode.fakeIp: 'fake-ip',
  DnsMode.redirHost: 'redir-host',
  DnsMode.hosts: 'hosts',
};

_$NtpImpl _$$NtpImplFromJson(Map<String, dynamic> json) => _$NtpImpl(
      enable: json['enable'] as bool? ?? true,
      writeToSystem: json['write-to-system'] as bool? ?? false,
      server: json['server'] as String? ?? 'ntp.aliyun.com',
      port: (json['port'] as num?)?.toInt() ?? 123,
      interval: (json['interval'] as num?)?.toInt() ?? 60,
    );

Map<String, dynamic> _$$NtpImplToJson(_$NtpImpl instance) => <String, dynamic>{
      'enable': instance.enable,
      'write-to-system': instance.writeToSystem,
      'server': instance.server,
      'port': instance.port,
      'interval': instance.interval,
    };

_$ExperimentalImpl _$$ExperimentalImplFromJson(Map<String, dynamic> json) =>
    _$ExperimentalImpl(
      quicGoDisableGso: json['quic-go-disable-gso'] as bool? ?? false,
      quicGoDisableEcn: json['quic-go-disable-ecn'] as bool? ?? false,
      dialerIp4pConvert: json['dialer-ip4p-convert'] as bool? ?? false,
    );

Map<String, dynamic> _$$ExperimentalImplToJson(_$ExperimentalImpl instance) =>
    <String, dynamic>{
      'quic-go-disable-gso': instance.quicGoDisableGso,
      'quic-go-disable-ecn': instance.quicGoDisableEcn,
      'dialer-ip4p-convert': instance.dialerIp4pConvert,
    };

_$GeoXUrlImpl _$$GeoXUrlImplFromJson(Map<String, dynamic> json) =>
    _$GeoXUrlImpl(
      mmdb: json['mmdb'] as String? ??
          'https://cdn.jsdelivr.net/gh/Loyalsoldier/geoip@release/Country-only-cn-private.mmdb',
      asn: json['asn'] as String? ??
          'https://cdn.jsdelivr.net/gh/Loyalsoldier/geoip@release/Country-asn.mmdb',
      geoip: json['geoip'] as String? ??
          'https://cdn.jsdelivr.net/gh/Loyalsoldier/geoip@release/geoip-only-cn-private.dat',
      geosite: json['geosite'] as String? ??
          'https://cdn.jsdelivr.net/gh/Loyalsoldier/v2ray-rules-dat@release/geosite.dat',
    );

Map<String, dynamic> _$$GeoXUrlImplToJson(_$GeoXUrlImpl instance) =>
    <String, dynamic>{
      'mmdb': instance.mmdb,
      'asn': instance.asn,
      'geoip': instance.geoip,
      'geosite': instance.geosite,
    };

_$RuleImpl _$$RuleImplFromJson(Map<String, dynamic> json) => _$RuleImpl(
      id: json['id'] as String,
      value: json['value'] as String,
    );

Map<String, dynamic> _$$RuleImplToJson(_$RuleImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'value': instance.value,
    };

_$SubRuleImpl _$$SubRuleImplFromJson(Map<String, dynamic> json) =>
    _$SubRuleImpl(
      name: json['name'] as String,
    );

Map<String, dynamic> _$$SubRuleImplToJson(_$SubRuleImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
    };

_$ClashConfigSnippetImpl _$$ClashConfigSnippetImplFromJson(
        Map<String, dynamic> json) =>
    _$ClashConfigSnippetImpl(
      proxyGroups: (json['proxy-groups'] as List<dynamic>?)
              ?.map((e) => ProxyGroup.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      rule: json['rules'] == null ? const [] : _genRule(json['rules'] as List?),
      ruleProvider: json['rule-providers'] == null
          ? const []
          : _genRuleProviders(json['rule-providers'] as Map<String, dynamic>),
      subRules: json['sub-rules'] == null
          ? const []
          : _genSubRules(json['sub-rules'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ClashConfigSnippetImplToJson(
        _$ClashConfigSnippetImpl instance) =>
    <String, dynamic>{
      'proxy-groups': instance.proxyGroups,
      'rules': instance.rule,
      'rule-providers': instance.ruleProvider,
      'sub-rules': instance.subRules,
    };

_$ClashConfigImpl _$$ClashConfigImplFromJson(Map<String, dynamic> json) =>
    _$ClashConfigImpl(
      mixedPort: (json['mixed-port'] as num?)?.toInt() ?? defaultMixedPort,
      socksPort: (json['socks-port'] as num?)?.toInt() ?? 0,
      port: (json['port'] as num?)?.toInt() ?? 0,
      redirPort: (json['redir-port'] as num?)?.toInt() ?? 0,
      tproxyPort: (json['tproxy-port'] as num?)?.toInt() ?? 0,
      mode: $enumDecodeNullable(_$ModeEnumMap, json['mode']) ?? Mode.rule,
      allowLan: json['allow-lan'] as bool? ?? false,
      logLevel: $enumDecodeNullable(_$LogLevelEnumMap, json['log-level']) ??
          LogLevel.error,
      ipv6: json['ipv6'] as bool? ?? false,
      findProcessMode: $enumDecodeNullable(
              _$FindProcessModeEnumMap, json['find-process-mode'],
              unknownValue: FindProcessMode.always) ??
          FindProcessMode.off,
      keepAliveInterval: (json['keep-alive-interval'] as num?)?.toInt() ??
          defaultKeepAliveInterval,
      unifiedDelay: json['unified-delay'] as bool? ?? true,
      tcpConcurrent: json['tcp-concurrent'] as bool? ?? true,
      tun: json['tun'] == null
          ? defaultTun
          : Tun.safeFormJson(json['tun'] as Map<String, Object?>?),
      dns: json['dns'] == null
          ? defaultDns
          : Dns.safeDnsFromJson(json['dns'] as Map<String, Object?>),
      ntp: json['ntp'] == null
          ? defaultNtp
          : Ntp.safeNtpFromJson(json['ntp'] as Map<String, Object?>),
      sniffer: json['sniffer'] == null
          ? defaultSniffer
          : Sniffer.safeSnifferFromJson(
              json['sniffer'] as Map<String, Object?>),
      tunnels: (json['tunnels'] as List<dynamic>?)
              ?.map((e) => TunnelEntry.fromJson(e as Map<String, dynamic>))
              .toList() ??
          defaultTunnel,
      experimental: json['experimental'] == null
          ? defaultExperimental
          : Experimental.safeExperimentalFromJson(
              json['experimental'] as Map<String, Object?>),
      geoXUrl: json['geox-url'] == null
          ? defaultGeoXUrl
          : GeoXUrl.safeFormJson(json['geox-url'] as Map<String, Object?>?),
      geodataLoader:
          $enumDecodeNullable(_$GeodataLoaderEnumMap, json['geodata-loader']) ??
              GeodataLoader.memconservative,
      proxyGroups: (json['proxy-groups'] as List<dynamic>?)
              ?.map((e) => ProxyGroup.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      rule:
          (json['rule'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      globalUa: json['global-ua'] as String?,
      externalController: $enumDecodeNullable(
              _$ExternalControllerStatusEnumMap, json['external-controller']) ??
          ExternalControllerStatus.close,
      externalUiUrl: json['external-ui-url'] as String? ?? '',
      hosts: (json['hosts'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const {},
    );

Map<String, dynamic> _$$ClashConfigImplToJson(_$ClashConfigImpl instance) =>
    <String, dynamic>{
      'mixed-port': instance.mixedPort,
      'socks-port': instance.socksPort,
      'port': instance.port,
      'redir-port': instance.redirPort,
      'tproxy-port': instance.tproxyPort,
      'mode': _$ModeEnumMap[instance.mode]!,
      'allow-lan': instance.allowLan,
      'log-level': _$LogLevelEnumMap[instance.logLevel]!,
      'ipv6': instance.ipv6,
      'find-process-mode': _$FindProcessModeEnumMap[instance.findProcessMode]!,
      'keep-alive-interval': instance.keepAliveInterval,
      'unified-delay': instance.unifiedDelay,
      'tcp-concurrent': instance.tcpConcurrent,
      'tun': instance.tun,
      'dns': instance.dns,
      'ntp': instance.ntp,
      'sniffer': instance.sniffer,
      'tunnels': instance.tunnels,
      'experimental': instance.experimental,
      'geox-url': instance.geoXUrl,
      'geodata-loader': _$GeodataLoaderEnumMap[instance.geodataLoader]!,
      'proxy-groups': instance.proxyGroups,
      'rule': instance.rule,
      'global-ua': instance.globalUa,
      'external-controller':
          _$ExternalControllerStatusEnumMap[instance.externalController]!,
      'external-ui-url': instance.externalUiUrl,
      'hosts': instance.hosts,
    };

const _$ModeEnumMap = {
  Mode.rule: 'rule',
  Mode.global: 'global',
  Mode.direct: 'direct',
};

const _$LogLevelEnumMap = {
  LogLevel.debug: 'debug',
  LogLevel.info: 'info',
  LogLevel.warning: 'warning',
  LogLevel.error: 'error',
  LogLevel.silent: 'silent',
};

const _$FindProcessModeEnumMap = {
  FindProcessMode.always: 'always',
  FindProcessMode.off: 'off',
};

const _$GeodataLoaderEnumMap = {
  GeodataLoader.standard: 'standard',
  GeodataLoader.memconservative: 'memconservative',
};

const _$ExternalControllerStatusEnumMap = {
  ExternalControllerStatus.close: '',
  ExternalControllerStatus.open: '127.0.0.1:9090',
};
