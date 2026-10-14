import 'package:flutter/material.dart';
import '../theme/femme_theme.dart';
import '../widgets/femme_nav.dart';
import 'femme_home.dart';
import 'femme_cycle.dart';
import 'femme_log.dart';
import 'femme_content.dart';
import 'femme_profile.dart';

class FemmeShell extends StatefulWidget {
  const FemmeShell({super.key});
  @override
  State<FemmeShell> createState() => _FemmeShellState();
}

class _FemmeShellState extends State<FemmeShell> {
  int index = 0;
  @override
  Widget build(BuildContext context) => Theme(
    data: FemmeTheme.theme,
    child: Scaffold(
      body: IndexedStack(
        index: index,
        children: [
          FemmeHome(openTab: (i) => setState(() => index = i)),
          const FemmeCycle(),
          const FemmeLog(),
          const FemmeContent(),
          const FemmeProfile(),
        ],
      ),
      bottomNavigationBar: FemmeNav(
        index: index,
        onTap: (i) => setState(() => index = i),
      ),
    ),
  );
}
