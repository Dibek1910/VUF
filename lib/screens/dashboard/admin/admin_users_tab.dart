import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vishv_umiyadham_foundation/providers/admin_provider.dart';
import 'package:vishv_umiyadham_foundation/utils/app_theme.dart';

class AdminUsersTab extends StatelessWidget {
  const AdminUsersTab({super.key});

  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context);

    return RefreshIndicator(
      onRefresh: () async {
        await adminProvider.fetchAllUsers();
      },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'User Management',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${adminProvider.allUsers.length} Users',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textLightColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: DefaultTabController(
                length: 4,
                child: Column(
                  children: [
                    const TabBar(
                      tabs: [
                        Tab(text: 'All Users'),
                        Tab(text: 'Admins'),
                        Tab(text: 'Captains'),
                        Tab(text: 'Players'),
                      ],
                      labelColor: AppTheme.primaryColor,
                      unselectedLabelColor: AppTheme.textLightColor,
                      indicatorColor: AppTheme.primaryColor,
                      isScrollable: true,
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: TabBarView(
                        children: [
                          _buildUsersList(adminProvider, null),
                          _buildUsersList(adminProvider, 'Admin'),
                          _buildUsersList(adminProvider, 'Captain'),
                          _buildUsersList(adminProvider, 'Player'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsersList(AdminProvider adminProvider, String? role) {
    if (adminProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    List<dynamic> filteredUsers = adminProvider.allUsers;
    if (role != null) {
      filteredUsers =
          adminProvider.allUsers.where((user) => user['role'] == role).toList();
    }

    if (filteredUsers.isEmpty) {
      return _buildEmptyUsersState(role);
    }

    return ListView.builder(
      itemCount: filteredUsers.length,
      itemBuilder: (context, index) {
        final user = filteredUsers[index];
        return _buildUserCard(context, user, adminProvider);
      },
    );
  }

  Widget _buildEmptyUsersState(String? role) {
    String message =
        role == null ? 'No users found' : 'No ${role.toLowerCase()}s found';

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(
              fontSize: 18,
              color: AppTheme.textLightColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard(
      BuildContext context, dynamic user, AdminProvider adminProvider) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: _getRoleColor(user['role']),
                  radius: 24,
                  child: Text(
                    user['name'][0].toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user['name'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user['email'],
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.textLightColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getRoleColor(user['role']).withAlpha(25),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        user['role'],
                        style: TextStyle(
                          fontSize: 12,
                          color: _getRoleColor(user['role']),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (user['role'] != 'Admin')
                      PopupMenuButton<String>(
                        onSelected: (value) async {
                          if (value == 'delete') {
                            _showDeleteUserDialog(context, user, adminProvider);
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete, color: Colors.red),
                                SizedBox(width: 8),
                                Text('Delete User'),
                              ],
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildUserDetailItem('Phone', user['phone'] ?? 'N/A'),
                ),
                Expanded(
                  child: _buildUserDetailItem(
                      'Unique ID', user['uniqueId'] ?? 'N/A'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildUserDetailItem(
                      'Status', user['isApproved'] ? 'Approved' : 'Pending'),
                ),
                Expanded(
                  child: _buildUserDetailItem(
                      'Joined', _formatDate(user['createdAt'])),
                ),
              ],
            ),
            if (!user['isApproved'] && user['role'] != 'Admin') ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withAlpha(25),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.withAlpha(77)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.warning, color: Colors.orange, size: 16),
                    SizedBox(width: 8),
                    Text(
                      'This user is pending approval',
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildUserDetailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.textLightColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'Admin':
        return Colors.red;
      case 'Captain':
        return Colors.blue;
      case 'Player':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  void _showDeleteUserDialog(
      BuildContext context, dynamic user, AdminProvider adminProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete User'),
        content: Text(
            'Are you sure you want to delete "${user['name']}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final success = await adminProvider.deleteUser(user['_id']);
              if (success && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('User deleted successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return 'N/A';
    }
  }
}
