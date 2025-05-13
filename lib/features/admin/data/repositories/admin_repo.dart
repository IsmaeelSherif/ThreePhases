import 'package:dartz/dartz.dart';
import 'package:three_phases/core/utils/game_error.dart';
import 'package:three_phases/features/admin/data/models/unverified_word_model.dart';
abstract class AdminRepo {
  Future<Either<ErrorHandlar, Unit>> verifyWords(UnverifiedWordModel words);
  Future<Either<ErrorHandlar, List<UnverifiedWordModel>>> getUnverifiedWords();
}


