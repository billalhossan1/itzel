import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:itzel/constants/app_api_url.dart';
import 'package:itzel/models/event_model.dart';
import 'package:itzel/services/api/api_get_services.dart';
import 'package:mime/mime.dart';

import '../../../models/event_schedule_model.dart' as EventSchedule;
import '../../../models/get_event_status_model.dart';
import '../../../utils/app_all_log/error_log.dart';
import '../../api/api_delete_services.dart';
import '../../api/api_post_services.dart';

class EventRepository {
  final ApiGetServices _apiGetServices = ApiGetServices();
  final ApiPostServices _apiPostServices = ApiPostServices();
  final ApiDeleteServices _apiDeleteServices = ApiDeleteServices();

  Future<List<EventModel>?> getAllEvents() async {
    try {
      final response = await _apiGetServices.apiGetServices(AppApiUrl.allEvent);
      if (response != null && response['data'] != null) {
        // Ensure we're getting the data array from the response
        final List<dynamic> eventList = response['data'];
        return eventList.map((event) => EventModel.fromJson(event)).toList();
      }
    } catch (e) {
      errorLog("Error fetching events", e);
      print('Error fetching events: $e');
    }
    return null;
  }

  Future<EventModel?> getEventById(String id) async {
    try {
      final response = await _apiGetServices
          .apiGetServices('${AppApiUrl.baseUrl}/event/$id');

      print("Response type: ${response.runtimeType}");

      if (response is Map<String, dynamic>) {
        print("Processing Map response");
        if (response['data'] != null) {
          final data = response['data'];
          print("Data type: ${data.runtimeType}");

          if (data is List) {
            if (data.isNotEmpty) {
              try {
                final eventData = data[0];
                print("Processing event data: $eventData");
                return _createEventModelSafely(eventData);
              } catch (e) {
                errorLog(
                    "Error creating EventModel from list data", e.toString());
                return null;
              }
            }
            return null;
          } else if (data is Map<String, dynamic>) {
            try {
              print("Processing event data: $data");
              return _createEventModelSafely(data);
            } catch (e) {
              errorLog("Error creating EventModel from map data", e.toString());
              return null;
            }
          } else {
            errorLog("Data is neither List nor Map", data.toString());
            return null;
          }
        }
      } else if (response is String) {
        try {
          final Map<String, dynamic> jsonResponse = json.decode(response);
          print("Decoded JSON: $jsonResponse");

          if (jsonResponse['data'] != null) {
            final data = jsonResponse['data'];
            print("Data type: ${data.runtimeType}");

            if (data is List) {
              return data.isNotEmpty ? _createEventModelSafely(data[0]) : null;
            } else if (data is Map<String, dynamic>) {
              return _createEventModelSafely(data);
            } else {
              errorLog("Data is neither List nor Map", data.toString());
              return null;
            }
          }
        } catch (e) {
          errorLog("Error parsing JSON string", e.toString());
          return null;
        }
      }
    } catch (e) {
      errorLog("Error fetching event by ID", e);
    }
    return null;
  }

  EventModel? _createEventModelSafely(dynamic data) {
    if (data == null) return null;

    try {
      // Manually extract and validate each field to find the problematic one
      final id = data['_id']?.toString();
      final thumbnailImage = data['thumbnailImage']?.toString();
      final introMedia = data['introMedia']?.toString();
      final name = data['name']?.toString();

      // Handle time field specially
      DateTime? time;
      if (data['time'] != null) {
        try {
          time = DateTime.parse(data['time'].toString());
        } catch (e) {
          print("Error parsing time: ${data['time']}");
        }
      }

      final description = data['description']?.toString();

      // Handle tags field carefully
      List<String> tags = [];
      if (data['tags'] != null && data['tags'] is List) {
        tags = (data['tags'] as List).map((item) => item.toString()).toList();
      }

      final price = data['price'] is int
          ? data['price']
          : (data['price'] != null
              ? int.tryParse(data['price'].toString()) ?? 0
              : 0);

      // Handle creator field
      Creator? creator;
      if (data['creator'] != null) {
        try {
          if (data['creator'] is Map<String, dynamic>) {
            creator = Creator.fromJson(data['creator']);
          } else if (data['creator'] is String) {
            // Try to parse creator from string
            creator = Creator.fromJson(json.decode(data['creator']));
          }
        } catch (e) {
          print("Error parsing creator: $e");
        }
      }

      final type = data['type']?.toString();
      final address = data['address']?.toString();

      // Handle coordinate field carefully
      List<double> coordinates = [];
      if (data['coordinate'] != null && data['coordinate'] is List) {
        coordinates = (data['coordinate'] as List)
            .map((item) => (item is double)
                ? item
                : double.tryParse(item.toString()) ?? 0.0)
            .toList();
      }

      // Handle dates
      DateTime? createdAt;
      DateTime? updatedAt;
      try {
        if (data['createdAt'] != null) {
          createdAt = DateTime.parse(data['createdAt'].toString());
        }
        if (data['updatedAt'] != null) {
          updatedAt = DateTime.parse(data['updatedAt'].toString());
        }
      } catch (e) {
        print("Error parsing dates: $e");
      }

      final v = data['__v'] is int
          ? data['__v']
          : (data['__v'] != null
              ? int.tryParse(data['__v'].toString()) ?? 0
              : 0);

      final isFavourite = data['isFavourite'] is bool
          ? data['isFavourite']
          : (data['isFavourite'] == 'true' || data['isFavourite'] == '1');

      // Create model with manually extracted fields
      return EventModel(
        id: id,
        thumbnailImage: thumbnailImage,
        introMedia: introMedia,
        name: name,
        time: time,
        description: description,
        tags: tags,
        price: price,
        creator: creator,
        type: type,
        address: address,
        coordinate: coordinates,
        createdAt: createdAt,
        updatedAt: updatedAt,
        v: v,
        isFavourite: isFavourite,
      );
    } catch (e) {
      print("Error in _createEventModelSafely: $e");
      return null;
    }
  }

// Your other repository methods...

  Future<bool> addToWishlist(String eventId) async {
    try {
      final response = await _apiPostServices.apiPostServices(
        url: '${AppApiUrl.baseUrl}/user/wishlist/event/add/$eventId',
      );
      if (response != null) {
        return true;
      }
      return false;
    } catch (e) {
      errorLog("Error adding event to wishlist", e);
      return false;
    }
  }

  Future<bool> removeFromWishlist(String eventId) async {
    try {
      final response = await _apiDeleteServices.apiDeleteServices(
        '${AppApiUrl.baseUrl}/user/wishlist/event/remove/$eventId',
      );
      if (response != null) {
        return true;
      }
      return false;
    } catch (e) {
      errorLog("Error removing event from wishlist", e);
      return false;
    }
  }

  Future<Map<String, dynamic>?> createPaymentIntent(int amount) async {
    try {
      final response = await _apiPostServices.apiPostServices(
        url: '${AppApiUrl.baseUrl}${AppApiUrl.createPaymentIntent}',
        body: {'amount': amount},
      );
      return response;
    } catch (e) {
      errorLog("Error creating payment intent", e);
      return null;
    }
  }

  Future<List<EventModel>?> getEventsByDate(String date) async {
    try {
      print('Attempting to fetch events with date: $date');

      final response = await _apiGetServices.apiGetServices(
        '${AppApiUrl.baseUrl}/event',
        queryParameters: {'time': date},
      );

      print('Raw API response: $response');

      if (response != null && response['data'] != null) {
        print('Response data type: ${response['data'].runtimeType}');
        print('Response data: ${response['data']}');

        return List<EventModel>.from(
            response['data'].map((event) => EventModel.fromJson(event)));
      } else {
        print('No data found in the response');
      }
    } catch (e, stackTrace) {
      errorLog("Error fetching events by date", e);
      print('Error fetching events by date: $e');
      print('Stacktrace: $stackTrace');
    }
    return null;
  }

// Creator

  Future<bool> createEvent(Map<String, dynamic> eventData,
      {File? imageFile, File? videoFile}) async {
    try {
      FormData formData = FormData.fromMap({
        ...eventData,
      });

      if (imageFile != null && await imageFile.exists()) {
        String imageFileName = imageFile.path.split('/').last;
        String? imageMimeType = lookupMimeType(imageFile.path);
        formData.files.add(MapEntry(
          'thumbnailImage',
          await MultipartFile.fromFile(
            imageFile.path,
            filename: imageFileName,
            contentType: MediaType.parse(imageMimeType ?? 'image/jpeg'),
          ),
        ));
      }

      if (videoFile != null && await videoFile.exists()) {
        String videoFileName = videoFile.path.split('/').last;
        String? videoMimeType = lookupMimeType(videoFile.path);
        formData.files.add(MapEntry(
          'introMedia',
          await MultipartFile.fromFile(
            videoFile.path,
            filename: videoFileName,
            contentType: MediaType.parse(videoMimeType ?? 'video/mp4'),
          ),
        ));
      }

      final response = await _apiPostServices.apiPostServices(
        url: AppApiUrl.createEvent,
        body: formData,
      );

      return response != null;
    } catch (e) {
      errorLog("Error creating event with files", e);
      return false;
    }
  }

  Future<EventStatus?> getEventStatus() async {
    try {
      final response = await _apiGetServices
          .apiGetServices('${AppApiUrl.baseUrl}${AppApiUrl.getEventStatus}');
      if (response != null) {
        return EventStatus.fromJson(response['data']);
      }
    } catch (e) {
      errorLog("Error fetching event status", e);
    }
    return null;
  }

  Future<List<EventStatus>?> getAllEventStatus() async {
    try {
      final response = await _apiGetServices
          .apiGetServices('${AppApiUrl.baseUrl}${AppApiUrl.getAllEventStatus}');
      if (response != null && response['data'] != null) {
        return List<EventStatus>.from(
            response['data'].map((event) => EventStatus.fromJson(event)));
      }
    } catch (e) {
      errorLog("Error fetching all event status", e);
    }
    return null;
  }

  Future<EventSchedule.Welcome?> getEventSchedule() async {
    try {
      final response =
          await _apiGetServices.apiGetServices(AppApiUrl.eventSchedule);
      print('Raw response from getEventSchedule: $response');

      if (response != null) {
        return EventSchedule.Welcome.fromJson(response as Map<String, dynamic>);
      }
      return null;
    } catch (e, stackTrace) {
      errorLog("Error fetching event schedule", e);
      print('Error fetching event schedule: $e');
      print('Stack trace: $stackTrace');
      return null;
    }
  }
}
