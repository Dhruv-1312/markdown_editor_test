import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';
import 'package:markdown_editor_test/components/editor/toolbar_items.dart/type.dart';
import 'package:markdown_editor_test/components/editor/util.dart';

final boldToolbarItem = CustomToolbarItem(
  itemBuilder: (context, editorState, _, __, onAction) {
    return CustomToolbarIconItem(
      editorState: editorState,
      shouldListenToToggledStyle: true,
      isSelected: () =>
          editorState.isTextDecorationSelected(
            AppFlowyRichTextKeys.bold,
          ) &&
          editorState.toggledStyle[AppFlowyRichTextKeys.bold] != false,
      icon: Icons.format_bold_outlined,
      onTap: () async => editorState.toggleAttribute(
        AppFlowyRichTextKeys.bold,
        selectionExtraInfo: {
          selectionExtraInfoDisableFloatingToolbar: true,
        },
      ),
    );
  },
);

final italicToolbarItem = CustomToolbarItem(
  itemBuilder: (context, editorState, _, __, onAction) {
    return CustomToolbarIconItem(
      editorState: editorState,
      shouldListenToToggledStyle: true,
      isSelected: () => editorState.isTextDecorationSelected(
        AppFlowyRichTextKeys.italic,
      ),
      icon: Icons.format_italic_outlined,
      onTap: () async => editorState.toggleAttribute(
        AppFlowyRichTextKeys.italic,
        selectionExtraInfo: {
          selectionExtraInfoDisableFloatingToolbar: true,
        },
      ),
    );
  },
);

final underlineToolbarItem = CustomToolbarItem(
  itemBuilder: (context, editorState, _, __, onAction) {
    return CustomToolbarIconItem(
      editorState: editorState,
      shouldListenToToggledStyle: true,
      isSelected: () => editorState.isTextDecorationSelected(
        AppFlowyRichTextKeys.underline,
      ),
      icon: Icons.format_underline_outlined,
      onTap: () async => editorState.toggleAttribute(
        AppFlowyRichTextKeys.underline,
        selectionExtraInfo: {
          selectionExtraInfoDisableFloatingToolbar: true,
        },
      ),
    );
  },
);

final strikethroughToolbarItem = CustomToolbarItem(
  itemBuilder: (context, editorState, _, __, onAction) {
    return CustomToolbarIconItem(
      editorState: editorState,
      shouldListenToToggledStyle: true,
      isSelected: () => editorState.isTextDecorationSelected(
        AppFlowyRichTextKeys.strikethrough,
      ),
      icon: Icons.strikethrough_s_outlined,
      onTap: () async => editorState.toggleAttribute(
        AppFlowyRichTextKeys.strikethrough,
        selectionExtraInfo: {
          selectionExtraInfoDisableFloatingToolbar: true,
        },
      ),
    );
  },
);
final codeBlockToolbarItem = CustomToolbarItem(
  itemBuilder: (context, editorState, _, __, onAction) {
    return CustomToolbarIconItem(
      editorState: editorState,
      shouldListenToToggledStyle: true,
      isSelected: () => editorState.isTextDecorationSelected(
        AppFlowyRichTextKeys.code,
      ),
      icon: Icons.code_outlined,
      onTap: () async => editorState.toggleAttribute(
        AppFlowyRichTextKeys.code,
        selectionExtraInfo: {
          selectionExtraInfoDisableFloatingToolbar: true,
        },
      ),
    );
  },
);
