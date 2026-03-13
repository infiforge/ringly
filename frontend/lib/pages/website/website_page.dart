import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class WebsitePage extends StatefulWidget {
  const WebsitePage({super.key});

  @override
  State<WebsitePage> createState() => _WebsitePageState();
}

// Ringly Color Palette
class RinglyColors {
  // Background gradient range
  static const Color backgroundStart = Color(0xFF0D2B1A);
  static const Color backgroundEnd = Color(0xFF111D14);

  // Primary accent - amber gold
  static const Color primaryAccent = Color(0xFFF5A623);
  static const Color primaryAccentLight = Color(0xFFFFD580);

  // Secondary glow - soft gold
  static const Color secondaryGlow = Color(0xFFFFD580);

  // Shadows
  static const Color shadowDark = Color(0xFF050D07);

  // Text colors
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFB8C5B9);
  static const Color textMuted = Color(0xFF7A8A7C);

  // Card/Surface colors
  static const Color surface = Color(0xFF1A2E1F);
  static const Color surfaceElevated = Color(0xFF223829);
}

class _WebsitePageState extends State<WebsitePage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _homeKey = GlobalKey();
  final GlobalKey _featuresKey = GlobalKey();
  final GlobalKey _howItWorksKey = GlobalKey();
  final GlobalKey _pricingKey = GlobalKey();

  void _scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              RinglyColors.backgroundStart,
              RinglyColors.backgroundEnd,
            ],
          ),
        ),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              _Header(
                onNavigate: _scrollToSection,
                homeKey: _homeKey,
                featuresKey: _featuresKey,
                howItWorksKey: _howItWorksKey,
                pricingKey: _pricingKey,
              ),
              Container(key: _homeKey, child: const _HeroSection()),
              Container(key: _featuresKey, child: const _FeaturesSection()),
              Container(key: _howItWorksKey, child: const _HowItWorksSection()),
              Container(key: _pricingKey, child: const _PricingSection()),
              const _FooterSection(),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final Function(GlobalKey) onNavigate;
  final GlobalKey homeKey;
  final GlobalKey featuresKey;
  final GlobalKey howItWorksKey;
  final GlobalKey pricingKey;

  const _Header({
    required this.onNavigate,
    required this.homeKey,
    required this.featuresKey,
    required this.howItWorksKey,
    required this.pricingKey,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: RinglyColors.backgroundStart.withAlpha(204),
        border: Border(
          bottom: BorderSide(
            color: RinglyColors.primaryAccent.withAlpha(26),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      RinglyColors.primaryAccent,
                      RinglyColors.secondaryGlow,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: RinglyColors.primaryAccent.withAlpha(77),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.phone_in_talk,
                  color: RinglyColors.shadowDark,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Ringly',
                style: TextStyle(
                  color: RinglyColors.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          // Navigation
          Row(
            children: [
              _NavLink('Features', () => onNavigate(featuresKey)),
              _NavLink('How It Works', () => onNavigate(howItWorksKey)),
              _NavLink('Pricing', () => onNavigate(pricingKey)),
              const SizedBox(width: 24),
              _GoldButton(
                onPressed: () => context.router.pushNamed('/auth'),
                child: const Text('Sign In'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NavLink extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _NavLink(this.text, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextButton(
        onPressed: onTap,
        child: Text(
          text,
          style: const TextStyle(
            color: RinglyColors.textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      child: Column(
        children: [
          // Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: RinglyColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: RinglyColors.primaryAccent.withAlpha(51),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: RinglyColors.primaryAccent,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Self-Hosted Call Attribution',
                  style: TextStyle(
                    color: RinglyColors.textSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // Main Headline
          const Text(
            'Track Every Call.\nAttribute Every Conversion.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: RinglyColors.textPrimary,
              fontSize: 56,
              fontWeight: FontWeight.bold,
              height: 1.2,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 24),
          // Subheadline
          Container(
            constraints: const BoxConstraints(maxWidth: 600),
            child: const Text(
              'Ringly helps you track offline conversions from phone calls and attribute them to your Google Ads campaigns. Perfect for businesses in Kenya and across Africa.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: RinglyColors.textSecondary,
                fontSize: 18,
                height: 1.6,
              ),
            ),
          ),
          const SizedBox(height: 48),
          // CTA Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _GoldButton(
                onPressed: () {},
                isLarge: true,
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.download),
                    SizedBox(width: 8),
                    Text('Download App'),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              _OutlinedGoldButton(
                onPressed: () {},
                isLarge: true,
                child: const Text('Learn More'),
              ),
            ],
          ),
          const SizedBox(height: 64),
          // Stats
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: RinglyColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: RinglyColors.primaryAccent.withAlpha(26),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _StatItem('99.9%', 'Uptime Guaranteed'),
                Container(
                  width: 1,
                  height: 50,
                  color: RinglyColors.primaryAccent.withAlpha(26),
                ),
                _StatItem('<50ms', 'Response Time'),
                Container(
                  width: 1,
                  height: 50,
                  color: RinglyColors.primaryAccent.withAlpha(26),
                ),
                _StatItem('24/7', 'Support Available'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem(this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: RinglyColors.primaryAccent,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: RinglyColors.textMuted,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

class _FeaturesSection extends StatelessWidget {
  const _FeaturesSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      child: Column(
        children: [
          _SectionTitle(
            title: 'Powerful Features',
            subtitle:
                'Everything you need to track and attribute phone calls to your Google Ads campaigns.',
          ),
          const SizedBox(height: 64),
          Wrap(
            spacing: 24,
            runSpacing: 24,
            alignment: WrapAlignment.center,
            children: const [
              _FeatureCard(
                icon: Icons.phone_callback,
                title: 'GCLID Tracking',
                description:
                    'Automatically capture Google Click IDs from ad clicks and attribute calls to specific campaigns.',
              ),
              _FeatureCard(
                icon: Icons.record_voice_over,
                title: 'DTMF/IVR Integration',
                description:
                    'Interactive Voice Response for call routing with touch-tone input collection.',
              ),
              _FeatureCard(
                icon: Icons.offline_bolt,
                title: 'Offline Conversions',
                description:
                    'Send conversion data to Google Ads API with proper attribution windows.',
              ),
              _FeatureCard(
                icon: Icons.sms,
                title: 'SMS/WhatsApp Alerts',
                description:
                    'Real-time call alerts and daily summary reports via SMS and WhatsApp.',
              ),
              _FeatureCard(
                icon: Icons.dashboard,
                title: 'Analytics Dashboard',
                description:
                    'Real-time call volume, conversion rates, and cost per conversion metrics.',
              ),
              _FeatureCard(
                icon: Icons.business,
                title: 'Multi-tenant',
                description:
                    'Agency account management with client sub-accounts and role-based access.',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: RinglyColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: RinglyColors.primaryAccent.withAlpha(26),
        ),
        boxShadow: [
          BoxShadow(
            color: RinglyColors.shadowDark.withAlpha(128),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  RinglyColors.primaryAccent,
                  RinglyColors.secondaryGlow,
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: RinglyColors.shadowDark,
              size: 24,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              color: RinglyColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              color: RinglyColors.textSecondary,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _HowItWorksSection extends StatelessWidget {
  const _HowItWorksSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      child: Column(
        children: [
          _SectionTitle(
            title: 'How It Works',
            subtitle: 'Get started with Ringly in three simple steps.',
          ),
          const SizedBox(height: 64),
          Wrap(
            spacing: 16,
            runSpacing: 24,
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _StepCard(
                number: '01',
                title: 'Install Ringly',
                description:
                    'Deploy the self-hosted solution on your infrastructure.',
              ),
              _StepConnector(),
              _StepCard(
                number: '02',
                title: 'Configure Campaigns',
                description:
                    'Set up your Google Ads campaigns and phone number mappings.',
              ),
              _StepConnector(),
              _StepCard(
                number: '03',
                title: 'Track & Optimize',
                description:
                    'Monitor call attribution and optimize your campaigns.',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  final String number;
  final String title;
  final String description;

  const _StepCard({
    required this.number,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: RinglyColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: RinglyColors.primaryAccent.withAlpha(26),
        ),
      ),
      child: Column(
        children: [
          Text(
            number,
            style: const TextStyle(
              color: RinglyColors.primaryAccent,
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              color: RinglyColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: RinglyColors.textSecondary,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _StepConnector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            RinglyColors.primaryAccent,
            RinglyColors.secondaryGlow,
          ],
        ),
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }
}

class _PricingSection extends StatelessWidget {
  const _PricingSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      child: Column(
        children: [
          _SectionTitle(
            title: 'Simple Pricing',
            subtitle: 'Choose the plan that works best for your business.',
          ),
          const SizedBox(height: 64),
          Wrap(
            spacing: 24,
            runSpacing: 24,
            alignment: WrapAlignment.center,
            children: [
              _PricingCard(
                name: 'Starter',
                price: 'Free',
                period: 'Forever',
                features: const [
                  'Up to 100 calls/month',
                  'Basic GCLID tracking',
                  'Email support',
                  '1 user account',
                ],
                isPopular: false,
              ),
              _PricingCard(
                name: 'Professional',
                price: '\$49',
                period: '/month',
                features: const [
                  'Unlimited calls',
                  'Advanced attribution',
                  'IVR/DTMF support',
                  'SMS/WhatsApp alerts',
                  'Priority support',
                  '5 user accounts',
                ],
                isPopular: true,
              ),
              _PricingCard(
                name: 'Enterprise',
                price: 'Custom',
                period: 'Contact us',
                features: const [
                  'Everything in Pro',
                  'Multi-tenant setup',
                  'White-labeling',
                  'Dedicated support',
                  'Custom integrations',
                  'Unlimited users',
                ],
                isPopular: false,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PricingCard extends StatelessWidget {
  final String name;
  final String price;
  final String period;
  final List<String> features;
  final bool isPopular;

  const _PricingCard({
    required this.name,
    required this.price,
    required this.period,
    required this.features,
    required this.isPopular,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: isPopular ? RinglyColors.surfaceElevated : RinglyColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPopular
              ? RinglyColors.primaryAccent
              : RinglyColors.primaryAccent.withAlpha(26),
          width: isPopular ? 2 : 1,
        ),
        boxShadow: isPopular
            ? [
                BoxShadow(
                  color: RinglyColors.primaryAccent.withAlpha(51),
                  blurRadius: 30,
                  offset: const Offset(0, 8),
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isPopular)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    RinglyColors.primaryAccent,
                    RinglyColors.secondaryGlow,
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Most Popular',
                style: TextStyle(
                  color: RinglyColors.shadowDark,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          const SizedBox(height: 16),
          Text(
            name,
            style: const TextStyle(
              color: RinglyColors.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                price,
                style: const TextStyle(
                  color: RinglyColors.primaryAccent,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                period,
                style: const TextStyle(
                  color: RinglyColors.textMuted,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(color: RinglyColors.surfaceElevated),
          const SizedBox(height: 24),
          ...features.map((feature) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: RinglyColors.primaryAccent,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        feature,
                        style: const TextStyle(
                          color: RinglyColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: isPopular
                ? _GoldButton(
                    onPressed: () {},
                    child: const Text('Get Started'),
                  )
                : _OutlinedGoldButton(
                    onPressed: () {},
                    child: const Text('Get Started'),
                  ),
          ),
        ],
      ),
    );
  }
}

class _FooterSection extends StatelessWidget {
  const _FooterSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        color: RinglyColors.shadowDark,
        border: Border(
          top: BorderSide(
            color: RinglyColors.primaryAccent.withAlpha(26),
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      RinglyColors.primaryAccent,
                      RinglyColors.secondaryGlow,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.phone_in_talk,
                  color: RinglyColors.shadowDark,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Ringly',
                style: TextStyle(
                  color: RinglyColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            '© 2026 Ringly by Infiforge. All rights reserved.',
            style: TextStyle(
              color: RinglyColors.textMuted,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _FooterLink('Privacy Policy'),
              _FooterLink('Terms of Service'),
              _FooterLink('Contact'),
            ],
          ),
        ],
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  final String text;

  const _FooterLink(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextButton(
        onPressed: () {},
        child: Text(
          text,
          style: const TextStyle(
            color: RinglyColors.textMuted,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionTitle({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: RinglyColors.textPrimary,
            fontSize: 36,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: RinglyColors.textSecondary,
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}

class _GoldButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final bool isLarge;

  const _GoldButton({
    required this.onPressed,
    required this.child,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: RinglyColors.primaryAccent,
        foregroundColor: RinglyColors.shadowDark,
        padding: EdgeInsets.symmetric(
          horizontal: isLarge ? 32 : 24,
          vertical: isLarge ? 16 : 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 0,
      ),
      child: DefaultTextStyle(
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        child: child,
      ),
    );
  }
}

class _OutlinedGoldButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final bool isLarge;

  const _OutlinedGoldButton({
    required this.onPressed,
    required this.child,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: RinglyColors.primaryAccent,
        side: const BorderSide(color: RinglyColors.primaryAccent),
        padding: EdgeInsets.symmetric(
          horizontal: isLarge ? 32 : 24,
          vertical: isLarge ? 16 : 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: DefaultTextStyle(
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        child: child,
      ),
    );
  }
}
