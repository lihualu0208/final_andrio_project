/**
 * Displays detailed information about a dealership and allows editing.
 */
import 'package:flutter/material.dart';
import 'car_dealership.dart';
import 'dealership_localizations.dart';

/// A widget that shows detailed information about a dealership and allows editing
class DealershipDetailPage extends StatefulWidget {
  /// The dealership to display and edit
  final Dealership dealership;

  /// Callback when the dealership is updated
  final Function(Dealership) onUpdate;

  /// Callback when the dealership is deleted
  final Function(Dealership) onDelete;

  /// Creates a detail page for the given dealership
  const DealershipDetailPage({
    Key? key,
    required this.dealership,
    required this.onUpdate,
    required this.onDelete,
  }) : super(key: key);

  @override
  State<DealershipDetailPage> createState() => _DealershipDetailPageState();
}

/// State for the dealership detail page, manages form editing
class _DealershipDetailPageState extends State<DealershipDetailPage> {
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _postalCodeController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.dealership.name);
    _addressController = TextEditingController(text: widget.dealership.address);
    _cityController = TextEditingController(text: widget.dealership.city);
    _postalCodeController = TextEditingController(text: widget.dealership.postalCode);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _postalCodeController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant DealershipDetailPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.dealership.id != oldWidget.dealership.id) {
      _nameController.text = widget.dealership.name;
      _addressController.text = widget.dealership.address;
      _cityController.text = widget.dealership.city;
      _postalCodeController.text = widget.dealership.postalCode;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DealershipLocalizations.of(context)!.translate('edit_dealership'),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: DealershipLocalizations.of(context)!.translate('dealership_name'),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _addressController,
            decoration: InputDecoration(
              labelText: DealershipLocalizations.of(context)!.translate('address'),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _cityController,
            decoration: InputDecoration(
              labelText: DealershipLocalizations.of(context)!.translate('city'),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _postalCodeController,
            decoration: InputDecoration(
              labelText: DealershipLocalizations.of(context)!.translate('postal_code'),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              final name = _nameController.text.trim();
              final address = _addressController.text.trim();
              final city = _cityController.text.trim();
              final postalCode = _postalCodeController.text.trim();

              if (name.isEmpty || address.isEmpty || city.isEmpty || postalCode.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        DealershipLocalizations.of(context)!.translate('all_fields_required') ??
                            'All fields are required'
                    ),
                  ),
                );
                return;
              }

              final updatedDealership = Dealership(
                id: widget.dealership.id,
                name: name,
                address: address,
                city: city,
                postalCode: postalCode,
              );
              widget.onUpdate(updatedDealership);
            },
            child: Text(DealershipLocalizations.of(context)!.translate('update')),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              widget.onDelete(widget.dealership);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(DealershipLocalizations.of(context)!.translate('delete')),
          ),
        ],
      ),
    );
  }
}