import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markdown_editor_test/components/editor/custom_toolbar.dart';
import 'package:markdown_editor_test/components/editor/table/table_menu.dart';
import 'package:markdown_editor_test/components/editor/toolbar_items.dart/add_block_component.dart';
import 'package:markdown_editor_test/components/editor/toolbar_items.dart/link_block_component.dart';
import 'package:markdown_editor_test/components/editor/toolbar_items.dart/table_block_component.dart';
import 'package:markdown_editor_test/components/editor/toolbar_items.dart/text_decoration_component.dart';
import 'package:markdown_editor_test/components/editor/toolbar_items.dart/type.dart';

class MobileEditor extends StatefulWidget {
  const MobileEditor({
    super.key,
    this.editorStyle,
  });

  final EditorStyle? editorStyle;

  @override
  State<MobileEditor> createState() => _MobileEditorState();
}

class _MobileEditorState extends State<MobileEditor> {
  late EditorState _editorState;

  late final EditorScrollController editorScrollController;

  late EditorStyle editorStyle;
  late final Map<String, BlockComponentBuilder>? blockComponentBuilders;

  @override
  void initState() {
    super.initState();
    _editorState = EditorState.blank();
    editorScrollController = EditorScrollController(
      editorState: _editorState,
      shrinkWrap: true,
    );
    blockComponentBuilders = _buildBlockComponentBuilders();
    editorStyle = _buildMobileEditorStyle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Editor"),
        actions: [
          TextButton(
            onPressed: () {
              final data = _editorState.document;
              final result = documentToMarkdown(data);
              print(result.toString());
            },
            child: const Text("Submit"),
          ),
        ],
      ),
      body: CustomToolBar(
        toolbarHeight: 50.0,
        editorState: _editorState,
        toolbarItemsBuilder: (sel) =>
            buildMobileToolbarItems(_editorState, sel),
        child: MobileFloatingToolbar(
          editorState: _editorState,
          editorScrollController: editorScrollController,
          toolbarBuilder: (_, anchor, closeToolbar) =>
              AdaptiveTextSelectionToolbar.editable(
            clipboardStatus: ClipboardStatus.pasteable,
            onCopy: () {
              copyCommand.execute(_editorState);
              closeToolbar();
            },
            onCut: () => cutCommand.execute(_editorState),
            onPaste: () => pasteCommand.execute(_editorState),
            onSelectAll: () => selectAllCommand.execute(_editorState),
            onLiveTextInput: null,
            onLookUp: null,
            onSearchWeb: null,
            onShare: null,
            anchors: TextSelectionToolbarAnchors(
              primaryAnchor: anchor,
            ),
          ),
          child: AppFlowyEditor(
            autoFocus: true,
            editorStyle: editorStyle,
            editorState: _editorState,
            editorScrollController: editorScrollController,
            blockComponentBuilders: blockComponentBuilders,
            showMagnifier: true,
            header: const Padding(
              padding: EdgeInsets.only(bottom: 10.0),
            ),
            footer: const SizedBox(
              height: 100,
            ),
            shrinkWrap: true,
          ),
        ),
      ),
    );
  }

  EditorStyle _buildMobileEditorStyle() {
    return EditorStyle.mobile(
      textScaleFactor: 1.0,
      cursorColor: const Color.fromARGB(255, 134, 46, 247),
      dragHandleColor: const Color.fromARGB(255, 134, 46, 247),
      selectionColor: const Color.fromARGB(50, 134, 46, 247),
      textStyleConfiguration: TextStyleConfiguration(
        text: GoogleFonts.poppins(
          fontSize: 14,
          color: Colors.black,
        ),
        code: GoogleFonts.sourceCodePro(
          backgroundColor: Colors.grey.shade200,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      magnifierSize: const Size(144, 96),
      mobileDragHandleBallSize: const Size(12, 12),
    );
  }
}

List<CustomToolbarItem> buildMobileToolbarItems(
  EditorState editorState,
  Selection? selection,
) {
  if (selection == null) {
    return [];
  }
  return [
    customAddBlockItem,
    boldToolbarItem,
    italicToolbarItem,
    underlineToolbarItem,
    strikethroughToolbarItem,
    codeBlockToolbarItem,
    linkBlockItem,
    tableBlockItem,
  ];
}

Map<String, BlockComponentBuilder> _buildBlockComponentBuilders() {
  final map = {
    ...standardBlockComponentBuilderMap,
  };
  map[TableBlockKeys.type] = _buildTableBlockComponentBuilder();
  map[TableCellBlockKeys.type] = _buildTableCellBlockComponentBuilder();
  return map;
}

TableBlockComponentBuilder _buildTableBlockComponentBuilder() {
  return TableBlockComponentBuilder(
    menuBuilder: (node, editorState, position, dir, onBuild, onClose) =>
        TableMenu(
      node: node,
      editorState: editorState,
      position: position,
      dir: dir,
      onBuild: onBuild,
      onClose: onClose,
    ),
  );
}

TableCellBlockComponentBuilder _buildTableCellBlockComponentBuilder() {
  return TableCellBlockComponentBuilder(
    colorBuilder: (context, node) {
      final String colorString =
          node.attributes[TableCellBlockKeys.colBackgroundColor] ??
              node.attributes[TableCellBlockKeys.rowBackgroundColor] ??
              '';
      if (colorString.isEmpty) {
        return null;
      }
      return Colors.transparent;
    },
    menuBuilder: (node, editorState, position, dir, onBuild, onClose) =>
        TableMenu(
      node: node,
      editorState: editorState,
      position: position,
      dir: dir,
      onBuild: onBuild,
      onClose: onClose,
    ),
  );
}
