import 'package:wallix/core/utils/constants/translations.dart';
import 'package:wallix/core/utils/cubit/home_cubit.dart';

TranslationModel appTranslation() =>
    homeCubit.translationModel ?? TranslationModel.fromJson({});
