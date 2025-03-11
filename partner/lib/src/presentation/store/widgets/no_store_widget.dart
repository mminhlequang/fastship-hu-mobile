import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/store_cubit.dart';

class NoStoreWidget extends StatelessWidget {
  const NoStoreWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: Colors.grey.shade300,
                style: BorderStyle.solid,
              ),
            ),
            child: const Icon(
              Icons.store,
              color: Colors.grey,
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Title here',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Text here',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              context.read<StoreCubit>().createNewStore();
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.green,
              backgroundColor: Colors.white,
              side: const BorderSide(color: Colors.green),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text('Create New Shop'),
          ),
        ],
      ),
    );
  }
}
