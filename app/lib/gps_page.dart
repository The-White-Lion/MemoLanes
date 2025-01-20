import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:memolanes/gps_manager.dart';
import 'package:memolanes/utils.dart';
import 'package:provider/provider.dart';

class GPSPage extends StatefulWidget {
  const GPSPage({super.key});

  @override
  State<GPSPage> createState() => _GPSPageState();
}

class _GPSPageState extends State<GPSPage> {
  Future<void> _showEndJourneyDialog() async {
    final shouldEndJourney = await showCommonDialog(
        context, context.tr('home.end_journey_message'),
        hasCancel: true,
        title: context.tr('home.end_journey_title'),
        confirmText: context.tr('common.end'),
        confirmGroundColor: Colors.red,
        confirmTextColor: Colors.white);

    if (shouldEndJourney) {
      if (!context.mounted) return;
      await context
          .read<GpsManager>()
          .changeRecordingState(GpsRecordingStatus.none);
    }
  }

  @override
  Widget build(BuildContext context) {
    var gpsManager = context.watch<GpsManager>();

    Widget controls;
    if (gpsManager.recordingStatus == GpsRecordingStatus.none) {
      controls = Center(
        child: ElevatedButton(
          onPressed: () async {
            gpsManager.changeRecordingState(GpsRecordingStatus.recording);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFB4EC51),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(9999),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          ),
          child: Text(
            context.tr("home.start_new_journey"),
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w400,
              fontSize: 20,
            ),
          ),
        ),
      );
    } else if (gpsManager.recordingStatus == GpsRecordingStatus.recording) {
      controls = Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () async {
                gpsManager.changeRecordingState(GpsRecordingStatus.paused);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9999),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: Text(
                context.tr("home.pause"),
                style: const TextStyle(
                  color: Color(0xFFB4EC51),
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(width: 24),
            ElevatedButton(
              onPressed: _showEndJourneyDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(16),
              ),
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 24,
              ),
            ),
          ],
        ),
      );
    } else {
      controls = Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () async {
                gpsManager.changeRecordingState(GpsRecordingStatus.recording);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9999),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: Text(
                context.tr("home.resume"),
                style: const TextStyle(
                  color: Color(0xFFB4EC51),
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(width: 24),
            ElevatedButton(
              onPressed: _showEndJourneyDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(16),
              ),
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 24,
              ),
            ),
          ],
        ),
      );
    }

    return controls;
  }
}
