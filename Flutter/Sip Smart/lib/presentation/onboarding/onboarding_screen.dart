import 'package:flutter/material.dart';
import 'package:gradution_project_smart_sip/l10n/app_localizations.dart';
import 'package:gradution_project_smart_sip/routes/app_routes.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final S = AppLocalizations.of(context)!;
    final primaryColor = theme.primaryColor;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Skip Button
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, RoutesNames.login),
                  child: Text(
                    S.skip, // Localization Applied
                    style: TextStyle(
                      color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6), 
                      fontSize: 16, 
                      fontWeight: FontWeight.w500
                    ),
                  ),
                ),
              ),
            ),

            // Onboarding Pages Content
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentPage = index),
                children: [
                  OnboardingPage(
                    index: 0,
                    title: S.onboardingTitle1,
                    description: S.onboardingDesc1, 
                    mainIcon: Icons.insert_chart_outlined,
                    subIcon: Icons.water_drop, 
                  ),
                  OnboardingPage(
                    index: 1,
                    title: S.onboardingTitle2,
                    description: S.onboardingDesc2,
                    mainIcon: Icons.notifications_active_outlined,
                    subIcon: Icons.auto_awesome_rounded,
                  ),
                  OnboardingPage(
                    index: 2,
                    title: S.onboardingTitle3,
                    description: S.onboardingDesc3,
                    mainIcon: Icons.published_with_changes_rounded,
                    subIcon: Icons.ads_click_rounded,
                  ),
                ],
              ),
            ),

            // Page Indicators (Dots)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 5),
                height: 8,
                width: _currentPage == index ? 28 : 10,
                decoration: BoxDecoration(
                  color: _currentPage == index ? primaryColor : theme.disabledColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
              )),
            ),

            // Navigation Button
            Padding(
              padding: const EdgeInsets.all(24.0).copyWith(bottom: 40, top: 30),
              child: ElevatedButton(
                onPressed: () {
                  if (_currentPage < 2) {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOutQuart,
                    );
                  } else {
                    Navigator.pushReplacementNamed(context, RoutesNames.login);
                  }
                },
                style: ElevatedButton.styleFrom(
                
                  minimumSize: const Size.fromHeight(60),
                  shadowColor: primaryColor.withOpacity(0.4),
                ),
                child: Text(
                  _currentPage == 2 ? S.getStarted : S.next, // Localization Applied
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: 1.2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final int index;
  final String title;
  final String description;
  final IconData mainIcon;
  final IconData subIcon;

  const OnboardingPage({
    super.key,
    required this.index,
    required this.title,
    required this.description,
    required this.mainIcon,
    required this.subIcon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35),
        child: Column(
          children: [
            const SizedBox(height: 40),
            
            _buildSmartIllustration(primaryColor, mainIcon, subIcon),
            
            const SizedBox(height: 60),
            
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontSize: 30,
                fontWeight: FontWeight.w900,
                height: 1.1,
              ),
            ),
            
            const SizedBox(height: 20),
            
            Text(
              description,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 17,
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                height: 1.5,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmartIllustration(Color color, IconData main, IconData sub) {
    return SizedBox(
      width: 260,
      height: 260,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 240,
            height: 240,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: color.withOpacity(0.08), width: 3),
            ),
          ),
          
          Container(
            width: 175,
            height: 175,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [color.withOpacity(0.7), color],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 25,
                  spreadRadius: 2,
                  offset: const Offset(0, 10),
                )
              ],
            ),
            child: Icon(main, size: 85, color: Colors.white),
          ),
        
          Positioned(
            bottom: 35,
            right: 35,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: Icon(sub, size: 30, color: color),
            ),
          ),
        ],
      ),
    );
  }
}