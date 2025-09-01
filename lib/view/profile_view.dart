import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/base/base_singleton.dart';
import '../core/base/size_singleton.dart';
import '../core/extension/context_extension.dart';
import '../viewModel/auth_view_model.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView>
    with BaseSingleton, SizeSingleton {
  late AuthViewModel authViewModel;

  @override
  void initState() {
    super.initState();
    authViewModel = Provider.of<AuthViewModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, value, _) {
        return Scaffold(
          backgroundColor: Colors.grey[50],
          body: Container(
            margin: const EdgeInsets.all(20),
            child: ListView(
              children: [
                const SizedBox(height: 20),
                // Profile Avatar with subtle styling
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: .1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        value.gender == "Erkek" ? imgCons.male : imgCons.female,
                        height: sizeConfig.widthSize(context, 110),
                        width: sizeConfig.widthSize(context, 110),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  value.userName ?? '',
                  style: context.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  value.department ?? '',
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                // Info cards with clean design
                _buildCleanInfoCard(
                  context,
                  strCons.phone,
                  value.phone,
                  Icons.phone_outlined,
                ),
                const SizedBox(height: 16),
                _buildCleanInfoCard(
                  context,
                  strCons.email,
                  value.email,
                  Icons.email_outlined,
                ),
                const SizedBox(height: 16),
                _buildCleanInfoCard(
                  context,
                  strCons.gender,
                  value.gender,
                  Icons.person_outline,
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCleanInfoCard(
    BuildContext context,
    String title,
    String? description,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .09),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.grey[600], size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description ?? '',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
