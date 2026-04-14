.
Unhandled exception:
FileSystemException: writeFrom failed, path =
'C:\Users\Pc\AppData\Local\Temp\flutter_tools.dfa33845\flutter_tool.74a57009\app.d
ill.sources' (OS Error: There is not enough space on the disk, errno = 112)       
#0      _checkForErrorResponse (dart:io/common.dart:58)
#1      _RandomAccessFile.writeFrom.<anonymous closure>
(dart:io/file_impl.dart:976)
<asynchronous suspension>
#2      _FileStreamConsumer.addStream.<anonymous closure>.<anonymous
closure>.<anonymous closure> (dart:io/file_impl.dart:237)
<asynchronous suspension>
The Dart compiler exited unexpectedly.
Waiting for connection from debug service on Chrome...             33.3s
Failed to compile application.
PS C:\Users\Pc\Desktop\ULTIMO CUATRIMESTRE\Pawtopia> import 'package:flutter/foundation.dart';
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
