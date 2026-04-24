import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginExercisePage extends StatelessWidget {
  const LoginExercisePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginExerciseModel(),
      child: const _LoginExerciseView(),
    );
  }
}

class _LoginExerciseView extends StatelessWidget {
  const _LoginExerciseView();

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginExerciseModel>(
      builder: (context, model, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('登录系统练习')),
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            child: model.isLoggedIn
                ? const _AccountDashboard(key: ValueKey('dashboard'))
                : const _LoginFormPanel(key: ValueKey('login-form')),
          ),
        );
      },
    );
  }
}

class _LoginFormPanel extends StatefulWidget {
  const _LoginFormPanel({super.key});

  @override
  State<_LoginFormPanel> createState() => _LoginFormPanelState();
}

class _LoginFormPanelState extends State<_LoginFormPanel> {
  final _formKey = GlobalKey<FormState>();
  final _accountController = TextEditingController(text: 'flutter@example.com');
  final _passwordController = TextEditingController(text: 'flutter123');
  bool _obscureText = true;

  @override
  void dispose() {
    _accountController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<LoginExerciseModel>();
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primaryContainer,
                Theme.of(context).colorScheme.secondaryContainer,
              ],
            ),
            borderRadius: BorderRadius.circular(28),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '模拟账号系统',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '练习点：表单校验、异步登录、加载状态和退出确认。\n默认密码：flutter123',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _accountController,
                    decoration: const InputDecoration(
                      labelText: '账号',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return '请输入账号';
                      }
                      if (!value.contains('@')) {
                        return '这里用邮箱格式更合适';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      labelText: '密码',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '请输入密码';
                      }
                      if (value.length < 6) {
                        return '密码至少 6 位';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 18),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('记住登录状态'),
                    subtitle: const Text('仅做交互演示，不做真实持久化'),
                    value: model.rememberMe,
                    onChanged: model.setRememberMe,
                  ),
                  const SizedBox(height: 12),
                  if (model.errorMessage != null) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        model.errorMessage!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onErrorContainer,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: model.isLoading
                          ? null
                          : () => _submit(context, model),
                      child: model.isLoading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.2,
                              ),
                            )
                          : const Text('登录'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _submit(BuildContext context, LoginExerciseModel model) async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final success = await model.login(
      account: _accountController.text.trim(),
      password: _passwordController.text,
    );

    if (success && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('登录成功')));
    }
  }
}

class _AccountDashboard extends StatelessWidget {
  const _AccountDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<LoginExerciseModel>();
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Text(
                  model.displayName.characters.first.toUpperCase(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.displayName,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text('上次登录：${model.lastLoginText}'),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: const [
              ListTile(
                leading: Icon(Icons.verified_user_outlined),
                title: Text('会话状态'),
                subtitle: Text('当前处于已登录状态，页面已从表单切换到个人面板。'),
              ),
              Divider(height: 1),
              ListTile(
                leading: Icon(Icons.timer_outlined),
                title: Text('异步流程'),
                subtitle: Text('登录过程通过 Future.delayed 模拟网络请求。'),
              ),
              Divider(height: 1),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('退出登录'),
                subtitle: Text('点击底部按钮会弹出确认对话框。'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        FilledButton.icon(
          onPressed: () => _showLogoutDialog(context),
          icon: const Icon(Icons.logout),
          label: const Text('退出登录'),
        ),
      ],
    );
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('退出登录'),
          content: const Text('确认结束当前会话吗？'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('取消'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('退出'),
            ),
          ],
        );
      },
    );

    if (confirmed == true && context.mounted) {
      context.read<LoginExerciseModel>().logout();
    }
  }
}

class LoginExerciseModel extends ChangeNotifier {
  bool _isLoading = false;
  bool _isLoggedIn = false;
  bool _rememberMe = true;
  String? _errorMessage;
  String _displayName = '';
  DateTime? _lastLoginAt;

  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;
  bool get rememberMe => _rememberMe;
  String? get errorMessage => _errorMessage;
  String get displayName => _displayName;

  String get lastLoginText {
    final loginAt = _lastLoginAt;
    if (loginAt == null) {
      return '暂无记录';
    }
    final hour = loginAt.hour.toString().padLeft(2, '0');
    final minute = loginAt.minute.toString().padLeft(2, '0');
    return '${loginAt.month}月${loginAt.day}日 $hour:$minute';
  }

  void setRememberMe(bool value) {
    _rememberMe = value;
    notifyListeners();
  }

  Future<bool> login({
    required String account,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future<void>.delayed(const Duration(milliseconds: 1200));

    if (password != 'flutter123') {
      _isLoading = false;
      _isLoggedIn = false;
      _errorMessage = '密码错误，示例默认密码是 flutter123';
      notifyListeners();
      return false;
    }

    _isLoading = false;
    _isLoggedIn = true;
    _displayName = account.split('@').first;
    _lastLoginAt = DateTime.now();
    _errorMessage = null;
    notifyListeners();
    return true;
  }

  void logout() {
    _isLoggedIn = false;
    _errorMessage = null;
    notifyListeners();
  }
}
