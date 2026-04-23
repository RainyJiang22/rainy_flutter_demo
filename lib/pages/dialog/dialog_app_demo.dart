

import 'package:flutter/material.dart';

class DialogAppDemo extends StatelessWidget {
  const DialogAppDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("对话框"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _showDeleteConfirmDialog(context),
              child: const Text("删除确认对话框"),
            ),
            SizedBox(height: 16),

            ElevatedButton(
              onPressed: () => _showLanguageDialog(context),
              child: const Text('语言选中对话框'),
            ),
            SizedBox(height: 16),

            ElevatedButton(
              onPressed: () => _showCheckboxDialog(context),
              child: const Text('带复选框的对话框'),
            ),

            const SizedBox(height: 16),

            // 4. 列表对话框
            ElevatedButton(
              onPressed: () => _showListDialog(context),
              child: const Text('列表选择对话框'),
            ),
            const SizedBox(height: 16),

            // 5. 自定义动画对话框
            ElevatedButton(
              onPressed: () => _showCustomAnimDialog(context),
              child: const Text('自定义动画对话框'),
            ),
          ],
        ),
      ),
    );
  }

  /// 删除确认对话框
  Future<void> _showDeleteConfirmDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('提示'),
          content: const Text('您确定要删除当前文件吗？'),
          actions: <Widget>[
            TextButton(
              child: const Text('取消'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: const Text('删除', style: TextStyle(color: Colors.red)),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (result == true) {
      debugPrint('确认删除');
    } else {
      debugPrint('取消删除');
    }
  }
  /// 语言选择对话框
  Future<void> _showLanguageDialog(BuildContext context) async {
    final result = await showDialog<int>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('请选择语言'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 1),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text('中文简体'),
              ),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 2),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text('美国英语'),
              ),
            ),
          ],
        );
      },
    );

    if (result != null) {
      debugPrint('选择了：${result == 1 ? "中文简体" : "美国英语"}');
    }
  }

  /// 带复选框的对话框
  /// 使用StatefulBuilder管理对话框内部状态
  Future<void> _showCheckboxDialog(BuildContext context) async {
    bool withTree = false;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('提示'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('您确定要删除当前文件吗？'),
                  Row(
                    children: [
                      const Text('同时删除子目录'),
                      Checkbox(
                        value: withTree,
                        onChanged: (value) {
                          // 使用StatefulBuilder提供的setState更新对话框状态
                          setState(() {
                            withTree = value ?? false;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('取消'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(withTree),
                  child: const Text('删除'),
                ),
              ],
            );
          },
        );
      },
    );

    if (result != null) {
      debugPrint('同时删除子目录: $result');
    }
  }

  /// 列表选择对话框
  /// 使用Dialog而不是AlertDialog，因为AlertDialog不支持滚动列表
  Future<void> _showListDialog(BuildContext context) async {
    final result = await showDialog<int>(
      context: context,
      builder: (context) {
        return Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ListTile(title: Text('请选择')),
              const Divider(height: 1),
              SizedBox(
                height: 300,
                child: ListView.builder(
                  itemCount: 20,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('选项 $index'),
                      onTap: () => Navigator.of(context).pop(index),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );

    if (result != null) {
      debugPrint('选择了：选项 $result');
    }
  }

  /// 自定义动画对话框
  Future<void> _showCustomAnimDialog(BuildContext context) async {
    await showGeneralDialog(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          ),
          child: AlertDialog(
            title: const Text('自定义动画'),
            content: const Text('这是一个带缩放动画的对话框'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('关闭'),
              ),
            ],
          ),
        );
      },
      barrierColor: Colors.black45,
      barrierDismissible: true,
      barrierLabel: '关闭',
      transitionDuration: const Duration(milliseconds: 200),
    );
  }
}
