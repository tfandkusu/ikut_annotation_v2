import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ikut_annotation_v2/util/view/check_one_shot_operation.dart';
import 'package:url_launcher/url_launcher.dart';

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
      checkOneShotOperation(
          previous, next, (uiModel) => uiModel.showAnnotationTaskGuideEffect,
          (showAnnotationTaskGuideEffect) {
        if (showAnnotationTaskGuideEffect) {
          eventHandler.onShownAnnotationTaskGuide();
          launchUrl(Uri.parse(
              "https://github.com/tfandkusu/ikut_annotation_v2/blob/main/how_to_define_annotation_jobs.md"));
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 0.0, vertical: 16.0),
              children: [
                _sampleSubtitle(context, localization),
                _sampleButton(context, uiModel.openSampleTaskButtonEnabled,
                    eventHandler, localization),
                _yourSubtitle(context, localization),
                _annotationTaskUrlTextField(
                    context, eventHandler, localization),
                _howToDefineAnnotationTextTextButton(
                  context,
                  eventHandler,
                  localization,
                ),
                _yourButton(context, uiModel.openYourTaskButtonEnabled,
                    uiModel.annotationTaskUrl, eventHandler, localization)
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(localization.selectionSampleSubTitle, style: style),
    );
  }

  Widget _sampleButton(BuildContext context, bool openSampleButtonEnabled,
      SelectionEventHandler eventHandler, Localization localization) {
    VoidCallback? onPressed;
    if (openSampleButtonEnabled) {
      onPressed = () {
        eventHandler.onClickSampleTask();
      };
    } else {
      onPressed = null;
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
      child: FilledButton(
        onPressed: onPressed,
        child: Text(localization.selectionOpenSampleTask),
      ),
    );
  }

  Widget _yourSubtitle(BuildContext context, Localization localization) {
    final style = Theme.of(context).textTheme.titleLarge;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 0.0),
      child: Text(localization.selectionYourSubTitle, style: style),
    );
  }

  Widget _annotationTaskUrlTextField(BuildContext context,
      SelectionEventHandler eventHandler, Localization localization) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
      child: TextField(
        onChanged: (annotationTaskUrl) {
          eventHandler.setAnnotationTaskUrl(annotationTaskUrl);
        },
        decoration: InputDecoration(
          labelText: localization.selectionAnnotationTaskUrl,
          hintText: localization.selectionAnnotationTaskUrlPlaceHolder,
        ),
        keyboardType: TextInputType.url,
      ),
    );
  }

  Widget _howToDefineAnnotationTextTextButton(BuildContext context,
      SelectionEventHandler eventHandler, Localization localization) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 0.0),
      child: Row(
        children: [
          TextButton(
            onPressed: () {
              eventHandler.onClickAnnotationTaskGuide();
            },
            child: Text(localization.selectionHowToDefineAnnotationTask),
          ),
          const Spacer()
        ],
      ),
    );
  }

  _yourButton(
      BuildContext context,
      bool openYourTaskButtonEnabled,
      String annotationTaskUrl,
      SelectionEventHandler eventHandler,
      Localization localization) {
    VoidCallback? onPressed;
    if (openYourTaskButtonEnabled) {
      onPressed = () {
        eventHandler.onClickYourTask(annotationTaskUrl);
      };
    } else {
      onPressed = null;
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
      child: FilledButton(
        onPressed: onPressed,
        child: Text(localization.selectionOpenYourTask),
      ),
    );
  }
}
