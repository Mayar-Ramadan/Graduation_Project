import 'package:flutter/material.dart';
import 'package:gradution_project_smart_sip/l10n/app_localizations.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final S = AppLocalizations.of(context)!;

    return Container(
      height: 90,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(35)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
          )
        ],
      ),
      child: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          // Navigation Items
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
          
                Expanded(child: _navItem(context, Icons.local_drink, S.navBottle, currentIndex == 4, () => onTap(4))),
                Expanded(child: _navItem(context, Icons.history, S.navHistory, currentIndex == 1, () => onTap(1))),
                
              
                const SizedBox(width: 75), 
                
              
                Expanded(child: _navItem(context, Icons.settings, S.navSettings, currentIndex == 2, () => onTap(2))),
                Expanded(child: _navItem(context, Icons.person_outline_rounded, S.navProfile, currentIndex == 3, () => onTap(3))),
              ],
            ),
          ),

          // Home Button
          Positioned(
            top: -30,
            child: GestureDetector(
              onTap: () => onTap(0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 65,
                    width: 65,
                    decoration: BoxDecoration(
                      color: theme.primaryColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: theme.primaryColor.withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        )
                      ],
                    ),
                    child: const Icon(Icons.home_outlined, color: Colors.white, size: 32),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    S.navHome,
                    style: TextStyle(
                      color: currentIndex == 0 ? theme.primaryColor : Colors.blueGrey.shade200,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _navItem(BuildContext context, IconData icon, String label, bool isSelected, VoidCallback onPressed) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? theme.primaryColor : Colors.blueGrey.shade200,
            size: 26,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis, 
            style: TextStyle(
              color: isSelected ? theme.primaryColor : Colors.blueGrey.shade200,
              fontSize: 13, 
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}