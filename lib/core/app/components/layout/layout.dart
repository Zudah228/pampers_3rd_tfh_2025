import 'package:flutter/material.dart';

class Headline2 extends StatelessWidget {
  const Headline2({super.key, this.style, required this.child});

  final TextStyle? style;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 16,
      ),
      child: DefaultTextStyle.merge(
        style: Theme.of(context).textTheme.headlineSmall!.merge(style),
        child: child,
      ),
    );
  }
}

class Headline3 extends StatelessWidget {
  const Headline3({super.key, this.style, required this.child});

  final TextStyle? style;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 8,
      ),
      child: DefaultTextStyle.merge(
        style: Theme.of(context).textTheme.titleMedium!.merge(style),
        child: child,
      ),
    );
  }
}

class Body extends StatelessWidget {
  const Body({super.key, this.style, required this.children});

  final TextStyle? style;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 24,
      ),
      child: DefaultTextStyle.merge(
        style: Theme.of(context).textTheme.bodyMedium!.merge(style),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: children,
        ),
      ),
    );
  }
}
