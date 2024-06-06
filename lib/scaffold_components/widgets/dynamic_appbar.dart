import 'package:benebono_technical_ex/scaffold_components/cubit/bool_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DynamicAppBarView extends StatelessWidget {
  const DynamicAppBarView({
    super.key,
    required this.child,
    this.scaffoldKey,
    required this.title,
    this.hasBackButton = false
  });

  final Widget                    child;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final String                    title;
  final bool                      hasBackButton;

  bool _onScrollNotification(
      BuildContext context, ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      final metrics = notification.metrics;
      final scrollDelta = notification.scrollDelta ?? 0;
                                                                                                    // CHECKS IN THIS IF :
      if (scrollDelta.abs() > 10                                                                    // user has scroll more than 10 pixel
        && (metrics.pixels > metrics.minScrollExtent && metrics.pixels < metrics .maxScrollExtent)  // AND (scrollView is not < min OR > max) (this prevent from 'bounceEffect' unwanted notifications)
        && ((context.read<BoolCubit>().state && scrollDelta > 0)                                    // AND user is scrolling in a way that need to trigers .invert()
          || (!context.read<BoolCubit>().state && scrollDelta < 0)
        )
      ) {
        context.read<BoolCubit>().invert();
      }
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    // The Container, SafeArea and Material widgets are to prevent Ink widgets from being visible above the DynamicAppBarView
    return Container(
      color: Colors.white,
      child: SafeArea(
        left: false,
        right: false,
        bottom: false,
        child: Material(
          child: BlocProvider(
            create: (context) => BoolCubit(),
            child: Builder(
              builder: (context) {
                return Stack(
                  children: [
                    Positioned.fill(
                      child: NotificationListener<ScrollNotification>(
                        onNotification: (notification) => _onScrollNotification(context, notification),
                        child: child
                      )
                    ),
                    _DynamicAppBar(
                      scaffoldKey: scaffoldKey,
                      title: title,
                      hasBackButton: hasBackButton,
                    )
                  ],
                );
              }
            ),
          ),
        ),
      ),
    );
  }
}

class _DynamicAppBar extends StatelessWidget {
  const _DynamicAppBar({
    required this.title,
    required this.hasBackButton,
    required GlobalKey<ScaffoldState>? scaffoldKey,
  }) : _scaffoldKey = scaffoldKey;

  final String                    title;
  final bool                      hasBackButton;
  final GlobalKey<ScaffoldState>? _scaffoldKey;

  static const double appBarHeight = 50;

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      top: context.watch<BoolCubit>().state ? 0 : -appBarHeight,
      left: 0,
      right: 0,
      height: appBarHeight,
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
      child: Container(
        padding: EdgeInsets.only(
            left: MediaQuery.of(context).padding.left,
            right: MediaQuery.of(context).padding.right),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 50,
              child: hasBackButton ? const BackButton() : null,
            ),
            Text(title,
                style: const TextStyle(fontSize: 24)),
            SizedBox(
              width: 50,
              child: _scaffoldKey != null ?
                IconButton(
                  onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
                  icon: const Icon(Icons.menu)
                )
                : null,
            )
          ],
        ),
      ),
    );
  }
}
