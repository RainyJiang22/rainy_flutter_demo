import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

// final class TransformativePreview extends Preview {
//   const TransformativePreview({
//     super.name,
//     super.group,
//     super.size,
//     super.textScaleFactor,
//     super.wrapper,
//     super.brightness,
//     super.localizations,
//   });
//
//   // Note: this is no longer public or static as it's injected
//   // at runtime when transform() is invoked.
//   PreviewThemeData _themeBuilder() {
//     return PreviewThemeData(
//       materialLight: ThemeData.light(),
//       materialDark: ThemeData.dark(),
//     );
//   }
//
//   @override
//   Preview transform() {
//     final originalPreview = super.transform();
//     // Create's a PreviewBuilder that can be used to modify
//     // the preview contents.
//     final builder = originalPreview.toBuilder();
//     builder
//       ..name = 'Transformed - ${originalPreview.name}'
//       ..theme = _themeBuilder;
//
//     // Return the updated Preview instance.
//     return builder.toPreview();
//   }
// }

@Preview(name: 'My Sample Text')
Widget mySampleText() {
  return const Text('Hello, World!');
}