import 'package:flutter/material.dart';

/// All preset avatars available for users to choose from.
/// Each entry is an [IconData] + background [Color] pair.
class AvatarPreset {
  final IconData icon;
  final Color background;
  final Color iconColor;

  const AvatarPreset({
    required this.icon,
    required this.background,
    required this.iconColor,
  });
}

const List<AvatarPreset> kAvatarPresets = [
  AvatarPreset(
    icon: Icons.person,
    background: Color(0xFF000000),
    iconColor: Colors.white,
  ),
  AvatarPreset(
    icon: Icons.person,
    background: Color(0xFF424242),
    iconColor: Colors.white,
  ),
  AvatarPreset(
    icon: Icons.face,
    background: Color(0xFF1565C0),
    iconColor: Colors.white,
  ),
  AvatarPreset(
    icon: Icons.face_2,
    background: Color(0xFFAD1457),
    iconColor: Colors.white,
  ),
  AvatarPreset(
    icon: Icons.face_3,
    background: Color(0xFF2E7D32),
    iconColor: Colors.white,
  ),
  AvatarPreset(
    icon: Icons.face_4,
    background: Color(0xFFE65100),
    iconColor: Colors.white,
  ),
  AvatarPreset(
    icon: Icons.face_5,
    background: Color(0xFF4527A0),
    iconColor: Colors.white,
  ),
  AvatarPreset(
    icon: Icons.face_6,
    background: Color(0xFF00838F),
    iconColor: Colors.white,
  ),
  AvatarPreset(
    icon: Icons.sentiment_satisfied_alt,
    background: Color(0xFFF9A825),
    iconColor: Colors.white,
  ),
  AvatarPreset(
    icon: Icons.mood,
    background: Color(0xFFD32F2F),
    iconColor: Colors.white,
  ),
  AvatarPreset(
    icon: Icons.star,
    background: Color(0xFF558B2F),
    iconColor: Colors.white,
  ),
  AvatarPreset(
    icon: Icons.favorite,
    background: Color(0xFFC62828),
    iconColor: Colors.white,
  ),
];

/// Builds the avatar widget for a given [index].
/// [size] is the diameter of the circle.
Widget buildAvatar(int index, {double size = 56}) {
  final preset = kAvatarPresets[index.clamp(0, kAvatarPresets.length - 1)];
  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(color: preset.background, shape: BoxShape.circle),
    child: Icon(preset.icon, size: size * 0.55, color: preset.iconColor),
  );
}
