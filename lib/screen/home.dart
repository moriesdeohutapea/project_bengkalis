import 'package:flutter/material.dart';

import '../component/component.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderSection(),
              SizedBox(height: 24),
              QuickActionsSection(),
              SizedBox(height: 24),
              RecentActivitiesSection(),
            ],
          ),
        ),
      ),
    );
  }
}

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: 'Welcome Back, User!',
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        SizedBox(height: 8),
        CustomText(
          text: 'Here’s what’s happening today:',
          fontSize: 16.0,
          fontWeight: FontWeight.normal,
          color: Colors.grey,
        ),
      ],
    );
  }
}

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomButton(
          label: 'Check Transactions',
          onPressed: () {
            print('Navigating to Transactions!');
          },
          backgroundColor: Colors.blue,
          borderRadius: 12.0,
          padding: 16.0,
          textStyle: const TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        CustomButton(
          label: 'View Profile',
          onPressed: () {
            print('Navigating to Profile!');
          },
          backgroundColor: Colors.green,
          borderRadius: 12.0,
          padding: 16.0,
          textStyle: const TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class RecentActivitiesSection extends StatelessWidget {
  const RecentActivitiesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(
            text: 'Recent Activities',
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.blueAccent,
                      child: Icon(
                        Icons.receipt_long,
                        color: Colors.white,
                      ),
                    ),
                    title: CustomText(
                      text: 'Transaction #$index',
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                    subtitle: const CustomText(
                      text: 'Completed on Nov 27, 2024',
                      fontSize: 14.0,
                      color: Colors.grey,
                    ),
                    trailing: CustomText(
                      text: '\$${(index + 1) * 20}.00',
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
