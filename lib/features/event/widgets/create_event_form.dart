import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_scan/core/components/custom_button.dart';
import 'package:sun_scan/core/components/custom_form_widget.dart';
import 'package:sun_scan/core/routes/app_transition.dart';
import 'package:sun_scan/data/model/event_model.dart';

import '../bloc/event/event_bloc.dart';

class CreateEventForm extends StatelessWidget {
  const CreateEventForm({super.key, this.activeEvent});

  final EventModel? activeEvent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: DefaultForm(activeEvent: activeEvent)),
    );
  }
}

class DefaultForm extends StatefulWidget {
  const DefaultForm({super.key, this.activeEvent});

  final EventModel? activeEvent;

  @override
  State<DefaultForm> createState() => _DefaultFormState();
}

class _DefaultFormState extends State<DefaultForm> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _location = TextEditingController();
  bool _scanOutActive = false;
  bool _isActive = false;
  bool _isLocked = false;
  String? _eventCode;

  DateTime? _eventDateStart;
  DateTime? _eventDateEnd;

  bool _isFormValid = false;

  void _validateForm() {
    final isValid =
        _nameController.text.isNotEmpty &&
        _eventDateStart != null &&
        _eventDateEnd != null;

    if (isValid != _isFormValid) {
      setState(() {
        _isFormValid = isValid;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.activeEvent != null) {
      _nameController.text = widget.activeEvent!.name;
      _eventDateStart = widget.activeEvent!.eventDateStart;
      _eventDateEnd = widget.activeEvent!.eventDateEnd;
      _location.text = widget.activeEvent!.location ?? '';
      _scanOutActive = widget.activeEvent!.outActive;
      _isActive = widget.activeEvent!.isActive;
      _isLocked = widget.activeEvent!.isLocked;
      _eventCode = widget.activeEvent!.eventCode;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _location.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();

    // Pick date first
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _eventDateStart ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 2),
    );

    if (pickedDate == null) return;

    // Then pick time
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_eventDateStart ?? now),
    );

    if (pickedTime != null) {
      setState(() {
        _eventDateStart = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      });
      _validateForm();
    }
  }

  Future<void> _pickDateEnd() async {
    final now = DateTime.now();

    // Pick date first
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _eventDateEnd ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 2),
    );

    if (pickedDate == null) return;

    // Then pick time
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_eventDateEnd ?? now),
    );

    if (pickedTime != null) {
      setState(() {
        _eventDateEnd = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      });
      _validateForm();
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate() || !_isFormValid) return;

    if (_eventDateStart == null && _eventDateEnd == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tanggal event wajib diisi')),
      );
      return;
    }

    /// 🔥 NANTI DI SINI DISPATCH BLOC
    final event = EventModel(
      eventUuid: widget.activeEvent?.eventUuid,
      name: _nameController.text.trim(),
      eventDateStart: _eventDateStart!,
      eventDateEnd: _eventDateEnd!,
      eventCode: _eventCode,
      location: _location.text.trim(),
      createdAt: DateTime.now(),
      isActive: _isActive,
      outActive: _scanOutActive,
      isLocked: _isLocked,
    );

    if (widget.activeEvent == null) {
      context.read<EventBloc>().createEvent(event);
    } else {
      print('[CreateEventForm] Updating event: ${event.eventUuid}');
      context.read<EventBloc>().updateEvent(event);
    }

    AppTransition.popTransition(context);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            /// NAMA ACARA
            CustomFormWidget().buildTextFormInput(
              controller: _nameController,
              label: 'Nama Acara',
              hintText: 'Contoh: Acara Pernikahan Megha & Dito',
              contentPadding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 12,
              ),
              onChanged: (_) => _validateForm(),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Nama event wajib diisi';
                }
                return null;
              },
            ),

            const SizedBox(height: 24),

            /// TANGGAL EVENT
            CustomFormWidget().buildDateFormInput(
              _eventDateStart,
              _pickDate,
              label: 'Tanggal dan Waktu Acara Mulai',
            ),
            const SizedBox(height: 24),
            CustomFormWidget().buildDateFormInput(
              _eventDateEnd,
              _pickDateEnd,
              label: 'Tanggal dan Waktu Acara Selesai',
            ),

            const SizedBox(height: 24),

            /// CATATAN
            CustomFormWidget().buildTextFormInput(
              controller: _location,
              label: 'Alamat Acara (opsional)',
              hintText: 'Contoh: Bekasi, Jawa Barat',
              maxLines: 4,
              onChanged: (_) => _validateForm(),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 12,
              ),
              isRequired: false,
            ),
            const SizedBox(height: 24),

            /// SWITCH SCAN KELUAR MASUK TAMU
            CustomFormWidget().buildSwitchInput(
              title: 'Scan Keluar Masuk Tamu',
              value: _scanOutActive,
              onChanged: (value) {
                setState(() {
                  _scanOutActive = value;
                });
                _validateForm();
              },
            ),

            const SizedBox(height: 32),

            /// BUTTON SIMPAN
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                onPressed: _submit,
                title: 'Simpan Event',
                buttonType: _isFormValid
                    ? ButtonType.primary
                    : ButtonType.disable,
              ),
            ),

            /// LOCK EVENT
            if (widget.activeEvent != null) ...[
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  onPressed: () {
                    setState(() {
                      _isLocked = !_isLocked;
                    });
                    // DISPATCH BLOC UNTUK UPDATE ISLOCKED
                    final updatedEvent = widget.activeEvent!.copyWith(
                      isLocked: _isLocked,
                    );

                    context.read<EventBloc>().updateEvent(updatedEvent);
                    AppTransition.popTransition(context);
                  },
                  title: widget.activeEvent!.isLocked
                      ? 'Buka Kunci Acara'
                      : 'Kunci Acara',
                  buttonType: widget.activeEvent!.isLocked
                      ? ButtonType.disable
                      : ButtonType.outline,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
