import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ikut_annotation_v2/util/view/check_one_shot_operation.dart';

import '../../i10n/localization.dart';
import '../stateholder/selection_event_handler.dart';
import '../stateholder/selection_ui_model_provider.dart';

class SelectionScreen extends HookConsumerWidget {
  const SelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = ref.watch(localizationProvider);
    final uiModel = ref.watch(selectionUiModelProvider);
    final eventHandler = ref.read(selectionEventHandlerProvider);
    useEffect(() {
      eventHandler.onCreate();
      return () {};
    }, const []);
    ref.listen(selectionUiModelProvider, (previous, next) {
      checkOneShotOperation(previous, next, (uiModel) => uiModel.backEffect,
          (backEffect) {
        if (backEffect) {
          Navigator.pop(context);
        }
      });
    });
    return PopScope(
      canPop: uiModel.canPop,
      child: Stack(children: [
        Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: Text(localization.selectionTitle),
            ),
            body: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                _sampleSubtitle(context, localization),
                _sampleButton(context, eventHandler, localization),
              ],
            )),
        if (uiModel.progress)
          const ModalBarrier(
            color: Colors.black54,
            dismissible: false,
          ),
        if (uiModel.progress)
          const Center(
            child: CircularProgressIndicator(),
          ),
      ]),
    );
  }

  Widget _sampleSubtitle(BuildContext context, Localization localization) {
    final style = Theme.of(context).textTheme.titleLarge;
    return Text(localization.selectionSampleSubTitle, style: style);
  }

  Widget _sampleButton(BuildContext context, SelectionEventHandler eventHandler,
      Localization localization) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: FilledButton(
        onPressed: () {
          eventHandler.onClickSampleTask();
        },
        child: Text(localization.selectionOpenSampleTask),
      ),
    );
  }
}
