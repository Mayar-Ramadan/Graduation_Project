import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:flutter/material.dart';
import 'package:gradution_project_smart_sip/data/models/user_model.dart';
import 'package:gradution_project_smart_sip/providers/auth_provider.dart' show AuthProvider;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:gradution_project_smart_sip/l10n/app_localizations.dart';
import 'package:gradution_project_smart_sip/core/utils/formatters.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isEditing = false;
  late TextEditingController nameCtrl;
  late TextEditingController ageCtrl;
  late TextEditingController weightCtrl;
  late TextEditingController heightCtrl;

  String? selectedActivity;
  final List<String> activityLevels = const ["Low", "Medium", "High"];

  String? _originalName;
  String? _originalAge;
  String? _originalWeight;
  String? _originalHeight;
  String? _originalActivity;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController();
    ageCtrl = TextEditingController();
    weightCtrl = TextEditingController();
    heightCtrl = TextEditingController();
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    ageCtrl.dispose();
    weightCtrl.dispose();
    heightCtrl.dispose();
    super.dispose();
  }


  String _getTranslatedActivity(BuildContext context, String? activityKey) {
    final S = AppLocalizations.of(context)!;
    final key = activityKey ?? 'Low';
    final Map<String, String> map = {
      'Low': S.activityLow,
      'Medium': S.activityMedium,
      'High': S.activityHigh,
    };
    return map[key] ?? key;
  }

  @override
  Widget build(BuildContext context) {
    final S = AppLocalizations.of(context)!;
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final currentUser = FirebaseAuth.instance.currentUser;
    final uid = currentUser?.uid ?? '';
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F1115) : theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.primaryColor,
        automaticallyImplyLeading: false,
        title: Text(
          S.profile,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.2),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
            onPressed: () => _showLogoutDialog(context, authProvider, S),
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data?.data() == null) {
            return Center(child: Text(S.noUserData));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final user = UserModel.fromMap(data);

        
          if (_originalName == null) {
            _originalName = user.fullName;
            _originalAge = user.age.toString();
            _originalWeight = user.weight.toString();
            _originalHeight = user.height.toString();
            _originalActivity = data['activityLevel'] ?? 'Low';
          }

  
          nameCtrl.text = user.fullName;
          ageCtrl.text = user.age.toString();
          weightCtrl.text = user.weight.toString();
          heightCtrl.text = user.height.toString();
          if (!isEditing) {
            final activityFromDb = data['activityLevel'] ?? 'Low';
            selectedActivity = activityLevels.contains(activityFromDb) ? activityFromDb : 'Low';
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              children: [
                _buildAvatar(context, user, authProvider),
                const SizedBox(height: 25),

                isEditing
                    ? _buildNameField(theme.primaryColor, theme)
                    : Text(
                        user.fullName.isNotEmpty ? user.fullName : S.user,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),

                const SizedBox(height: 8),
                Text(
                  currentUser?.email ?? user.email,
                  style: theme.textTheme.bodyMedium?.copyWith(color: isDark ? Colors.white54 : Colors.grey),
                ),

                const SizedBox(height: 40),

                _buildEditableInfoTile(
                  context,
                  Icons.calendar_today_rounded,
                  S.age,
                  ageCtrl,
                  isEditing,
                  S.years,
                  const Color(0xFF40C4FF),
                  (val) => int.tryParse(val) ?? 0,
                ),
                _buildEditableInfoTile(
                  context,
                  Icons.monitor_weight_rounded,
                  S.weight,
                  weightCtrl,
                  isEditing,
                  S.kg,
                  const Color(0xFF00E676),
                  (val) => double.tryParse(val) ?? 0.0,
                ),
                _buildEditableInfoTile(
                  context,
                  Icons.height_rounded,
                  S.height,
                  heightCtrl,
                  isEditing,
                  S.cm,
                  const Color(0xFFFFD740),
                  (val) => double.tryParse(val) ?? 0.0,
                ),
                _buildActivityDropdownTile(context, Icons.directions_run_rounded, S.activity, isEditing, const Color(0xFFD4E157)),
                _buildStaticInfoTile(context, Icons.wc_rounded, S.gender, user.gender == "Male" ? S.male : S.female, Colors.deepPurpleAccent),

                const SizedBox(height: 40),

                _buildMainButton(context, isEditing, theme.primaryColor, authProvider, S),

                if (isEditing)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isEditing = false;
                        ageCtrl.text = _originalAge ?? '';
                        weightCtrl.text = _originalWeight ?? '';
                        heightCtrl.text = _originalHeight ?? '';
                        selectedActivity = _originalActivity ?? 'Low';
                      });
                    },
                    child: Text(
                      S.cancel,
                      style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEditableInfoTile(
    BuildContext context,
    IconData icon,
    String label,
    TextEditingController controller,
    bool editing,
    String unit,
    Color accentColor,
    num Function(String) parser,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final rawValue = controller.text.trim();
    final numericValue = rawValue.isNotEmpty ? parser(rawValue) : 0;
    final formattedValue = rawValue.isNotEmpty
        ? (numericValue is int
            ? AppFormatters.formatInt(context, numericValue)
            : AppFormatters.formatDouble(context, numericValue.toDouble()))
        : '';

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1D23) : const Color.fromARGB(255, 248, 247, 247),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: accentColor.withOpacity(isDark ? 0.3 : 0.15), width: 1.5),
        boxShadow: [
          if (isDark) BoxShadow(color: accentColor.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5)),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: accentColor.withOpacity(0.12), borderRadius: BorderRadius.circular(15)),
          child: Icon(icon, color: accentColor, size: 22),
        ),
        title: Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isDark ? Colors.white70 : theme.hintColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: SizedBox(
          width: 140,
          child: editing
              ? TextField(
                  controller: controller,
                  enabled: true,
                  textAlign: TextAlign.right,
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 17,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    suffixText: " $unit",
                    suffixStyle: TextStyle(color: isDark ? Colors.white38 : Colors.grey, fontSize: 12),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      formattedValue.isNotEmpty ? formattedValue : '---',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 17,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      unit,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: isDark ? Colors.white54 : Colors.grey,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildActivityDropdownTile(BuildContext context, IconData icon, String label, bool editing, Color accentColor) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (selectedActivity == null || !activityLevels.contains(selectedActivity)) {
      selectedActivity = 'Low';
    }

    return Container(
      height: 70,
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1D23) : const Color.fromARGB(255, 248, 247, 247),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: accentColor.withOpacity(isDark ? 0.3 : 0.15), width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: accentColor.withOpacity(0.12), borderRadius: BorderRadius.circular(15)),
            child: Icon(icon, color: accentColor, size: 22),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isDark ? Colors.white70 : theme.hintColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          if (editing)
            DropdownButton<String>(
              value: selectedActivity,
              dropdownColor: isDark ? const Color(0xFF1A1D23) : Colors.white,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w900,
              ),
              underline: const SizedBox(),
              items: activityLevels.map((level) {
                return DropdownMenuItem<String>(
                  value: level,
                  child: Text(_getTranslatedActivity(context, level)),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  selectedActivity = val;
                });
              },
            ),
          Text(
              _getTranslatedActivity(context, selectedActivity),
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
            ),
        ],
      ),
    );
  }

  Widget _buildStaticInfoTile(BuildContext context, IconData icon, String label, String value, Color accentColor) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1D23) : const Color.fromARGB(255, 248, 247, 247),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: accentColor.withOpacity(isDark ? 0.3 : 0.15), width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: accentColor.withOpacity(0.12), borderRadius: BorderRadius.circular(15)),
            child: Icon(icon, color: accentColor, size: 22),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isDark ? Colors.white70 : theme.hintColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(BuildContext context, UserModel user, AuthProvider provider) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(colors: [theme.primaryColor, const Color(0xFF40C4FF)]),
            boxShadow: [if (isDark) BoxShadow(color: theme.primaryColor.withOpacity(0.4), blurRadius: 20)],
          ),
          child: CircleAvatar(
            radius: 65,
            backgroundColor: isDark ? const Color(0xFF1A1D23) : Colors.white,
            backgroundImage: user.profileUrl.isNotEmpty ? NetworkImage(user.profileUrl) : null,
            child: user.profileUrl.isEmpty ? Icon(Icons.person_rounded, size: 70, color: theme.primaryColor) : null,
          ),
        ),
        GestureDetector(
          onTap: () async {
            final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 50);
            if (pickedFile != null) await provider.updateProfileImage(File(pickedFile.path));
          },
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF00E676),
              shape: BoxShape.circle,
              border: Border.all(color: isDark ? const Color(0xFF0F1115) : Colors.white, width: 4),
              boxShadow: [const BoxShadow(color: Colors.black26, blurRadius: 10)],
            ),
            padding: const EdgeInsets.all(10),
            child: const Icon(Icons.camera_alt_rounded, size: 20, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildMainButton(BuildContext context, bool editing, Color color, AuthProvider provider, var S) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: (editing ? Colors.green : color).withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: editing ? const Color(0xFF00E676) : color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 0,
        ),
        onPressed: () async {
          if (editing) {
            await provider.updateUserData({
              'fullName': nameCtrl.text.trim(),
              'age': ageCtrl.text.trim(),
              'weight': weightCtrl.text.trim(),
              'height': heightCtrl.text.trim(),
              'activityLevel': selectedActivity,
            });

            // ✅ التحقق من أن الشاشة لسه موجودة
            if (!mounted) return;

            _originalAge = ageCtrl.text.trim();
            _originalWeight = weightCtrl.text.trim();
            _originalHeight = heightCtrl.text.trim();
            _originalActivity = selectedActivity;
            setState(() => isEditing = false);
          } else {
            setState(() => isEditing = true);
          }
        },
        child: Text(
          editing ? S.saveChanges : S.editProfile,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1.1),
        ),
      ),
    );
  }

  Widget _buildNameField(Color primaryColor, ThemeData theme) {
    return SizedBox(
      width: 250,
      child: TextField(
        controller: nameCtrl,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 24,
          color: theme.brightness == Brightness.dark ? Colors.white : Colors.black87,
        ),
        decoration: InputDecoration(
          hintText: "Full Name",
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: primaryColor, width: 3)),
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: theme.dividerColor)),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, AuthProvider provider, var S) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1A1D23) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
          side: BorderSide(color: Colors.redAccent.withOpacity(0.3)),
        ),
        title: Text(
          S.logout,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent),
        ),
        content: Text(S.areYouSure),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(S.no),
          ),
          TextButton(
            onPressed: () async {
              await provider.logout();
              if (context.mounted) Navigator.pushReplacementNamed(context, '/login');
            },
            child: Text(
              S.yes,
              style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}