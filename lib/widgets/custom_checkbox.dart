import 'package:flutter/material.dart';
import 'package:gym_app/widgets/custom_text.dart';

class CustomCheckBox extends StatelessWidget {
  final bool value;
  final void Function(bool) onChanged;
  final String title;
  final String subtitle;

  const CustomCheckBox({
    super.key,
    required this.value,
    required this.onChanged,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onChanged(!value),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(text: title, styles: TextStyle(fontSize: 18)),
                    CustomText(
                      text: subtitle,
                      styles: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              Checkbox(
                value: value,
                onChanged: null, // InkWell handles the tap
                activeColor: Theme.of(context).colorScheme.inversePrimary,
                checkColor: Theme.of(context).colorScheme.onPrimary,
                side: WidgetStateBorderSide.resolveWith(
                  (states) => BorderSide(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    width: 2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
