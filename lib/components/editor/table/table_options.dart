import 'package:flutter/material.dart';
import 'package:markdown_editor_test/components/editor/table/pop_up_action.dart';

enum TableOptionAction {
  addAfter,
  addBefore,
  delete,
  duplicate,
  clear,

  /// row|cell background color
  bgColor;

  Widget icon(Color? color) {
    switch (this) {
      case TableOptionAction.addAfter:
        return const Icon(Icons.add_outlined);
      case TableOptionAction.addBefore:
        return const Icon(Icons.add_outlined);
      case TableOptionAction.delete:
        return const Icon(Icons.delete);
      case TableOptionAction.duplicate:
        return const Icon(Icons.copy_outlined);
      case TableOptionAction.clear:
        return const Icon(Icons.delete_outline);
      case TableOptionAction.bgColor:
        return const Icon(Icons.format_color_fill);
    }
  }

  String get description {
    switch (this) {
      case TableOptionAction.addAfter:
        return "Add After";
      case TableOptionAction.addBefore:
        return "Add Before";
      case TableOptionAction.delete:
        return "Delete";
      case TableOptionAction.duplicate:
        return "Duplicate";
      case TableOptionAction.clear:
        return "clear";
      case TableOptionAction.bgColor:
        return "bg Color";
    }
  }
}

class TableOptionActionWrapper extends ActionCell {
  TableOptionActionWrapper(this.inner);

  final TableOptionAction inner;

  @override
  Widget? leftIcon(Color iconColor) => inner.icon(iconColor);

  @override
  String get name => inner.description;
}

// class TableColorOptionAction extends PopoverActionCell {
//   TableColorOptionAction({
//     required this.node,
//     required this.editorState,
//     required this.position,
//     required this.dir,
//   });

//   final Node node;
//   final EditorState editorState;
//   final int position;
//   final TableDirection dir;

//   @override
//   Widget? leftIcon(Color iconColor) =>
//       TableOptionAction.bgColor.icon(iconColor);

//   @override
//   String get name => TableOptionAction.bgColor.description;

//   @override
//   Widget Function(
//     BuildContext context,
//     PopoverController parentController,
//     PopoverController controller,
//   ) get builder => (context, parentController, controller) {
//         int row = 0, col = position;
//         if (dir == TableDirection.row) {
//           col = 0;
//           row = position;
//         }

//         final cell = node.children.firstWhereOrNull(
//           (n) =>
//               n.attributes[TableCellBlockKeys.colPosition] == col &&
//               n.attributes[TableCellBlockKeys.rowPosition] == row,
//         );
//         final key = dir == TableDirection.col
//             ? TableCellBlockKeys.colBackgroundColor
//             : TableCellBlockKeys.rowBackgroundColor;
//         final bgColor = cell?.attributes[key] as String?;
//         final selectedColor = bgColor?.tryToColor();
//         // get default background color from themeExtension
//         final defaultColor = AFThemeExtension.of(context).tableCellBGColor;
//         final colors = [
//           // reset to default background color
//           FlowyColorOption(
//             color: defaultColor,
//             i18n: LocaleKeys.document_plugins_optionAction_defaultColor.tr(),
//             id: tableCellDefaultColor,
//           ),
//           ...FlowyTint.values.map(
//             (e) => FlowyColorOption(
//               color: e.color(context),
//               i18n: e.tintName(AppFlowyEditorL10n.current),
//               id: e.id,
//             ),
//           ),
//         ];

//         return FlowyColorPicker(
//           colors: colors,
//           selected: selectedColor,
//           border: Border.all(
//             color: AFThemeExtension.of(context).onBackground,
//           ),
//           onTap: (option, index) async {
//             final backgroundColor =
//                 selectedColor != option.color ? option.id : '';
//             TableActions.setBgColor(
//               node,
//               position,
//               editorState,
//               backgroundColor,
//               dir,
//             );

//             controller.close();
//             parentController.close();
//           },
//         );
//       };
// }
