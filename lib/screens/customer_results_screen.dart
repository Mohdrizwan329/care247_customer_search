import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/customer.dart';
import '../state/customer_search_state.dart';
import '../theme/app_theme.dart';
import '../widgets/customer_list_item.dart';
import '../widgets/state_widgets.dart';
import 'customer_detail_screen.dart';

class CustomerResultsScreen extends StatelessWidget {
  const CustomerResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Results'),
        actions: [
          Consumer<CustomerSearchState>(
            builder: (context, state, _) {
              if (!state.hasResults) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Center(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${state.customers.length} found',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<CustomerSearchState>(
        builder: (context, state, _) {
          switch (state.status) {
            case SearchStatus.loading:
              return const LoadingState();
            case SearchStatus.empty:
              return EmptyState(
                onRetry: () => Navigator.of(context).pop(),
              );
            case SearchStatus.error:
              return ErrorState(
                message: state.errorMessage ?? 'Unknown error',
                onRetry: () => state.refresh(),
              );
            case SearchStatus.success:
              return RefreshIndicator(
                color: AppTheme.primary,
                onRefresh: () => state.refresh(),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  itemCount: state.customers.length,
                  itemBuilder: (context, index) {
                    final customer = state.customers[index];
                    return CustomerListItem(
                      customer: customer,
                      onTap: () => _openDetail(context, customer),
                    );
                  },
                ),
              );
            case SearchStatus.initial:
              return const EmptyState(
                title: 'No search yet',
                subtitle: 'Go back and enter search criteria',
              );
          }
        },
      ),
    );
  }

  void _openDetail(BuildContext context, Customer customer) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CustomerDetailScreen(customer: customer),
      ),
    );
  }
}
