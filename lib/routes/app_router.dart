import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../pages/home_page.dart';
import '../pages/about_page.dart';
import '../pages/privacy_page.dart';
import '../pages/article_list_page.dart';
import '../pages/github_article_page.dart';
import '../pages/categorized_article_page.dart';
import '../models/unified_article.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/articles',
      builder: (context, state) => const ArticleListPage(),
    ),
    GoRoute(
      path: '/articles/categories',
      builder: (context, state) => const CategorizedArticlePage(),
    ),
    GoRoute(
      path: '/about',
      builder: (context, state) => const AboutPage(),
    ),
    GoRoute(
      path: '/privacy',
      builder: (context, state) => const PrivacyPage(),
    ),
    GoRoute(
      path: '/article/page',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final path = extra?['path'] as String? ?? '';
        final name = extra?['name'] as String? ?? '';
        
        print('路由参数:');
        print('- 路径: $path');
        print('- 名称: $name');
        if (extra != null) {
          print('- 下载链接: ${extra['downloadUrl']}');
        }
        
        return GitHubArticlePage(
          owner: 'android-greenhand',
          repo: 'Logseq',
          path: path,
          title: name,
        );
      },
    ),
  ],
  errorBuilder: (context, state) {
    print('路由错误:');
    print('错误路径: ${state.uri.path}');
    print('错误信息: ${state.error}');
    return Scaffold(
      body: Center(
        child: Text('路由错误: ${state.error}'),
      ),
    );
  },
); 