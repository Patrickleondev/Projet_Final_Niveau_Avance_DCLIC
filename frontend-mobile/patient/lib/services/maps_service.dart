import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

class MapsService {
  // Ouvrir Google Maps avec une adresse
  static Future<bool> openGoogleMaps({
    required String address,
    String? label,
  }) async {
    try {
      final encodedAddress = Uri.encodeComponent(address);
      final labelParam = label != null ? '&q=${Uri.encodeComponent(label)}' : '';
      final url = 'https://www.google.com/maps/search/?api=1&query=$encodedAddress$labelParam';
      
      final uri = Uri.parse(url);
      
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
      return false;
    } catch (e) {
      debugPrint('Erreur ouverture Google Maps: $e');
      return false;
    }
  }

  // Ouvrir Google Maps avec des coordonnées
  static Future<bool> openGoogleMapsWithCoordinates({
    required double latitude,
    required double longitude,
    String? label,
  }) async {
    try {
      final labelParam = label != null ? '&q=${Uri.encodeComponent(label)}' : '';
      final url = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude$labelParam';
      
      final uri = Uri.parse(url);
      
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
      return false;
    } catch (e) {
      debugPrint('Erreur ouverture Google Maps: $e');
      return false;
    }
  }

  // Obtenir l'itinéraire vers une adresse
  static Future<bool> getDirectionsTo({
    required String destination,
    String? origin,
  }) async {
    try {
      final encodedDestination = Uri.encodeComponent(destination);
      final originParam = origin != null ? '&origin=${Uri.encodeComponent(origin)}' : '';
      final url = 'https://www.google.com/maps/dir/?api=1&destination=$encodedDestination$originParam';
      
      final uri = Uri.parse(url);
      
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
      return false;
    } catch (e) {
      debugPrint('Erreur obtention itinéraire: $e');
      return false;
    }
  }

  // Obtenir l'itinéraire avec des coordonnées
  static Future<bool> getDirectionsToCoordinates({
    required double destinationLatitude,
    required double destinationLongitude,
    double? originLatitude,
    double? originLongitude,
  }) async {
    try {
      final originParam = (originLatitude != null && originLongitude != null) 
          ? '&origin=$originLatitude,$originLongitude' 
          : '';
      final url = 'https://www.google.com/maps/dir/?api=1&destination=$destinationLatitude,$destinationLongitude$originParam';
      
      final uri = Uri.parse(url);
      
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
      return false;
    } catch (e) {
      debugPrint('Erreur obtention itinéraire: $e');
      return false;
    }
  }
}
