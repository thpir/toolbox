import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:localization/localization.dart';

import '../../models/ruler_measurement.dart';
import '../../controllers/storage/databases/database_provider.dart/database_provider.dart';

class RulerMeasurementsListScreen extends StatefulWidget {
  static const routeName = '/ruler-measurement-list-screen';
  const RulerMeasurementsListScreen({super.key});

  @override
  State<RulerMeasurementsListScreen> createState() =>
      _RulerMeasurementsListScreenState();
}

class _RulerMeasurementsListScreenState
    extends State<RulerMeasurementsListScreen> {
  TextEditingController textEditingController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    textEditingController.dispose();
  }

  // Delete an item from the measurements database.
  void _deleteItem(String id) {
    Provider.of<DatabaseProvider>(context, listen: false).deleteMeasurement(id);
  }

  // Edit the label of one of the values in the database.
  void _editItem(RulerMeasurement measurement) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('edit_title'.i18n()),
        content: TextField(
          controller: textEditingController,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: measurement.description,
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: Text('button_text_cancel'.i18n()),
          ),
          TextButton(
            onPressed: () {
              String editedDescription = textEditingController.text;
              Provider.of<DatabaseProvider>(context, listen: false)
                  .updateMeasurement(
                      measurement, editedDescription, measurement.id);
              Navigator.pop(context, 'OK');
            },
            child: Text('button_text_save'.i18n()),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'appbar_history_text'.i18n(),
          style: const TextStyle(
              fontFamily: 'Roboto', fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: FutureBuilder(
        future: Provider.of<DatabaseProvider>(context, listen: false)
            .fetchMeasurements(),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Consumer<DatabaseProvider>(builder: (ctx, measurements, child) {
                if (measurements.items.isEmpty) {
                  return child ??
                      Center(
                        child: Text(
                          'no_measurements_text'.i18n(),
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      );
                } else {
                  return ListView.builder(
                    reverse: true,
                    shrinkWrap: true,
                    itemCount: measurements.items.length,
                    itemBuilder: (ctx, i) => ListTile(
                        title: Text(measurements.items[i].value),
                        subtitle: Text(measurements.items[i].description),
                        trailing: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: Theme.of(context).focusColor,
                              ),
                              onPressed: () {
                                _editItem(measurements.items[i]);
                              },
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                _deleteItem(measurements.items[i].id);
                              },
                            ),
                          ],
                        )),
                  );
                }
              }),
      ),
    );
  }
}
