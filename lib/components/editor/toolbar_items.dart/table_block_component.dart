import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';
import 'package:markdown_editor_test/components/editor/toolbar_items.dart/type.dart';

final tableBlockItem = CustomToolbarItem(
  itemBuilder: (context, editorState, _, __, onAction) {
    return CustomToolbarIconItem(
      editorState: editorState,
      shouldListenToToggledStyle: true,
      icon: Icons.table_rows_outlined,
      onTap: () async {
        final selection = editorState.selection;
        if (selection == null || !selection.isCollapsed) {
          return;
        }

        final currentNode = editorState.getNodeAtPath(selection.end.path);
        if (currentNode == null) {
          return;
        }

        final tableNode = TableNode.fromList([
          ['', ''],
          ['', ''],
        ]);

        final transaction = editorState.transaction;
        final delta = currentNode.delta;
        if (delta != null && delta.isEmpty) {
          transaction
            ..insertNode(selection.end.path, tableNode.node)
            ..deleteNode(currentNode);
          transaction.afterSelection = Selection.collapsed(
            Position(
              path: selection.end.path + [0, 0],
            ),
          );
        } else {
          transaction.insertNode(selection.end.path.next, tableNode.node);
          transaction.afterSelection = Selection.collapsed(
            Position(
              path: selection.end.path.next + [0, 0],
            ),
          );
        }

        await editorState.apply(transaction);
      },
    );
  },
);
