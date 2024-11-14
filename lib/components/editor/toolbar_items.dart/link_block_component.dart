import 'dart:async';
import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';
import 'package:markdown_editor_test/components/adaptive_modal_bottom_sheet.dart';
import 'package:markdown_editor_test/components/editor/toolbar_items.dart/type.dart';
import 'package:markdown_editor_test/components/editor/util.dart';

extension MobileToolbarBuildContext on BuildContext {
  double get scale => MediaQuery.of(this).size.width / 375.0;
}

final linkBlockItem = CustomToolbarItem(
  itemBuilder: (context, editorState, service, onMenu, onAction) {
    return CustomToolbarIconItem(
      editorState: editorState,
      icon: Icons.link_outlined,
      onTap: () {
        final selection = editorState.selection;

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

        onLinkItemTap(editorState);
      },
    );
  },
);

void onLinkItemTap(EditorState editorState) async {
  final selection = editorState.selection;
  if (selection == null) {
    return;
  }

  final nodes = editorState.getNodesInSelection(selection);
  // show edit link bottom sheet
  final context = nodes.firstOrNull?.context;
  if (context != null) {
    // keep the selection
    keepEditorFocusNotifier.increase();

    final text = editorState.getTextInSelection(selection).join();
    final href = editorState.getDeltaAttributeValueInSelection<String>(
      AppFlowyRichTextKeys.href,
      selection,
    );
    await MobileBottomSheetEditLinkWidget(
      href: href,
      text: text,
      onEdit: (newText, newHref) {
        editorState.updateTextAndHref(
          text,
          href,
          newText,
          newHref,
          selection: selection,
        );
        Navigator.pop(context);
      },
    ).show(context);
  }
}

class MobileBottomSheetEditLinkWidget extends StatefulWidget {
  const MobileBottomSheetEditLinkWidget({
    super.key,
    required this.text,
    required this.href,
    required this.onEdit,
  });

  final String text;
  final String? href;
  final void Function(String text, String href) onEdit;

  @override
  State<MobileBottomSheetEditLinkWidget> createState() =>
      _MobileBottomSheetEditLinkWidgetState();
  show(BuildContext context) {
    showAdaptiveModalBottomSheet(
      context: context,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(13),
          topRight: Radius.circular(13),
        ),
      ),
      builder: (BuildContext context) {
        return MobileBottomSheetEditLinkWidget(
          href: href,
          text: text,
          onEdit: onEdit,
        );
      },
    );
  }
}

class _MobileBottomSheetEditLinkWidgetState
    extends State<MobileBottomSheetEditLinkWidget> {
  late final TextEditingController textController;
  late final TextEditingController hrefController;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController(
      text: widget.text,
    );
    hrefController = TextEditingController(
      text: widget.href,
    );
  }

  @override
  void dispose() {
    textController.dispose();
    hrefController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(13),
        topRight: Radius.circular(13),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  left: 0,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.close_outlined),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                const Align(
                  child: Text(
                    "Add Link",
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onEdit(textController.text, hrefController.text);
                    },
                    child: const Text('Elevated Button'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            _buildTextField(
              controller: textController,
              hintText: "Enter link title",
            ),
            const SizedBox(height: 12.0),
            _buildTextField(
              controller: hrefController,
              hintText: "Enter link URL",
            ),
            const SizedBox(height: 12.0),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      {required TextEditingController controller, required String? hintText}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(fontSize: 16.0),
        suffixIcon: Padding(
          padding: const EdgeInsets.all(4.0),
          child: IconButton(
            icon: const Icon(Icons.close_outlined),
            onPressed: () {
              controller.clear();
            },
          ),
        ),
      ),
    );
  }
}
