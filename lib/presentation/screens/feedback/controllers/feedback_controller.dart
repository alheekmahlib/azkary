part of '../feedback.dart';

/// FeedbackController - إدارة ميزة الملاحظات (Feedback) بالكامل.
///
/// يحفظ **قائمة tokens** محلياً (كل ملاحظة لها token مستقل خاص بها)،
/// يحمّل كل المحادثات للعرض كقائمة، ويدير المحادثة المفتوحة حالياً.
/// كل اللوجيك هنا — الشاشات مجرد واجهة تستهلك الـ Rx state.
class FeedbackController extends GetxController {
  /// الحصول على المتحكم (تسجيل ذاتي عند أول وصول)
  static FeedbackController get instance =>
      Get.isRegistered<FeedbackController>()
          ? Get.find<FeedbackController>()
          : Get.put(FeedbackController());

  final _box = GetStorage();

  /// مفتاح حفظ قائمة الـ tokens في GetStorage.
  static const _tokensKey = 'feedback_tokens';

  /// آخر id رد رآه المستخدم (للكشف عن الردود الجديدة).
  static const _lastReplyKey = 'feedback_last_reply_id';

  /// اسم التطبيق الثابت المُرسل للـ backend.
  static const String appSource = 'Azkary - Al Heekmah Library';

  // ---------- State ----------
  /// قائمة كل المحادثات (لعرضها كقائمة بطاقات).
  final threads = <FeedbackThread>[].obs;

  /// حالة تحميل القائمة.
  final isLoadingList = false.obs;

  /// حالة الإرسال من الـ bottom sheet.
  final isSubmitting = false.obs;

  /// المحادثة المفتوحة حالياً (في شاشة conversation).
  final openThread = Rxn<FeedbackThread>();

  /// حالة تحميل المحادثة المفتوحة.
  final isLoadingThread = false.obs;

  /// حالة إرسال رد متابعة.
  final isReplying = false.obs;

  // ---------- state الوسائط ----------
  /// الملفات المختارة محلياً قبل الإرسال (في الـ bottom sheet).
  final selectedFiles = <File>[].obs;

  /// حالة رفع الوسائط لـ R2.
  final isUploading = false.obs;

  /// تقدّم الرفع الحالي (0.0 - 1.0).
  final uploadProgress = 0.0.obs;

  /// الحد الأقصى لعدد الملفات لكل رسالة.
  static const int maxFiles = 5;

  /// أنواع الصور المسموحة + حد حجمها (10MB).
  static const Set<String> _allowedImageExts = {
    'jpg',
    'jpeg',
    'png',
    'webp',
    'gif',
  };
  static const int _maxImageBytes = 10 * 1024 * 1024; // 10MB

  /// أنواع الفيديو المسموحة + حد حجمها (50MB).
  static const Set<String> _allowedVideoExts = {'mp4', 'webm', 'mov'};
  static const int _maxVideoBytes = 50 * 1024 * 1024; // 50MB

  // ---------- Lifecycle ----------
  @override
  void onInit() {
    super.onInit();
    // حمّل tokens مبكراً لمعرفة هل توجد ملاحظات سابقة.
    _loadTokens();
    // تحميل هادئ للقائمة + فحص الردود الجديدة عند فتح الشاشة.
    loadAllThreads();
    checkForNewReplies();
  }

  /// يضمن تحميل القائمة عند فتح شاشة الملاحظات (ولو بعد hot restart).
  ///
  /// يُستدعى من بناء الشاشة عبر [WidgetsBinding.addPostFrameCallback].
  /// لا يعيد التحميل إن كان جارياً already.
  Future<void> ensureLoaded() async {
    if (isLoadingList.value) return;
    await loadAllThreads();
  }

  // ---------- Tokens ----------
  /// قائمة الـ tokens المحفوظة (Rx داخلي للتفاعل).
  final _tokens = <String>[].obs;
  List<String> get tokens => _tokens.toList();
  bool get hasFeedback => _tokens.isNotEmpty;

  void _loadTokens() {
    final raw = _box.read<List<dynamic>>(_tokensKey) ?? [];
    _tokens.value = raw.map((e) => e.toString()).toList();
  }

  void _saveTokens() {
    _box.write(_tokensKey, _tokens.toList());
  }

  /// يضيف token جديد (بدون تكرار) ويحفظ القائمة.
  void _addToken(String token) {
    if (token.isEmpty) return;
    if (!_tokens.contains(token)) {
      _tokens.insert(0, token); // الأحدث أولاً
      _saveTokens();
    }
  }

  // ---------- قائمة الملاحظات ----------

  /// يحمّل كل المحادثات للـ tokens المحفوظة لعرضها كقائمة بطاقات.
  Future<void> loadAllThreads() async {
    _loadTokens();
    if (_tokens.isEmpty) {
      threads.clear();
      return;
    }
    isLoadingList.value = true;
    try {
      final loaded = <FeedbackThread>[];
      // حمّل كل محادثة على حدة (التوازي مسموح لأن الـ endpoints مستقلة).
      final results = await Future.wait(_tokens.map((t) => _fetchThread(t)));
      for (final r in results) {
        r.fold((_) => null, (thread) => loaded.add(thread));
      }
      // رتّب: الأحدث أولاً حسب created_at للرسالة الأصلية.
      loaded.sort(
        (a, b) => b.feedback.createdAt.compareTo(a.feedback.createdAt),
      );
      threads.value = loaded;
    } finally {
      isLoadingList.value = false;
    }
  }

  /// جلب محادثة واحدة بالـ token (داخلي).
  Future<Either<Failure, FeedbackThread>> _fetchThread(String token) async {
    try {
      final endpoint =
          '${ApiConstants.feedbackApiUrl}${ApiConstants.feedbackEndpoint}/$token';
      final result = await ApiClient().request(
        endpoint: endpoint,
        method: HttpMethod.get,
        printResponse: false,
      );
      return result.fold((f) => Left(f), (data) {
        final map = _asMap(data);
        if (map == null) return Left(DataSource.DEFAULT.getFailure());
        return Right(FeedbackThread.fromJson(map));
      });
    } catch (e) {
      log('_fetchThread error: $e', name: 'FeedbackController');
      return Left(DataSource.DEFAULT.getFailure());
    }
  }

  // ---------- الإرسال ----------

  /// إرسال ملاحظة جديدة من الـ bottom sheet. يحفظ الـ token ويُحدّث القائمة.
  ///
  /// يُرجع الـ model عند النجاح (لإغلاق الـ bottom sheet والانتقال).
  Future<Either<Failure, FeedbackModel>> submitFeedback(String msg,
      {String? email}) async {
    final trimmed = msg.trim();
    if (trimmed.isEmpty || trimmed.length > 8000) {
      return Left(Failure(400, 'feedback_message_hint'));
    }

    isSubmitting.value = true;
    try {
      // ارفع الوسائط المختارة أولاً (إن وُجدت) واحصل على روابط R2.
      final mediaUrls = await _uploadAllFiles();
      if (mediaUrls == null) {
        // فشل الرفع — أوقف العملية.
        return Left(Failure(500, 'feedback_uploading'));
      }

      final body = <String, dynamic>{
        'message': trimmed,
        'app_source': appSource,
        'user_meta': await _collectUserMeta(),
      };
      if (email != null && email.trim().isNotEmpty) {
        body['contact_email'] = email.trim();
      }
      if (mediaUrls.isNotEmpty) {
        body['media_urls'] = mediaUrls;
      }

      final endpoint =
          '${ApiConstants.feedbackApiUrl}${ApiConstants.feedbackEndpoint}';

      final result = await ApiClient().request(
        endpoint: endpoint,
        method: HttpMethod.post,
        data: body,
        printResponse: false,
      );

      return result.fold((failure) => Left(failure), (data) {
        final map = _asMap(data);
        if (map == null) return Left(DataSource.DEFAULT.getFailure());
        final token = map['token']?.toString();
        final dataField = map['data'];
        final feedbackMap =
            dataField is Map ? Map<String, dynamic>.from(dataField) : null;
        if (feedbackMap == null) return Left(DataSource.DEFAULT.getFailure());
        final model = FeedbackModel.fromJson(feedbackMap);
        final finalToken =
            (token != null && token.isNotEmpty) ? token : model.token;
        if (finalToken.isNotEmpty) {
          _addToken(finalToken);
        }
        clearFiles(); // افرغ القائمة بعد النجاح
        return Right(model);
      });
    } catch (e) {
      log('submitFeedback error: $e', name: 'FeedbackController');
      return Left(DataSource.DEFAULT.getFailure());
    } finally {
      isSubmitting.value = false;
    }
  }

  // ---------- المحادثة المفتوحة ----------

  /// فتح محادثة للعرض في شاشة المحادثة.
  ///
  /// يعتمد على token المحادثة المطلوبة.
  Future<void> openConversation(String token) async {
    isLoadingThread.value = true;
    openThread.value = null;
    try {
      final result = await _fetchThread(token);
      result.fold((_) => null, (t) {
        openThread.value = t;
        // حدّث آخر رد مُشاهد لهذه المحادثة.
        _markThreadSeen(t);
      });
    } finally {
      isLoadingThread.value = false;
    }
  }

  /// إرسال رد متابعة في المحادثة المفتوحة. يضيفه محلياً ويُحدّث القائمة.
  ///
  /// يقبل وسائط فقط (دون نص) — النص مطلوب فقط إن لم تكن هناك وسائط مختارة.
  Future<Either<Failure, FeedbackReplyModel>> sendReply(String body) async {
    final token = openThread.value?.feedback.token;
    if (token == null || token.isEmpty) {
      return Left(Failure(404, 'no_feedback_yet'));
    }
    final trimmed = body.trim();

    isReplying.value = true;
    try {
      // ارفع الوسائط المختارة أولاً (إن وُجدت).
      final mediaUrls = await _uploadAllFiles();
      if (mediaUrls == null) {
        return Left(Failure(500, 'feedback_uploading'));
      }
      // النص مطلوب فقط إن لم تكن هناك وسائط.
      if (trimmed.isEmpty && mediaUrls.isEmpty) {
        return Left(Failure(400, 'feedback_reply_hint'));
      }

      final endpoint =
          '${ApiConstants.feedbackApiUrl}${ApiConstants.feedbackEndpoint}/$token${ApiConstants.feedbackReplySuffix}';
      final payload = <String, dynamic>{'body': trimmed};
      if (mediaUrls.isNotEmpty) {
        payload['media_urls'] = mediaUrls;
      }
      final result = await ApiClient().request(
        endpoint: endpoint,
        method: HttpMethod.post,
        data: payload,
        printResponse: false,
      );

      return result.fold((failure) => Left(failure), (data) {
        final map = _asMap(data);
        final replyMap = map == null
            ? null
            : (map['data'] is Map
                ? Map<String, dynamic>.from(map['data'])
                : null);
        if (replyMap == null) return Left(DataSource.DEFAULT.getFailure());
        final reply = FeedbackReplyModel.fromJson(replyMap);
        // أضف الرد محلياً للمحادثة المفتوحة + للقائمة.
        final current = openThread.value;
        if (current != null) {
          final updated = current.copyWith(
            replies: [...current.replies, reply],
          );
          openThread.value = updated;
          _upsertThreadInList(updated);
        }
        return Right(reply);
      });
    } catch (e) {
      log('sendReply error: $e', name: 'FeedbackController');
      return Left(DataSource.DEFAULT.getFailure());
    } finally {
      isReplying.value = false;
    }
  }

  /// يحدّث/يضيف محادثة في قائمة [threads] (بعد رد جديد مثلاً).
  void _upsertThreadInList(FeedbackThread updated) {
    final idx = threads.indexWhere(
      (t) => t.feedback.token == updated.feedback.token,
    );
    if (idx >= 0) {
      final list = threads.toList();
      list[idx] = updated;
      threads.value = list;
    } else {
      threads.insert(0, updated);
    }
  }

  // ---------- اختيار ورفع الوسائط ----------

  /// يفتح المعرض لاختيار صور متعددة. يتحقق من النوع والحجم والحد الأقصى.
  ///
  /// يُرجع مفتاح ترجمة الخطأ عند الفشل، أو null عند النجاح/الإلغاء.
  Future<String?> pickImages() async {
    final remaining = maxFiles - selectedFiles.length;
    if (remaining <= 0) return 'feedback_max_files';

    final picker = ImagePicker();
    try {
      final results = await picker.pickMultiImage(
        limit: remaining,
        imageQuality: 85,
      );
      if (results.isEmpty) return null; // ألغى المستخدم

      for (final x in results) {
        if (selectedFiles.length >= maxFiles) break;
        final file = File(x.path);
        final ext = _extension(x.path);
        final size = await file.length();

        if (!_allowedImageExts.contains(ext)) {
          return 'feedback_invalid_type';
        }
        if (size > _maxImageBytes) {
          return 'feedback_file_too_large';
        }
        selectedFiles.add(file);
      }
      return null; // نجاح
    } catch (e) {
      log('pickImages error: $e', name: 'FeedbackController');
      return 'feedback_invalid_type';
    }
  }

  /// يفتح المعرض لاختيار فيديو واحد. يتحقق من النوع والحجم.
  Future<String?> pickVideo() async {
    if (selectedFiles.length >= maxFiles) return 'feedback_max_files';

    final picker = ImagePicker();
    try {
      final x = await picker.pickVideo(source: ImageSource.gallery);
      if (x == null) return null; // ألغى المستخدم

      final file = File(x.path);
      final ext = _extension(x.path);
      final size = await file.length();

      if (!_allowedVideoExts.contains(ext)) {
        return 'feedback_invalid_type';
      }
      if (size > _maxVideoBytes) {
        return 'feedback_file_too_large';
      }
      selectedFiles.add(file);
      return null; // نجاح
    } catch (e) {
      log('pickVideo error: $e', name: 'FeedbackController');
      return 'feedback_invalid_type';
    }
  }

  /// يزيل ملفاً من القائمة المختارة بالـ index.
  void removeFileAt(int index) {
    if (index >= 0 && index < selectedFiles.length) {
      selectedFiles.removeAt(index);
    }
  }

  /// يفرّغ قائمة الملفات المختارة (بعد الإرسال أو الإلغاء).
  void clearFiles() {
    selectedFiles.clear();
    uploadProgress.value = 0.0;
  }

  /// هل الملف فيديو؟ (حسب الامتداد).
  bool isVideoFile(File file) {
    return _allowedVideoExts.contains(_extension(file.path));
  }

  /// يرفع كل الملفات المختارة لـ R2 عبر [ApiClient.uploadFile].
  ///
  /// يُرجع قائمة الروابط عند النجاح، أو `null` عند الفشل.
  /// يحدّث [uploadProgress] و [isUploading].
  Future<List<String>?> _uploadAllFiles() async {
    if (selectedFiles.isEmpty) return const [];

    isUploading.value = true;
    uploadProgress.value = 0.0;
    final urls = <String>[];
    final endpoint =
        '${ApiConstants.feedbackApiUrl}${ApiConstants.feedbackUploadEndpoint}';

    try {
      for (var i = 0; i < selectedFiles.length; i++) {
        final file = selectedFiles[i];
        final fileName = file.path.split('/').last;
        final formField = await dio.MultipartFile.fromFile(
          file.path,
          filename: fileName,
        );
        final formData = dio.FormData.fromMap({'file': formField});

        final result = await ApiClient().uploadFile(
          endpoint: endpoint,
          data: formData,
          onSendProgress: (sent, total) {
            if (total > 0) {
              // نسبة الملف الحالي ضمن كل الملفات.
              final fileFraction = (i + (sent / total)) / selectedFiles.length;
              uploadProgress.value = fileFraction.clamp(0.0, 1.0);
            }
          },
          printResponse: false,
        );

        if (result.isLeft) {
          log(
            'upload failed: ${result.left.message}',
            name: 'FeedbackController',
          );
          uploadProgress.value = 0.0;
          return null;
        }
        final data = result.right;
        final url = data is Map ? data['url']?.toString() : null;
        if (url == null || url.isEmpty) {
          uploadProgress.value = 0.0;
          return null;
        }
        urls.add(url);
      }
      uploadProgress.value = 1.0;
      return urls;
    } catch (e) {
      log('_uploadAllFiles error: $e', name: 'FeedbackController');
      uploadProgress.value = 0.0;
      return null;
    } finally {
      isUploading.value = false;
    }
  }

  /// استخراج الامتداد من مسار الملف (بدون نقطة، بأحرف صغيرة).
  String _extension(String path) {
    final dot = path.lastIndexOf('.');
    if (dot < 0 || dot == path.length - 1) return '';
    return path.substring(dot + 1).toLowerCase();
  }

  // ---------- الإشعارات عند وصول رد جديد ----------

  /// يفحص كل المحادثات للكشف عن ردود أدمن جديدة ويطلق إشعاراً فورياً لكل رد.
  Future<void> checkForNewReplies() async {
    try {
      if (_tokens.isEmpty) return;

      final lastSeen = _box.read<int>(_lastReplyKey) ?? 0;
      int newMax = lastSeen;
      for (final token in _tokens) {
        final result = await _fetchThread(token);
        if (result.isLeft) continue;
        final thread = result.right;
        final adminReplies = thread.replies.where((r) => r.isAdmin);
        for (final reply in adminReplies) {
          final idInt = _replyIdAsInt(reply.id);
          if (idInt > lastSeen) {
            await NotifyHelper().showNotification(
              id: reply.id.hashCode,
              title: _tr('feedback_reply_title', fallback: 'ردّ المشرف'),
              summary: _tr('feedback', fallback: 'الملاحظات'),
              body: reply.body,
              payload: {
                'type': 'feedback_reply',
                'feedback_token': token,
                'reply_id': reply.id,
              },
            );
            if (idInt > newMax) newMax = idInt;
          }
        }
      }
      if (newMax > lastSeen) {
        await _box.write(_lastReplyKey, newMax);
      }
    } catch (e) {
      log('checkForNewReplies error: $e', name: 'FeedbackController');
    }
  }

  /// ترجمة آمنة: ترجع القيمة المُترجمة إن وُجدت، وإلا fallback.
  String _tr(String key, {required String fallback}) {
    try {
      final translated = key.tr;
      return translated == key ? fallback : translated;
    } catch (_) {
      return fallback;
    }
  }

  int _replyIdAsInt(String id) => int.tryParse(id) ?? id.hashCode;

  void _markThreadSeen(FeedbackThread t) {
    if (t.replies.isEmpty) return;
    final lastSeen = _box.read<int>(_lastReplyKey) ?? 0;
    final maxInThread = t.replies
        .map((r) => _replyIdAsInt(r.id))
        .fold(lastSeen, (a, b) => a > b ? a : b);
    if (maxInThread > lastSeen) {
      _box.write(_lastReplyKey, maxInThread);
    }
  }

  // ---------- Helpers ----------

  /// يجمع معلومات الجهاز تلقائياً (بدون سؤال المستخدم).
  Future<Map<String, dynamic>> _collectUserMeta() async {
    String appVersion = 'unknown';
    try {
      final info = await PackageInfo.fromPlatform();
      appVersion = info.version;
    } catch (_) {}
    return {
      'platform': Platform.isIOS ? 'ios' : 'android',
      'app_version': appVersion,
      'device_model': '',
      'os_version': Platform.operatingSystemVersion,
      'language': Get.locale?.languageCode ?? 'ar',
      'os_name': Platform.operatingSystem,
    };
  }

  Map<String, dynamic>? _asMap(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    if (data is String) {
      final trimmed = data.trim();
      if (trimmed.isEmpty) return null;
      try {
        final decoded = jsonDecode(trimmed);
        if (decoded is Map) return Map<String, dynamic>.from(decoded);
      } catch (_) {}
    }
    return null;
  }
}

/// ربط متحكم شاشة الملاحظات / Feedback screen controller binding
class FeedbackBinding extends Bindings {
  @override
  void dependencies() {
    // Get.put (وليس lazyPut) لضمان إنشاء المتحكم وتشغيل onInit فوراً
    Get.put<FeedbackController>(FeedbackController());
  }
}
