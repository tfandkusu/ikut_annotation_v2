import 'package:flutter/material.dart';
import '../stateholder/main_ui_model.dart';

class LabelsWidget extends StatelessWidget {
  final MainUiModel mainUiModel;

  const LabelsWidget(this.mainUiModel, {super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context)
        .textTheme
        .displayMedium
        ?.copyWith(color: Theme.of(context).colorScheme.onPrimary);
    if (mainUiModel.images.isNotEmpty) {
      return Column(
        children: [
          Row(
            children: [
              Container(
                  color: Colors.black54,
                  padding: const EdgeInsets.all(16),
                  child: Text(mainUiModel.imageIndex.toString(),
                      style: textStyle)),
              const Spacer()
            ],
          ),
          const Spacer(),
          Container(
              color: Colors.black54,
              padding: const EdgeInsets.all(16),
              child: Row(
                  children: mainUiModel.labels.map((label) {
                return Expanded(
                    child: Visibility(
                        visible: label ==
                            mainUiModel.images[mainUiModel.imageIndex].label,
                        maintainSize: true,
                        maintainAnimation: true,
                        maintainState: true,
                        child: Text(label, style: textStyle)));
              }).toList()))
        ],
      );
    } else {
      return Container();
    }
  }
}
