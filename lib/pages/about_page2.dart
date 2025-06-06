import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../widgets/page_container.dart';
import '../services/unified_article_service.dart';

class PrivateGitHubImage extends StatelessWidget {
  final String imagePath;
  final String token;

  const PrivateGitHubImage({
    super.key,
    required this.imagePath,
    required this.token,
  });

  Future<void> _loadArticles() async {
    try {
          final imageUrl = 'https://api.github.com/repos/android-greenhand/Logseq/contents/assets/image_1675233675801_0.png';
          final download_url = await UnifiedArticleService.getImageContent(imageUrl);
          print('download_url: $download_url');
    
    
        // setState(() {
         
        // });
      
    } catch (e) {
      
    }
  }

  @override
  Widget build(BuildContext context) {
    // final imageUrl = 'https://raw.githubusercontent.com/android-greenhand/Logseq/master/$imagePath';
        final imageUrl = 'https://api.github.com/repos/android-greenhand/Logseq/contents/assets/image_1675233675801_0.png';
    print('正在加载图片: $imageUrl');
    _loadArticles();
    return FadeInImage(
      placeholder: AssetImage('placeholder.png'),
      image: NetworkImage(
        imageUrl,
        headers: {
          'Authorization': 'token $token',
          'Accept': 'application/vnd.github.v3.raw',
          'Content-Type': 'image/png',
        },
      ),
      imageErrorBuilder: (context, error, stackTrace) {
        return Container(
          color: Colors.grey[200],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: Colors.red),
              Text('图片加载失败\n${_getErrorReason(error)}'),
            ],
          ),
        );
      },
    );
  }

  String _getErrorReason(Object error) {
    if (error is NetworkImageLoadException) {
      return error.statusCode == 403 ? '权限不足，请检查 Token' : 'HTTP ${error.statusCode} 错误';
    }
    print("gzp,error:$error");
    return '网络连接异常';
  }
  
}

