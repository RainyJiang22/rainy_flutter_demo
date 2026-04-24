import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartExercisePage extends StatelessWidget {
  const CartExercisePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CartExerciseModel(),
      child: const _CartExerciseView(),
    );
  }
}

class _CartExerciseView extends StatelessWidget {
  const _CartExerciseView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('购物车练习'),
        actions: [
          Selector<CartExerciseModel, int>(
            selector: (_, model) => model.totalCount,
            builder: (context, count, _) {
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Badge(
                  isLabelVisible: count > 0,
                  label: Text('$count'),
                  child: IconButton(
                    tooltip: '清空购物车',
                    onPressed: count == 0
                        ? null
                        : () => _showClearDialog(context),
                    icon: const Icon(Icons.delete_sweep_outlined),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
        children: const [
          _CartSummaryCard(),
          SizedBox(height: 20),
          _SectionTitle(title: '商品列表', subtitle: '点击加入购物车，体验 Provider 的状态联动。'),
          SizedBox(height: 12),
          _ProductCatalog(),
          SizedBox(height: 20),
          _SectionTitle(title: '购物车', subtitle: '支持加减数量、删除商品和结算确认。'),
          SizedBox(height: 12),
          _CartItemsSection(),
        ],
      ),
      bottomNavigationBar: const _CheckoutBar(),
    );
  }

  Future<void> _showClearDialog(BuildContext context) async {
    final model = context.read<CartExerciseModel>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('清空购物车'),
          content: Text('当前共有 ${model.totalCount} 件商品，确认全部移除吗？'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('取消'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('清空'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      model.clear();
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('购物车已清空')));
      }
    }
  }
}

class _CartSummaryCard extends StatelessWidget {
  const _CartSummaryCard();

  @override
  Widget build(BuildContext context) {
    return Consumer<CartExerciseModel>(
      builder: (context, model, _) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primaryContainer,
                Theme.of(context).colorScheme.secondaryContainer,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '订单概览',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _MetricTile(
                      label: '商品种类',
                      value: '${model.cartItems.length}',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _MetricTile(
                      label: '商品件数',
                      value: '${model.totalCount}',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _MetricTile(
                      label: '合计',
                      value: '¥${model.totalPrice.toStringAsFixed(2)}',
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.58),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _ProductCatalog extends StatelessWidget {
  const _ProductCatalog();

  @override
  Widget build(BuildContext context) {
    final catalog = context.read<CartExerciseModel>().catalog;
    return Column(
      children: catalog
          .map((product) => _ProductCard(product: product))
          .toList(growable: false),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(product.icon),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(product.description),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '¥${product.price.toStringAsFixed(2)}',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                FilledButton.tonalIcon(
                  onPressed: () {
                    context.read<CartExerciseModel>().addProduct(product);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${product.name} 已加入购物车'),
                        duration: const Duration(milliseconds: 900),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add_shopping_cart),
                  label: const Text('加入'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CartItemsSection extends StatelessWidget {
  const _CartItemsSection();

  @override
  Widget build(BuildContext context) {
    return Consumer<CartExerciseModel>(
      builder: (context, model, _) {
        if (model.cartItems.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).dividerColor),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.shopping_cart_outlined,
                  size: 42,
                  color: Theme.of(context).hintColor,
                ),
                const SizedBox(height: 10),
                Text('购物车还是空的', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(
                  '从上方商品列表中添加几件商品试试。',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          );
        }

        return Column(
          children: model.cartItems
              .map((item) => _CartLineTile(item: item))
              .toList(growable: false),
        );
      },
    );
  }
}

class _CartLineTile extends StatelessWidget {
  const _CartLineTile({required this.item});

  final CartLine item;

  @override
  Widget build(BuildContext context) {
    final model = context.read<CartExerciseModel>();
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
              child: Icon(item.product.icon),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.name,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '单价 ¥${item.product.price.toStringAsFixed(2)}  ·  小计 ¥${item.subtotal.toStringAsFixed(2)}',
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () => model.decrease(item.product.id),
              icon: const Icon(Icons.remove_circle_outline),
            ),
            Text(
              '${item.count}',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            IconButton(
              onPressed: () => model.increase(item.product.id),
              icon: const Icon(Icons.add_circle_outline),
            ),
            IconButton(
              onPressed: () => model.remove(item.product.id),
              icon: const Icon(Icons.delete_outline),
            ),
          ],
        ),
      ),
    );
  }
}

class _CheckoutBar extends StatelessWidget {
  const _CheckoutBar();

  @override
  Widget build(BuildContext context) {
    return Consumer<CartExerciseModel>(
      builder: (context, model, _) {
        return SafeArea(
          top: false,
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 18,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '合计 ¥${model.totalPrice.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 4),
                      Text('共 ${model.totalCount} 件商品'),
                    ],
                  ),
                ),
                FilledButton(
                  onPressed: model.totalCount == 0
                      ? null
                      : () => _showCheckoutDialog(context, model),
                  child: const Text('去结算'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showCheckoutDialog(
    BuildContext context,
    CartExerciseModel model,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('确认结算'),
          content: Text(
            '本次共 ${model.totalCount} 件商品，合计 ¥${model.totalPrice.toStringAsFixed(2)}。',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('稍后'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('确认支付'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      model.clear();
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('模拟支付成功，订单已清空')));
      }
    }
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        Text(subtitle),
      ],
    );
  }
}

class Product {
  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.icon,
  });

  final String id;
  final String name;
  final String description;
  final double price;
  final IconData icon;
}

class CartLine {
  const CartLine({required this.product, required this.count});

  final Product product;
  final int count;

  double get subtotal => product.price * count;

  CartLine copyWith({int? count}) {
    return CartLine(product: product, count: count ?? this.count);
  }
}

class CartExerciseModel extends ChangeNotifier {
  CartExerciseModel();

  final List<Product> catalog = const [
    Product(
      id: 'keyboard',
      name: '机械键盘',
      description: '青轴，适合编码与长时间输入。',
      price: 399,
      icon: Icons.keyboard_alt_outlined,
    ),
    Product(
      id: 'mouse',
      name: '无线鼠标',
      description: '静音按键，支持多设备切换。',
      price: 169,
      icon: Icons.mouse_outlined,
    ),
    Product(
      id: 'headphone',
      name: '降噪耳机',
      description: '通勤和专注场景都比较稳妥。',
      price: 899,
      icon: Icons.headphones_outlined,
    ),
    Product(
      id: 'stand',
      name: '笔记本支架',
      description: '改善桌面姿势，减少肩颈压力。',
      price: 129,
      icon: Icons.laptop_mac_outlined,
    ),
  ];

  final Map<String, CartLine> _cartMap = {};

  UnmodifiableListView<CartLine> get cartItems =>
      UnmodifiableListView(_cartMap.values);

  int get totalCount =>
      _cartMap.values.fold(0, (sum, item) => sum + item.count);

  double get totalPrice =>
      _cartMap.values.fold(0, (sum, item) => sum + item.subtotal);

  void addProduct(Product product) {
    final current = _cartMap[product.id];
    if (current == null) {
      _cartMap[product.id] = CartLine(product: product, count: 1);
    } else {
      _cartMap[product.id] = current.copyWith(count: current.count + 1);
    }
    notifyListeners();
  }

  void increase(String productId) {
    final current = _cartMap[productId];
    if (current == null) {
      return;
    }
    _cartMap[productId] = current.copyWith(count: current.count + 1);
    notifyListeners();
  }

  void decrease(String productId) {
    final current = _cartMap[productId];
    if (current == null) {
      return;
    }
    if (current.count == 1) {
      _cartMap.remove(productId);
    } else {
      _cartMap[productId] = current.copyWith(count: current.count - 1);
    }
    notifyListeners();
  }

  void remove(String productId) {
    _cartMap.remove(productId);
    notifyListeners();
  }

  void clear() {
    _cartMap.clear();
    notifyListeners();
  }
}
