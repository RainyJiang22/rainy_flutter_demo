import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 金额输入组件
class AmountInput extends StatefulWidget {
  final double? initialValue;
  final ValueChanged<double>? onChanged;
  final ValueChanged<double>? onSubmitted;
  final String? hintText;
  final bool enabled;
  final TextStyle? style;
  final FocusNode? focusNode;

  const AmountInput({
    super.key,
    this.initialValue,
    this.onChanged,
    this.onSubmitted,
    this.hintText,
    this.enabled = true,
    this.style,
    this.focusNode,
  });

  @override
  State<AmountInput> createState() => _AmountInputState();
}

class _AmountInputState extends State<AmountInput> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.initialValue != null && widget.initialValue! > 0
          ? widget.initialValue!.toStringAsFixed(2)
          : '',
    );
    _focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void dispose() {
    _controller.dispose();
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _handleChanged(String value) {
    final amount = double.tryParse(value) ?? 0;
    widget.onChanged?.call(amount);
  }

  void _handleSubmitted(String value) {
    final amount = double.tryParse(value) ?? 0;
    widget.onSubmitted?.call(amount);
  }

  @override
  Widget build(BuildContext context) {
    final defaultStyle = Theme.of(context).textTheme.displaySmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onSurface,
        );

    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      enabled: widget.enabled,
      style: widget.style ?? defaultStyle,
      textAlign: TextAlign.center,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
      ],
      decoration: InputDecoration(
        hintText: widget.hintText ?? '0.00',
        hintStyle: (widget.style ?? defaultStyle)?.copyWith(
          color: Theme.of(context).colorScheme.outline,
        ),
        prefixText: '¥ ',
        prefixStyle: widget.style ?? defaultStyle,
        border: InputBorder.none,
        contentPadding: EdgeInsets.zero,
      ),
      onChanged: _handleChanged,
      onSubmitted: _handleSubmitted,
    );
  }
}

/// 大字体金额显示
class AmountDisplay extends StatelessWidget {
  final double amount;
  final bool isExpense;
  final TextStyle? style;

  const AmountDisplay({
    super.key,
    required this.amount,
    this.isExpense = true,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final defaultStyle = Theme.of(context).textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: isExpense
              ? Theme.of(context).colorScheme.error
              : Theme.of(context).colorScheme.primary,
        );

    return Text(
      '${isExpense ? "-" : "+"}¥${amount.toStringAsFixed(2)}',
      style: style ?? defaultStyle,
    );
  }
}

/// 小字体金额显示
class SmallAmountDisplay extends StatelessWidget {
  final double amount;
  final bool isExpense;
  final TextStyle? style;

  const SmallAmountDisplay({
    super.key,
    required this.amount,
    this.isExpense = true,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final defaultStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: isExpense
              ? Theme.of(context).colorScheme.error
              : Theme.of(context).colorScheme.primary,
        );

    return Text(
      '${isExpense ? "-" : "+"}¥${amount.toStringAsFixed(2)}',
      style: style ?? defaultStyle,
    );
  }
}
