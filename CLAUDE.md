# Base — دليل المشروع

Flutter base template (White Label) بيستخدم **Cubit (flutter_bloc)** لإدارة الحالة، **GetIt** لل-DI، **Dio** للنتورك، **easy_localization** للترجمة، و**flutter_screenutil** للمقاسات. الهدف إن أي فيتشر جديدة تتبني بنفس الباترن ده بالظبط.

---

## 1) هيكل الفولدرات (Structure)

```
lib/
  app/
    app.dart                 # MyApp: MultiBlocProvider + MaterialApp + ScreenUtilInit
    router/
      routes.dart             # أسماء الـ routes (constants)
      app_router.dart          # RouteGenerator.generateRoute (switch-case)
      navigation_services.dart # navigatorKey عشان الناڤيجيشن من بره الـ widget tree
    theme/
      app_theme.dart           # lightTheme / darkTheme

  core/
    di/injection.dart          # setupDi() — تسجيل كل حاجة في GetIt
    network/
      dio_client.dart          # DioClient (get/post/put/patch/delete/postForm/putForm) + Auth/Lang interceptors
      api_endpoints.dart        # كل الـ paths (base + endpoints) في مكان واحد
      api_response.dart         # ApiResponse<T> wrapper عام (message/status/data)
      api_handler.dart          # mixin ApiHandler: guard / dataOf / fetch — هاندلة الـ response والأخطاء لكل الـ Repos
      network_exceptions.dart   # NetworkException.fromDioException(e)
    storage/local_storage.dart # GetStorage (عادي) + FlutterSecureStorage (للـ token فقط)
    utils/
      app_colors.dart           # AppColors + ColorModel (light/dark) — كل الألوان من هنا
      app_constants.dart        # AppConstants (paddings, radius, durations, otp, ساعات الدوام...) + AppFonts (Cairo / FiraSans للأرقام)
      app_images.dart           # AppImages (كل مسارات الصور والأيقونات)
      locale_keys.dart          # LocaleKeys (مفاتيح الترجمة) — مرآة لملفات en.json/ar.json
      app_overlay.dart          # AppOverlay.showError/showSuccess (بانر بدل SnackBar)
      convert_helper.dart / helper_methods.dart
    widgets/                    # الـ Widgets العامة المشتركة بين كل الفيتشرز (شرح تفصيلي تحت)
    extensions/extensions.dart # num.height/.width/.paddingX + BuildContext.pushNamed...

  features/
    <feature_name>/
      data/
        <feature>_repo.dart     # بيكلم DioClient مباشرة ويرجع Model أو يرمي NetworkException
        models/*.dart            # الموديلز (fromJson/toJson) — Equatable
      logic/
        <feature>_cubit.dart     # الـ Cubit، بيستدعي الـ Repo فقط (مش Dio مباشرة)
        <feature>_state.dart     # part of الـ cubit — sealed states (Initial/Loading/Success/Error)
      presentation/
        <name>_screen.dart       # الشاشة نفسها بس (build + state management)، من غير أي private widget كلاس
        widgets/                 # ✅ إجباري: أي جزء UI مُقسّم بييجي هنا في ملف منفصل
          <widget_name>.dart
```

الفيتشرز الموجودة دلوقتي: `splash`, `onboarding`, `auth` (login/register/otp/pending), `layout` (bottom nav حسب الدور), `attendance` (رئيسية الموظف + الحضور/الإيقاف/الانصراف), `board`, `requests`, `decisions`, `tasks`, `projects`, `reports`, `reviewer`, `admin`, `team`, `profile`.

**الأدوار:** `UserRole.employee` / `reviewer` / `admin` (في `auth/data/models/user_role.dart`). التابات بتتحدد من `AppTab.forRole(role)`، والدور جاي من حساب المستخدم مش بيختاره.

**الـ API:** كل الـ Repos مربوطة بالباك إند الحقيقي (`ApiEndpoints.baseUrl`). الـ JSON بيتقري بـ `JsonReader` والـ enums بـ `EnumValue` (`{key, value}`).

---

## 2) قاعدة الـ Widgets — أهم حاجة تتاخد بالجدية

> **ممنوع** إنك تعمل private widget (`_HeaderSection`, `_ProfileCard`, `_MoreTile`...) جوا نفس ملف الشاشة أو تحت الكلاس الرئيسي بـ underscore.
> **لازم** كل جزء UI منفصل (تقسيمة منطقية للشاشة) يبقى **كلاس عام (public)** في **ملف منفصل** جوا `presentation/widgets/` بتاعة نفس الفيتشر.

- مسار الملف: `lib/features/<feature>/presentation/widgets/<widget_name>.dart`
- اسم الملف بـ snake_case، اسم الكلاس بـ PascalCase وعادةً مش بيبدأ بـ underscore (إلا لو داخلي جدًا جوا نفس ملف الويدجت وده استثناء نادر مثل helper class صغير جوا نفس ملف الويدجت).
- في `lib/features/auth/presentation/widgets/` فيه ملف `.gitkeep` بس — يعني الفولدر اتعمل بالفعل وناقص إنه يتاستخدم.
- **ملاحظة (دين تِكنيكال موجود):** حاليًا `login_screen.dart`, `more_screen.dart`, `on_boarding_screen.dart`, `layout_screen.dart` كلهم فيهم private widgets جوا نفس الملف (زي `_HeaderSection`, `_ProfileCard`, `_MoreTile`, `_LanguageSheet`, `_ConfirmDialog`, `_CustomNavBar`...). **القاعدة الجديدة تتطبق على أي كود جديد أو أي تعديل في الملفات دي من دلوقتي** — لو هتلمس أي شاشة من دول، انقل الـ widgets الداخلية بتاعتها لفولدر `widgets/` بتاعتها كجزء من الشغل.
- الويدجتس العامة اللي بتتشارك بين أكتر من فيتشر تروح `lib/core/widgets/` مش جوا فيتشر معينة.

### الاستثناء الوحيد
`State` class بتاعة `StatefulWidget` (زي `_LoginScreenState`) ده مش "widget مقسّم" وليه استثناء طبيعي في Flutter — ده جزء أساسي من الـ StatefulWidget نفسه، مش المقصود بالقاعدة.

---

## 3) Core Widgets الجاهزة (استخدمها بدل ما تعمل واحدة جديدة)

كل دول في `lib/core/widgets/` — **قبل ما تعمل widget جديد دور هنا الأول**:

| Widget | الاستخدام |
|---|---|
| `AppText` | بديل `Text` — بيحط `fontFamily: 'Cairo'` تلقائي. **استخدمه دايمًا بدل `Text` العادي** لأي نص في التطبيق. |
| `CustomButton` (`app_button.dart`, الاسم القديم `AppButton` متعمل له alias) | الزرار الأساسي — بارامترز: `title`/`child`, `color`, `borderColor`, `textColor`, `isOutlined`, `loading`, `expanded`, `radius`... بيحتوي على `CustomLoadingWidget` تلقائي لو `loading: true`. |
| `CustomTextField` (`app_text_field.dart`, alias قديم `AppTextField`) | حقل الإدخال الموحّد — فيه `isPassword` (بيتحكم في obscure + toggle icon تلقائي)، ألوان بوردر افتراضية، ودعم لـ validator. |
| `CustomLoadingWidget` | Loading indicator موحّد (`loading_animation_widget`). |
| `CustomTapEffect` | Wrapper بيدي "scale animation" بسيط لأي حاجة قابلة للضغط بدل `GestureDetector` العادي لو عايز إحساس لمسة. |
| `DarkHeader` + `HeaderOverlapLayout` | الهيدر الكحلي المتدرّج بالـ grid المتحرك، والكارت اللي بيركب عليه (الرئيسيات والبروفايل). |
| `AppSheet.show(context, child:)` | الـ bottom sheet الموحّد (grab handle + scroll + keyboard). |
| `AppCard` / `InfoBlock` / `StatusChip` (`ChipTone`) / `AppAvatar` / `EmojiBox` | كروت، بلوك بعنوان، شيبس الحالات بألوانها، أفاتار بالحروف الأولى. |
| `SegmentTabs` / `ChoiceChipsPicker` / `SegmentedToggle` / `EmojiOptionGrid` | تابات أفقية بعدّاد، اختيار chips، toggle، وجريد اختيارات بإيموجي. |
| `PageTopBar` / `SectionTitle` / `KeyValueRow` / `StatTilesRow` / `MeterBar` / `MenuItemTile` / `AlertTile` / `PersonRow` / `ScheduleEditor` / `AppFab` / `LiveTicker` / `FadeSlideIn` | باقي القطع المشتركة بين الشاشات. |
| `CustomImage` / `CustomImageOnlyRadius` | صورة Network مع `errorBuilder` بيرجع لـ `AppImages.holder` تلقائيًا لو فشل التحميل. `openBottomSheet()` لعرض الصورة full-screen بالـ `PhotoView`. |
| `CustomScreenStateLayout` (`screen_state_layout.dart`) | Wrapper موحّد لحالات الشاشة: `isLoading` / `error` (`ErrorModel`) / `isEmpty` / success — بيرجع `CustomLoadingWidget` / `CustomErrorView` / `CustomNoDataView` تلقائيًا لو مبعتش builder مخصص. **استخدمه في أي شاشة فيها API call بدل ما تكتب if/else يدوي.** |
| `AppEmpty` / `AppError` | حالات فاضية/خطأ بسيطة مستقلة (لو مش محتاج الـ layout الكامل). |
| `CustomPaginationListView<T>` / `CustomPaginationGridview<T>` (`pagination_widgets/`) | لستة/جريد مع **infinite scroll pagination** جاهز (`onLoadMore`, `hasMorePages`, `isMoreLoading`, `onRefresh`). استخدمهم لأي API فيه pagination بدل ما تعمل `ScrollController` يدوي. |
| `AppOverlay` (`utils/app_overlay.dart`) | `AppOverlay.showError(msg)` / `AppOverlay.showSuccess(msg)` — بانر متحرك أعلى الشاشة بدل `ScaffoldMessenger`/`SnackBar`. الـ Cubits بتنادي عليه مباشرة عند الخطأ. |

---

## 4) الألوان (Colors)

كل الألوان في `lib/core/utils/app_colors.dart` عن طريق `ColorModel(lightColor, darkColor)`:

```dart
AppColors.primaryColor       // 0xff0f67f6 (أزرق Matrix Clouds)
AppColors.primarySoftColor   // 0xffe8f0ff
AppColors.navyColor          // 0xff071633
AppColors.backgroundColor    // 0xfff4f7fd
AppColors.textPrimaryColor / textSecondaryColor / dividerColor / cardColor / surfaceColor
AppColors.successColor / warningColor / errorColor / orangeColor / violetColor  (+ كل واحد ليه SoftColor)
AppColors.primaryGradient / darkGradient / dangerGradient / successGradient / warningGradient
```

**قاعدة الاستخدام:** متستخدمش `.light` أو `.dark` مباشرة في الـ UI. استخدم دايمًا:

```dart
AppColors.primaryColor.themeColor
```

`themeColor` (extension `ColorTheme`) بيقرأ `Theme.of(context).brightness` تلقائي من الـ `navigationKey.currentContext` ويرجع اللون المناسب. لو محتاج لون جديد مش موجود، **ضيفه في `AppColors` كـ `ColorModel` جديد** (متكتبش `Color(0xFF...)` inline في الشاشات إلا لو تفصيلة صغيرة جدًا خاصة بشاشة واحدة — الأفضل حتى دي تترفع لـ `AppColors` أول ما تتكرر في مكان تاني). ألوان المشاريع جاية مع الداتا نفسها (`ProjectModel.color`).

الـ Theme نفسه (`app_theme.dart`) بيبني `ColorScheme.fromSeed` من `AppColors.primaryColor` + خط `Cairo` كـ font family افتراضي، و`themeMode: ThemeMode.light` مضبوط حاليًا في `app.dart` (الـ dark theme موجود بس مش مفعّل).

---

## 5) الترجمة (Localization)

- الباكدج: `easy_localization`. ملفات الترجمة: `assets/translations/en.json` و`assets/translations/ar.json` (لازم يفضلوا متطابقين في المفاتيح).
- كل مفتاح ترجمة **لازم** يتضاف في `lib/core/utils/locale_keys.dart` كـ `static const String` (نفس الـ dot path بالظبط).
- الاستخدام في الكود: `LocaleKeys.auth_login.tr()` (من `easy_localization`). ممنوع نص hardcoded في الـ UI (لا بالعربي ولا بالإنجليزي) — لازم يمر على `LocaleKeys` + `en.json`/`ar.json`.
- عند إضافة نص جديد: (1) ضيفه في `en.json` و`ar.json` بنفس المفتاح، (2) ضيف الـ constant المطابق في `locale_keys.dart`، (3) استخدمه بـ `.tr()`.
- اللغة الافتراضية `ar` (`LocalStorage.getLang() => 'ar'` لو مفيش قيمة محفوظة)، وبتتغيّر من `LanguageSheet` (في البروفايل وصفحة المزيد) وبتترسل في هيدر كل request كـ `Accept-Language` (شوف `dio_client.dart`).

---

## 6) دورة الـ API (API Cycle)

```
UI (Screen)
  └─ getIt<XCubit>().doSomething(...)   (أو الـ `_cubit` المخزّن: `late final _cubit = getIt<XCubit>()`)
        └─ Cubit: emit(Loading) → يستدعي Repo.method()
              └─ Repo: بيستخدم getIt<DioClient>() (get/post/put/patch/delete/postForm/putForm)
                    └─ DioClient: بيحط baseUrl + Authorization header (لو فيه token) + Accept-Language + PrettyDioLogger (debug فقط)
                          └─ عند 401 (وكان فيه Authorization header أصلاً — يعني جلسة حقيقية ماتت، مش محاولة لوجن غلط): يمسح كل التخزين ويرجع Login تلقائيًا (AuthInterceptor.onError) + AppOverlay.showError
              └─ Repo: يحول response.data لـ Model (`Model.fromJson`) أو يرمي NetworkException.fromDioException(e)
        └─ Cubit: emit(Success(model)) أو catch(e) → emit(Error(msg)) + غالبًا AppOverlay.showError(msg)
  └─ UI: BlocBuilder/BlocListener/BlocConsumer بيقرأ الـ State ويبني الشاشة (أو CustomScreenStateLayout لو فيه loading/error/empty)
```

نقط مهمة:
- **هاندلة الـ response والأخطاء مركزية في `ApiHandler`** (`core/network/api_handler.dart`) — كل Repo بيعمل `class XRepo with ApiHandler` ويستخدم:
  - `guard(() async { ... })` → بيلف الـ request ويحوّل `DioException` لـ `NetworkException`.
  - `dataOf(response)` → بيرجع `data` من الـ envelope كـ `Map` (أو `{}` لو مش موجود).
  - `fetch(() => _dio.get(...))` → `guard` + `dataOf` في سطر واحد.
  - **ممنوع** تكتب `_guard` / `_data` / `try { } on DioException` / `JsonReader.map(response.data)['data']` جوا أي Repo تاني. لو محتاج هاندلة جديدة مشتركة (status خاص، شكل response مختلف) ضيفها في `ApiHandler` مش في الـ Repo.
- **الـ Cubit لا يكلم `DioClient` مباشرة أبدًا** — دايمًا عن طريق `Repo`. الـ `Repo` بيلف كل نداء بـ `guard` من `ApiHandler` اللي بيحوّل `DioException` لـ `NetworkException`.
- الـ Repos بتاخد dependencies بتاعتها (`DioClient`, `LocalStorage`) في الـ constructor، ومسجلة كـ `registerLazySingleton` في `injection.dart`. الـ Cubits مسجلة كـ `registerFactory` (نسخة جديدة كل مرة تتعمل provide) — إلا لو محتاجة تعيش طول الـ session (زي `QueueCubit`/`OrdersCubit`) فبتتسجل `registerLazySingleton`.
- شكل الـ Response القياسي من الباك إند: `{ "message": str, "status": bool, "data": {...} }` — فيه `ApiResponse<T>` جاهز لو حبيت تستخدمه، لكن الـ Repos الحالية بتعمل parsing يدوي من `response.data['data']`.
- الـ States دايمًا `sealed class` بأربع حالات أساسية: `Initial` / `Loading` / `Success(data)` / `Error(message)`، معمولة بـ `Equatable`، وموجودة في ملف `part of` منفصل (`<feature>_state.dart`).
- الـ Endpoints/paths كلها مركزية في `ApiEndpoints` — ممنوع تكتب string path مباشر في الـ Repo.
- الـ Token محفوظ في `FlutterSecureStorage` (مش `GetStorage` العادي) لأنه بيانات حساسة؛ باقي البيانات (user json، lang، onboarding seen) في `GetStorage`.
- المستخدم الحالي في `AuthCubit.currentUser` (الـ `AuthCubit` مسجّل `registerLazySingleton` ومتوفر app-wide بـ `BlocProvider.value`). الـ Cubits اللي بتعيش طول الجلسة (`TasksCubit`, `ProjectsCubit`, `DecisionsCubit`, `TeamCubit`, `AttendanceCubit`...) `registerLazySingleton` وبتتعمل لها reset عند الخروج من `resetSession()` في `injection.dart`.

### 6.1) اختيار الأداة الصح: BlocBuilder / BlocListener / BlocConsumer / context.watch / context.read

كل الـ Cubits اللي بتعيش طول الجلسة متوفرة app-wide من `SessionScope` (`lib/app/session_scope.dart`) كـ `BlocProvider.value(getIt<X>())` فوق الـ `MaterialApp`: `AuthCubit`, `LayoutCubit`, `CatalogCubit`, `DashboardCubit`, `AttendanceCubit`, `BoardCubit`, `TeamCubit`, `TasksCubit`, `ProjectsCubit`, `RequestsCubit`, `DecisionsCubit`, `NotificationsCubit`, `ApprovalsCubit`, `ApprovalsTabCubit`, `ReportsCubit`. بعد الخروج `resetSession()` بيعمل نسخ جديدة و`SessionScope.restart()` بيعيد بناء الـ providers. أي Cubit جلسة جديد لازم يتضاف هنا + في `resetSession()`.

- **في الـ UI ممنوع `getIt<XCubit>()`** لأي Cubit من دول — استخدم `context.read` / `context.watch` / `BlocBuilder<X, XState>` من غير `bloc:`.
- **عرض + فعل جانبي من نفس الـ Cubit** → `BlocConsumer` (الـ side effects زي `Navigator`/`AppOverlay`/`showDialog` في `listener` بس، أبدًا في `builder`).
- **عرض جزء من الـ state** → `context.watch<XCubit>()` جوا الـ widget الصغير، أو `BlocBuilder<XCubit, XState>` مُصغّر النطاق.
- **نداء method بس** → `context.read<XCubit>().method()` (أو `late final _cubit = context.read<XCubit>()..load();` في الـ State). ممنوع تلف حاجة في `BlocBuilder` عشان توصل للنسخة.
- **تحميل الداتا أول ما الشاشة تفتح يتعمل في `initState`** (`_cubit.load();`)، **ممنوع** `late final _cubit = context.read<X>()..load();` — الـ `late` lazy، فالـ `load` مش بيتنفذ غير أول مرة حد يلمس `_cubit`، ولو `_cubit` مستخدم بس جوا callback (`() => _cubit.x()`) الشاشة هتفضل Loading للأبد (ده اللي حصل في شاشة الحضور).
- **Cubits الشاشة الواحدة** (`registerFactory`: `EmployeesCubit`, `EmployeeDetailCubit`, `ReportDetailCubit`) بتتوفر بـ `BlocProvider(create: (_) => getIt<X>()..load())` في الشاشة نفسها، وتحتها نفس قواعد `read`/`watch`.
- `context.watch` بيعمل rebuild للـ widget كله؛ متستخدموش في شاشة كبيرة لو محتاج بس جزء صغير — صغّر النطاق بـ widget منفصل أو `BlocBuilder`.

### 6.1.1) الفورمز وعمليات الـ submit

- **أي submit ليه loading/نجاح/فشل** (إضافة موظف، إنشاء مشروع...) → Cubit خاص بالفورم (`registerFactory`) بحالات `Initial/Loading/Success/Error`، ومتوفر بـ `BlocProvider(create: (_) => getIt<X>())` في ملف الشيت/الشاشة، والفورم نفسها في widget منفصل تحته (مثال: `AddEmployeeSheet` → `AddEmployeeForm` + `AddEmployeeCubit`).
- **ممنوع `bool _saving` + `setState`** للـ loading — الـ loading جاي من الـ state (`state is XLoading`) جوا `BlocConsumer` حوالين الزرار بس، والـ `pop` + `AppOverlay.showSuccess` في الـ `listener`.
- **ممنوع `onChanged: (_) => setState(() {})`** عشان تحدّث `enabled` بتاع الزرار — ده بيعيد بناء الفورم كلها مع كل حرف. استخدم `ListenableBuilder(listenable: Listenable.merge([controllers...]))` حوالين الزرار بس.
- `setState` مسموح بس لاختيارات UI محلية بضغطة صريحة (اختيار من chips/toggle/picker)، مش مع الكتابة.
- **امنع الـ double submit** من الـ Cubit نفسه: `if (state is XLoading || state is XSuccess) return;`.
- **العملية اللي فيها أكتر من request** (إنشاء + ربط بمشاريع...) تتعمل كلها جوا Cubit الفورم عن طريق الـ Repos مباشرة (بـ `Future.wait` لو مستقلين)، وبعدين تحدّث Cubits الجلسة **مرة واحدة** (`upsert` / `putAll`). ممنوع تنادي method في Cubit جلسة جوا loop (كل نداء = emit + rebuild + توست).
- جوا الفورم متستخدمش `context.watch` لداتا محتاجها مرة واحدة (زي لستة المشاريع للاختيار) — اقراها مرة بـ `late final ... = context.read<X>()...`.
- `context.read<XCubit>()` لـ Cubit جلسة **مش بيعمل نسخة جديدة** — بيرجع نفس الـ singleton اللي في `SessionScope` (نفس `getIt<XCubit>()` بالظبط). اللي بيعمل نسخة جديدة هو `getIt<X>()` لـ Cubit مسجّل `registerFactory`، فده يتعمل مرة واحدة بس في `BlocProvider(create:)` (وهو اللي بيقفله لوحده).

### 6.2) الـ Pagination وحالات الشاشة

- أي لستة من API فيها `meta` → `Paginated<T>` (`core/models/paginated.dart`) في الـ State، والـ Cubit فيه `load` / `refresh` / `loadMore` (بيحط `loadingMore: true` وبعدين `append`).
- العرض دايمًا بـ `CustomPaginationListView` (`itemCount`, `hasMorePages: page.hasMore`, `isMoreLoading: page.loadingMore`, `onLoadMore`, `onRefresh`, `emptyMessage`) جوا `CustomScreenStateLayout` (`isLoading` / `error: ErrorModel(...)` / `onRetry`).
- الـ API من غير `page` بيرجع كل الصفوف — ده بيتستخدم بس لما التصميم محتاج عدّادات/تجميعات على الكل (زي التاسكات والمشاريع).

## 7) Routing

- كل الأسماء constants في `Routes` (`app/router/routes.dart`).
- التنقل عن طريق `RouteGenerator.generateRoute` (switch-case) في `app_router.dart` — أي شاشة جديدة لازم يتضاف لها `case` هنا.
- الـ arguments بتتبعت كـ `Map<String, dynamic>?` في `settings.arguments`.
- للناڤيجيشن من بره الـ widget tree (زي جوا `DioClient`/interceptors) استخدم `NavigationService.navigationKey.currentState`.

---

## 8) Dependency Injection

كل حاجة بتتسجل مرة واحدة في `core/di/injection.dart` عن طريق `setupDi()`:
- `registerLazySingleton` → Storage, DioClient, Repos (نسخة واحدة طول عمر الأبلكيشن).
- `registerFactory` → Cubits (نسخة جديدة كل مرة).

أي فيتشر جديدة (Repo + Cubit) لازم تتسجل هنا بنفس النمط.

---

## 9) الأحجام والـ Extensions (Sizing)

- المشروع بيستخدم `flutter_screenutil` (design size `375x812`). استخدم `.w` / `.h` / `.sp` / `.r` بدل الأرقام الخام في أي مقاس جديد.
- في `core/extensions/extensions.dart`:
  - `num.height` / `num.width` → `SizedBox` سريع (`16.height` بدل `SizedBox(height: 16.h)`).
  - `num.paddingAll` / `.paddingVert` / `.paddingHorizontal` / `.paddingStart` / `.paddingEnd` / `.paddingTop` / `.paddingBottom` → `EdgeInsetsDirectional` (بتدعم RTL/LTR تلقائي — استخدمها بدل `EdgeInsets.symmetric` العادي في شاشات فيها نص عربي).
  - `BuildContext.pushNamed` / `.pushReplacementNamed` / `.pushNamedAndRemoveUntil` / `.pop()` → اختصارات فوق `Navigator.of(this)`.

---

## 10) قواعد عامة للكود (Clean Code)

- ملف الشاشة (`*_screen.dart`) يفضل يحتوي بس: الكلاس الرئيسي + الـ State بتاعته (لو Stateful). أي تقسيمة تانية → `presentation/widgets/`.
- الويدجت المشتركة بين فيتشرز متعددة → `core/widgets/`، مش نسخ ولزق بين الفيتشرز.
- الألوان/النصوص/الصور/المسافات كلها من الملفات المركزية (`AppColors`, `LocaleKeys`, `AppImages`, `AppConstants`) — مفيش hardcoded values في نص الشاشة إلا لو تفصيلة فريدة جدًا مش هتتكرر.
- الـ Models: `Equatable` + `fromJson`/`toJson` صريحين (من غير code generation حاليًا في المشروع).
- الـ Cubit بيرمي/يمسك الأخطاء بنفسه ويعرض `AppOverlay.showError` — الـ UI مش المفروض تعمل try/catch بتاعها.
- **القاعدة الافتراضية: من غير كومنتات خالص.** ده تكرر أكتر من مرة والقاعدة اتخففت في كل مرة، فخليها واضحة قد ما تقدر: **الافتراض إنك متكتبش كومنت خالص** — مش "قلل الكومنتات"، مش "اكتب بس لو مهم" — **من غير**. لو حسّيت إن سطر محتاج توضيح، الحل إنك تحسّن اسم المتغير/الفانكشن/الكلاس لحد ما الكود يشرح نفسه، مش إنك تضيف كومنت جنبه. ده يشمل بالتحديد:
  - كومنتات بتشرح "ليه الفلاج/المتغير ده موجود" أو "ليه الحماية دي لازمة" (زي "`_hydrated` عشان الداتا متتمسحش لو حصل رebuild") — الاسم `_hydrated` نفسه المفروض يكفي.
  - كومنتات بتشرح "ليه استخدمت الباترن ده هنا" أو بتوثّق قرار معماري متكرر (القرار موثّق في الملف ده مرة واحدة، مش محتاج يتكرر جوا الكود).
  - أي كومنت بيوصف اللي السطر اللي تحته بيعمله (لو السطر مش واضح، أعد كتابته أوضح — الحل مش كومنت فوقه).
  - **الاستثناء الوحيد:** توثيق سلوك خارجي غريب موثّق فعليًا (زي API بيرجع status غير متوقع، أو بَج حقيقي في السيرفر لازم القارئ يعرفه عشان مايرجعش يمسح الكود ظنًا إنه غلط) — وده لازم يكون قصير جدًا (سطر واحد) ومربوط بحقيقة خارجية فعلية اتأكدنا منها (زي لوج حقيقي شفناه)، مش تبرير لقرار تصميم داخلي.
