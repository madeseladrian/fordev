import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/usecases/usecases.dart';

import 'package:fordev/presentation/presenters/presenters.dart';

class LoadCurrentAccountSpy extends Mock implements LoadCurrentAccount {}

void main() {
  late GetxSplashPresenter sut;
  late LoadCurrentAccountSpy loadCurrentAccount;
  late AccountEntity account;

  When mockLoadCall() => when(() => loadCurrentAccount.load());
  void mockLoad({required AccountEntity account}) => 
    mockLoadCall().thenAnswer((_) async => account);
  
  AccountEntity makeAccount() => AccountEntity(token: faker.guid.guid());

  setUp(() {
    account = makeAccount();
    loadCurrentAccount = LoadCurrentAccountSpy();
    mockLoad(account: account);
    sut = GetxSplashPresenter(loadCurrentAccount: loadCurrentAccount);
  });

  setUpAll(() {
    makeAccount();
  });
 
  test('1 - Should call LoadCurrentAccount', () async {
    await sut.checkAccount();
    verify(() => loadCurrentAccount.load()).called(1);
  });

  test('2 - Should go to initial page on success', () async {
    sut.navigateToStream.listen(expectAsync1((page) => expect(page, '/surveys')));

    await sut.checkAccount();
  });
}