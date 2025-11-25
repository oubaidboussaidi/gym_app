import 'package:flutter/material.dart';
import 'package:gym_app/widgets/custom_text.dart';

class DescriptionBox extends StatelessWidget {
  const DescriptionBox({super.key});

  @override
  Widget build(BuildContext context) {
    final TextStyle primaryTextStyle = TextStyle(
      color: Theme.of(context).colorScheme.inversePrimary,
      fontWeight: FontWeight.bold,
    );

    final TextStyle secondaryTextStyle = TextStyle(
      color: Theme.of(context).colorScheme.primary,
    );
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.secondary),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // delivery fee
          Column(
            children: [
              CustomText(text: "\$0.99", styles: primaryTextStyle),
              CustomText(text: "Delivery Fee", styles: secondaryTextStyle),
            ],
          ),
          // delivery time
          Column(
            children: [
              CustomText(text: "25-30 min", styles: primaryTextStyle),
              CustomText(text: "Delivery Time", styles: secondaryTextStyle),
            ],
          ),
        ],
      ),
    );
  }
}
