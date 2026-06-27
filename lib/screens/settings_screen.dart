import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = context.watch<AppProvider>();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            title: Text('Settings', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _SectionHeader('Appearance'),
                Card(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      SwitchListTile(
                        title: Text('Dark Mode'),
                        subtitle: Text('Use dark theme'),
                        secondary: Icon(provider.isDarkMode ? Icons.dark_mode : Icons.light_mode),
                        value: provider.isDarkMode,
                        onChanged: (_) => provider.toggleDarkMode(),
                      ),
                    ],
                  ),
                ),
                _SectionHeader('Network'),
                Card(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      SwitchListTile(
                        title: Text('Offline Mode'),
                        subtitle: Text('Use saved rates only'),
                        secondary: Icon(Icons.offline_bolt),
                        value: provider.isOfflineMode,
                        onChanged: (_) => provider.toggleOfflineMode(),
                      ),
                    ],
                  ),
                ),
                _SectionHeader('About'),
                Card(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.info),
                        title: Text('Version'),
                        trailing: Text('1.0.0', style: TextStyle(color: Colors.grey)),
                      ),
                      ListTile(
                        leading: Icon(Icons.star),
                        title: Text('Rate App'),
                        trailing: Icon(Icons.chevron_right),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: Icon(Icons.share),
                        title: Text('Share App'),
                        trailing: Icon(Icons.chevron_right),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: Icon(Icons.privacy_tip),
                        title: Text('Privacy Policy'),
                        trailing: Icon(Icons.chevron_right),
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24, 24, 24, 8),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
