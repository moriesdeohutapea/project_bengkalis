import 'package:flutter/material.dart';

import '../../widgets/component.dart';


class TransactionPage extends StatelessWidget {
  const TransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomText(
          text: 'Transactions',
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
              TransactionHeader(),
              SizedBox(height: 16),
              TransactionActions(),
              SizedBox(height: 24),
              Expanded(child: TransactionList()),
            ],
          ),
        ),
      ),
    );
  }
}

class TransactionHeader extends StatelessWidget {
  const TransactionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomText(
      text: 'Your Recent Transactions',
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
      color: Colors.black87,
    );
  }
}

class TransactionActions extends StatelessWidget {
  const TransactionActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomButton(
          label: 'Filter',
          onPressed: () {
            print('Filter button pressed!');
          },
          backgroundColor: Colors.blueAccent,
          borderRadius: 12.0,
          padding: 12.0,
        ),
        CustomButton(
          label: 'Add Transaction',
          onPressed: () {
            print('Add Transaction button pressed!');
          },
          backgroundColor: Colors.green,
          borderRadius: 12.0,
          padding: 12.0,
        ),
      ],
    );
  }
}

class TransactionList extends StatelessWidget {
  const TransactionList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: index % 2 == 0 ? Colors.blue : Colors.orange,
              child: Icon(
                index % 2 == 0 ? Icons.arrow_upward : Icons.arrow_downward,
                color: Colors.white,
              ),
            ),
            title: CustomText(
              text: 'Transaction #${index + 1}',
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
            subtitle: CustomText(
              text: index % 2 == 0 ? 'Sent on Nov 27, 2024' : 'Received on Nov 27, 2024',
              fontSize: 14.0,
              color: Colors.grey,
            ),
            trailing: CustomText(
              text: index % 2 == 0 ? '-\$${(index + 1) * 10}.00' : '+\$${(index + 1) * 10}.00',
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: index % 2 == 0 ? Colors.red : Colors.green,
            ),
          ),
        );
      },
    );
  }
}
