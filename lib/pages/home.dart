import 'package:li_clash/common/common.dart';
import 'package:li_clash/enum/enum.dart';
import 'package:li_clash/providers/providers.dart';
import 'package:li_clash/state.dart';
import 'package:li_clash/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef OnSelected = void Function(int index);

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeBackScope(
      child: Material(
        color: context.colorScheme.surface,
        child: Consumer(
          builder: (context, ref, __) {
            final state = ref.watch(navigationStateProvider);
            final isMobile = state.viewMode == ViewMode.mobile;
            final navigationItems = state.navigationItems;
            final pageView = _HomePageView(pageBuilder: (_, index) {
              final navigationItem = state.navigationItems[index];
              final navigationView = navigationItem.builder(context);
              
              // 监听 groups 变化，用于强制刷新代理页面
              final groupsLen = ref.watch(currentGroupsStateProvider).value.length;
              
              final view = isMobile
                  ? KeepScope(
                      keep: navigationItem.keep,
                      child: navigationView,
                    )
                  : KeepScope(
                      keep: navigationItem.keep,
                      child: Navigator(
                        // 当 groups 数量变化时（特别是从0变多），强制重建 Navigator
                        key: navigationItem.label == PageLabel.proxies
                            ? ValueKey('${navigationItem.label}_$groupsLen')
                            : null,
                        onGenerateRoute: (_) {
                          return CommonRoute(
                            builder: (_) => navigationView,
                          );
                        },
                      ),
                    );
              return view;
            });
            final currentIndex = state.currentIndex;
            final isAnimateToPage = ref.watch(
              appSettingProvider.select((state) => state.isAnimateToPage),
            );
            final bottomNavigationBar = GoogleBottomNavBar(
              navigationItems: navigationItems,
              selectedIndex: currentIndex,
              enableAnimation: isAnimateToPage,
              onTabChange: (index) {
                globalState.appController.toPage(
                  navigationItems[index].label,
                );
              },
            );
            if (isMobile) {
              return AnnotatedRegion<SystemUiOverlayStyle>(
                value: globalState.appState.systemUiOverlayStyle.copyWith(
                  systemNavigationBarColor:
                      context.colorScheme.surfaceContainer,
                ),
                child: Column(
                  children: [
                    Flexible(
                      flex: 1,
                      child: MediaQuery.removePadding(
                        removeTop: false,
                        removeBottom: true,
                        removeLeft: true,
                        removeRight: true,
                        context: context,
                        child: pageView,
                      ),
                    ),
                    MediaQuery.removePadding(
                      removeTop: true,
                      removeBottom: false,
                      removeLeft: true,
                      removeRight: true,
                      context: context,
                      child: bottomNavigationBar,
                    ),
                  ],
                ),
              );
            } else {
              return pageView;
            }
          },
        ),
      ),
    );
  }
}

class _HomePageView extends ConsumerStatefulWidget {
  final IndexedWidgetBuilder pageBuilder;

  const _HomePageView({
    required this.pageBuilder,
  });

  @override
  ConsumerState createState() => _HomePageViewState();
}

class _HomePageViewState extends ConsumerState<_HomePageView> {
  late PageController _pageController;

  @override
  initState() {
    super.initState();
    _pageController = PageController(
      initialPage: _pageIndex,
    );
    ref.listenManual(currentPageLabelProvider, (prev, next) {
      if (prev != next) {
        _toPage(next);
      }
    });
    ref.listenManual(currentNavigationItemsStateProvider, (prev, next) {
      if (prev?.value.length != next.value.length) {
        _updatePageController();
      }
    });
  }

  int get _pageIndex {
    final navigationItems = ref.read(currentNavigationItemsStateProvider).value;
    return navigationItems.indexWhere(
      (item) => item.label == globalState.appState.pageLabel,
    );
  }

  Future<void> _toPage(PageLabel pageLabel,
      [bool ignoreAnimateTo = false]) async {
    if (!mounted) {
      return;
    }
    final navigationItems = ref.read(currentNavigationItemsStateProvider).value;
    final index = navigationItems.indexWhere((item) => item.label == pageLabel);
    if (index == -1) {
      return;
    }
    final isAnimateToPage = ref.read(appSettingProvider).isAnimateToPage;
    final isMobile = ref.read(isMobileViewProvider);
    if (isAnimateToPage && isMobile && !ignoreAnimateTo) {
      await _pageController.animateToPage(
        index,
        duration: kTabScrollDuration,
        curve: Curves.easeOut,
      );
    } else {
      _pageController.jumpToPage(index);
    }
  }

  void _updatePageController() {
    final pageLabel = globalState.appState.pageLabel;
    _toPage(pageLabel, true);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final itemCount = ref.watch(currentNavigationItemsStateProvider
        .select((state) => state.value.length));
    return PageView.builder(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return widget.pageBuilder(context, index);
      },
    );
  }
}

class HomeBackScope extends StatelessWidget {
  final Widget child;

  const HomeBackScope({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    if (system.isAndroid) {
      return CommonPopScope(
        onPop: () async {
          final canPop = Navigator.canPop(context);
          if (canPop) {
            Navigator.pop(context);
          } else {
            await globalState.appController.handleBackOrExit();
          }
          return false;
        },
        child: child,
      );
    }
    return child;
  }
}
