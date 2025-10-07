import 'package:dio/dio.dart';
import 'package:selena/models/journal_models/journal_models.dart';
import 'package:selena/services/api.dart';

abstract class JournalService {
  Future<List<JournalModels>> getAllJournal();
  Future<JournalModels?> getJournalById(int id);
  Future<void> createJournal(JournalModels journal);
  Future<void> updateJournal(JournalModels journal);
  Future<void> deleteJournal(int id);
}

class JournalApiService implements JournalService {
  final DioHttpClient _httpClient = DioHttpClient.getInstance();
  late List<JournalModels> _journals;

  @override
  Future<List<JournalModels>> getAllJournal() async {
    try {
      final response = await _httpClient.get(
        API.journal,
        queryParameters: {"action": "all"},
      );

      print("Full Response: ${response.data}");

      // ✅ ambil list di dalam `data.data`
      if (response.data['data'] != null && response.data['data']['data'] != null) {
        final List<dynamic> journalList = response.data['data']['data'];
        _journals = JournalModels.fromJsonList(journalList);

        print("Parsed Journals: $_journals");
        return _journals;
      } else {
        throw Exception("Unexpected response format: ${response.data}");
      }
    } on DioException catch (e) {
      print("Dio Error: ${e.message}");
      throw Exception("Failed to load journals: ${e.response?.statusCode}");
    }
  }

  @override
  Future<JournalModels?> getJournalById(int id) async {
    try {
      final response = await _httpClient.get(API.journalDetail(id));
      
      if (response.data['data'] != null) {
        return JournalModels.fromJson(response.data['data']);
      } else {
        throw Exception("Journal not found or invalid response format");
      }
    } on DioException catch (e) {
      print("Dio Error getting journal by ID: ${e.message}");
      throw Exception("Failed to load journal: ${e.response?.statusCode}");
    }
  }

  @override
  Future<void> createJournal(JournalModels journal) async {
    try {
      await _httpClient.post(
        API.journal,
        data: journal.toJson(),
      );
    } on DioException catch (e) {
      print("Dio Error creating journal: ${e.message}");
      throw Exception("Failed to create journal: ${e.response?.statusCode}");
    }
  }

  @override
  Future<void> updateJournal(JournalModels journal) async {
    try {
      await _httpClient.patch(
        API.journalDetail(journal.entriesId!),
        data: journal.toJson(),
      );
    } on DioException catch (e) {
      print("Dio Error updating journal: ${e.message}");
      throw Exception("Failed to update journal: ${e.response?.statusCode}");
    }
  }

  @override
  Future<void> deleteJournal(int id) async {
    try {
      await _httpClient.delete(API.journalDetail(id));
    } on DioException catch (e) {
      print("Dio Error deleting journal: ${e.message}");
      throw Exception("Failed to delete journal: ${e.response?.statusCode}");
    }
  }
}

class JournalLocalService implements JournalService {
  final List<JournalModels> _localJournals = [];

  @override
  Future<List<JournalModels>> getAllJournal() async {
    print("Fetching all journals locally");
    return List.from(_localJournals);
  }

  @override
  Future<JournalModels?> getJournalById(int id) async {
    print("Fetching journal locally with ID: $id");
    try {
      return _localJournals.firstWhere((journal) => journal.entriesId == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> createJournal(JournalModels journal) async {
    print("Creating journal locally: ${journal.title}");
    _localJournals.add(journal);
  }

  @override
  Future<void> updateJournal(JournalModels journal) async {
    print("Updating journal locally with ID: ${journal.entriesId}");
    final index = _localJournals.indexWhere((j) => j.entriesId == journal.entriesId);
    if (index != -1) {
      _localJournals[index] = journal;
    }
  }

  @override
  Future<void> deleteJournal(int id) async {
    print("Deleting journal locally with ID: $id");
    _localJournals.removeWhere((journal) => journal.entriesId == id);
  }
}