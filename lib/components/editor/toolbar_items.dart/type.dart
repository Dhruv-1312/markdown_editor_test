import 'dart:async';

import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';

abstract class CustomToolbarWidgetService {
  void closeItemMenu();
  void closeKeyboard();

  PropertyValueNotifier<bool> get showMenuNotifier;
}

typedef CustomToolbarItemBuilder = Widget Function(
  BuildContext context,
  EditorState editorState,
  CustomToolbarWidgetService service,
  VoidCallback? onMenuCallback,
  VoidCallback? onActionCallback,
);

// build the menu after clicking the toolbar item
typedef CustomToolbarItemMenuBuilder = Widget Function(
  BuildContext context,
  EditorState editorState,
  CustomToolbarWidgetService service,
);

class CustomToolbarItem {
  /// Tool bar item that implements attribute directly(without opening menu)
  const CustomToolbarItem({
    required this.itemBuilder,
    this.menuBuilder,
    this.pilotAtCollapsedSelection = false,
    this.pilotAtExpandedSelection = false,
  });

  final CustomToolbarItemBuilder itemBuilder;
  final CustomToolbarItemMenuBuilder? menuBuilder;
  final bool pilotAtCollapsedSelection;
  final bool pilotAtExpandedSelection;
}

class CustomToolbarIconItem extends StatefulWidget {
  const CustomToolbarIconItem({
    super.key,
    required this.icon,
    this.keepSelectedStatus = false,
    this.iconBuilder,
    this.isSelected,
    this.shouldListenToToggledStyle = false,
    this.enable,
    required this.onTap,
    required this.editorState,
  });

  final IconData icon;
  final bool keepSelectedStatus;
  final VoidCallback onTap;
  final WidgetBuilder? iconBuilder;
  final bool Function()? isSelected;
  final bool shouldListenToToggledStyle;
  final EditorState editorState;
  final bool Function()? enable;

  @override
  State<CustomToolbarIconItem> createState() => _CustomToolbarIconItemState();
}

class _CustomToolbarIconItemState extends State<CustomToolbarIconItem> {
  bool isSelected = false;
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();

    isSelected = widget.isSelected?.call() ?? false;
    if (widget.shouldListenToToggledStyle) {
      widget.editorState.toggledStyleNotifier.addListener(_rebuild);
      _subscription = widget.editorState.transactionStream.listen((_) {
        _rebuild();
      });
    }
  }

  @override
  void dispose() {
    if (widget.shouldListenToToggledStyle) {
      widget.editorState.toggledStyleNotifier.removeListener(_rebuild);
      _subscription?.cancel();
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant CustomToolbarIconItem oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isSelected != null) {
      isSelected = widget.isSelected!.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: GestureDetector(
        onTap: () {
          widget.onTap();
          _rebuild();
        },
        child: widget.iconBuilder?.call(context) ??
            Container(
              width: 40,
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9),
                color: isSelected ? Colors.grey[400] : null,
              ),
              child: Icon(widget.icon, color: Colors.black),
            ),
      ),
    );
  }

  void _rebuild() {
    if (!mounted) {
      return;
    }
    setState(() {
      isSelected = (widget.keepSelectedStatus && widget.isSelected == null)
          ? !isSelected
          : widget.isSelected?.call() ?? false;
    });
  }
}
