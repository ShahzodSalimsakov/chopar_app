import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MyAlertDialog extends StatelessWidget {
  /// Creates an alert dialog.
  ///
  /// Typically used in conjunction with [showDialog].
  ///
  /// The [contentPadding] must not be null. The [titlePadding] defaults to
  /// null, which implies a default that depends on the values of the other
  /// properties. See the documentation of [titlePadding] for details.
  const MyAlertDialog({
    Key? key,
    this.title,
    this.titlePadding,
    this.content,
    this.contentPadding = const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0),
    this.actions,
    this.semanticLabel,
    this.divider = true,
    this.leftActions,
  }) : super(key: key);

  /// The (optional) title of the dialog is displayed in a large font at the top
  /// of the dialog.
  ///
  /// Typically a [Text] widget.
  final Widget? title;

  /// Padding around the title.
  ///
  /// If there is no title, no padding will be provided. Otherwise, this padding
  /// is used.
  ///
  /// This property defaults to providing 24 pixels on the top, left, and right
  /// of the title. If the [content] is not null, then no bottom padding is
  /// provided (but see [contentPadding]). If it _is_ null, then an extra 20
  /// pixels of bottom padding is added to separate the [title] from the
  /// [actions].
  final EdgeInsetsGeometry? titlePadding;

  /// The (optional) content of the dialog is displayed in the center of the
  /// dialog in a lighter font.
  ///
  /// Typically, this is a [ListView] containing the contents of the dialog.
  /// Using a [ListView] ensures that the contents can scroll if they are too
  /// big to fit on the display.
  final Widget? content;

  /// Padding around the content.
  ///
  /// If there is no content, no padding will be provided. Otherwise, padding of
  /// 20 pixels is provided above the content to separate the content from the
  /// title, and padding of 24 pixels is provided on the left, right, and bottom
  /// to separate the content from the other edges of the dialog.
  final EdgeInsetsGeometry contentPadding;

  /// The (optional) set of actions that are displayed at the bottom of the
  /// dialog.
  ///
  /// Typically this is a list of [FlatButton] widgets.
  ///
  /// These widgets will be wrapped in a [ButtonBar], which introduces 8 pixels
  /// of padding on each side.
  ///
  /// If the [title] is not null but the [content] _is_ null, then an extra 20
  /// pixels of padding is added above the [ButtonBar] to separate the [title]
  /// from the [actions].
  final List<Widget>? actions;

  /// The (optional) set of actions that are displayed at the bottom of the
  /// dialog.
  ///
  /// Typically this is a list of [FlatButton] widgets.
  ///
  /// These widgets will be wrapped in a [ButtonBar], which introduces 8 pixels
  /// of padding on each side.
  ///
  /// If the [title] is not null but the [content] _is_ null, then an extra 20
  /// pixels of padding is added above the [ButtonBar] to separate the [title]
  /// from the [actions].
  final List<Widget>? leftActions;

  /// The semantic label of the dialog used by accessibility frameworks to
  /// announce screen transitions when the dialog is opened and closed.
  ///
  /// If this label is not provided, a semantic label will be infered from the
  /// [title] if it is not null.  If there is no title, the label will be taken
  /// from [MaterialLocalizations.alertDialogLabel].
  ///
  /// See also:
  ///
  ///  * [SemanticsConfiguration.isRouteName], for a description of how this
  ///    value is used.
  final String? semanticLabel;

  /// add divider at the actions
  final bool divider;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[];
    String? label = semanticLabel;

    if (title != null) {
      children.add(Padding(
        padding: titlePadding ??
            EdgeInsets.fromLTRB(24.0, 24.0, 24.0, content == null ? 20.0 : 0.0),
        child: DefaultTextStyle(
          style: Theme.of(context).textTheme.titleLarge!,
          child: Semantics(
            child: title,
            namesRoute: true,
            container: true,
          ),
        ),
      ));
    } else {
      switch (defaultTargetPlatform) {
        case TargetPlatform.iOS:
          label = semanticLabel;
          break;
        case TargetPlatform.android:
        case TargetPlatform.fuchsia:
        case TargetPlatform.linux:
        case TargetPlatform.macOS:
        case TargetPlatform.windows:
          label = semanticLabel ??
              MaterialLocalizations.of(context).alertDialogLabel;
      }
    }

    if (content != null) {
      children.add(Flexible(
        child: Padding(
          padding: contentPadding,
          child: DefaultTextStyle(
            style: Theme.of(context).textTheme.titleMedium!,
            child: content!,
          ),
        ),
      ));
    }

    if (actions != null || leftActions != null) {
      if (divider) {
        children.add(const Divider(
          height: 0,
        ));
      }
      children.add(ButtonBar(
        alignment: leftActions != null
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.end,
        buttonPadding: const EdgeInsets.symmetric(horizontal: 16),
        children: <Widget>[
          if (leftActions != null) ...[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: leftActions!,
            ),
          ],
          if (actions != null) ...[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: actions!,
            ),
          ],
        ],
      ));
    }

    Widget dialogChild = IntrinsicWidth(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );

    if (label != null)
      dialogChild = Semantics(
        namesRoute: true,
        label: label,
        child: dialogChild,
      );

    return Dialog(child: dialogChild);
  }
}
