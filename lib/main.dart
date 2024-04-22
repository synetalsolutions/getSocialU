import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/app_theme.dart';
import 'package:socialv/language/app_localizations.dart';
import 'package:socialv/language/languages.dart';
import 'package:socialv/models/common_models.dart';
import 'package:socialv/screens/messages/calls/open_call_contorller.dart';
import 'package:socialv/screens/splash_screen.dart';
import 'package:socialv/services/call_service.dart';
import 'package:socialv/services/login_service.dart';
import 'package:socialv/store/app_store.dart';
import 'package:socialv/store/lms_store.dart';
import 'package:socialv/store/message_store.dart';
import 'package:socialv/store/pmp_store.dart';
import 'package:socialv/utils/app_constants.dart';
import 'package:socialv/utils/push_notification_service.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  log('${FirebaseMsgConst.notificationDataKey} : ${message.data}');
  log('${FirebaseMsgConst.notificationKey} : ${message.notification}');
  log('${FirebaseMsgConst.notificationTitleKey} : ${message.notification!.title}');
  log('${FirebaseMsgConst.notificationBodyKey} : ${message.notification!.body}');
}

AppStore appStore = AppStore();
LmsStore lmsStore = LmsStore();
MessageStore messageStore = MessageStore();
PmpStore pmpStore = PmpStore();
OpenCallController openCallController = OpenCallController();

LoginService loginService = LoginService();
CallService callService = CallService();

late BaseLanguage language;

String currentPackageName = '';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp().then((value) {
    PushNotificationService().setupFirebaseMessaging();
    MobileAds.instance.initialize();
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  }).catchError(onError);

  await initialize(aLocaleLanguageList: languageList());

  defaultRadius = 32.0;
  defaultAppButtonRadius = 12;
  fontFamilyBoldGlobal = fontFamily;
  fontFamilySecondaryGlobal = fontFamily;
  fontFamilyPrimaryGlobal = fontFamily;

  exitFullScreen();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    init();

    openCallController.initializeStream(context);
  }

  void init() async {
    afterBuildCreated(() async {
      int themeModeIndex = getIntAsync(SharePreferencesKey.APP_THEME, defaultValue: AppThemeMode.ThemeModeSystem);

      if (themeModeIndex == AppThemeMode.ThemeModeLight) {
        appStore.toggleDarkMode(value: false, isFromMain: true);
      } else {
        appStore.toggleDarkMode(value: true, isFromMain: true);
      }

      await appStore.setLoggedIn(getBoolAsync(SharePreferencesKey.IS_LOGGED_IN));
      if (appStore.isLoggedIn) {
        appStore.setToken(getStringAsync(SharePreferencesKey.TOKEN));
        appStore.setVerificationStatus(getStringAsync(SharePreferencesKey.VERIFICATION_STATUS));
        appStore.setNonce(getStringAsync(SharePreferencesKey.NONCE));
        appStore.setLoginEmail(getStringAsync(SharePreferencesKey.LOGIN_EMAIL));
        appStore.setLoginName(getStringAsync(SharePreferencesKey.LOGIN_DISPLAY_NAME));
        appStore.setLoginFullName(getStringAsync(SharePreferencesKey.LOGIN_FULL_NAME));
        appStore.setLoginUserId(getStringAsync(SharePreferencesKey.LOGIN_USER_ID));
        appStore.setLoginAvatarUrl(getStringAsync(SharePreferencesKey.LOGIN_AVATAR_URL));
        messageStore.setBmSecretKey(getStringAsync(SharePreferencesKey.BM_SECRET_KEY));

        messageStore.setUserNameKey(getStringAsync(SharePreferencesKey.USERNAME_KEY));
        messageStore.setUserAvatarKey(getStringAsync(SharePreferencesKey.USER_AVATAR_KEY));
      }

      appStore.setFilterContent(getBoolAsync(SharePreferencesKey.FILTER_CONTENT, defaultValue: true));
      if (getMemberListPref().isNotEmpty) appStore.recentMemberSearchList.addAll(getMemberListPref());
      if (getGroupListPref().isNotEmpty) appStore.recentGroupsSearchList.addAll(getGroupListPref());

      if (getLmsQuizListPref().isNotEmpty) {
        lmsStore.quizList.addAll(getLmsQuizListPref());
      }
    });
  }

  MaterialPageRoute handleDeepLink(String link) {
    if (link.isDigit()) {
      return MaterialPageRoute(
        builder: (context) {
          return SplashScreen(activityId: link.toInt());
        },
      );
    } else {
      return MaterialPageRoute(builder: (_) => SplashScreen());
    }
  }

  @override
  void dispose() {
    openCallController.closeStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Portal(
      child: Observer(
        builder: (_) => MaterialApp(
          builder: (context, child) {
            return ScrollConfiguration(behavior: MyBehavior(), child: child!);
          },
          navigatorKey: navigatorKey,
          title: APP_NAME,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: appStore.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: SplashScreen(),
          supportedLocales: LanguageDataModel.languageLocales(),
          localizationsDelegates: [
            AppLocalizations(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          localeResolutionCallback: (locale, supportedLocales) => locale,
          locale: Locale(appStore.selectedLanguage.validate(value: Constants.defaultLanguage)),
          onGenerateRoute: (settings) {
            String pathComponents = settings.name!.split('/').last;

            return handleDeepLink(pathComponents);
          },
        ),
      ),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
