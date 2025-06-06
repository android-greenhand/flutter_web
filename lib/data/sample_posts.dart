import '../models/unified_article.dart';

final List<UnifiedArticle> samplePosts = [
  UnifiedArticle(
    name: 'Flutter Web 开发入门',
    title: 'Flutter Web 开发入门',
    path: 'posts/flutter-web-intro',
    downloadUrl: '',
    slug: '1',
    excerpt: '学习如何使用 Flutter 构建现代化的 Web 应用程序，包括响应式设计和性能优化。',
    content: '''
# Flutter Web 开发入门

Flutter Web 允许你使用同一套代码库构建高质量的网页应用。本文将介绍 Flutter Web 开发的基础知识。

## 为什么选择 Flutter Web？

- 跨平台开发
- 高性能渲染
- 丰富的组件库
- 热重载支持

## 开始使用

首先确保你已经安装了 Flutter SDK 并启用了 Web 支持：

```bash
flutter channel stable
flutter upgrade
flutter config --enable-web
```

## 创建项目

使用以下命令创建一个新的 Flutter Web 项目：

```bash
flutter create my_web_app
cd my_web_app
flutter run -d chrome
```
    ''',
    author: '张三',
    publishDate: DateTime(2024, 3, 10),
    imageUrl: 'https://picsum.photos/800/400',
    tags: ['Flutter', 'Web', '教程'],
  ),
  UnifiedArticle(
    name: 'Flutter 状态管理详解',
    title: 'Flutter 状态管理详解',
    path: 'posts/flutter-state-management',
    downloadUrl: '',
    slug: '2',
    excerpt: '深入理解 Flutter 中的各种状态管理方案，包括 Provider、Riverpod 和 Bloc。',
    content: '''
# Flutter 状态管理详解

在 Flutter 应用程序中，状态管理是一个核心概念。本文将介绍几种流行的状态管理方案。

## Provider

Provider 是 Flutter 官方推荐的状态管理解决方案之一。它简单易用，适合中小型应用。

## Riverpod

Riverpod 是 Provider 的升级版，提供了更好的类型安全和依赖管理。

## Bloc

Bloc 是一个可预测的状态管理库，特别适合大型应用程序。
    ''',
    author: '李四',
    publishDate: DateTime(2024, 3, 9),
    imageUrl: 'https://picsum.photos/800/400',
    tags: ['Flutter', '状态管理', 'Provider', 'Bloc'],
  ),
];

/// 通过ID查找文章
UnifiedArticle? getSamplePostById(String id) {
  try {
    return samplePosts.firstWhere((post) => post.slug == id);
  } catch (e) {
    return null;
  }
} 