import 'package:booster/features/projects/presentation/widgets/action_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ActionsBar extends StatelessWidget {
  const ActionsBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ActionItem(
          icon:  Image.asset('assets/images/icon1.png'),
          iconColor: Color.fromARGB(255, 207, 8, 8),
          backgroundColor: const Color(0xFFE5E5E5),
          onTap: () {},
        ),
        ActionItem(
          icon:  SvgPicture.asset('assets/svg/persons.svg'),
          backgroundColor: const Color(0xFFFFE3C2),
          iconColor: const Color(0xFFF57C00),
          onTap: () {},
        ),
        ActionItem(
          icon:  SvgPicture.asset('assets/svg/chart_icon.svg'),
          backgroundColor: const Color(0xFFFFE3C2),
          iconColor: const Color(0xFFF57C00),
          onTap: () {},
        ),
        ActionItem(
          icon:  SvgPicture.asset('assets/svg/person.svg'),
          backgroundColor: const Color(0xFFFFE3C2),
          iconColor: const Color(0xFFF57C00),
          onTap: () {},
        ),
      ],
    );
  }
}
