import 'package:flutter_test/flutter_test.dart';
import 'package:tv/app/presentation/service_locator/service_locator.dart';

void main() {
  tearDown(() {
    ServiceLocator.instance.clear();
  });
  test('ServiceLocator > put', () {
    expect(
      () {
        ServiceLocator.instance.find<String>();
      },
      throwsAssertionError,
    );

    final name = ServiceLocator.instance.put<String>('Bryan');

    expect(name, ServiceLocator.instance.find<String>());
  });

  test(
    'ServiceLocator > put 2',
    () {
      ServiceLocator.instance.put('Darwin');
      ServiceLocator.instance.put(
        'Santiago',
        tag: 'name2',
      );

      final user = ServiceLocator.instance.put(User('Lulu'));

      final name = ServiceLocator.instance.find<String>(tag: 'name2');

      expect(ServiceLocator.instance.find<User>(), user);
      expect(ServiceLocator.instance.find<String>(), 'Darwin');
      expect(name, 'Santiago');
    },
  );
}

class User {
  final String name;

  User(this.name);
}
