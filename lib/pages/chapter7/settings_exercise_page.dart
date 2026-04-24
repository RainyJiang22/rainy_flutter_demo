import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsExercisePage extends StatelessWidget {
  const SettingsExercisePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SettingsExerciseModel(),
      child: const _SettingsExerciseView(),
    );
  }
}

class _SettingsExerciseView extends StatelessWidget {
  const _SettingsExerciseView();

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsExerciseModel>(
      builder: (context, settings, _) {
        final brightness = switch (settings.themeMode) {
          ThemeMode.light => Brightness.light,
          ThemeMode.dark => Brightness.dark,
          ThemeMode.system => Theme.of(context).brightness,
        };

        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(settings.textScale)),
          child: Theme(
            data: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: settings.seedColor,
                brightness: brightness,
              ),
            ),
            child: Scaffold(
              appBar: AppBar(title: const Text('设置页面练习')),
              body: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _SettingsPreviewCard(settings: settings),
                  const SizedBox(height: 20),
                  _SettingsSection(
                    title: '外观',
                    children: [
                      ListTile(
                        leading: const Icon(Icons.dark_mode_outlined),
                        title: const Text('主题模式'),
                        subtitle: Text(settings.themeModeLabel),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => _showThemeDialog(context, settings),
                      ),
                      ListTile(
                        leading: const Icon(Icons.palette_outlined),
                        title: const Text('主题色'),
                        subtitle: Text(settings.seedColorLabel),
                        trailing: CircleAvatar(
                          radius: 12,
                          backgroundColor: settings.seedColor,
                        ),
                        onTap: () => _showSeedColorDialog(context, settings),
                      ),
                      ListTile(
                        leading: const Icon(Icons.format_size_outlined),
                        title: const Text('字体缩放'),
                        subtitle: Text(
                          '${(settings.textScale * 100).round()}%',
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => _showTextScaleSheet(context, settings),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _SettingsSection(
                    title: '偏好',
                    children: [
                      SwitchListTile(
                        secondary: const Icon(Icons.notifications_outlined),
                        title: const Text('接收通知'),
                        subtitle: const Text('模拟推送与提醒设置'),
                        value: settings.notificationsEnabled,
                        onChanged: settings.setNotificationsEnabled,
                      ),
                      SwitchListTile(
                        secondary: const Icon(Icons.fingerprint),
                        title: const Text('生物识别'),
                        subtitle: const Text('用于下次快速登录'),
                        value: settings.biometricEnabled,
                        onChanged: settings.setBiometricEnabled,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _SettingsSection(
                    title: '说明',
                    children: const [
                      ListTile(
                        leading: Icon(Icons.info_outline),
                        title: Text('练习点'),
                        subtitle: Text(
                          '本页重点练习 Theme、ThemeMode、MediaQuery 和设置项状态联动。',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showThemeDialog(
    BuildContext context,
    SettingsExerciseModel settings,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('选择主题模式'),
          content: RadioGroup<ThemeMode>(
            groupValue: settings.themeMode,
            onChanged: (value) {
              if (value == null) {
                return;
              }
              settings.setThemeMode(value);
              Navigator.of(dialogContext).pop();
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: ThemeMode.values
                  .map(
                    (mode) => RadioListTile<ThemeMode>(
                      contentPadding: EdgeInsets.zero,
                      title: Text(_themeModeLabel(mode)),
                      value: mode,
                    ),
                  )
                  .toList(growable: false),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showSeedColorDialog(
    BuildContext context,
    SettingsExerciseModel settings,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('选择主题色'),
          content: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: SettingsExerciseModel.seedOptions.entries
                .map((entry) {
                  final selected = entry.value == settings.seedColor;
                  return InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      settings.setSeedColor(entry.value);
                      Navigator.of(dialogContext).pop();
                    },
                    child: Container(
                      width: 72,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: entry.value.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: selected ? entry.value : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        children: [
                          CircleAvatar(backgroundColor: entry.value),
                          const SizedBox(height: 8),
                          Text(
                            entry.key,
                            style: Theme.of(dialogContext).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  );
                })
                .toList(growable: false),
          ),
        );
      },
    );
  }

  Future<void> _showTextScaleSheet(
    BuildContext context,
    SettingsExerciseModel settings,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '调整字体缩放',
                style: Theme.of(
                  sheetContext,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              Consumer<SettingsExerciseModel>(
                builder: (context, model, _) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('当前：${(model.textScale * 100).round()}%'),
                      Slider(
                        min: 0.9,
                        max: 1.4,
                        divisions: 5,
                        value: model.textScale,
                        onChanged: model.setTextScale,
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  String _themeModeLabel(ThemeMode mode) {
    return switch (mode) {
      ThemeMode.system => '跟随系统',
      ThemeMode.light => '浅色模式',
      ThemeMode.dark => '深色模式',
    };
  }
}

class _SettingsPreviewCard extends StatelessWidget {
  const _SettingsPreviewCard({required this.settings});

  final SettingsExerciseModel settings;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primaryContainer,
            Theme.of(context).colorScheme.tertiaryContainer,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '实时预览',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          Text('主题：${settings.themeModeLabel}'),
          Text('主题色：${settings.seedColorLabel}'),
          Text('通知：${settings.notificationsEnabled ? "开启" : "关闭"}'),
          Text('字体：${(settings.textScale * 100).round()}%'),
          const SizedBox(height: 16),
          FilledButton.tonal(onPressed: () {}, child: const Text('预览按钮')),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            ...children,
          ],
        ),
      ),
    );
  }
}

class SettingsExerciseModel extends ChangeNotifier {
  static const Map<String, Color> seedOptions = {
    '青绿': Colors.teal,
    '琥珀': Colors.amber,
    '珊瑚': Colors.deepOrange,
    '靛蓝': Colors.indigo,
  };

  ThemeMode _themeMode = ThemeMode.system;
  bool _notificationsEnabled = true;
  bool _biometricEnabled = false;
  double _textScale = 1.0;
  Color _seedColor = Colors.teal;

  ThemeMode get themeMode => _themeMode;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get biometricEnabled => _biometricEnabled;
  double get textScale => _textScale;
  Color get seedColor => _seedColor;

  String get themeModeLabel {
    return switch (_themeMode) {
      ThemeMode.system => '跟随系统',
      ThemeMode.light => '浅色模式',
      ThemeMode.dark => '深色模式',
    };
  }

  String get seedColorLabel {
    for (final entry in seedOptions.entries) {
      if (entry.value == _seedColor) {
        return entry.key;
      }
    }
    return '自定义';
  }

  void setThemeMode(ThemeMode value) {
    _themeMode = value;
    notifyListeners();
  }

  void setNotificationsEnabled(bool value) {
    _notificationsEnabled = value;
    notifyListeners();
  }

  void setBiometricEnabled(bool value) {
    _biometricEnabled = value;
    notifyListeners();
  }

  void setTextScale(double value) {
    _textScale = value;
    notifyListeners();
  }

  void setSeedColor(Color value) {
    _seedColor = value;
    notifyListeners();
  }
}
