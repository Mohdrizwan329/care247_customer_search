import 'package:flutter/material.dart';

import '../models/address.dart';
import '../models/customer.dart';
import '../models/email.dart';
import '../models/phone.dart';
import '../theme/app_theme.dart';

class CustomerDetailScreen extends StatelessWidget {
  final Customer customer;

  const CustomerDetailScreen({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(customer.fullName),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.primary, Color(0xFF7C3AED)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primary.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white30, width: 2),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    _initials(customer),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 22,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        customer.fullName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          customer.maritalStatus,
                          style: const TextStyle(
                            color: Colors.white,
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
          const SizedBox(height: 16),
          _SectionCard(
            title: 'Basic Information',
            icon: Icons.person_rounded,
            accentColor: AppTheme.primary,
            children: [
              _InfoRow(label: 'First Name', value: customer.firstName),
              _InfoRow(label: 'Last Name', value: customer.lastName),
              _InfoRow(label: 'Date of Birth', value: customer.dateOfBirth),
              _InfoRow(label: 'Marital Status', value: customer.maritalStatus),
              _InfoRow(label: 'Secure ID', value: customer.secureId),
            ],
          ),
          const SizedBox(height: 12),
          _SectionCard(
            title: 'Addresses',
            icon: Icons.location_on_rounded,
            accentColor: AppTheme.secondary,
            children: customer.addresses.isEmpty
                ? [
                    Text('No addresses on file',
                        style: TextStyle(color: Colors.grey.shade500))
                  ]
                : customer.addresses
                    .map((a) => _AddressTile(address: a))
                    .toList(),
          ),
          const SizedBox(height: 12),
          _SectionCard(
            title: 'Phone Numbers',
            icon: Icons.phone_rounded,
            accentColor: AppTheme.tertiary,
            children: customer.phones.isEmpty
                ? [
                    Text('No phone numbers on file',
                        style: TextStyle(color: Colors.grey.shade500))
                  ]
                : customer.phones.map((p) => _PhoneTile(phone: p)).toList(),
          ),
          const SizedBox(height: 12),
          _SectionCard(
            title: 'Email Addresses',
            icon: Icons.email_rounded,
            accentColor: AppTheme.accent,
            children: customer.emails.isEmpty
                ? [
                    Text('No email addresses on file',
                        style: TextStyle(color: Colors.grey.shade500))
                  ]
                : customer.emails.map((e) => _EmailTile(email: e)).toList(),
          ),
        ],
      ),
    );
  }

  String _initials(Customer c) {
    final f = c.firstName.isNotEmpty ? c.firstName[0] : '';
    final l = c.lastName.isNotEmpty ? c.lastName[0] : '';
    return ('$f$l').toUpperCase();
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color accentColor;
  final List<Widget> children;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.accentColor,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: accentColor, size: 20),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: Color(0xFF1E1B4B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(height: 1, color: Colors.grey.shade100),
          const SizedBox(height: 4),
          ...children,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? '—' : value,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Color(0xFF1E1B4B),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddressTile extends StatelessWidget {
  final Address address;

  const _AddressTile({required this.address});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: AppTheme.secondary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              address.type,
              style: const TextStyle(
                color: AppTheme.secondary,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(address.street,
              style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Color(0xFF1E1B4B))),
          Text(
            '${address.city}, ${address.state} ${address.zipCode}',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _PhoneTile extends StatelessWidget {
  final Phone phone;

  const _PhoneTile({required this.phone});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 4),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  phone.type,
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  phone.number,
                  style: TextStyle(
                    fontWeight:
                        phone.isPrimary ? FontWeight.w700 : FontWeight.w500,
                    color: phone.isPrimary
                        ? AppTheme.primary
                        : const Color(0xFF1E1B4B),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          if (phone.isPrimary)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Primary',
                style: TextStyle(
                  color: AppTheme.primary,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _EmailTile extends StatelessWidget {
  final Email email;

  const _EmailTile({required this.email});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 4),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  email.type,
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  email.address,
                  style: TextStyle(
                    fontWeight:
                        email.isPrimary ? FontWeight.w700 : FontWeight.w500,
                    color: email.isPrimary
                        ? AppTheme.secondary
                        : const Color(0xFF1E1B4B),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          if (email.isPrimary)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: AppTheme.secondary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Primary',
                style: TextStyle(
                  color: AppTheme.secondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
