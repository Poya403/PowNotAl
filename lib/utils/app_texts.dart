class AppTexts{
  AppTexts._();
  // AI
  static String prompt(String form, String title, String content) {
    return '''
      من به عنوان ورودی یک متن بهت میدم 
        فقط ازت میخواهم در خروجی تو فقط یک متن توسعه یافته باشه و گسترشش بدی. دیگه توضیح بیشتر نده چون میخواهم داخل اپلیکیشن استفاده کنم.
      فرم متن: $form
      عنوان متن: $title
      محتوای متن: $content
      ''';
  }

  static String close = 'بستن';
  static String noData = 'اطلاعاتی جهت نمایش وجود ندارد.';


  // note text
  static String notes = 'یادداشت ها';
  static String title = 'عنوان';
  static String save = 'ذخیره';
  static String loadNotes = 'بارگذاری یادداشت ها';
  static String delete = 'حذف';
  static String addNote = 'افزودن یادداشت';
  static String editNote = 'ویرایش متن';
  static String refresh = 'بارگذاری مجدد';
  static String developText = 'توسعه متن';

  static String form = 'شکل متن';
  static String clearChanges = 'حذف تغییرات';

  static String internetNeeded = 'برای توسعه متن به اینترنت نیاز است';

  static String text = 'متن';
  static String enterText = 'متن یادداشت را وارد کنید...';

  static String menu = 'منو کاربری';

  static String share = 'اشتراک گذاری';

  static String areYouSure = 'آیا مطمئن هستید؟';

  static String trashList = 'سطل زباله';

  // بخش مدیریت داده ها
  static String cloudSpace = 'فضای ابری';
  static String backUp = 'پشتیبان‌گیری';
  static String restoreBackup = 'بازگردانی نسخه پشتیبان';

  static String selectDriveFile = 'انتخاب نسخه پشتیبان';

  static String unknown = 'بدون نام';
  static String latestVersion = 'آخرین ورژن';
  static String noBackups = 'نسخه پشتیبانی برای بازیابی وجود ندارد.';

  static String search = 'جستجو عنوان';

  static String startDate = 'از تاریخ';
  static String endDate = 'تا تاریخ';
  // messagebox
}