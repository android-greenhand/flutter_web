import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/unified_article.dart';

class BlogCard extends StatefulWidget {
  final UnifiedArticle post;

  const BlogCard({super.key, required this.post});

  @override
  State<BlogCard> createState() => _BlogCardState();
}

class _BlogCardState extends State<BlogCard> with SingleTickerProviderStateMixin {
  late final AnimationController _hoverController;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _elevationAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOutCubic,
    ));
    _elevationAnimation = Tween<double>(
      begin: 2,
      end: 8,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  Widget _buildImage(BuildContext context) {
    return Hero(
      tag: 'post-image-${widget.post.slug}',
      flightShuttleBuilder: (
        BuildContext flightContext,
        Animation<double> animation,
        HeroFlightDirection flightDirection,
        BuildContext fromHeroContext,
        BuildContext toHeroContext,
      ) {
        return AnimatedBuilder(
          animation: animation,
          child: Image.network(
            widget.post.imageUrl,
            fit: BoxFit.cover,
          ),
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(
                  flightDirection == HeroFlightDirection.push
                      ? Tween<double>(begin: 12, end: 0).evaluate(animation)
                      : Tween<double>(begin: 0, end: 12).evaluate(animation),
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: child,
            );
          },
        );
      },
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Image.network(
          widget.post.imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Theme.of(context).colorScheme.surfaceVariant,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image_outlined,
                    size: 48,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '图片加载失败',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: child,
              );
            }
            return Container(
              color: Theme.of(context).colorScheme.surfaceVariant,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                          : null,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    if (loadingProgress.expectedTotalBytes != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        '${((loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!) * 100).toStringAsFixed(0)}%',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTags(BuildContext context) {
    final tags = widget.post.tags.isNotEmpty 
        ? widget.post.tags 
        : (widget.post.categories.isNotEmpty ? widget.post.categories : [widget.post.category]);
    
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: tags.asMap().entries.map((entry) {
        final index = entry.key;
        final tag = entry.value;
        return AnimatedBuilder(
          animation: _hoverController,
          builder: (context, child) {
            final delay = index * 0.1;
            final offsetAnimation = Tween<Offset>(
              begin: Offset.zero,
              end: const Offset(0, -4),
            ).animate(
              CurvedAnimation(
                parent: _hoverController,
                curve: Interval(
                  delay.clamp(0.0, 1.0),
                  (delay + 0.4).clamp(0.0, 1.0),
                  curve: Curves.easeOutCubic,
                ),
              ),
            );
            return Transform.translate(
              offset: offsetAnimation.value,
              child: child,
            );
          },
          child: Chip(
            label: Text(
              tag,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _hoverController.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _hoverController.reverse();
      },
      child: AnimatedBuilder(
        animation: _hoverController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Card(
              clipBehavior: Clip.antiAlias,
              elevation: _elevationAnimation.value,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: child,
            ),
          );
        },
        child: InkWell(
          onTap: () => context.go('/article/page', extra: {
            'path': '${widget.post.path}',
            'name': widget.post.title,
          }),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImage(context),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.post.title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.post.excerpt.isNotEmpty ? widget.post.excerpt : widget.post.description,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          height: 1.5,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      const Divider(),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.person_outline,
                            size: 16,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${widget.post.author.isNotEmpty ? widget.post.author : "未知作者"}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const Spacer(),
                          Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatDate(widget.post.publishDate ?? (widget.post.commitDate.isNotEmpty ? DateTime.parse(widget.post.commitDate) : DateTime.now())),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildTags(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
} 