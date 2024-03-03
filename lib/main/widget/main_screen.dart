import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ikut_annotation_v2/main/stateholder/main_event_handler.dart';
import 'package:ikut_annotation_v2/main/stateholder/main_ui_model.dart';
import 'package:ikut_annotation_v2/main/stateholder/main_ui_model_provider.dart';
import 'package:ikut_annotation_v2/main/widget/image_widget.dart';
import 'package:ikut_annotation_v2/main/widget/labels_widget.dart';

import '../i10n/localization.dart';

class MainScreen extends HookConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiModel = ref.watch(mainUiModelProvider);
    final eventHandler = ref.read(mainEventHandlerProvider);
    final localization = ref.watch(localizationProvider);
    useEffect(() {
      eventHandler.load();
      return () {};
    }, const []);
    final stackChildren = <Widget>[];
    if (uiModel.shouldShowImage()) {
      stackChildren
          .add(ImageWidget(uiModel.images[uiModel.previousImageIndex]));
      stackChildren.add(ImageWidget(uiModel.images[uiModel.imageIndex]));
    }
    stackChildren.add(LabelsWidget(uiModel));
    return Focus(
      autofocus: true,
      onKey: (node, event) {
        if (event is RawKeyDownEvent) {
          if (event.logicalKey.keyLabel == ']') {
            eventHandler.move(1);
          } else if (event.logicalKey.keyLabel == '[') {
            eventHandler.move(-1);
          } else if (event.logicalKey.keyLabel == 'P') {
            eventHandler.move(100);
          } else if (event.logicalKey.keyLabel == 'O') {
            eventHandler.move(-100);
          } else if (event.logicalKey.keyLabel == 'Z') {
            eventHandler.update(0);
          } else if (event.logicalKey.keyLabel == 'X') {
            eventHandler.update(1);
          } else if (event.logicalKey.keyLabel == 'C') {
            eventHandler.update(2);
          } else if (event.logicalKey.keyLabel == 'V') {
            eventHandler.update(3);
          }
        }
        return KeyEventResult.handled;
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(localization.appName),
          ),
          body: Stack(
            children: stackChildren,
          )),
    );
  }
}
