import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _birthdateController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;
  DateTime? _selectedBirthdate;

  String _selectedGender = 'Laki-laki';
  String _selectedFitnessGoal = 'Bulking';
  String _selectedActivityLevel = 'Tidak Aktif';
  String _selectedExperienceLevel = 'Pemula';

  final List<String> _genders = ['Laki-laki', 'Perempuan'];
  final List<String> _fitnessGoals = [
    'Bulking',
    'Cutting',
    'Perkuat Otot',
  ];
  final List<String> _activityLevels = [
    'Tidak Aktif',
    'Ringan',
    'Sedang',
    'Sangat Aktif',
    'Ekstrim',
  ];
  final List<String> _experienceLevels = [
    'Pemula',
    'Menengah',
    'Lanjutan',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _birthdateController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _selectBirthdate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 13)),
    );

    if (picked != null) {
      setState(() {
        _selectedBirthdate = picked;
        _birthdateController.text =
            '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      });
    }
  }

  Future<void> _saveUserData() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Create user account with Firebase Auth
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );

      // Save additional user data to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_name', _nameController.text.trim());
      await prefs.setString('user_email', _emailController.text.trim());
      await prefs.setString('user_birthdate', _birthdateController.text);
      await prefs.setDouble(
        'user_height',
        double.parse(_heightController.text),
      );
      await prefs.setDouble(
        'user_weight',
        double.parse(_weightController.text),
      );
      await prefs.setString('fitness_goal', _selectedFitnessGoal);
      await prefs.setString('activity_level', _selectedActivityLevel);
      await prefs.setString('user_gender', _selectedGender);
      await prefs.setString('experience_level', _selectedExperienceLevel);

      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = _getErrorMessage(e.code);
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Terjadi kesalahan. Silakan coba lagi.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _getErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'email-already-in-use':
        return 'Email sudah terdaftar.';
      case 'invalid-email':
        return 'Format email tidak valid.';
      case 'weak-password':
        return 'Password terlalu lemah.';
      case 'operation-not-allowed':
        return 'Pendaftaran akun dinonaktifkan.';
      default:
        return 'Pendaftaran gagal. Silakan coba lagi.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                const Text(
                  'Selamat Datang!',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A6FFF),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Mari mulai perjalanan fitness Anda dengan mengisi data berikut',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 32),

                // Error Message
                if (_errorMessage != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.red.shade700),
                    ),
                  ),

                if (_errorMessage != null) const SizedBox(height: 16),

                // Basic Information
                _buildSectionHeader('Informasi Dasar'),
                const SizedBox(height: 16),

                // Name
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Lengkap',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Email
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email tidak boleh kosong';
                    }
                    if (!value.contains('@')) {
                      return 'Email tidak valid';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Password
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password tidak boleh kosong';
                    }
                    if (value.length < 6) {
                      return 'Password minimal 6 karakter';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Birthdate
                TextFormField(
                  controller: _birthdateController,
                  decoration: const InputDecoration(
                    labelText: 'Tanggal Lahir',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
                    hintText: 'DD/MM/YYYY',
                  ),
                  readOnly: true,
                  onTap: _selectBirthdate,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tanggal lahir tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Gender
                DropdownButtonFormField<String>(
                  value: _selectedGender,
                  decoration: const InputDecoration(
                    labelText: 'Jenis Kelamin',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.people),
                  ),
                  items: _genders.map((gender) {
                    return DropdownMenuItem(value: gender, child: Text(gender));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value!;
                    });
                  },
                ),
                const SizedBox(height: 32),

                // Physical Information
                _buildSectionHeader('Informasi Fisik'),
                const SizedBox(height: 16),

                // Height
                TextFormField(
                  controller: _heightController,
                  decoration: const InputDecoration(
                    labelText: 'Tinggi Badan (cm)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.height),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tinggi badan tidak boleh kosong';
                    }
                    final height = double.tryParse(value);
                    if (height == null || height < 100 || height > 250) {
                      return 'Tinggi badan harus antara 100-250 cm';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Weight
                TextFormField(
                  controller: _weightController,
                  decoration: const InputDecoration(
                    labelText: 'Berat Badan (kg)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.monitor_weight),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Berat badan tidak boleh kosong';
                    }
                    final weight = double.tryParse(value);
                    if (weight == null || weight < 30 || weight > 200) {
                      return 'Berat badan harus antara 30-200 kg';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                // Fitness Goals
                _buildSectionHeader('Tujuan & Preferensi'),
                const SizedBox(height: 16),

                // Fitness Goal
                DropdownButtonFormField<String>(
                  value: _selectedFitnessGoal,
                  decoration: const InputDecoration(
                    labelText: 'Tujuan Fitness',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.flag),
                  ),
                  items: _fitnessGoals.map((goal) {
                    return DropdownMenuItem(value: goal, child: Text(goal));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedFitnessGoal = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Activity Level
                DropdownButtonFormField<String>(
                  value: _selectedActivityLevel,
                  decoration: const InputDecoration(
                    labelText: 'Tingkat Aktivitas',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.directions_run),
                  ),
                  items: _activityLevels.map((level) {
                    return DropdownMenuItem(value: level, child: Text(level));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedActivityLevel = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Experience Level
                DropdownButtonFormField<String>(
                  value: _selectedExperienceLevel,
                  decoration: const InputDecoration(
                    labelText: 'Tingkat Pengalaman',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.school),
                  ),
                  items: _experienceLevels.map((level) {
                    return DropdownMenuItem(value: level, child: Text(level));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedExperienceLevel = value!;
                    });
                  },
                ),
                const SizedBox(height: 40),

                // Register Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveUserData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A6FFF),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 2,
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Mulai Perjalanan Fitness',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 24),

                // Login Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Sudah punya akun?'),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/login');
                      },
                      child: const Text('Masuk'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Color(0xFF4A6FFF),
      ),
    );
  }
}
