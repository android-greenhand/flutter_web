import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'app_navbar.dart';
import 'app_footer.dart';

class PageContainer extends StatelessWidget {
  final Widget child;
  final bool showNavbar;
  final bool showFooter;
  final EdgeInsets padding;

  const PageContainer({
    super.key,
    required this.child,
    this.showNavbar = true,
    this.showFooter = true,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    final maxWidth = isDesktop ? 1200.0 : double.infinity;

    return Scaffold(
      appBar: showNavbar ? const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppNavbar(),
      ) : null,
      body: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          scrollbars: true,
        ),
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: maxWidth),
              padding: padding,
              child: Column(
                children: [
                  child,
                  if (showFooter) const AppFooter(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
} 