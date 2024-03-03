import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ikut_annotation_v2/main/stateholder/main_event_handler.dart';
import 'package:ikut_annotation_v2/main/stateholder/main_ui_model.dart';
import 'package:ikut_annotation_v2/main/stateholder/main_ui_model_provider.dart';
import 'package:ikut_annotation_v2/main/widget/image_widget.dart';

import '../../util/view/check_one_shot_operation.dart';
import '../i10n/localization.dart';

class MainScreen extends HookConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiModel = ref.watch(mainUiModelProvider);
    final eventHandler = ref.read(mainEventHandlerProvider);
    final localization = ref.watch(localizationProvider);
    ref.listen(mainUiModelProvider, (previous, next) {
      checkOneShotOperation(previous, next, (state) => state.saveEffect,
          (saveTarget) {
        eventHandler.save(saveTarget);
      });
    });
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
    stackChildren.add(_makeLabelButtons(context, uiModel, (index) {
      eventHandler.update(index);
    }));
    stackChildren.add(
        _makePageMoveButtons(context, (int move) => eventHandler.move(move)));
    if (uiModel.progress) {
      stackChildren.add(const Center(child: CircularProgressIndicator()));
    }
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

  Widget _makePageMoveButtons(BuildContext context, void Function(int) move) {
    final iconColor = Theme.of(context).colorScheme.onPrimary;
    return Center(
      child: Row(
        children: [
          Container(
            color: Colors.black54,
            padding: const EdgeInsets.all(8),
            child: IconButton(
              onPressed: () {
                move(-1);
              },
              icon: const Icon(Icons.arrow_back),
              color: iconColor,
              iconSize: 48,
            ),
          ),
          const Spacer(),
          Container(
            color: Colors.black54,
            padding: const EdgeInsets.all(8),
            child: IconButton(
              onPressed: () {
                move(1);
              },
              icon: const Icon(Icons.arrow_forward),
              color: iconColor,
              iconSize: 48,
            ),
          ),
        ],
      ),
    );
  }

  Widget _makeLabelButtons(
      BuildContext context, MainUiModel uiModel, void Function(int) update) {
    final textStyle = Theme.of(context)
        .textTheme
        .displayMedium
        ?.copyWith(color: Theme.of(context).colorScheme.onPrimary);
    if (uiModel.images.isNotEmpty) {
      return Column(
        children: [
          Row(
            children: [
              Container(
                  color: Colors.black54,
                  padding: const EdgeInsets.all(16),
                  child: Text(uiModel.imageIndex.toString(), style: textStyle)),
              const Spacer()
            ],
          ),
          const Spacer(),
          Container(
              color: Colors.black54,
              padding: const EdgeInsets.all(8),
              child: Row(
                  children: uiModel.labels.mapIndexed((index, label) {
                return Expanded(
                    child: _makeLabelButton(
                        context,
                        label == uiModel.images[uiModel.imageIndex].label,
                        label, () {
                  update(index);
                }));
              }).toList()))
        ],
      );
    } else {
      return Container();
    }
  }

  Widget _makeLabelButton(BuildContext context, bool selected, String label,
      void Function() onTap) {
    Color textColor;
    if (selected) {
      textColor = Theme.of(context).colorScheme.onPrimary;
    } else {
      textColor = Theme.of(context).colorScheme.onPrimary.withOpacity(0.5);
    }
    final textStyle =
        Theme.of(context).textTheme.titleLarge?.copyWith(color: textColor);
    return TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          foregroundColor: textColor,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(label, style: textStyle),
        ));
  }
}
