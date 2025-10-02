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
  final Dio _dio = Dio();
  final String _baseUrl = "http://192.168.1.21:8000/api/journal";
  late List<JournalModels> _journals;

  @override
  Future<List<JournalModels>> getAllJournal() async {
    try {
      final response = await DioHttpClient.getInstance().get(
        API.journal,
        queryParameters: {"action": "all"},
      );
      print("Response: ${response.data['body']}");
      if (response.data['body'] is List) {
        _journals = JournalModels.fromJsonList(response.data['body']);
        print("Response: ${_journals}");
        return _journals;
      } else {
        throw Exception("Unexpected response format");
      }
    } on DioException catch (e) {
      print("Dio Error: ${e.message}");
      throw Exception("Failed to load posts: ${e.response?.statusCode}");
    }
  }

  @override
  Future<JournalModels?> getJournalById(int id) async {
    final response = await _dio.get("$_baseUrl/$id");
    return JournalModels.fromJson(response.data);
  }

  @override
  Future<void> createJournal(JournalModels journal) async {
    await _dio.post(_baseUrl, data: journal.toJson());
  }

  @override
  Future<void> updateJournal(JournalModels journal) async {
    await _dio.put("$_baseUrl/${journal.entriesId}", data: journal.toJson());
  }

  @override
  Future<void> deleteJournal(int id) async {
    await _dio.delete("$_baseUrl/$id");
  }
}

class JournalLocalService implements JournalService {
  @override
  Future<List<JournalModels>> getAllJournal() async {
    print("Fetching all journals locally");
    return [];
  }

  @override
  Future<JournalModels?> getJournalById(int id) async {
    print("Fetching journal locally with ID: $id");
    return null;
  }

  @override
  Future<void> createJournal(JournalModels journal) async {
    print("Creating journal locally: ${journal.title}");
  }

  @override
  Future<void> updateJournal(JournalModels journal) async {
    print("Updating journal locally with ID: ${journal.entriesId}");
  }

  @override
  Future<void> deleteJournal(int id) async {
    print("Deleting journal locally with ID: $id");
  }
}
