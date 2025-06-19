import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'dart:developer' as dev;
import '../models/unified_article.dart';

/// 统一的文章服务类，使用 UnifiedArticle 模型
class UnifiedArticleService {
  // 仓库配置
  static const String owner = 'android-greenhand';
  static const String repo = 'Logseq';
  static const String contentsPath = 'pages/contents.md';
  // static const String contentsPath = 'logseq/bak/pages/contents/2024-06-28T09_33_18.708Z.Desktop.md';
  
  // 修改为 Vercel 代理服务地址
  static const String _baseUrl = 'https://ktor-vercel.vercel.app';

  // 简化的 headers，不需要 GitHub token
  static Map<String, String> get _headers => {
    'Accept': 'application/json',
  };

  /// 获取文章列表，返回 UnifiedArticle 类型
  static Future<List<UnifiedArticle>> getArticleList(String owner, String repo, String path) async {
    final url = Uri.parse('$_baseUrl/api/contents/$path?owner=$owner&repo=$repo');
    dev.log('正在请求文章列表...');
    dev.log('请求 URL: ${url.toString()}');
    dev.log('请求头: ${_headers.toString()}');

    try {
      final response = await http.get(url, headers: _headers);
      dev.log('响应状态码: ${response.statusCode}');
      if (response.statusCode == 200) {
        final List<dynamic> items = json.decode(response.body);
        dev.log('成功获取到 ${items.length} 个文件');
        final articles = items
            .where((item) => item['name'].toString().endsWith('.md'))
            .map((item) {
              final name = _formatArticleName(item['name']);
              final itemPath = item['path'];
              return UnifiedArticle(
                name: name,
                title: name,
                path: itemPath,
                downloadUrl: item['download_url'],
                sha: item['sha'],
                size: item['size'],
                type: item['type'],
                description: name,
                date: DateTime.now().toIso8601String(),
                category: '',
                imageUrl: 'https://picsum.photos/800/400',
                slug: itemPath.replaceAll('.md', '').replaceAll('/', '-'),
                commitDate: DateTime.now().toIso8601String(),
              );
            })
            .toList()
          ..sort((a, b) => b.name.compareTo(a.name));
        dev.log('过滤后的 Markdown 文章数量: ${articles.length}');
        return articles;
      }
      dev.log('请求失败，响应内容: ${response.body}', error: response.statusCode);
      throw Exception('Failed to load article list: ${response.statusCode}');
    } catch (e) {
      dev.log('请求发生错误', error: e);
      rethrow;
    }
  }

  static String _formatArticleName(String fileName) {
    String name = fileName.replaceAll('.md', '');
    name = name.replaceAll(RegExp(r'[-_]'), ' ');
    return name.split(' ').map((word) => word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1)).join(' ');
  }

  /// 获取文章内容
  static Future<String> getMarkdownContent(String owner, String repo, String path) async {
    try {
      final apiUrl = Uri.parse('$_baseUrl/api/contents/$path?owner=$owner&repo=$repo');
      print('🔍 [UnifiedArticleService] 开始获取文件内容');
      print('📝 [UnifiedArticleService] 仓库: $owner/$repo');
      print('📝 [UnifiedArticleService] 路径: $path');
      print('🔗 [UnifiedArticleService] API URL: $apiUrl');
      final response = await http.get(apiUrl, headers: _headers);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (!data.containsKey('content')) {
          throw Exception('响应中缺少文件内容');
        }
        final rawContent = data['content'] as String;
        final cleanBase64 = rawContent.replaceAll('\n', '').replaceAll('\r', '').replaceAll(' ', '');
        try {
          final decoded = base64.decode(cleanBase64);
          final content = utf8.decode(decoded);
          final tempContent = content.replaceAllMapped(
            RegExp(r'(?<!`)`(?!`)'), // 匹配规则：前后无连续反引号的单个 `
                (match) => '&&',
          )
          //     .replaceAllMapped(
          //   RegExp(r'(?<!-) ```(?!\n)'), // 匹配规则：前面无减号且后面无换行的三个反引号
          //       (match) => '- ```',
          // ).replaceAll('```', '`')
          .replaceAll('**', '&&');
          print('tempContent $tempContent');
          return tempContent;
        } catch (e) {
          rethrow;
        }
      } else {
        throw Exception('获取文件内容失败: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('加载内容错误: $e');
    }
  }

  static Future<String> getImageContent(String fileName) async {
    final url = Uri.parse('$_baseUrl/api/contents/$fileName?owner=$owner&repo=$repo');
    final response = await http.get(url, headers: _headers);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['download_url'];
    }
    throw Exception('Failed to load image: ${response.statusCode}');
  }

  static Future<Map<String, dynamic>?> getFileCommitInfo(String owner, String repo, String path) async {
    try {
      final url = Uri.parse('$_baseUrl/api/commits/$path?owner=$owner&repo=$repo');
      final response = await http.get(url, headers: _headers);
      if (response.statusCode == 200) {
        final List<dynamic> commits = json.decode(response.body);
        if (commits.isNotEmpty) {
          final commit = commits[0];
          return {
            'date': commit['commit']['author']['date'],
            'message': commit['commit']['message'],
            'author': commit['commit']['author']['name'],
          };
        }
      }
      return null;
    } catch (e) {
      dev.log('获取提交信息失败', name: 'UnifiedArticleService', error: e);
      return null;
    }
  }

  // ================== 分类文章部分 ==================
  static final List<String> _skipCategories = [
    '个人', '生活', '日记', '随笔', '第一次见家长', '贷款', '目标',
  ];

  static bool _shouldSkipCategory(String category) {
    return _skipCategories.any((skipCategory) => category.contains(skipCategory));
  }

  static Future<Map<String, List<String>>> fetchCategories() async {
    try {
      print('开始获取分类信息');
      print('请求路径: $contentsPath');
      final content = await getMarkdownContent(owner, repo, contentsPath);
      if (content.isEmpty) {
        throw Exception('获取分类信息失败: 内容为空');
      }
      final categories = _parseCategories(content);
      return categories;
    } catch (e, stack) {
      print('获取分类信息失败');
      print('错误: $e');
      print('堆栈: $stack');
      rethrow;
    }
  }

  static Map<String, List<String>> _parseCategories(String markdown) {
    final Map<String, List<String>> categories = {};
    String currentCategory = '';
    int currentIndentLevel = 0;
    final lines = markdown.split('\n');
    for (var i = 0; i < lines.length; i++) {
      var line = lines[i];
      int indentLevel = line.indexOf(line.trim());
      line = line.trim();
      if (line.isEmpty) continue;
      if (line.contains('collapsed::') || line.startsWith('- **')) continue;
      if (indentLevel == 1 && line.startsWith('- [[')) {
        final match = RegExp(r'\[\[(.*?)\]\]').firstMatch(line);
        if (match != null) {
          currentCategory = match.group(1)!;
          if (_shouldSkipCategory(currentCategory)) {
            currentCategory = '';
            continue;
          }
          if (!categories.containsKey(currentCategory)) {
            categories[currentCategory] = [];
          }
          currentIndentLevel = indentLevel;
        }
      } else if (line.contains('[[') && currentCategory.isNotEmpty && indentLevel > currentIndentLevel) {
        final matches = RegExp(r'\[\[(.*?)\]\]').allMatches(line);
        for (final match in matches) {
          final title = match.group(1)!;
          if (!title.contains('http') && !title.startsWith('((') && !categories[currentCategory]!.contains(title)) {
            categories[currentCategory]!.add(title);
          }
        }
      }
    }
    return categories;
  }

  static Future<List<ArticleCategory>> getCategorizedArticles() async {
    try {
      final contents = await getMarkdownContent(owner, repo, contentsPath);
      final categoriesMap = _parseCategories(contents);
      final result = categoriesMap.entries.map((entry) {
        final categoryName = entry.key;
        final articleTitles = entry.value;
        final articles = articleTitles.map((title) {
          final path = 'pages/$title.md';
          // 直接创建 UnifiedArticle
          final unifiedArticle = UnifiedArticle(
            name: title,
            title: title,
            path: path,
            downloadUrl: path,
            commitDate: DateTime.now().toIso8601String(),
            imageUrl: 'https://picsum.photos/800/400',
            category: categoryName, // 设置分类
            categories: [categoryName], // 同时设置categories数组
            slug: path.replaceAll('.md', '').replaceAll('/', '-'),
          );
          return unifiedArticle;
        }).toList();
        return ArticleCategory(
          name: categoryName,
          articles: articles,
        );
      }).toList();
      return result;
    } catch (e, stack) {
      print('获取分类文章失败');
      print('错误: $e');
      print('堆栈: $stack');
      rethrow;
    }
  }

  /// 获取所有分类文章，直接返回 UnifiedArticle 列表
  static Future<List<UnifiedArticle>> getAllCategorizedArticles() async {
    try {
      final contents = await getMarkdownContent(owner, repo, contentsPath);
      final categoriesMap = _parseCategories(contents);
      
      final List<UnifiedArticle> result = [];
      
      for (final entry in categoriesMap.entries) {
        final categoryName = entry.key;
        final articleTitles = entry.value;
        
        for (final title in articleTitles) {
          final path = 'pages/$title.md';
          final unifiedArticle = UnifiedArticle(
            name: title,
            title: title,
            path: path,
            downloadUrl: path,
            commitDate: DateTime.now().toIso8601String(),
            imageUrl: 'https://picsum.photos/800/400',
            category: categoryName,
            categories: [categoryName],
            slug: path.replaceAll('.md', '').replaceAll('/', '-'),
          );
          result.add(unifiedArticle);
        }
      }
      
      return result;
    } catch (e, stack) {
      print('获取所有分类文章失败');
      print('错误: $e');
      print('堆栈: $stack');
      rethrow;
    }
  }

  static Future<UnifiedArticle> getArticleDetails(UnifiedArticle article) async {
    try {
      final content = await getMarkdownContent(owner, repo, article.path);
      if (content.isEmpty) {
        return article;
      }
      final commitInfo = await getFileCommitInfo(owner, repo, article.path);
      final imageUrl = _extractImageFromContent(content);
      
      // 提取文章摘要
      final excerpt = _extractExcerpt(content);
      
      return UnifiedArticle(
        name: article.name,
        title: article.title,
        path: article.path,
        downloadUrl: article.downloadUrl,
        sha: article.sha,
        size: article.size,
        type: article.type,
        commitDate: commitInfo != null ? commitInfo['date'] ?? article.commitDate : article.commitDate,
        imageUrl: imageUrl ?? article.imageUrl,
        category: article.category,
        categories: article.categories,
        description: excerpt, // 使用摘要作为描述
        excerpt: excerpt,
        content: content, // 保存完整内容
        author: commitInfo != null ? commitInfo['author'] ?? '' : '',
        date: article.date,
        slug: article.slug,
        tags: article.tags,
      );
    } catch (e) {
      print('获取文章详情失败：$e');
      return article;
    }
  }

  static String? _extractImageFromContent(String content) {
    final imageRegex = RegExp(r'!\[.*?\]\((.*?)\)');
    final match = imageRegex.firstMatch(content);
    if (match != null) {
      return match.group(1);
    }
    return null;
  }
  
  static String _extractExcerpt(String content) {
    // 去除 Markdown 标记
    final plainText = content
        .replaceAll(RegExp(r'#+\s+'), '')  // 移除标题
        .replaceAll(RegExp(r'!\[.*?\]\(.*?\)'), '')  // 移除图片
        .replaceAll(RegExp(r'\[([^\]]*)\]\(.*?\)'), r'\$1')  // 替换链接为文本
        .replaceAll(RegExp(r'`{1,3}.*?`{1,3}'), '')  // 移除代码
        .replaceAll(RegExp(r'[*_]{1,2}(.*?)[*_]{1,2}'), r'\$1')  // 移除强调标记
        .trim();
    
    // 获取前200个字符作为摘要
    final maxLength = 200;
    if (plainText.length <= maxLength) {
      return plainText;
    }
    
    return '${plainText.substring(0, maxLength)}...';
  }
} 