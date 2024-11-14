import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';
import 'package:markdown_editor_test/components/editor/popover/src/popover.dart';
import 'package:markdown_editor_test/components/editor/table/pop_up_action.dart';
import 'package:markdown_editor_test/components/editor/table/table_options.dart';
import 'dart:math' as math;

const tableActions = <TableOptionAction>[
  TableOptionAction.addAfter,
  TableOptionAction.addBefore,
  TableOptionAction.delete,
  TableOptionAction.duplicate,
  TableOptionAction.clear,
];

class TableMenu extends StatelessWidget {
  const TableMenu({
    super.key,
    required this.node,
    required this.editorState,
    required this.position,
    required this.dir,
    this.onBuild,
    this.onClose,
  });

  final Node node;
  final EditorState editorState;
  final int position;
  final TableDirection dir;
  final VoidCallback? onBuild;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final actions = tableActions.map((action) {
      switch (action) {
        default:
          return TableOptionActionWrapper(action);
      }
    }).toList();

    return PopoverActionList<PopoverAction>(
      direction: dir == TableDirection.col
          ? PopoverDirection.bottomWithCenterAligned
          : PopoverDirection.rightWithTopAligned,
      actions: actions,
      onPopupBuilder: onBuild,
      onClosed: onClose,
      onSelected: (action, controller) {
        if (action is TableOptionActionWrapper) {
          _onSelectAction(action.inner);
          controller.close();
        }
      },
      buildChild: (controller) => _buildOptionButton(controller, context),
    );
  }

  Widget _buildOptionButton(
    PopoverController controller,
    BuildContext context,
  ) {
    return Card(
      elevation: 1.0,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => controller.show(),
          child: Transform.rotate(
            angle: dir == TableDirection.col ? math.pi / 2 : 0,
            child: const Icon(
              Icons.drag_handle_outlined,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  void _onSelectAction(TableOptionAction action) {
    switch (action) {
      case TableOptionAction.addAfter:
        TableActions.add(node, position + 1, editorState, dir);
        break;
      case TableOptionAction.addBefore:
        TableActions.add(node, position, editorState, dir);
        break;
      case TableOptionAction.delete:
        TableActions.delete(node, position, editorState, dir);
        break;
      case TableOptionAction.clear:
        TableActions.clear(node, position, editorState, dir);
        break;
      case TableOptionAction.duplicate:
        TableActions.duplicate(node, position, editorState, dir);
        break;
      default:
    }
  }
}
