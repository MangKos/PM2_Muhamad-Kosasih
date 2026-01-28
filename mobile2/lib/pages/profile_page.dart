// lib/pages/profile_page.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback? onThemeToggle;

  const ProfilePage({super.key, this.isDarkMode = false, this.onThemeToggle});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _notificationsEnabled = true;

  // User profile data - loaded from SharedPreferences
  late String _userName;
  late String _userEmail;
  late int _userAge;
  late String _userBirthdate;
  late double _userHeight;
  late double _userWeight;
  late String _fitnessGoal;
  late String _activityLevel;
  late String _userGender;
  late String _experienceLevel;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  int _calculateAge(String birthdateStr) {
    try {
      final parts = birthdateStr.split('/');
      if (parts.length != 3) return 0;
      
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      
      final birthdate = DateTime(year, month, day);
      final today = DateTime.now();
      
      int age = today.year - birthdate.year;
      if (today.month < birthdate.month ||
          (today.month == birthdate.month && today.day < birthdate.day)) {
        age--;
      }
      return age;
    } catch (e) {
      return 0;
    }
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('user_name') ?? 'admin';
      _userEmail = prefs.getString('user_email') ?? 'admin@gmail.com';
      _userBirthdate = prefs.getString('user_birthdate') ?? '01/01/2000';
      _userAge = _calculateAge(_userBirthdate);
      _userHeight = prefs.getDouble('user_height') ?? 165.0;
      _userWeight = prefs.getDouble('user_weight') ?? 60.0;
      _fitnessGoal = prefs.getString('fitness_goal') ?? 'Bulking';
      _activityLevel = prefs.getString('activity_level') ?? 'Sedang';
      _userGender = prefs.getString('user_gender') ?? 'Perempuan';
      _experienceLevel = prefs.getString('experience_level') ?? 'Pemula';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                const Text(
                  'Profil',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),

                // User Info Card
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F7),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: const Color(0xFF4A6FFF),
                          borderRadius: BorderRadius.circular(35),
                        ),
                        child: const Center(
                          child: Text(
                            'C',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _userName,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _userEmail,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF4A6FFF).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'Akun Gratis',
                                style: TextStyle(
                                  color: Color(0xFF4A6FFF),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Profile Details Section
                _buildProfileDetailsSection(),
                const SizedBox(height: 24),

                // Menu Options
                _buildMenuSection(),
                const SizedBox(height: 24),

                // Laporan & Informasi Section
                _buildReportAndFoodSection(),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget untuk Profile Details
  Widget _buildProfileDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Informasi Fisik & Tujuan',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 12),

        // Umur
        Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F7),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF4A6FFF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.cake_outlined,
                  color: Color(0xFF4A6FFF),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Umur',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      '$_userAge tahun',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Tinggi Badan
        Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F7),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF4A6FFF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.height,
                  color: Color(0xFF4A6FFF),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tinggi Badan',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      '${_userHeight.toStringAsFixed(0)} cm',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Berat Badan
        Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F7),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF4A6FFF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.monitor_weight_outlined,
                  color: Color(0xFF4A6FFF),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Berat Badan',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      '${_userWeight.toStringAsFixed(1)} kg',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Tujuan Fitness
        Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F7),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF4A6FFF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.flag_outlined,
                  color: Color(0xFF4A6FFF),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tujuan Fitness',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      _fitnessGoal,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Tingkat Aktivitas
        Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F7),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF4A6FFF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.directions_run_outlined,
                  color: Color(0xFF4A6FFF),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tingkat Aktivitas',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      _activityLevel,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Tingkat Pengalaman
        Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F7),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF4A6FFF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.school_outlined,
                  color: Color(0xFF4A6FFF),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tingkat Pengalaman',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      _experienceLevel,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Widget untuk Menu Options
  Widget _buildMenuSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Pengaturan', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),

        // Edit Profile
        _buildMenuItem(
          icon: Icons.person_outline,
          title: 'Edit Profil',
          onTap: () {
            _showEditProfileDialog();
          },
        ),

        // Notifications
        _buildMenuItem(
          icon: Icons.notifications_outlined,
          title: 'Notifikasi',
          trailing: Switch(
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
            activeThumbColor: const Color(0xFF4A6FFF),
          ),
        ),

        // Security
        _buildMenuItem(
          icon: Icons.security_outlined,
          title: 'Keamanan',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Keamanan coming soon!')),
            );
          },
        ),

        // Help
        _buildMenuItem(
          icon: Icons.help_outline,
          title: 'Bantuan',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Bantuan coming soon!')),
            );
          },
        ),

        // Dark Theme
        _buildMenuItem(
          icon: Icons.dark_mode_outlined,
          title: 'Tema Gelap',
          trailing: Switch(
            value: widget.isDarkMode,
            onChanged: widget.onThemeToggle != null
                ? (value) => widget.onThemeToggle!()
                : null,
            activeThumbColor: const Color(0xFF4A6FFF),
          ),
        ),

        // Logout
        _buildMenuItem(
          icon: Icons.logout_outlined,
          title: 'Keluar',
          titleColor: Colors.red,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Logout coming soon!')),
            );
          },
        ),
      ],
    );
  }

  // Widget untuk Laporan & Informasi Makanan
  Widget _buildReportAndFoodSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Laporan & Informasi',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 12),

        // Laporan
        _buildMenuItem(
          icon: Icons.analytics_outlined,
          title: 'Laporan Mingguan',
          onTap: () {
            _showWeeklyReport();
          },
        ),

        // Informasi Makanan
        _buildMenuItem(
          icon: Icons.restaurant_outlined,
          title: 'Informasi Makanan',
          onTap: () {
            _showFoodInformation();
          },
        ),
      ],
    );
  }

  // Widget untuk Menu Item
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    Color titleColor = Colors.black,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 0),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFF4A6FFF).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFF4A6FFF), size: 20),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: titleColor,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing:
            trailing ??
            Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
        onTap: onTap,
      ),
    );
  }

  // Function untuk menampilkan Laporan Mingguan
  void _showWeeklyReport() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: ListView(
                controller: scrollController,
                children: [
                  const Text(
                    'Laporan Mingguan',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  // Report items in responsive container
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        _buildReportItem('Total Latihan', '12 sesi', Icons.fitness_center),
                        const Divider(height: 16),
                        _buildReportItem('Durasi Total', '4 jam 30 menit', Icons.schedule),
                        const Divider(height: 16),
                        _buildReportItem('Kalori Terbakar', '1,850 Cal', Icons.local_fire_department),
                        const Divider(height: 16),
                        _buildReportItem('Rata-rata BPM', '72 bpm', Icons.favorite),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Pencapaian:',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildAchievementChip('🔥 5 Hari Berturut-turut'),
                      _buildAchievementChip('🏆 Latihan Terlama: 45 menit'),
                      _buildAchievementChip('💪 10 Latihan Baru Dicoba'),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4A6FFF),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Tutup'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildReportItem(String title, String value, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF4A6FFF).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFF4A6FFF), size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAchievementChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF4A6FFF).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF4A6FFF),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // Function untuk menghitung kebutuhan nutrisi berdasarkan tujuan fitness
  Map<String, dynamic> _calculateNutritionNeeds() {
    double protein;
    double calories;
    String description;

    // Perhitungan berdasarkan berat badan dan tujuan fitness
    if (_fitnessGoal == 'Bulking') {
      // Untuk bulking: protein 1.6-2.2g per kg, kalori surplus 300-500
      protein = _userWeight * 2.0; // gram
      calories = (_userWeight * 30) + 500; // surplus kalori
      description =
          'Kebutuhan kalori surplus untuk pertumbuhan otot. Fokus pada makanan bernutrisi tinggi.';
    } else if (_fitnessGoal == 'Cutting') {
      // Untuk cutting: protein 1.6-2.2g per kg, kalori deficit 300-500
      protein = _userWeight * 2.0; // gram
      calories = (_userWeight * 25) - 400; // deficit kalori
      description =
          'Kebutuhan kalori deficit untuk pembakaran lemak. Prioritaskan protein tinggi.';
    } else {
      // Perkuat Otot: protein 1.8-2.2g per kg, kalori maintenance
      protein = _userWeight * 2.1; // gram
      calories = _userWeight * 28; // maintenance
      description =
          'Kebutuhan kalori seimbang untuk memperkuat otot. Asupan protein konsisten penting.';
    }

    return {
      'protein': protein.toStringAsFixed(0),
      'calories': calories.toStringAsFixed(0),
      'description': description,
    };
  }

  // Function untuk menampilkan Informasi Makanan
  void _showFoodInformation() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            String selectedCategory = _fitnessGoal;
            final nutritionNeeds = _calculateNutritionNeeds();

            final categories = ['Bulking', 'Cutting', 'Perkuat Otot'];

            // Function untuk menghitung nutrisi berdasarkan kategori yang dipilih
            Map<String, dynamic> getNutritionForCategory(String category) {
              double protein;
              double calories;
              String description;

              if (category == 'Bulking') {
                protein = _userWeight * 2.0;
                calories = (_userWeight * 30) + 500;
                description =
                    'Kebutuhan kalori surplus untuk pertumbuhan otot. Fokus pada makanan bernutrisi tinggi.';
              } else if (category == 'Cutting') {
                protein = _userWeight * 2.0;
                calories = (_userWeight * 25) - 400;
                description =
                    'Kebutuhan kalori deficit untuk pembakaran lemak. Prioritaskan protein tinggi.';
              } else {
                protein = _userWeight * 2.1;
                calories = _userWeight * 28;
                description =
                    'Kebutuhan kalori seimbang untuk memperkuat otot. Asupan protein konsisten penting.';
              }

              return {
                'protein': protein.toStringAsFixed(0),
                'calories': calories.toStringAsFixed(0),
                'description': description,
              };
            }

            final foodRecommendations = {
              'Bulking': [
                _FoodItem(
                  name: 'Dada Ayam',
                  protein: '31g',
                  calories: '165',
                  description: 'Sumber protein lean terbaik',
                ),
                _FoodItem(
                  name: 'Nasi Merah',
                  protein: '5g',
                  calories: '215',
                  description: 'Karbohidrat kompleks',
                ),
                _FoodItem(
                  name: 'Alpukat',
                  protein: '2g',
                  calories: '160',
                  description: 'Lemak sehat & serat',
                ),
                _FoodItem(
                  name: 'Telur Utuh',
                  protein: '13g',
                  calories: '155',
                  description: 'Protein lengkap & kolin',
                ),
                _FoodItem(
                  name: 'Kacang Almond',
                  protein: '21g',
                  calories: '575',
                  description: 'Lemak sehat & vitamin E',
                ),
              ],
              'Cutting': [
                _FoodItem(
                  name: 'Ikan Salmon',
                  protein: '25g',
                  calories: '206',
                  description: 'Omega-3 & protein',
                ),
                _FoodItem(
                  name: 'Brokoli',
                  protein: '2.8g',
                  calories: '34',
                  description: 'Serat tinggi & antioksidan',
                ),
                _FoodItem(
                  name: 'Greek Yogurt',
                  protein: '10g',
                  calories: '59',
                  description: 'Probiotik & protein',
                ),
                _FoodItem(
                  name: 'Tahu',
                  protein: '8g',
                  calories: '76',
                  description: 'Protein nabati rendah kalori',
                ),
                _FoodItem(
                  name: 'Bayam',
                  protein: '2.9g',
                  calories: '23',
                  description: 'Zat besi & vitamin K',
                ),
              ],
              'Perkuat Otot': [
                _FoodItem(
                  name: 'Daging Sapi Lean',
                  protein: '26g',
                  calories: '250',
                  description: 'Kreatin & zat besi',
                ),
                _FoodItem(
                  name: 'Whey Protein',
                  protein: '24g',
                  calories: '120',
                  description: 'Protein cepat serap',
                ),
                _FoodItem(
                  name: 'Ubi Jalar',
                  protein: '2g',
                  calories: '86',
                  description: 'Beta-karoten & karbohidrat',
                ),
                _FoodItem(
                  name: 'Kacang Mete',
                  protein: '18g',
                  calories: '553',
                  description: 'Magnesium & zinc',
                ),
                _FoodItem(
                  name: 'Susu Skim',
                  protein: '8g',
                  calories: '83',
                  description: 'Kalsium & vitamin D',
                ),
              ],
            };

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Informasi Makanan Sehat',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Rekomendasi makanan berdasarkan tujuan fitness Anda',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 16),

                  // Nutrition Needs Section
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4A6FFF).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF4A6FFF).withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.info_outlined,
                              color: Color(0xFF4A6FFF),
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Kebutuhan Harian (${_fitnessGoal})',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF4A6FFF),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  const Text(
                                    'Protein',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${nutritionNeeds['protein']} g',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF4A6FFF),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  const Text(
                                    'Kalori',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${nutritionNeeds['calories']} kkal',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF4A6FFF),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          nutritionNeeds['description'],
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Category Filter Section
                  const Text(
                    'Pilih Kategori:',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: categories.map((category) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(category),
                            selected: selectedCategory == category,
                            selectedColor: const Color(0xFF4A6FFF),
                            checkmarkColor: Colors.white,
                            onSelected: (selected) {
                              setState(() {
                                selectedCategory = category;
                              });
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Food Recommendations - Using Expanded
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: foodRecommendations[selectedCategory]!.length,
                      itemBuilder: (context, index) {
                        final food =
                            foodRecommendations[selectedCategory]![index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.grey[200]!,
                              width: 1,
                            ),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(12),
                            leading: Container(
                              width: 45,
                              height: 45,
                              decoration: BoxDecoration(
                                color: const Color(0xFF4A6FFF).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.restaurant,
                                color: const Color(0xFF4A6FFF),
                                size: 20,
                              ),
                            ),
                            title: Text(
                              food.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Wrap(
                                  spacing: 6,
                                  runSpacing: 4,
                                  children: [
                                    _buildNutritionChip(
                                      'Protein: ${food.protein}',
                                    ),
                                    _buildNutritionChip(
                                      'Kalori: ${food.calories}',
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  food.description,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 11,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                            trailing: SizedBox(
                              width: 36,
                              height: 36,
                              child: IconButton(
                                icon: const Icon(Icons.info_outline),
                                color: const Color(0xFF4A6FFF),
                                iconSize: 18,
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  _showFoodDetail(food, selectedCategory);
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4A6FFF),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Tutup'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildNutritionChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF4A6FFF).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF4A6FFF),
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _showFoodDetail(_FoodItem food, String category) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(food.name),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Kategori: $category'),
              const SizedBox(height: 8),
              Text('Protein: ${food.protein} per 100g'),
              Text('Kalori: ${food.calories} per 100g'),
              const SizedBox(height: 8),
              Text(
                'Deskripsi: ${food.description}',
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),
              const Text(
                'Tips Konsumsi:',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                _getConsumptionTips(category, food.name),
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  String _getConsumptionTips(String category, String foodName) {
    if (category == 'Bulking') {
      return 'Konsumsi 2-3 jam setelah latihan berat. Kombinasikan dengan karbohidrat kompleks untuk pemulihan optimal.';
    } else if (category == 'Cutting') {
      return 'Konsumsi dalam porsi kecil 4-5 kali sehari. Fokus pada protein tinggi dan kalori terkontrol.';
    } else {
      return 'Konsumsi 30-60 menit setelah latihan untuk mendukung sintesis protein dan pertumbuhan otot.';
    }
  }

  // Function untuk menampilkan dialog Edit Profil
  void _showEditProfileDialog() {
    // Temporary variables for editing
    String tempName = _userName;
    String tempEmail = _userEmail;
    String tempBirthdate = _userBirthdate;
    DateTime? tempSelectedBirthdate;
    double tempHeight = _userHeight;
    double tempWeight = _userWeight;
    String tempFitnessGoal = _fitnessGoal;
    String tempActivityLevel = _activityLevel;
    String tempGender = _userGender;
    String tempExperienceLevel = _experienceLevel;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            Future<void> selectBirthdate() async {
              final picked = await showDatePicker(
                context: context,
                initialDate: DateTime(2000),
                firstDate: DateTime(1950),
                lastDate: DateTime.now().subtract(const Duration(days: 365 * 13)),
              );

              if (picked != null) {
                setState(() {
                  tempSelectedBirthdate = picked;
                  tempBirthdate =
                      '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
                });
              }
            }

            return AlertDialog(
              title: const Text('Edit Profil'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Name
                    TextField(
                      decoration: const InputDecoration(labelText: 'Nama'),
                      controller: TextEditingController(text: tempName),
                      onChanged: (value) => tempName = value,
                    ),
                    const SizedBox(height: 16),

                    // Email
                    TextField(
                      decoration: const InputDecoration(labelText: 'Email'),
                      controller: TextEditingController(text: tempEmail),
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) => tempEmail = value,
                    ),
                    const SizedBox(height: 16),

                    // Birthdate
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Tanggal Lahir',
                        hintText: 'DD/MM/YYYY',
                      ),
                      controller: TextEditingController(text: tempBirthdate),
                      readOnly: true,
                      onTap: selectBirthdate,
                    ),
                    const SizedBox(height: 16),

                    // Height
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Tinggi (cm)',
                      ),
                      controller: TextEditingController(
                        text: tempHeight.toString(),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) =>
                          tempHeight = double.tryParse(value) ?? tempHeight,
                    ),
                    const SizedBox(height: 16),

                    // Weight
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Berat (kg)',
                      ),
                      controller: TextEditingController(
                        text: tempWeight.toString(),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) =>
                          tempWeight = double.tryParse(value) ?? tempWeight,
                    ),
                    const SizedBox(height: 16),

                    // Gender
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Jenis Kelamin',
                      ),
                      value: tempGender,
                      items: ['Laki-laki', 'Perempuan'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) => setState(() => tempGender = value!),
                    ),
                    const SizedBox(height: 16),

                    // Fitness Goal
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Tujuan Fitness',
                      ),
                      value: tempFitnessGoal,
                      items: ['Bulking', 'Cutting', 'Perkuat Otot']
                          .map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          })
                          .toList(),
                      onChanged: (value) =>
                          setState(() => tempFitnessGoal = value!),
                    ),
                    const SizedBox(height: 16),

                    // Activity Level
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Tingkat Aktivitas',
                      ),
                      value: tempActivityLevel,
                      items:
                          [
                            'Tidak Aktif',
                            'Ringan',
                            'Sedang',
                            'Sangat Aktif',
                            'Ekstrim',
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                      onChanged: (value) =>
                          setState(() => tempActivityLevel = value!),
                    ),
                    const SizedBox(height: 16),

                    // Experience Level
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Tingkat Pengalaman',
                      ),
                      value: tempExperienceLevel,
                      items: ['Pemula', 'Menengah', 'Lanjutan'].map((
                        String value,
                      ) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) =>
                          setState(() => tempExperienceLevel = value!),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    // Auto-save to SharedPreferences
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setString('user_name', tempName);
                    await prefs.setString('user_email', tempEmail);
                    await prefs.setString('user_birthdate', tempBirthdate);
                    await prefs.setDouble('user_height', tempHeight);
                    await prefs.setDouble('user_weight', tempWeight);
                    await prefs.setString('fitness_goal', tempFitnessGoal);
                    await prefs.setString('activity_level', tempActivityLevel);
                    await prefs.setString('user_gender', tempGender);
                    await prefs.setString(
                      'experience_level',
                      tempExperienceLevel,
                    );

                    // Update state
                    setState(() {
                      _userName = tempName;
                      _userEmail = tempEmail;
                      _userBirthdate = tempBirthdate;
                      _userAge = _calculateAge(tempBirthdate);
                      _userHeight = tempHeight;
                      _userWeight = tempWeight;
                      _fitnessGoal = tempFitnessGoal;
                      _activityLevel = tempActivityLevel;
                      _userGender = tempGender;
                      _experienceLevel = tempExperienceLevel;
                    });

                    Navigator.of(context).pop();

                    // Show success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Profil berhasil diperbarui!'),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A6FFF),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

// Model untuk Food Item
class _FoodItem {
  final String name;
  final String protein;
  final String calories;
  final String description;

  const _FoodItem({
    required this.name,
    required this.protein,
    required this.calories,
    required this.description,
  });
}
