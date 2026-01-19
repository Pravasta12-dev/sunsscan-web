import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sun_scan/core/endpoint/uri_helper.dart';
import 'package:sun_scan/core/injection/injection.dart';
import 'package:sun_scan/data/model/guest_activity_model.dart';

import '../../data/model/guests_model.dart';

class GuestPhotoHelper {
  static String urlImages(String filePath) {
    final host = Injection.baseUrl;

    final url = UriHelper.createUrl(host: host, path: filePath);

    return url.toString();
  }

  static ImageProvider? guestAvatarProvider(GuestsModel guest) {
    // 1️⃣ FOTO LOKAL (BELUM SYNC)
    if (guest.photoPath != null && guest.photoPath != guest.photoUrl) {
      final file = File(guest.photoPath!);
      if (file.existsSync()) {
        return FileImage(file);
      }
    }

    // 2️⃣ FOTO NETWORK (SUDAH SYNC / PULL)
    if (guest.photoUrl != null && guest.photoUrl!.isNotEmpty) {
      final url = urlImages(guest.photoUrl!);

      return CachedNetworkImageProvider(url);
    }

    // 3️⃣ TIDAK ADA FOTO
    return null;
  }

  static ImageProvider? guestSessionAvatarProvider(GuestActivityModel? activity) {
    // FOTO LOKAL (BELUM SYNC)
    if (activity?.photoPath != null && activity?.photoPath != activity?.photoUrl) {
      final file = File(activity!.photoPath!);
      if (file.existsSync()) {
        return FileImage(file);
      }
    }

    // FOTO NETWORK (SUDAH SYNC / PULL)
    if (activity?.photoUrl != null && activity!.photoUrl!.isNotEmpty) {
      final url = urlImages(activity.photoUrl!);

      return CachedNetworkImageProvider(url);
    }

    // TIDAK ADA FOTO
    return null;
  }
}
