import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../utils/Theme/colors.dart';

class EmptyFailureNoInternetView extends StatelessWidget {
  const EmptyFailureNoInternetView(
      {super.key,
      required this.image,
      required this.title,
      required this.description,
      required this.buttonText,
      required this.onPressed});

  final String title, description, buttonText, image;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Lottie.asset(
                image,
                height: 250,
                width: 250,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                title,
                style: const TextStyle(fontSize: 20 , fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                description,
                style: const TextStyle(fontSize: 18 , fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 8,
              ),
              ElevatedButton(
                onPressed: onPressed,
                style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => primaryColor)),
                child: Text(buttonText),
              )
            ],
          ),
        ),
      ),
    );
  }
}
