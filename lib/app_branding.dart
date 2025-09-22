import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class AppBranding extends StatelessWidget {
  const AppBranding({super.key, required int size});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.cake_rounded,
          size: 100,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(height: 20),
        Text(
          'Myop-Myup',
          style: GoogleFonts.pacifico(
            fontSize: 48,
            color: theme.colorScheme.primary,
            shadows: [
              Shadow(
                blurRadius: 10.0,
                color: theme.colorScheme.primary.withAlpha((255 * 0.3).round()),
                offset: const Offset(0, 4),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Toko Dessert Paling Imut',
          style: GoogleFonts.patrickHand(
            fontSize: 22,
            color: theme.colorScheme.onSurface.withAlpha((255 * 0.7).round()),
          ),
        ),
      ],
    );
  }
}

