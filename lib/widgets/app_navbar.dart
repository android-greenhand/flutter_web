import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';

class AppNavbar extends StatelessWidget {
  const AppNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(MOBILE);

    return AppBar(
      title: const Text('我的博客'),
      actions: [
        if (isDesktop) ...[
          TextButton(
            onPressed: () => context.go('/'),
            child: const Text('首页'),
          ),
          TextButton(
            onPressed: () => context.go('/articles'),
            child: const Text('文章列表'),
          ),
          TextButton(
            onPressed: () => context.go('/about'),
            child: const Text('关于'),
          ),
        ],
        IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(Icons.home),
                    title: const Text('首页'),
                    onTap: () {
                      context.go('/');
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.article),
                    title: const Text('文章列表'),
                    onTap: () {
                      context.go('/articles');
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.info),
                    title: const Text('关于'),
                    onTap: () {
                      context.go('/about');
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
} 