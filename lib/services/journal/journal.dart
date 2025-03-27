import 'package:dio/dio.dart';
import 'package:selena/models/journal_models/journal_models.dart';

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

  @override
  Future<List<JournalModels>> getAllJournal() async {
    final response = await _dio.get(_baseUrl);
    return (response.data as List)
        .map((json) => JournalModels.fromJson(json))
        .toList();
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
