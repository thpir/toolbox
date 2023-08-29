import 'package:flutter/material.dart';

import '../../../../models/ruler_measurement.dart';
import '../database_controller.dart';

class DatabaseProvider with ChangeNotifier {
  List<RulerMeasurement> _items = [];

  // Getter to return a COPY of the original _items list.
  List<RulerMeasurement> get items {
    return [..._items];
  }

  // Method to add a measurement to the database and update the list of
  // measurements.
  Future<void> addMeasurement(String measurement, String description) async {
    final newMeasurement = RulerMeasurement(
        id: DateTime.now().toString(),
        value: measurement,
        description: description);
    _items.add(newMeasurement);
    notifyListeners();
    await DatabaseController.insert('ruler_measurements', {
      'id': newMeasurement.id,
      'value': newMeasurement.value,
      'description': newMeasurement.description,
    });
  }

  // Method to edit a measurement from the database and update the list of
  // measurements.
  Future<void> updateMeasurement(
      RulerMeasurement measurement, String description, String id) async {
    final editedMeasurement = RulerMeasurement(
        id: measurement.id,
        value: measurement.value,
        description:
            description // Here we change the current description to the edited description
        );
    var index = _items.indexWhere((measurement) => measurement.id == id);
    _items[index] = editedMeasurement;
    notifyListeners();
    await DatabaseController.update(
      'ruler_measurements',
      id,
      description,
    );
  }

  // Method to delete a measurement from the database and update the list of
  // measurements.
  Future<void> deleteMeasurement(String id) async {
    _items.removeWhere((measurement) => measurement.id == id);
    notifyListeners();
    DatabaseController.delete('ruler_measurements', id);
  }

  // A method to display all the measurements that are saved to the database in
  // a list.
  Future<void> fetchMeasurements() async {
    final measurementsList = await DatabaseController.getData('ruler_measurements');
    _items = measurementsList
        .map((item) => RulerMeasurement(
            id: item['id'],
            value: item['value'],
            description: item['description']))
        .toList();
    notifyListeners();
  }
}
