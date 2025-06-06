import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../widgets/page_container.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    final contentMaxWidth = isDesktop ? 800.0 : double.infinity;

    return PageContainer(
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: contentMaxWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '关于我的博客',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '欢迎来到我的博客',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        '这是一个使用 Flutter Web 构建的个人博客网站。在这里，我会分享关于技术、编程和个人成长的文章。',
                        style: TextStyle(fontSize: 16, height: 1.6),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                '技术栈',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.check_circle,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      title: const Text('Flutter Web'),
                      subtitle: const Text('用于构建跨平台 Web 应用'),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.check_circle,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      title: const Text('Material Design 3'),
                      subtitle: const Text('现代化的 UI 设计系统'),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.check_circle,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      title: const Text('响应式设计'),
                      subtitle: const Text('适配各种屏幕尺寸'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Text(
                '联系方式',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.email,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      title: const Text('邮箱'),
                      subtitle: const Text('example@example.com'),
                      trailing: IconButton(
                        icon: const Icon(Icons.content_copy),
                        onPressed: () {},
                        tooltip: '复制邮箱地址',
                      ),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.link,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      title: const Text('GitHub'),
                      subtitle: const Text('github.com/yourusername'),
                      trailing: IconButton(
                        icon: const Icon(Icons.open_in_new),
                        onPressed: () {},
                        tooltip: '访问 GitHub',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 