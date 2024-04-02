import 'package:flutter/material.dart';
import '../../core/utils/size_utils.dart';
import '../../theme/theme_helper.dart';

/// A collection of pre-defined text styles for customizing text appearance,
/// categorized by different font families and weights.
/// Additionally, this class includes extensions on [TextStyle] to easily apply specific font families to text.

class CustomTextStyles {
  // Body text style
  static get bodyLarge18 => theme.textTheme.bodyLarge!.copyWith(
        fontSize: 18.fSize,
      );
  static get bodyLargeOnPrimaryContainer => theme.textTheme.bodyLarge!.copyWith(
        color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
      );
  static get bodyLargeSofiaPro => theme.textTheme.bodyLarge!.sofiaPro;
  static get bodyLargeff6a6a6a => theme.textTheme.bodyLarge!.copyWith(
        color: Color(0XFF6A6A6A),
      );
  static get bodySmallGray50001 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.gray50001,
      );
  static get bodySmallGray50002 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.gray50002,
      );
  static get bodySmallSofiaProGray50001 =>
      theme.textTheme.bodySmall!.sofiaPro.copyWith(
        color: appTheme.gray50001,
      );
  // Headline text style
  static get headlineLargeSemiBold => theme.textTheme.headlineLarge!.copyWith(
        fontWeight: FontWeight.w600,
      );
  // Label text style
  static get labelLargeSofiaProGray50001 =>
      theme.textTheme.labelLarge!.sofiaPro.copyWith(
        color: appTheme.gray50001,
      );
  // Title text style
  static get titleLargeGray700 => theme.textTheme.titleLarge!.copyWith(
        color: appTheme.gray700,
        fontWeight: FontWeight.w300,
      );
  static get titleMediumGray700 => theme.textTheme.titleLarge!.copyWith(
        color: appTheme.gray700,
        fontWeight: FontWeight.w300,
      );
  static get titleLargeInter => theme.textTheme.titleLarge!.inter.copyWith(
        fontSize: 23.fSize,
        fontWeight: FontWeight.w700,
      );
  static get titleLargeMedium => theme.textTheme.titleLarge!.copyWith(
        fontWeight: FontWeight.w500,
      );
  static get titleMediumOnPrimary => theme.textTheme.titleMedium!.copyWith(
        color: theme.colorScheme.onPrimary,
        fontWeight: FontWeight.w500,
      );
  static get titleMediumOnPrimaryContainer =>
      theme.textTheme.titleMedium!.copyWith(
        color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
      );
  static get titleMediumOnPrimaryContainerMedium =>
      theme.textTheme.titleMedium!.copyWith(
        color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
        fontWeight: FontWeight.w500,
      );
  static get titleMediumSofiaPro => theme.textTheme.titleMedium!.sofiaPro;
  static get titleMediumff1a1d1e => theme.textTheme.titleMedium!.copyWith(
        color: Color(0XFF1A1D1E),
        fontWeight: FontWeight.w500,
      );
  static get titleMediumff6a6a6a => theme.textTheme.titleMedium!.copyWith(
        color: Color(0XFF6A6A6A),
        fontWeight: FontWeight.w500,
      );

  static get bodyLargePoppins => theme.textTheme.bodyLarge!.poppins.copyWith(
        fontSize: 18.fSize,
      );
  static get bodyLargePoppins_1 => theme.textTheme.bodyLarge!.poppins;
  static get bodyMedium14 => theme.textTheme.bodyMedium!.copyWith(
        fontSize: 14.fSize,
      );

  static get titleLargeInterOnPrimaryContainer =>
      theme.textTheme.titleLarge!.inter.copyWith(
        color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
        fontSize: 22.fSize,
        fontWeight: FontWeight.w700,
      );

  static get titleMediumOnSecondaryContainer =>
      theme.textTheme.titleMedium!.copyWith(
        color: theme.colorScheme.onSecondaryContainer,
        fontSize: 18.fSize,
      );
  static get titleMediumPoppinsOnPrimary =>
      theme.textTheme.titleMedium!.poppins.copyWith(
        color: theme.colorScheme.onPrimary,
        fontWeight: FontWeight.w500,
      );
  static get titleMediumPoppinsOnPrimaryContainer =>
      theme.textTheme.titleMedium!.poppins.copyWith(
        color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
        fontWeight: FontWeight.w600,
      );
  static get titleMediumPoppinsOnSecondaryContainer =>
      theme.textTheme.titleMedium!.poppins.copyWith(
        color: theme.colorScheme.onSecondaryContainer,
        fontWeight: FontWeight.w600,
      );
  static get titleMediumSofiaProOnSecondaryContainer =>
      theme.textTheme.titleMedium!.sofiaPro.copyWith(
        color: theme.colorScheme.onSecondaryContainer,
        fontWeight: FontWeight.w600,
      );
  static get titleSmallOnSecondaryContainer =>
      theme.textTheme.titleSmall!.copyWith(
        color: theme.colorScheme.onSecondaryContainer,
      );
}

extension on TextStyle {
  TextStyle get poppins {
    return copyWith(
      fontFamily: 'Poppins',
    );
  }

  TextStyle get sofiaPro {
    return copyWith(
      fontFamily: 'Sofia Pro',
    );
  }

  TextStyle get inter {
    return copyWith(
      fontFamily: 'Inter',
    );
  }
}
