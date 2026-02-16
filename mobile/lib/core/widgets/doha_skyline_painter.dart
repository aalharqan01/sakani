import 'package:flutter/material.dart';

/// Paints a recognizable Doha skyline silhouette as a semi-transparent pattern.
/// Landmarks left-to-right: Museum of Islamic Art, Sheraton Hotel (pyramid),
/// West Bay towers (Tornado Tower, Burj Qatar/Doha Tower, Palm Towers,
/// Al Bidda Tower, Navigation Tower), 5 of June Arch, Aspire Tower (The Torch),
/// Katara Towers.
class DohaSkylinePainter extends CustomPainter {
  final Color color;

  DohaSkylinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;

    final path = Path();

    // Start from bottom-left
    path.moveTo(0, h);

    // Ground line — skyline sits above this
    final g = h * 0.82;

    // ─── Far left: low Corniche buildings ───
    path.lineTo(0, g);
    path.lineTo(w * 0.02, g);
    path.lineTo(w * 0.02, g - h * 0.04);
    path.lineTo(w * 0.05, g - h * 0.04);
    path.lineTo(w * 0.05, g - h * 0.07);
    path.lineTo(w * 0.08, g - h * 0.07);
    path.lineTo(w * 0.08, g - h * 0.03);
    path.lineTo(w * 0.10, g - h * 0.03);

    // ─── Museum of Islamic Art (stepped geometric cube + dome) ───
    // Characteristic tiered cubic base with small dome on top
    path.lineTo(w * 0.10, g - h * 0.08);
    path.lineTo(w * 0.11, g - h * 0.08);
    path.lineTo(w * 0.11, g - h * 0.13);
    path.lineTo(w * 0.12, g - h * 0.13);
    path.lineTo(w * 0.12, g - h * 0.17);
    path.lineTo(w * 0.13, g - h * 0.17);
    path.lineTo(w * 0.13, g - h * 0.21);
    // Small dome cap
    path.quadraticBezierTo(
        w * 0.145, g - h * 0.26, w * 0.16, g - h * 0.21);
    path.lineTo(w * 0.16, g - h * 0.17);
    path.lineTo(w * 0.17, g - h * 0.17);
    path.lineTo(w * 0.17, g - h * 0.13);
    path.lineTo(w * 0.18, g - h * 0.13);
    path.lineTo(w * 0.18, g - h * 0.08);
    path.lineTo(w * 0.19, g - h * 0.08);
    path.lineTo(w * 0.19, g - h * 0.03);

    // ─── Sheraton Hotel (iconic pyramid shape) ───
    path.lineTo(w * 0.21, g - h * 0.03);
    path.lineTo(w * 0.22, g - h * 0.22);
    // Pyramid peak
    path.lineTo(w * 0.235, g - h * 0.30);
    path.lineTo(w * 0.25, g - h * 0.22);
    path.lineTo(w * 0.26, g - h * 0.03);

    // ─── Gap / low buildings before West Bay ───
    path.lineTo(w * 0.27, g - h * 0.03);
    path.lineTo(w * 0.27, g - h * 0.06);
    path.lineTo(w * 0.29, g - h * 0.06);
    path.lineTo(w * 0.29, g - h * 0.10);
    path.lineTo(w * 0.30, g - h * 0.10);

    // ═══════════════════════════════════════════
    // ─── WEST BAY CLUSTER (dense skyscrapers) ──
    // ═══════════════════════════════════════════

    // -- Tornado Tower (distinctive twisted taper, narrow at top) --
    path.lineTo(w * 0.30, g - h * 0.12);
    // Slight taper inward as it rises
    path.lineTo(w * 0.31, g - h * 0.42);
    // Twisted rounded top
    path.quadraticBezierTo(
        w * 0.315, g - h * 0.47, w * 0.32, g - h * 0.42);
    path.lineTo(w * 0.33, g - h * 0.12);

    // -- Navigation Tower (slim, with pointed spire) --
    path.lineTo(w * 0.34, g - h * 0.12);
    path.lineTo(w * 0.345, g - h * 0.38);
    // Pointed spire
    path.lineTo(w * 0.35, g - h * 0.44);
    path.lineTo(w * 0.355, g - h * 0.38);
    path.lineTo(w * 0.36, g - h * 0.12);

    // -- Doha Tower / Burj Qatar (bullet-shaped, tallest in cluster) --
    path.lineTo(w * 0.37, g - h * 0.12);
    path.lineTo(w * 0.38, g - h * 0.50);
    // Distinctive dome/bullet top
    path.quadraticBezierTo(
        w * 0.395, g - h * 0.58, w * 0.41, g - h * 0.50);
    path.lineTo(w * 0.42, g - h * 0.12);

    // -- Palm Tower 1 (twin tower, flat top with crown) --
    path.lineTo(w * 0.43, g - h * 0.12);
    path.lineTo(w * 0.435, g - h * 0.40);
    // Small crown/antenna
    path.lineTo(w * 0.44, g - h * 0.43);
    path.lineTo(w * 0.445, g - h * 0.40);
    path.lineTo(w * 0.45, g - h * 0.12);

    // -- Al Bidda Tower (curved top, medium height) --
    path.lineTo(w * 0.455, g - h * 0.12);
    path.lineTo(w * 0.46, g - h * 0.34);
    // Gentle curved crown
    path.quadraticBezierTo(
        w * 0.47, g - h * 0.38, w * 0.48, g - h * 0.34);
    path.lineTo(w * 0.485, g - h * 0.12);

    // -- World Trade Center (stepped top, medium-tall) --
    path.lineTo(w * 0.49, g - h * 0.12);
    path.lineTo(w * 0.495, g - h * 0.36);
    path.lineTo(w * 0.50, g - h * 0.38);
    path.lineTo(w * 0.505, g - h * 0.40);
    path.lineTo(w * 0.51, g - h * 0.38);
    path.lineTo(w * 0.515, g - h * 0.36);
    path.lineTo(w * 0.52, g - h * 0.12);

    // -- Two shorter West Bay towers --
    path.lineTo(w * 0.53, g - h * 0.12);
    path.lineTo(w * 0.535, g - h * 0.30);
    path.lineTo(w * 0.55, g - h * 0.30);
    path.lineTo(w * 0.555, g - h * 0.12);

    path.lineTo(w * 0.56, g - h * 0.12);
    path.lineTo(w * 0.565, g - h * 0.26);
    path.lineTo(w * 0.58, g - h * 0.26);
    path.lineTo(w * 0.585, g - h * 0.12);

    // ═══════════════════════════════════════════
    // ─── END WEST BAY ──────────────────────────
    // ═══════════════════════════════════════════

    // Gap before 5 of June Arch
    path.lineTo(w * 0.60, g - h * 0.12);
    path.lineTo(w * 0.60, g - h * 0.03);

    // ─── 5 of June Arch (iconic gateway arch monument) ───
    // In silhouette: left leg rises, curves to peak, dips down for the
    // arch opening, rises again to peak, right leg descends.
    path.lineTo(w * 0.61, g - h * 0.03);

    // Left leg — thick base curving up to the arch peak
    path.lineTo(w * 0.61, g - h * 0.12);
    path.quadraticBezierTo(
        w * 0.615, g - h * 0.30, w * 0.625, g - h * 0.42);
    // Curve over to the peak
    path.quadraticBezierTo(
        w * 0.635, g - h * 0.50, w * 0.645, g - h * 0.52);
    // Peak — the top of the arch
    path.quadraticBezierTo(
        w * 0.655, g - h * 0.50, w * 0.665, g - h * 0.42);
    // Right leg descends
    path.quadraticBezierTo(
        w * 0.675, g - h * 0.30, w * 0.68, g - h * 0.12);
    path.lineTo(w * 0.68, g - h * 0.03);

    // Gap after arch
    path.lineTo(w * 0.69, g - h * 0.03);
    path.lineTo(w * 0.69, g - h * 0.08);

    // ─── Aspire Tower / The Torch (tallest structure, torch bulb top) ───
    path.lineTo(w * 0.70, g - h * 0.08);
    // Slim shaft rising
    path.lineTo(w * 0.71, g - h * 0.55);
    // Torch bulb — distinctive oval flame shape
    path.quadraticBezierTo(
        w * 0.705, g - h * 0.65, w * 0.715, g - h * 0.70);
    path.quadraticBezierTo(
        w * 0.725, g - h * 0.74, w * 0.735, g - h * 0.70);
    path.quadraticBezierTo(
        w * 0.745, g - h * 0.65, w * 0.74, g - h * 0.55);
    // Slim shaft down
    path.lineTo(w * 0.75, g - h * 0.08);

    // ─── Low buildings / Villaggio area ───
    path.lineTo(w * 0.77, g - h * 0.08);
    path.lineTo(w * 0.77, g - h * 0.12);
    path.lineTo(w * 0.79, g - h * 0.12);
    path.lineTo(w * 0.79, g - h * 0.06);

    // ─── Katara Towers (two crescent arches) ───
    path.lineTo(w * 0.81, g - h * 0.06);
    // Left crescent arch
    path.lineTo(w * 0.82, g - h * 0.18);
    path.quadraticBezierTo(
        w * 0.83, g - h * 0.28, w * 0.845, g - h * 0.32);
    // Peak between crescents
    path.quadraticBezierTo(
        w * 0.86, g - h * 0.28, w * 0.87, g - h * 0.32);
    // Right crescent arch
    path.quadraticBezierTo(
        w * 0.885, g - h * 0.28, w * 0.89, g - h * 0.18);
    path.lineTo(w * 0.90, g - h * 0.06);

    // ─── Lusail / far right fading buildings ───
    path.lineTo(w * 0.91, g - h * 0.06);
    path.lineTo(w * 0.91, g - h * 0.15);
    path.lineTo(w * 0.93, g - h * 0.15);
    path.lineTo(w * 0.93, g - h * 0.10);
    path.lineTo(w * 0.95, g - h * 0.10);
    path.lineTo(w * 0.95, g - h * 0.05);
    path.lineTo(w * 0.97, g - h * 0.05);
    path.lineTo(w * 0.97, g);
    path.lineTo(w, g);

    // Close to bottom-right corner
    path.lineTo(w, h);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant DohaSkylinePainter oldDelegate) =>
      color != oldDelegate.color;
}
