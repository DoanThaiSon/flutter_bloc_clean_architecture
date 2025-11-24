import 'package:auto_route/auto_route.dart';
import 'package:domain/domain.dart';
import 'package:resources/resources.dart';
import '../../../app.dart';
import '../../../shared_view/app_scaffold.dart';
import '../bloc/language_bloc.dart';

@RoutePage()
class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  _LanguagePageState createState() => _LanguagePageState();
}

class _LanguagePageState extends BasePageState<LanguagePage, LanguageBloc> {
  LanguageCode? _selectedLanguageCode;

  @override
  void initState() {
    super.initState();
    _selectedLanguageCode = appBloc.state.languageCode;
  }

  @override
  Widget buildPage(BuildContext context) {
    return AppScaffold(
      appBar: CommonAppBar(
        text: S.current.language,
        centerTitle: true,
        titleTextStyle: AppTextStyles.titleTextDefault(
          fontWeight: FontWeight.w600,
          fontSize: Dimens.d20,
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.only(top: Dimens.d26),
        shrinkWrap: true,
        itemCount: LanguageCode.values.length,
        itemBuilder: (context, index) {
          final languageCode = LanguageCode.values[index];
          final bool isSelected = _selectedLanguageCode == languageCode;

          final String flagPath;
          switch (languageCode) {
            case LanguageCode.vi:
              flagPath = Assets.images.icons.languageVi.path;
              break;
            case LanguageCode.en:
              flagPath = Assets.images.icons.languageEn.path;
              break;
            case LanguageCode.ja:
              flagPath = Assets.images.icons.languageJa.path;
              break;
          }

          return Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Dimens.d12, vertical: Dimens.d8),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedLanguageCode = languageCode;
                  appBloc.add(AppLanguageChanged(languageCode: languageCode));
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.current.backgroundSetting
                      : AppColors.current.whiteColor,
                  borderRadius: BorderRadius.circular(Dimens.d8),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.current.textLinkColor
                        : AppColors.current.borderDefaultColor,
                    width: Dimens.d1,
                  ),
                ),
                padding: const EdgeInsets.all(Dimens.d16),
                child: Row(
                  children: [
                    Image.asset(
                      flagPath,
                      width: Dimens.d24,
                      height: Dimens.d24,
                    ),
                    const SizedBox(width: Dimens.d16),
                    Text(
                      languageCode.getFullCountryNameByLanguage,
                      style: AppTextStyles.titleTextDefault(
                          fontWeight: FontWeight.w600, fontSize: Dimens.d16),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
