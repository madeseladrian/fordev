import 'package:http/http.dart';

import '../../../infra/http/http.dart';

HttpAdapter makeHttpAdapter() {
  return HttpAdapter(client: Client());
}