import 'package:flutter/foundation.dart';
import '../models/service_model.dart';
import '../services/service_service.dart';
class ServiceProvider with ChangeNotifier {
  final ServiceService _serviceService = ServiceService();
  Stream<List<ServiceModel>> getServicesStream() {
    return _serviceService.getServices();
  }
  Future<void> createDummyServices() async {
    await _serviceService.populateTestServices();
  }
}
