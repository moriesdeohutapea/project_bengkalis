import 'package:flutter/material.dart';

import '../component/component.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomText(
          text: 'Profile',
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        backgroundColor: Colors.blue,
      ),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileHeader(),
              SizedBox(height: 24),
              AccountInformation(),
              SizedBox(height: 24),
              ProfileActions(),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/profile_picture.png'),
          ),
          SizedBox(height: 12),
          CustomText(
            text: 'John Doe',
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
          ),
          SizedBox(height: 4),
          CustomText(
            text: 'johndoe@example.com',
            fontSize: 16.0,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}

class AccountInformation extends StatelessWidget {
  const AccountInformation({super.key});

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            text: title,
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
          ),
          CustomText(
            text: value,
            fontSize: 16.0,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomText(
          text: 'Account Information',
          fontSize: 18.0,
          fontWeight: FontWeight.w600,
        ),
        const SizedBox(height: 12),
        _buildInfoRow('Username', 'john_doe'),
        _buildInfoRow('Phone', '+1 234 567 890'),
        _buildInfoRow('Address', '123, Main Street, City'),
      ],
    );
  }
}

class ProfileActions extends StatelessWidget {
  const ProfileActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomButton(
          label: 'Edit Profile',
          onPressed: () {
            print('Edit Profile button pressed!');
          },
          backgroundColor: Colors.blueAccent,
          borderRadius: 12.0,
          padding: 16.0,
        ),
        const SizedBox(height: 16),
        CustomButton(
          label: 'Log Out',
          onPressed: () {
            print('Log Out button pressed!');
          },
          backgroundColor: Colors.red,
          borderRadius: 12.0,
          padding: 16.0,
        ),
      ],
    );
  }
}
