import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/src/presentation/report/cubit/report_cubit.dart';
import 'package:app/src/presentation/report/widgets/report_view.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReportCubit()..fetchReport(),
      child: const ReportView(),
    );
  }
}
