# 第9章：动画

## 📖 章节概述

第9章围绕 Flutter 动画体系展开，核心目标是把“会动”拆成可理解、可组合、可维护的几类能力：显式动画、路由过渡、共享元素动画、交织动画、切换动画和隐式动画。  
书里的主线非常清晰: 先理解 `Animation<double>` 这条 0 到 1 的时间轴，再理解如何把时间轴映射成尺寸、透明度、位置、颜色等 UI 状态。

### 学习目标

- 理解 Flutter 动画的基本抽象：`Animation`、`AnimationController`、`Tween`、`Curve`
- 掌握显式动画的标准结构和生命周期管理
- 能实现自定义页面切换、Hero 共享元素动画、交织动画
- 能在简单场景中优先使用 `AnimatedSwitcher`、`AnimatedContainer` 等隐式动画
- 理解动画性能优化的基本思路，避免不必要的整树重建

### 知识点总览

| 小节 | 核心内容 | 难度 | 重要性 | 一句话总结 |
| --- | --- | --- | --- | --- |
| 9.1 | 动画原理、插值、曲线 | 中 | 高 | 先理解“时间如何变成 UI 变化” |
| 9.2 | `AnimationController` + `Tween` + 监听 | 中 | 高 | 显式动画的标准模板 |
| 9.3 | `PageRouteBuilder` 自定义路由过渡 | 中 | 高 | 页面切换本质上也是动画 |
| 9.4 | `Hero` 共享元素动画 | 低 | 高 | 两个页面用相同 `tag` 连接同一个视觉元素 |
| 9.5 | 交织动画 `Interval` | 高 | 中 | 一个控制器驱动多个阶段 |
| 9.6 | `AnimatedSwitcher` | 低 | 高 | 子节点替换时自动做切换动画 |
| 9.7 | 隐式动画与过渡组件 | 中 | 高 | 简单属性变化优先用系统封装好的动画组件 |

### 学习难度评估

- 入门门槛：中等
- 真正常见难点：不是 API 多，而是“不知道什么时候该用显式动画、什么时候该用隐式动画”
- 本章最值得反复练的 3 个点：
  - `AnimatedBuilder` 的使用方式
  - `PageRouteBuilder` 和 `Hero` 的组合
  - `Interval` 拆分动画阶段

## 💡 核心概念

### 9.1 动画原理

动画的本质是：在一段时间内连续多次改变 UI。  
Flutter 用 `Animation<double>` 表示“当前进度”，它通常在 `[0, 1]` 之间变化。

这一节要抓住 4 个关键词：

- `AnimationController`
  - 负责推进时间轴
  - 决定动画时长、正向/反向、暂停、重复
- `Tween<T>`
  - 负责把 `[0, 1]` 的进度映射成具体业务值
  - 例如 `Tween<double>(begin: 80, end: 180)`
- `Curve`
  - 负责改变速度曲线
  - 例如 `Curves.easeInOut`、`Curves.easeOutBack`
- `lerp`
  - 线性插值
  - 书里强调了很多属性本质上都是通过插值计算每一帧状态

可以把动画过程理解成：

```text
AnimationController 提供时间进度 t
        ↓
Curve 对 t 做速度映射
        ↓
Tween 把 t 映射成具体状态值
        ↓
Widget 根据状态值重建当前帧
```

### 9.2 动画基本结构

显式动画的标准结构基本固定：

1. `StatefulWidget`
2. `State` 混入 `SingleTickerProviderStateMixin`
3. 在 `initState` 中创建 `AnimationController`
4. 用 `Tween.animate()` 或 `Tween.chain()` 构建动画
5. 使用 `AnimatedBuilder`、`AnimatedWidget` 或监听器驱动 UI 更新
6. 在 `dispose` 中释放 controller

这节最重要的工程化结论：

- 简单动画不要直接在 `addListener` 里 `setState` 整页
- 优先用 `AnimatedBuilder`
- 用 `AnimatedBuilder` 的 `child` 参数缓存不变子树

### 9.3 自定义路由过渡动画

`MaterialPageRoute` 和 `CupertinoPageRoute` 提供平台默认切换效果；  
如果要做定制动画，核心入口就是 `PageRouteBuilder`。

你需要重点理解两个回调：

- `pageBuilder`
  - 构建目标页面
- `transitionsBuilder`
  - 使用 `animation` 和 `secondaryAnimation` 生成过渡效果

常见做法：

- `FadeTransition`
- `SlideTransition`
- `ScaleTransition`
- 多种过渡叠加

### 9.4 Hero 动画

Hero 是“共享元素转场”。  
它的关键不是“页面整体怎么动”，而是“两个页面中同一个视觉元素怎么连续过渡”。

实现条件很简单：

- 起始页有 `Hero(tag: 'x', child: ...)`
- 目标页有 `Hero(tag: 'x', child: ...)`
- `Navigator.push()` 或 `pop()` 触发路由变化

注意点：

- 前后页面的 `tag` 必须完全一致
- 两边 Hero 内部结构越接近，效果通常越稳定
- Hero 适合图片、卡片、头像、商品封面等“视觉焦点元素”

### 9.5 交织动画

交织动画的核心思想是：  
一个 `AnimationController` 驱动多个属性，每个属性只占总时间轴中的一段。

关键工具是 `Interval`：

```dart
const Interval(0.0, 0.6)
const Interval(0.6, 1.0)
```

适合的场景：

- 卡片先放大，再位移
- 面板先淡入，再展开
- 列表项依次进入

真正要点不是“写更多动画”，而是“设计阶段顺序”。

### 9.6 AnimatedSwitcher

`AnimatedSwitcher` 解决的是“子节点换了，切换过程不要太生硬”。

它非常适合：

- 数字变化
- 占位态与内容态切换
- 登录/加载/错误态切换
- 标签页的小范围视图切换

这节最容易踩坑的一点是 `Key`：

- 如果新旧 child 没有被框架识别为不同节点，就不会触发预期切换
- 常见做法是给文本、卡片等 child 设置 `ValueKey(value)`

### 9.7 动画过渡组件

这节的核心是“隐式动画”。  
当你只是想在属性变化时自动补一段过渡，通常不需要手写 controller。

常见组件：

- `AnimatedContainer`
- `AnimatedOpacity`
- `AnimatedAlign`
- `AnimatedPadding`
- `AnimatedPositioned`
- `AnimatedDefaultTextStyle`

判断标准很简单：

- 如果只改一个或几个属性，并且过程固定：优先隐式动画
- 如果要精确控制进度、节奏、同步多个阶段：使用显式动画

## 📝 代码示例

### 示例1：显式动画基础

**适用知识点**：9.1、9.2  
**目标**：理解 controller、curve、tween、AnimatedBuilder 的配合方式。

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const BasicAnimationApp());
}

/// 显式动画基础示例
class BasicAnimationApp extends StatelessWidget {
  const BasicAnimationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '显式动画基础',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
      ),
      home: const ScaleDemoPage(),
    );
  }
}

class ScaleDemoPage extends StatefulWidget {
  const ScaleDemoPage({super.key});

  @override
  State<ScaleDemoPage> createState() => _ScaleDemoPageState();
}

class _ScaleDemoPageState extends State<ScaleDemoPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _sizeAnimation;
  bool _expanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _sizeAnimation = Tween<double>(begin: 88, end: 180).chain(
      CurveTween(curve: Curves.easeInOut),
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose(); // controller 必须释放
    super.dispose();
  }

  void _toggle() {
    if (_expanded) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    setState(() {
      _expanded = !_expanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('显式动画基础')),
      body: Center(
        child: AnimatedBuilder(
          animation: _sizeAnimation,
          child: const FlutterLogo(),
          builder: (context, child) {
            return Container(
              width: _sizeAnimation.value,
              height: _sizeAnimation.value,
              decoration: BoxDecoration(
                color: Colors.teal.withOpacity(0.12),
                borderRadius: BorderRadius.circular(24),
              ),
              alignment: Alignment.center,
              child: child,
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _toggle,
        icon: const Icon(Icons.animation),
        label: Text(_expanded ? '缩小' : '放大'),
      ),
    );
  }
}
```

**运行效果**：

- 页面中央的 `FlutterLogo` 容器在 88 到 180 之间平滑缩放
- 点击右下角按钮可正向/反向执行动画

**学习要点**：

- `AnimationController` 只负责推进时间
- `Tween` 负责把时间映射成尺寸
- `AnimatedBuilder` 负责把动画值转成 UI

### 示例2：自定义路由过渡 + Hero

**适用知识点**：9.3、9.4  
**目标**：把页面切换动画和共享元素动画组合起来。

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const RouteHeroApp());
}

class RouteHeroApp extends StatelessWidget {
  const RouteHeroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '路由与 Hero 动画',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      home: const GalleryHomePage(),
    );
  }
}

class GalleryHomePage extends StatelessWidget {
  const GalleryHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('路由过渡 + Hero')),
      body: Center(
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: () {
            Navigator.of(context).push(_buildDetailRoute());
          },
          child: Hero(
            tag: 'demo-card',
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: const LinearGradient(
                  colors: [Color(0xFF4F46E5), Color(0xFF06B6D4)],
                ),
              ),
              alignment: Alignment.center,
              child: const FlutterLogo(size: 96),
            ),
          ),
        ),
      ),
    );
  }
}

Route<void> _buildDetailRoute() {
  return PageRouteBuilder<void>(
    transitionDuration: const Duration(milliseconds: 450),
    pageBuilder: (context, animation, secondaryAnimation) {
      return const DetailPage();
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );

      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.08),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        ),
      );
    },
  );
}

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('详情页')),
      body: Center(
        child: Hero(
          tag: 'demo-card', // 前后页面 tag 必须一致
          child: Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              gradient: const LinearGradient(
                colors: [Color(0xFF4F46E5), Color(0xFF06B6D4)],
              ),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 24,
                  offset: Offset(0, 12),
                  color: Colors.black26,
                ),
              ],
            ),
            alignment: Alignment.center,
            child: const FlutterLogo(size: 140),
          ),
        ),
      ),
    );
  }
}
```

**运行效果**：

- 点击首页卡片，页面以淡入 + 上移的方式进入
- 卡片本身会从首页连续“飞”到详情页的大卡片位置

**学习要点**：

- `PageRouteBuilder` 负责整个页面转场
- `Hero` 负责局部共享元素转场
- 这两类动画可以叠加，不冲突

### 示例3：AnimatedSwitcher + AnimatedContainer

**适用知识点**：9.6、9.7  
**目标**：理解“简单属性变化优先用隐式动画”。

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const ImplicitAnimationApp());
}

class ImplicitAnimationApp extends StatelessWidget {
  const ImplicitAnimationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '隐式动画示例',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.orange,
      ),
      home: const ImplicitAnimationPage(),
    );
  }
}

class ImplicitAnimationPage extends StatefulWidget {
  const ImplicitAnimationPage({super.key});

  @override
  State<ImplicitAnimationPage> createState() => _ImplicitAnimationPageState();
}

class _ImplicitAnimationPageState extends State<ImplicitAnimationPage> {
  int _count = 0;
  bool _selected = false;

  void _increment() {
    setState(() {
      _count++;
      _selected = !_selected;
    });
  }

  @override
  Widget build(BuildContext context) {
    final color = _selected ? Colors.deepOrange : Colors.blue;
    final radius = _selected ? 36.0 : 12.0;

    return Scaffold(
      appBar: AppBar(title: const Text('隐式动画')),
      body: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          width: _selected ? 260 : 200,
          height: _selected ? 260 : 200,
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(radius),
          ),
          alignment: Alignment.center,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 260),
            transitionBuilder: (child, animation) {
              return ScaleTransition(
                scale: animation,
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              );
            },
            child: Text(
              '$_count',
              key: ValueKey(_count), // 没有 key 时切换可能不明显
              style: Theme.of(context).textTheme.displayLarge,
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _increment,
        icon: const Icon(Icons.add),
        label: const Text('增加'),
      ),
    );
  }
}
```

**运行效果**：

- 点一次按钮，数字会切换动画显示
- 同时容器的尺寸、圆角、颜色也会自动过渡

**学习要点**：

- 子节点切换用 `AnimatedSwitcher`
- 属性切换用 `AnimatedContainer`
- 简单场景不需要自己手动维护 controller

## ⚠️ 版本变更

### 当前版本背景

- 书籍基于 Flutter 3.0 时代内容
- Flutter 官方文档当前反映的是 **Flutter 3.44.0**
- Flutter SDK archive 显示 **3.44.0 stable 于 2026-05-18 发布**

### 本章相关 API 现状

第9章的大部分动画 API 在当前稳定版里仍然成立，没有出现“整章失效”的情况。变化主要集中在代码风格、Material 3、工程默认配置，而不是动画体系被推翻。

### 推荐写法对比

#### 1. Material 3 默认思维

```dart
// ✅ 当前推荐
MaterialApp(
  theme: ThemeData(
    useMaterial3: true,
    colorSchemeSeed: Colors.blue,
  ),
)
```

说明：

- 书中的动画示例多以 Material 2 时代的视觉风格展示
- 现在应默认以 Material 3 主题理解示例

#### 2. Widget 构造与空安全

```dart
// ❌ 旧风格
class DemoPage extends StatelessWidget {
  DemoPage({Key key}) : super(key: key);
}

// ✅ 当前推荐
class DemoPage extends StatelessWidget {
  const DemoPage({super.key});
}
```

说明：

- 当前代码应全面采用空安全
- 优先使用 `const` 构造器与 `super.key`

#### 3. `AnimatedBuilder` 优先于监听器里整页 `setState`

```dart
// ❌ 可运行，但重建范围通常过大
animation.addListener(() {
  setState(() {});
});

// ✅ 更推荐
AnimatedBuilder(
  animation: animation,
  builder: (context, child) {
    return Transform.scale(
      scale: animation.value,
      child: child,
    );
  },
  child: const FlutterLogo(),
)
```

说明：

- 书里会展示监听器方案帮助理解原理
- 实际项目里更推荐 `AnimatedBuilder`

#### 4. 隐式动画仍然是当前主流简化方案

```dart
// ✅ 简单属性变化优先用隐式动画
AnimatedOpacity(
  duration: const Duration(milliseconds: 300),
  opacity: visible ? 1 : 0,
  child: const Text('Hello'),
)
```

说明：

- `AnimatedContainer`、`AnimatedOpacity`、`AnimatedSwitcher` 仍是当前常用方案
- 很多业务场景不需要手写 controller

### 这一章里值得特别记住的现代建议

- Hero、PageRouteBuilder、AnimatedSwitcher、AnimatedContainer 都仍然是主流 API
- 当前版本更强调 `const`、小粒度重建、Material 3 主题一致性
- 如果是复杂导航项目，页面组织通常会配合 `go_router` 等路由库，但动画底层概念没有变

## 🎯 实践建议

### 学习重点

- 先用 `AnimatedContainer` / `AnimatedSwitcher` 理解“动效不是神秘机制，只是状态变化带来的过渡”
- 再掌握 `AnimationController + Tween + Curve + AnimatedBuilder`
- 最后练 `Hero` 和 `Interval`，因为它们更接近真实产品场景

### 常见错误

- 忘记 `dispose()` controller
  - 结果：Ticker 泄漏，控制台会报警告
- 在 `AnimatedSwitcher` 里没给变化 child 设置 `Key`
  - 结果：看起来“不触发动画”
- Hero 前后页面 `tag` 不一致
  - 结果：共享元素飞行动画失效
- 在 `addListener` 里整页 `setState`
  - 结果：重建范围过大，动画掉帧风险上升
- 一个简单透明度切换也强行手写 controller
  - 结果：代码复杂度明显上升，没有收益

### 性能优化建议

- 简单属性过渡优先使用隐式动画组件
- `AnimatedBuilder` 的 `child` 参数尽量复用不变子树
- 复杂区域可用 `RepaintBoundary` 隔离重绘
- 不要在动画帧里做 I/O、解析、列表排序等重活
- 交织动画尽量让多个属性共享同一个 controller，减少状态分散

## 实战练习

#### 练习项目1：动画展示台（完整代码）

**目标**：  
把第9章最常见的 5 类动画能力放进一个单文件项目里：

- 显式缩放动画
- 交织动画
- 自定义页面切换
- Hero 共享元素动画
- `AnimatedSwitcher` 与 `AnimatedContainer`

**完整代码**：

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const AnimationShowcaseApp());
}

/// 综合练习项目
class AnimationShowcaseApp extends StatelessWidget {
  const AnimationShowcaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '第9章综合练习',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF0F766E),
      ),
      home: const ShowcaseHomePage(),
    );
  }
}

class ShowcaseHomePage extends StatefulWidget {
  const ShowcaseHomePage({super.key});

  @override
  State<ShowcaseHomePage> createState() => _ShowcaseHomePageState();
}

class _ShowcaseHomePageState extends State<ShowcaseHomePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _panelHeight;
  late final Animation<double> _panelOpacity;
  late final Animation<Offset> _panelOffset;

  int _count = 0;
  bool _highlight = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _scale = Tween<double>(begin: 0.92, end: 1.08).chain(
      CurveTween(curve: Curves.easeInOut),
    ).animate(_controller);

    _panelHeight = Tween<double>(begin: 120, end: 220).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.55, curve: Curves.easeOutCubic),
      ),
    );

    _panelOpacity = Tween<double>(begin: 0.25, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.45, curve: Curves.easeIn),
      ),
    );

    _panelOffset = Tween<Offset>(
      begin: const Offset(0.16, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.55, 1.0, curve: Curves.easeOutBack),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _playOrReverse() {
    if (_controller.status == AnimationStatus.completed) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  void _incrementCounter() {
    setState(() {
      _count++;
      _highlight = !_highlight;
    });
  }

  void _openDetailPage() {
    Navigator.of(context).push(_buildShowcaseRoute(_highlight));
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('第9章动画展示台'),
        actions: [
          IconButton(
            onPressed: _playOrReverse,
            icon: const Icon(Icons.play_circle_outline),
            tooltip: '播放交织动画',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            '一页里练 5 种常见动画',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          AnimatedBuilder(
            animation: _controller,
            child: const FlutterLogo(size: 96),
            builder: (context, child) {
              return Transform.scale(
                scale: _scale.value,
                child: Center(
                  child: Hero(
                    tag: 'showcase-hero',
                    child: InkWell(
                      borderRadius: BorderRadius.circular(28),
                      onTap: _openDetailPage,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.easeInOut,
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            _highlight ? 40 : 24,
                          ),
                          gradient: LinearGradient(
                            colors: _highlight
                                ? const [Color(0xFF0F766E), Color(0xFF14B8A6)]
                                : const [Color(0xFF1D4ED8), Color(0xFF60A5FA)],
                          ),
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 24,
                              offset: Offset(0, 12),
                              color: Colors.black26,
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: child,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Opacity(
                opacity: _panelOpacity.value,
                child: SlideTransition(
                  position: _panelOffset,
                  child: Container(
                    height: _panelHeight.value,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: scheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '交织动画面板',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '前半段先淡入并增高，后半段再水平滑入。',
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            FilledButton.icon(
                              onPressed: _playOrReverse,
                              icon: const Icon(Icons.auto_awesome),
                              label: const Text('播放'),
                            ),
                            const SizedBox(width: 12),
                            OutlinedButton.icon(
                              onPressed: _openDetailPage,
                              icon: const Icon(Icons.arrow_forward),
                              label: const Text('打开详情'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: scheme.surfaceContainer,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AnimatedSwitcher 计数器',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 6),
                    const Text('每次点击都会做数字切换动画'),
                  ],
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 240),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(
                      scale: animation,
                      child: FadeTransition(
                        opacity: animation,
                        child: child,
                      ),
                    );
                  },
                  child: Text(
                    '$_count',
                    key: ValueKey(_count),
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _incrementCounter,
            icon: const Icon(Icons.add),
            label: const Text('增加计数并切换卡片样式'),
          ),
        ],
      ),
    );
  }
}

Route<void> _buildShowcaseRoute(bool highlight) {
  return PageRouteBuilder<void>(
    transitionDuration: const Duration(milliseconds: 420),
    pageBuilder: (context, animation, secondaryAnimation) {
      return DetailShowcasePage(highlight: highlight);
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );

      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.06),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        ),
      );
    },
  );
}

class DetailShowcasePage extends StatefulWidget {
  const DetailShowcasePage({
    super.key,
    required this.highlight,
  });

  final bool highlight;

  @override
  State<DetailShowcasePage> createState() => _DetailShowcasePageState();
}

class _DetailShowcasePageState extends State<DetailShowcasePage> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final colors = widget.highlight
        ? const [Color(0xFF0F766E), Color(0xFF14B8A6)]
        : const [Color(0xFF1D4ED8), Color(0xFF60A5FA)];

    return Scaffold(
      appBar: AppBar(title: const Text('动画详情页')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Hero(
              tag: 'showcase-hero',
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 380),
                curve: Curves.easeInOut,
                width: _expanded ? double.infinity : 260,
                height: _expanded ? 280 : 220,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(_expanded ? 36 : 28),
                  gradient: LinearGradient(colors: colors),
                ),
                alignment: Alignment.center,
                child: const FlutterLogo(size: 120),
              ),
            ),
            const SizedBox(height: 24),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: _expanded ? 1 : 0.65,
              child: const Text(
                '这里同时使用了 Hero、PageRouteBuilder 和 AnimatedContainer。',
                textAlign: TextAlign.center,
              ),
            ),
            const Spacer(),
            FilledButton(
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
              child: Text(_expanded ? '恢复卡片尺寸' : '展开卡片'),
            ),
          ],
        ),
      ),
    );
  }
}
```

**运行效果**：

- 首页顶部卡片持续可做轻微缩放
- 点击工具栏按钮，交织动画面板会依次淡入、增高、滑入
- 点击卡片，页面以自定义转场进入详情页，同时卡片触发 Hero 飞行动画
- 页面内计数器使用 `AnimatedSwitcher`
- 详情页按钮再触发一次 `AnimatedContainer` 和 `AnimatedOpacity`

**学习要点**：

- `AnimationController` 可以同时驱动多个动画
- `Interval` 适合把一条时间轴切成多个阶段
- 路由切换动画和 Hero 可以同时存在
- 简单属性变化没有必要继续手写 controller

### 扩展挑战

- 给交织动画面板增加颜色过渡
- 把 Hero 卡片换成商品列表，练习真实共享元素场景
- 在 `AnimatedSwitcher` 中自定义左右滑动切换效果
- 把详情页的尺寸变化改成 `AnimatedSize`

## 📚 扩展学习

### 相关章节

- 第7章：功能型组件
  - 理解 `ValueListenableBuilder`、`FutureBuilder` 后，更容易看懂动画驱动 UI 的方式
- 第8章：事件处理与通知
  - 手势是动画触发入口，尤其是拖拽、滑动、按压反馈
- 第10章：自定义组件
  - 如果想自己封装动画组件，下一章是自然延伸
- 第14章：Flutter 核心原理
  - 想理解重建、重绘、渲染管线与动画性能，最终要回到核心原理

### 进阶学习路径

1. 先熟练 `AnimatedContainer`、`AnimatedOpacity`、`AnimatedSwitcher`
2. 再熟练 `AnimationController`、`Tween`、`Curve`、`AnimatedBuilder`
3. 接着练 `Hero`、`PageRouteBuilder`、`Interval`
4. 最后再看自定义过渡组件、复杂列表入场、拖拽驱动动画

### 参考资料

- 书籍第9章目录：https://book.flutterchina.club/chapter9/index
- 9.1 Flutter 动画简介：https://book.flutterchina.club/chapter9/intro.html
- 9.2 动画基本结构及状态监听：https://book.flutterchina.club/chapter9/animation_structure.html
- 9.3 自定义路由切换动画：https://book.flutterchina.club/chapter9/route_transition.html
- 9.4 Hero 动画：https://book.flutterchina.club/chapter9/hero.html
- 9.5 交织动画：https://book.flutterchina.club/chapter9/stagger_animation.html
- 9.6 动画切换组件 AnimatedSwitcher：https://book.flutterchina.club/chapter9/animated_switcher.html
- 9.7 动画过渡组件：https://book.flutterchina.club/chapter9/animated_widgets.html
- Flutter 动画总览：https://docs.flutter.dev/ui/animations
- Hero 官方文档：https://docs.flutter.dev/ui/animations/hero-animations
- 自定义页面转场 cookbook：https://docs.flutter.dev/cookbook/animation/page-route-animation
- 隐式动画官方文档：https://docs.flutter.dev/ui/animations/implicit-animations
- 交织动画官方文档：https://docs.flutter.dev/ui/animations/staggered-animations
- Flutter 版本与发布信息：https://docs.flutter.dev/install/archive

## 总结一句话

第9章真正要学会的不是“背多少动画组件”，而是建立一个稳定判断：

- 简单属性变化，用隐式动画
- 页面切换，用路由过渡
- 共享元素，用 Hero
- 多阶段协同，用 `AnimationController + Interval`
- 要控制重建范围，用 `AnimatedBuilder`
