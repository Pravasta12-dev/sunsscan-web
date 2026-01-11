import 'package:flutter/material.dart';
import 'package:sun_scan/core/components/custom_form_widget.dart';
import 'package:sun_scan/core/theme/app_text_styles.dart';
import 'package:sun_scan/data/model/event_model.dart';
import 'package:sun_scan/features/event/widgets/create_event_button.dart';
import 'package:sun_scan/features/event/widgets/event_card.dart';
import 'package:sun_scan/features/event/widgets/event_empty.dart';
import '../../../core/theme/app_colors.dart';

class EventLoadedWidget extends StatefulWidget {
  const EventLoadedWidget({
    super.key,
    required this.events,
    this.isTablet = false,
  });

  final List<EventModel> events;
  final bool isTablet;

  @override
  State<EventLoadedWidget> createState() => _EventLoadedWidgetState();
}

class _EventLoadedWidgetState extends State<EventLoadedWidget> {
  List<EventModel> get events => widget.events;
  List<EventModel> filteredEvents = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    filteredEvents = events;
  }

  @override
  void didUpdateWidget(EventLoadedWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update filteredEvents ketika widget.events berubah
    if (oldWidget.events != widget.events) {
      _applyFilter();
    }
  }

  void _applyFilter() {
    setState(() {
      if (_searchQuery.isEmpty) {
        filteredEvents = events;
      } else {
        filteredEvents = events
            .where(
              (event) =>
                  event.name.toLowerCase().contains(_searchQuery.toLowerCase()),
            )
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.isTablet
          ? EdgeInsets.zero
          : const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Column(
        children: [
          if (widget.isTablet) ...[
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Event List',
                    style: AppTextStyles.title.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.whiteColor,
                    ),
                  ),
                ),
                CreateEventButton(buttonType: CreateEventButtonType.tabletUp),
              ],
            ),
            const SizedBox(height: 12),
          ],
          CustomFormWidget().buildTextFormInput(
            onChanged: (value) {
              _searchQuery = value;
              _applyFilter();
            },
            hintText: 'Cari Acara...',
            prefixIcon: const Icon(Icons.search),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 12,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: filteredEvents.isEmpty
                ? EventEmptyWidget()
                : ListView.separated(
                    itemCount: filteredEvents.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final event = filteredEvents[index];

                      return EventCard(event: event);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
