import 'package:wallix/core/utils/constants/translations.dart';
import 'package:wallix/core/utils/cubit/theme/theme_cubit.dart';

TranslationModel appTranslation() =>
    themeCubit.translationModel ?? TranslationModel.fromJson({});
