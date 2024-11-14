import 'dart:async';

import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';
import 'package:markdown_editor_test/components/adaptive_modal_bottom_sheet.dart';
import 'package:markdown_editor_test/components/editor/toolbar_items.dart/type.dart';

final customAddBlockItem = CustomToolbarItem(
  itemBuilder:
      (context, editorState, service, onMenuCallback, onActionCallback) {
    return CustomToolbarIconItem(
      editorState: editorState,
      icon: Icons.add_circle_outline_sharp,
      onTap: () {
        final selection = editorState.selection;
        service.closeKeyboard();

        // delay to wait the keyboard closed.
        Future.delayed(const Duration(milliseconds: 100), () async {
          unawaited(
            editorState.updateSelectionWithReason(
              selection,
              extraInfo: {
                selectionExtraInfoDisableMobileToolbarKey: true,
                selectionExtraInfoDisableFloatingToolbar: true,
                selectionExtraInfoDoNotAttachTextService: true,
              },
            ),
          );
          keepEditorFocusNotifier.increase();

          final didAddBlock = await showAdaptiveModalBottomSheet(
            context: context,
            enableDrag: true,
            barrierColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            builder: (context) => _BlocksMenu(editorState, selection!),
          );
          if (didAddBlock != true) {
            unawaited(editorState.updateSelectionWithReason(selection));
          }
        });
      },
    );
  },
);

class _BlocksMenu extends StatefulWidget {
  const _BlocksMenu(
    this.editorState,
    this.selection,
  );

  final Selection selection;
  final EditorState editorState;

  @override
  State<_BlocksMenu> createState() => _BlocksMenuState();
}

class _BlocksMenuState extends State<_BlocksMenu> {
  final lists = [
    // heading
    _ListUnit(
      icon: AFMobileIcons.h1,
      label: AppFlowyEditorL10n.current.mobileHeading1,
      name: HeadingBlockKeys.type,
      level: 1,
    ),
    _ListUnit(
      icon: AFMobileIcons.h2,
      label: AppFlowyEditorL10n.current.mobileHeading2,
      name: HeadingBlockKeys.type,
      level: 2,
    ),
    _ListUnit(
      icon: AFMobileIcons.h3,
      label: AppFlowyEditorL10n.current.mobileHeading3,
      name: HeadingBlockKeys.type,
      level: 3,
    ),
    // list
    _ListUnit(
      icon: AFMobileIcons.bulletedList,
      label: AppFlowyEditorL10n.current.bulletedList,
      name: BulletedListBlockKeys.type,
    ),
    _ListUnit(
      icon: AFMobileIcons.numberedList,
      label: AppFlowyEditorL10n.current.numberedList,
      name: NumberedListBlockKeys.type,
    ),
    _ListUnit(
      icon: AFMobileIcons.checkbox,
      label: AppFlowyEditorL10n.current.checkbox,
      name: TodoListBlockKeys.type,
    ),
    _ListUnit(
      icon: AFMobileIcons.quote,
      label: AppFlowyEditorL10n.current.quote,
      name: QuoteBlockKeys.type,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(13),
        topRight: Radius.circular(13),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          Container(
            height: 5,
            width: 50,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          const SizedBox(height: 16),
          Flexible(
            child: GridView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: lists.length,
              itemBuilder: (context, index) {
                final item = lists[index];
                final node = widget.editorState.getNodeAtPath(
                  widget.selection.start.path,
                )!;
                final isSelected = node.type == item.name &&
                    (item.level == null ||
                        node.attributes[HeadingBlockKeys.level] == item.level);
                return InkWell(
                  onTap: () {
                    setState(() {
                      Navigator.pop(context);
                      widget.editorState.formatNode(
                        widget.selection,
                        (node) => node.copyWith(
                          type:
                              isSelected ? ParagraphBlockKeys.type : item.name,
                          attributes: {
                            ParagraphBlockKeys.delta:
                                (node.delta ?? Delta()).toJson(),
                            blockComponentBackgroundColor:
                                node.attributes[blockComponentBackgroundColor],
                            if (!isSelected &&
                                item.name == TodoListBlockKeys.type)
                              TodoListBlockKeys.checked: false,
                            if (!isSelected &&
                                item.name == HeadingBlockKeys.type)
                              HeadingBlockKeys.level: item.level,
                          },
                        ),
                        selectionExtraInfo: {
                          selectionExtraInfoDoNotAttachTextService: true,
                        },
                      );
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          color: isSelected
                              ? Colors.blue
                              : const Color(0xFFCBD5E1),
                          width: 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AFMobileIcon(afMobileIcons: item.icon),
                        const SizedBox(height: 2),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            item.label,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ListUnit {
  final AFMobileIcons icon;
  final String label;
  final String name;
  final int? level;

  _ListUnit({
    required this.icon,
    required this.label,
    required this.name,
    this.level,
  });
}
