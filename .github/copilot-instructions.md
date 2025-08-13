# تعليمات GitHub Copilot للمشروع
# GitHub Copilot Project Instructions

## Language / اللغة
- أجب بالعربية دائماً / Always respond in Arabic
- أضف تعليقات بالعربية والإنجليزية / Add comments in Arabic and English

## Flutter & GetX Architecture
- استخدم GetX للبنية مع فصل كامل بين Controller/Binding/View
- استخدم Obx للتفاعل
- أسماء الطرق بـ snake_case
- استخدم طبقة الخدمات مع Get.putAsync وإنشاء instance مثل:
```dart
static ${featureName}Ctrl get instance => Get.isRegistered<${featureName}Ctrl>() 
    ? Get.find<${featureName}Ctrl>() 
    : Get.put(${featureName}Ctrl());
```

## State Management
- استخدم StatelessWidget مع GetX لإدارة الحالة
- استخدم GetBuilder مع id update للـ reactive widgets
- مثال: `GetBuilder<${featureName}Ctrl>(id: '${featureName}Ctrl', builder: (ctrl) => ...)`

## AppWrite Integration
- Authentication service
- Realtime DB للغرف الصوتية
- Storage لإدارة الملفات
- Functions لمعالجة الصوت

## Debugging & Utilities
- استخدم log للتصحيح: `log('text', name: 'ClassName')`
- استخدم Gab للمسافات: `Gab(10)` للمسافة العمودية والأفقية
- استخدم NotifyHelper للإشعارات المجدولة
- استخدم ApiClient للـ API calls مع Dio ومعالجة الأخطاء
- استخدم ConnectivityService لفحص الاتصال
- استخدم AppRouter لإدارة التنقل
- استخدم app_themes لإدارة الألوان والثيمات

## File Creation Rules
- لا تنشئ ملفات توثيق أو شرح (Readme)
- أنشئ فقط الملفات البرمجية المطلوبة
