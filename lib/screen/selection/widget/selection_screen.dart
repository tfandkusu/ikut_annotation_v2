import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
    return PopScope(
      canPop: uiModel.canPop,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(localization.selectionTitle),
          ),
          body: const Text("SelectionScreen")),
    );
  }
}
