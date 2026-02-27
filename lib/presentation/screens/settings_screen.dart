// lib/presentation/screens/settings_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../providers/app_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            snap: true,
            title: Text('Settings', style: theme.textTheme.headlineMedium),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // App Section
                _SectionLabel(label: 'APPEARANCE'),
                const SizedBox(height: 8),
                _SettingsCard(
                  children: [
                    _SettingsTile(
                      icon: isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                      iconColor: isDark ? Colors.amber : AppColors.textSecondaryLight,
                      title: 'Dark Mode',
                      subtitle: isDark ? 'Currently dark' : 'Currently light',
                      trailing: Switch.adaptive(
                        value: isDark,
                        onChanged: (_) =>
                            ref.read(themeProvider.notifier).toggleTheme(),
                        activeColor: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // News Section
                _SectionLabel(label: 'NEWS PREFERENCES'),
                const SizedBox(height: 8),
                _SettingsCard(
                  children: [
                    _SettingsTile(
                      icon: Icons.language_rounded,
                      iconColor: AppColors.primary,
                      title: 'Country',
                      subtitle: 'United States',
                      trailing: const Icon(Icons.chevron_right_rounded),
                    ),
                    const _SettingsDivider(),
                    _SettingsTile(
                      icon: Icons.translate_rounded,
                      iconColor: AppColors.techColor,
                      title: 'Language',
                      subtitle: 'English',
                      trailing: const Icon(Icons.chevron_right_rounded),
                    ),
                    const _SettingsDivider(),
                    _SettingsTile(
                      icon: Icons.notifications_rounded,
                      iconColor: AppColors.accent,
                      title: 'Push Notifications',
                      subtitle: 'Breaking news alerts',
                      trailing: Switch.adaptive(
                        value: true,
                        onChanged: (_) {},
                        activeColor: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Data Section
                _SectionLabel(label: 'DATA & STORAGE'),
                const SizedBox(height: 8),
                _SettingsCard(
                  children: [
                    _SettingsTile(
                      icon: Icons.download_rounded,
                      iconColor: AppColors.sportsColor,
                      title: 'Offline Reading',
                      subtitle: 'Cache articles for offline access',
                      trailing: Switch.adaptive(
                        value: true,
                        onChanged: (_) {},
                        activeColor: AppColors.primary,
                      ),
                    ),
                    const _SettingsDivider(),
                    _SettingsTile(
                      icon: Icons.delete_outline_rounded,
                      iconColor: Colors.red[400]!,
                      title: 'Clear Cache',
                      subtitle: 'Free up storage space',
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => _showClearCacheDialog(context),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // About
                _SectionLabel(label: 'ABOUT'),
                const SizedBox(height: 8),
                _SettingsCard(
                  children: [
                    _SettingsTile(
                      icon: Icons.info_outline_rounded,
                      iconColor: AppColors.scienceColor,
                      title: 'App Version',
                      subtitle: AppConstants.appVersion,
                    ),
                    const _SettingsDivider(),
                    _SettingsTile(
                      icon: Icons.article_outlined,
                      iconColor: AppColors.businessColor,
                      title: 'Powered by',
                      subtitle: 'NewsAPI.org',
                      trailing: const Icon(Icons.open_in_new_rounded, size: 16),
                    ),
                    const _SettingsDivider(),
                    _SettingsTile(
                      icon: Icons.privacy_tip_outlined,
                      iconColor: AppColors.generalColor,
                      title: 'Privacy Policy',
                      trailing: const Icon(Icons.chevron_right_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // App name footer
                Center(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              theme.colorScheme.primary,
                              theme.colorScheme.primary.withOpacity(0.7),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.language_rounded,
                            color: Colors.white, size: 24),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppConstants.appName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Stay informed, stay ahead',
                        style: theme.textTheme.labelMedium,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  void _showClearCacheDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache?'),
        content: const Text('This will remove all cached articles.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Clear'),
          ),
        ],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;

  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 1.0,
          ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;

  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
        ),
      ),
      child: Column(children: children),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.titleSmall),
                  if (subtitle != null)
                    Text(subtitle!, style: theme.textTheme.labelMedium),
                ],
              ),
            ),
            if (trailing != null)
              DefaultTextStyle(
                style: TextStyle(color: theme.textTheme.bodySmall?.color),
                child: IconTheme(
                  data: IconThemeData(
                      color: theme.textTheme.bodySmall?.color, size: 20),
                  child: trailing!,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SettingsDivider extends StatelessWidget {
  const _SettingsDivider();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Divider(
      height: 1,
      indent: 66,
      endIndent: 0,
      color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
    );
  }
}
