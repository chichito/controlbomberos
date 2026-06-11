import 'package:avatars/avatars.dart';
import 'package:flutter/material.dart';

class GloboAvatar extends StatelessWidget {
  const GloboAvatar({
    super.key,
    this.photoUrl,
    required this.name,
    this.radius = 20,
  });

  final String? photoUrl;
  final String name;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return (photoUrl != null)
        ? CircleAvatar(backgroundImage: NetworkImage(photoUrl!), radius: radius)
        : Avatar(name: name, shape: AvatarShape.circle(radius));
  }
}
