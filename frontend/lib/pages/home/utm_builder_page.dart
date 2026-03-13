import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_theme.dart';

class UtmBuilderPage extends StatefulWidget {
  const UtmBuilderPage({super.key});

  @override
  State<UtmBuilderPage> createState() => _UtmBuilderPageState();
}

class _UtmBuilderPageState extends State<UtmBuilderPage> {
  final _baseUrlController = TextEditingController();
  final _utmSourceController = TextEditingController(text: 'google');
  final _utmMediumController = TextEditingController(text: 'cpc');
  final _utmCampaignController = TextEditingController();
  final _utmTermController = TextEditingController();
  final _utmContentController = TextEditingController();

  String get _generatedUrl {
    if (_baseUrlController.text.isEmpty) return '';
    
    final params = <String, String>{};
    if (_utmSourceController.text.isNotEmpty) params['utm_source'] = _utmSourceController.text;
    if (_utmMediumController.text.isNotEmpty) params['utm_medium'] = _utmMediumController.text;
    if (_utmCampaignController.text.isNotEmpty) params['utm_campaign'] = _utmCampaignController.text;
    if (_utmTermController.text.isNotEmpty) params['utm_term'] = _utmTermController.text;
    if (_utmContentController.text.isNotEmpty) params['utm_content'] = _utmContentController.text;

    if (params.isEmpty) return _baseUrlController.text;

    final queryString = params.entries.map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}').join('&');
    final separator = _baseUrlController.text.contains('?') ? '&' : '?';
    return '${_baseUrlController.text}$separator$queryString';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: theme.scaffoldBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Build UTM Tracking URL',
                            style: theme.textTheme.headlineSmall,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            'Create properly tagged URLs for your marketing campaigns',
                            style: theme.textTheme.bodyMedium,
                          ),
                          const SizedBox(height: AppSpacing.xl),
                          _buildInputFields(),
                          const SizedBox(height: AppSpacing.xl),
                          _buildGeneratedUrlSection(),
                        ],
                      ),
                    ),
                  ),
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
            'UTM Builder',
            style: theme.textTheme.displaySmall,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Create campaign tracking URLs with UTM parameters',
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildInputFields() {
    return Column(
      children: [
        _buildTextField(
          controller: _baseUrlController,
          label: 'Website URL',
          hint: 'https://example.com',
          onChanged: () => setState(() {}),
        ),
        const SizedBox(height: AppSpacing.md),
        _buildTextField(
          controller: _utmSourceController,
          label: 'UTM Source',
          hint: 'google, facebook, newsletter',
          onChanged: () => setState(() {}),
        ),
        const SizedBox(height: AppSpacing.md),
        _buildTextField(
          controller: _utmMediumController,
          label: 'UTM Medium',
          hint: 'cpc, email, social',
          onChanged: () => setState(() {}),
        ),
        const SizedBox(height: AppSpacing.md),
        _buildTextField(
          controller: _utmCampaignController,
          label: 'UTM Campaign',
          hint: 'spring_sale, product_launch',
          onChanged: () => setState(() {}),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: _utmTermController,
                label: 'UTM Term (optional)',
                hint: 'running+shoes',
                onChanged: () => setState(() {}),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _buildTextField(
                controller: _utmContentController,
                label: 'UTM Content (optional)',
                hint: 'banner_a, text_link',
                onChanged: () => setState(() {}),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required VoidCallback onChanged,
  }) {
    return TextField(
      controller: controller,
      onChanged: (_) => onChanged(),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        alignLabelWithHint: true,
      ),
    );
  }

  Widget _buildGeneratedUrlSection() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: theme.dividerTheme.color!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Generated URL',
                style: theme.textTheme.titleLarge,
              ),
              if (_generatedUrl.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: _generatedUrl));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('URL copied to clipboard')),
                    );
                  },
                  tooltip: 'Copy URL',
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : AppColors.cardLight,
              borderRadius: BorderRadius.circular(AppRadius.sm),
              border: Border.all(color: theme.dividerTheme.color!),
            ),
            child: SelectableText(
              _generatedUrl.isEmpty ? 'Enter a URL to generate tracking link' : _generatedUrl,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontFamily: 'monospace',
                color: _generatedUrl.isEmpty ? theme.textTheme.bodySmall?.color : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _baseUrlController.dispose();
    _utmSourceController.dispose();
    _utmMediumController.dispose();
    _utmCampaignController.dispose();
    _utmTermController.dispose();
    _utmContentController.dispose();
    super.dispose();
  }
}
