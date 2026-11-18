import 'package:flutter/material.dart';

class NavDestination {
  const NavDestination(this.labelKey, this.icon, this.selectedIcon);
  final String labelKey;
  final IconData icon, selectedIcon;
}

const navDestinations = [
  NavDestination('nav.home', Icons.home_outlined, Icons.home),
  NavDestination('nav.search', Icons.search, Icons.manage_search),
  NavDestination('nav.inventory', Icons.medication_outlined, Icons.medication),
  NavDestination('nav.expiry', Icons.event_outlined, Icons.event),
  NavDestination('nav.settings', Icons.settings_outlined, Icons.settings),
];
