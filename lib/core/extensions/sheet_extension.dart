import 'package:flutter/material.dart';

extension BottomSheetExtension on BuildContext {
  Future<T?> showBottomSheet<T>({
    required Widget body,
    bool useRootNavigator = true,
    RouteSettings? routeSettings,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return showModalBottomSheet<T>(
      context: this,
      useRootNavigator: useRootNavigator,
      backgroundColor: Colors.transparent,
      barrierColor: const Color(0x6604040F),
      isDismissible: isDismissible,
      isScrollControlled: true,
      enableDrag: enableDrag,
      routeSettings: routeSettings,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 16 * 1.5,
            ),
            decoration: const BoxDecoration(
              color: Color(0xFFF7F9FC),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    children: [
                      const Spacer(),
                      Container(
                        width: 100,
                        height: 4,
                        margin: const EdgeInsets.only(
                          top: 8,
                          bottom: 16 * 2,
                        ),
                        decoration: const BoxDecoration(
                          color: Color(0xFFD8D8D8),
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                  body,
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<R?> showScrollableSheet<R>({
    required NullableIndexedWidgetBuilder listItemBuilder,
    Widget? listItemSeparator,
    required int itemCount,
    Widget? header,
    Widget? footer,
    RouteSettings? routeSettings,
  }) {
    return showModalBottomSheet<R>(
      context: this,
      isScrollControlled: true,
      useSafeArea: false,
      backgroundColor: Colors.transparent,
      barrierColor: const Color(0x6604040F),
      isDismissible: true,
      useRootNavigator: true,
      routeSettings: routeSettings,
      builder: (context) {
        return DraggableScrollableSheet(
          builder: (context, scrollController) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16 * 1.5,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFFF7F9FC),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Spacer(),
                          Container(
                            width: 100,
                            height: 4,
                            margin: const EdgeInsets.only(
                              top: 8,
                              bottom: 16 * 2,
                            ),
                            decoration: const BoxDecoration(
                              color: Color(0xFFD8D8D8),
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                      header ?? const SizedBox.shrink(),
                      Expanded(
                        child: ListView.separated(
                          controller: scrollController,
                          itemCount: itemCount,
                          itemBuilder: listItemBuilder,
                          separatorBuilder: (context, index) {
                            return listItemSeparator ?? const SizedBox.shrink();
                          },
                        ),
                      ),
                      footer ?? const SizedBox.shrink(),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
