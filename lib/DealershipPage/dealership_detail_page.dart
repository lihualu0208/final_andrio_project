import 'package:flutter/material.dart';
import 'car_dealership.dart';
import 'dealership_localizations.dart';

class DealershipDetailPage extends StatefulWidget {
  final Dealership dealership;
  final Function(Dealership) onUpdate;
  final Function(Dealership) onDelete;

  const DealershipDetailPage({
    Key? key,
    required this.dealership,
    required this.onUpdate,
    required this.onDelete,
  }) : super(key: key);

  @override
  State<DealershipDetailPage> createState() => _DealershipDetailPageState();
}

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
            AppLocalizations.of(context)!.translate('edit_dealership'),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.translate('dealership_name'),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _addressController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.translate('address'),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _cityController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.translate('city'),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _postalCodeController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.translate('postal_code'),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              final updatedDealership = Dealership(
                id: widget.dealership.id,
                name: _nameController.text.trim(),
                address: _addressController.text.trim(),
                city: _cityController.text.trim(),
                postalCode: _postalCodeController.text.trim(),
              );
              widget.onUpdate(updatedDealership);
            },
            child: Text(AppLocalizations.of(context)!.translate('update')),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              widget.onDelete(widget.dealership);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(AppLocalizations.of(context)!.translate('delete')),
          ),
        ],
      ),
    );
  }
}