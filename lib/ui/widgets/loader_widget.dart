import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  String loaderTitle;
  LoadingWidget({super.key, required this.loaderTitle});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.black.withOpacity(0.4)),
      child: Container(
        alignment: Alignment.center,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(loaderTitle, style: Theme.of(context).textTheme.displaySmall),
              const SizedBox(width: 10),
              const CircularProgressIndicator(strokeWidth: 2.5, color: Colors.purple),
            ],
          ),
        ),
      ),
    );
  }
}
