import '../../../core/controllers/session_controller.dart';

class MockAccount {
  const MockAccount({
    required this.id,
    required this.email,
    required this.password,
    required this.displayName,
    required this.role,
  });

  final String id;
  final String email;
  final String password;
  final String displayName;
  final UserRole role;
}

class MockAuthData {
  MockAuthData._();

  static const List<MockAccount> accounts = <MockAccount>[
    // Kiracılar
    MockAccount(
      id: 'renter_1',
      email: 'ahmet@kiralago.com',
      password: 'Password123',
      displayName: 'Ahmet Y.',
      role: UserRole.renter,
    ),
    MockAccount(
      id: 'renter_2',
      email: 'zeynep@kiralago.com',
      password: 'Password123',
      displayName: 'Zeynep K.',
      role: UserRole.renter,
    ),
    MockAccount(
      id: 'renter_3',
      email: 'can@kiralago.com',
      password: 'Password123',
      displayName: 'Can B.',
      role: UserRole.renter,
    ),

    // Araç Sahipleri
    MockAccount(
      id: 'owner_1',
      email: 'mehmet@kiralago.com',
      password: 'Password123',
      displayName: 'Mehmet K.',
      role: UserRole.owner,
    ),
    MockAccount(
      id: 'owner_2',
      email: 'ayse@kiralago.com',
      password: 'Password123',
      displayName: 'Ayşe T.',
      role: UserRole.owner,
    ),
    MockAccount(
      id: 'owner_3',
      email: 'burak@kiralago.com',
      password: 'Password123',
      displayName: 'Burak D.',
      role: UserRole.owner,
    ),
  ];

  static MockAccount? authenticate({
    required String email,
    required String password,
    required UserRole expectedRole,
  }) {
    final String cleanEmail = email.trim().toLowerCase();
    for (final MockAccount acc in accounts) {
      if (acc.email.toLowerCase() == cleanEmail &&
          acc.password == password &&
          acc.role == expectedRole) {
        return acc;
      }
    }
    return null;
  }
}
