import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_theme.dart';
import '../../providers/app_providers.dart';
import '../../providers/call_providers.dart';
import '../../models/call_models.dart';

class WhatsAppPage extends ConsumerWidget {
  const WhatsAppPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = ref.watch(mockWhatsAppMessagesProvider);
    final theme = Theme.of(context);

    return Container(
      color: theme.scaffoldBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Row(
                        children: [
                          Text(
                            'WhatsApp Messages',
                            style: theme.textTheme.headlineSmall,
                          ),
                          const Spacer(),
                          ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.send),
                            label: const Text('Send Message'),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: messages.isEmpty
                          ? _buildEmptyState(context)
                          : _buildMessagesList(context, messages),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        border: Border(
          bottom: BorderSide(color: theme.dividerTheme.color!),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'WhatsApp',
            style: theme.textTheme.displaySmall,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'WhatsApp message tracking and management',
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 48,
            color: AppColors.whatsappGreen,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'No messages yet',
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'WhatsApp messages will appear here',
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList(BuildContext context, List<WhatsAppMessage> messages) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final isInbound = message.direction == MessageDirection.inbound;

        return ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isInbound
                  ? (isDark ? AppColors.whatsappGreen.withOpacity(0.2) : AppColors.whatsappGreen.withOpacity(0.1))
                  : (isDark ? Colors.blue.withOpacity(0.2) : Colors.blue.withOpacity(0.1)),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              isInbound ? Icons.arrow_downward : Icons.arrow_upward,
              size: 16,
              color: isInbound ? AppColors.whatsappGreen : Colors.blue,
            ),
          ),
          title: Text(message.contactName),
          subtitle: Text(
            message.message,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _StatusBadge(status: message.status),
              const SizedBox(height: 4),
              Text(
                _formatTimestamp(message.timestamp),
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    return '${timestamp.day}/${timestamp.month} ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
  }
}

class _StatusBadge extends StatelessWidget {
  final MessageStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Color color;
    String label;

    switch (status) {
      case MessageStatus.sent:
        color = Colors.grey;
        label = 'Sent';
        break;
      case MessageStatus.delivered:
        color = Colors.blue;
        label = 'Delivered';
        break;
      case MessageStatus.read:
        color = AppColors.whatsappGreen;
        label = 'Read';
        break;
      case MessageStatus.failed:
        color = Colors.red;
        label = 'Failed';
        break;
      default:
        color = Colors.grey;
        label = 'Pending';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
