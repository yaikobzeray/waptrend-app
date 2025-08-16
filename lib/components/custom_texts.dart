import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../util/app_config_constants.dart';

class FontSizes {
  static double scale = 1;

  // Heading sizes
  static double get h1 => 32 * scale; // Large heading
  static double get h2 => 28 * scale; // Page heading
  static double get h3 => 24 * scale; // Section heading
  static double get h4 => 20 * scale; // Sub-section heading
  static double get h5 => 18 * scale; // Small heading
  static double get h6 => 16 * scale; // Extra small heading

  // Body sizes
  static double get b1 => 16 * scale; // Large body
  static double get b2 => 14 * scale; // Regular body
  static double get b3 => 13 * scale; // Medium body
  static double get b4 => 12 * scale; // Small body
  static double get b5 => 11 * scale; // Extra small body
}

class TextWeight {
  static FontWeight get light => FontWeight.w300;
  static FontWeight get regular => FontWeight.w400;
  static FontWeight get medium => FontWeight.w500;
  static FontWeight get semiBold => FontWeight.w600;
  static FontWeight get bold => FontWeight.w700;
  static FontWeight get extraBold => FontWeight.w800;
}

class _BaseText extends StatelessWidget {
  final String text;
  final int? maxLines;
  final TextAlign? textAlign;
  final FontWeight? weight;
  final Color? color;
  final double fontSize;
  final String? fontFamily;
  final TextOverflow? overflow;

  const _BaseText(
    this.text, {
    required this.fontSize,
    super.key,
    this.textAlign,
    this.maxLines,
    this.weight,
    this.color,
    this.fontFamily,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.ellipsis,
      textAlign: textAlign ?? TextAlign.left,
      style: GoogleFonts.poppins(
        fontSize: fontSize,
        fontWeight: weight ?? TextWeight.regular,
        color: color ?? AppColorConstants.mainTextColor,
      ),
    );
  }
}

class Heading1Text extends StatelessWidget {
  final String text;
  final int? maxLines;
  final FontWeight? weight;
  final Color? color;
  final TextAlign? textAlign;

  const Heading1Text(this.text,
      {super.key, this.textAlign, this.maxLines, this.weight, this.color});

  @override
  Widget build(BuildContext context) {
    return _BaseText(
      text,
      fontSize: FontSizes.h1,
      weight: weight ?? TextWeight.bold,
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
    );
  }
}

class Heading2Text extends StatelessWidget {
  final String text;
  final int? maxLines;
  final TextAlign? textAlign;
  final FontWeight? weight;
  final Color? color;

  const Heading2Text(this.text,
      {super.key, this.textAlign, this.maxLines, this.weight, this.color});

  @override
  Widget build(BuildContext context) {
    return _BaseText(
      text,
      fontSize: FontSizes.h2,
      weight: weight ?? TextWeight.bold,
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
    );
  }
}

class Heading3Text extends StatelessWidget {
  final String text;
  final int? maxLines;
  final TextAlign? textAlign;
  final FontWeight? weight;
  final Color? color;

  const Heading3Text(this.text,
      {super.key, this.textAlign, this.maxLines, this.weight, this.color});

  @override
  Widget build(BuildContext context) {
    return _BaseText(
      text,
      fontSize: FontSizes.h3,
      weight: weight ?? TextWeight.semiBold,
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
    );
  }
}

class Heading4Text extends StatelessWidget {
  final String text;
  final int? maxLines;
  final TextAlign? textAlign;
  final FontWeight? weight;
  final Color? color;

  const Heading4Text(this.text,
      {super.key, this.textAlign, this.maxLines, this.weight, this.color});

  @override
  Widget build(BuildContext context) {
    return _BaseText(
      text,
      fontSize: FontSizes.h4,
      weight: weight ?? TextWeight.semiBold,
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
    );
  }
}

class Heading5Text extends StatelessWidget {
  final String text;
  final int? maxLines;
  final TextAlign? textAlign;
  final FontWeight? weight;
  final Color? color;

  const Heading5Text(this.text,
      {super.key, this.textAlign, this.maxLines, this.weight, this.color});

  @override
  Widget build(BuildContext context) {
    return _BaseText(
      text,
      fontSize: FontSizes.h5,
      weight: weight ?? TextWeight.medium,
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
    );
  }
}

class Heading6Text extends StatelessWidget {
  final String text;
  final int? maxLines;
  final TextAlign? textAlign;
  final FontWeight? weight;
  final Color? color;

  const Heading6Text(this.text,
      {super.key, this.textAlign, this.maxLines, this.weight, this.color});

  @override
  Widget build(BuildContext context) {
    return _BaseText(
      text,
      fontSize: FontSizes.h6,
      weight: weight ?? TextWeight.medium,
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
    );
  }
}

class BodyExtraLargeText extends StatelessWidget {
  final String text;
  final int? maxLines;
  final TextAlign? textAlign;
  final FontWeight? weight;
  final Color? color;

  const BodyExtraLargeText(this.text,
      {super.key, this.textAlign, this.maxLines, this.weight, this.color});

  @override
  Widget build(BuildContext context) {
    return _BaseText(
      text,
      fontSize: FontSizes.b1,
      weight: weight ?? TextWeight.regular,
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
    );
  }
}

class BodyLargeText extends StatelessWidget {
  final String text;
  final int? maxLines;
  final TextAlign? textAlign;
  final FontWeight? weight;
  final Color? color;

  const BodyLargeText(this.text,
      {super.key, this.textAlign, this.maxLines, this.weight, this.color});

  @override
  Widget build(BuildContext context) {
    return _BaseText(
      text,
      fontSize: FontSizes.b1,
      weight: weight ?? TextWeight.regular,
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
    );
  }
}

class BodyMediumText extends StatelessWidget {
  final String text;
  final int? maxLines;
  final TextAlign? textAlign;
  final FontWeight? weight;
  final Color? color;

  const BodyMediumText(this.text,
      {super.key, this.textAlign, this.maxLines, this.weight, this.color});

  @override
  Widget build(BuildContext context) {
    return _BaseText(
      text,
      fontSize: FontSizes.b2,
      weight: weight ?? TextWeight.regular,
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
    );
  }
}

class BodySmallText extends StatelessWidget {
  final String? text;
  final int? maxLines;
  final TextAlign? textAlign;
  final FontWeight? weight;
  final Color? color;

  const BodySmallText(this.text,
      {super.key, this.textAlign, this.maxLines, this.weight, this.color});

  @override
  Widget build(BuildContext context) {
    return _BaseText(
      text ?? "",
      fontSize: FontSizes.b4,
      weight: weight ?? TextWeight.regular,
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
    );
  }
}

class BodyExtraSmallText extends StatelessWidget {
  final String text;
  final int? maxLines;
  final TextAlign? textAlign;
  final FontWeight? weight;
  final Color? color;

  const BodyExtraSmallText(this.text,
      {super.key, this.textAlign, this.maxLines, this.weight, this.color});

  @override
  Widget build(BuildContext context) {
    return _BaseText(
      text,
      fontSize: FontSizes.b5,
      weight: weight ?? TextWeight.regular,
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
    );
  }
}
