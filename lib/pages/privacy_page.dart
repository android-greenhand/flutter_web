import 'package:flutter/material.dart';
import '../widgets/page_container.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '隐私政策',
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
                    '信息收集和使用',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '我们非常重视您的隐私。本博客网站不会收集任何个人信息。我们不使用 cookies 或其他跟踪技术。',
                    style: TextStyle(height: 1.6),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    '第三方链接',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '本网站可能包含指向其他网站的链接。我们不对这些第三方网站的隐私政策或内容负责。',
                    style: TextStyle(height: 1.6),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    '更新',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '我们可能会不时更新本隐私政策。任何更改都将在本页面上发布。',
                    style: TextStyle(height: 1.6),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
} 