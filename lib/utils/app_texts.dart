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
  //bmi page
  static String bmiCalculator = 'BMI ' + 'محاسبه گر';
  static String pleaseEnterFields = 'لطفا فیلد های زیر را پر کنید';
  static String weight = 'وزن';
  static String height = 'قد';

  static String underWeight = 'کمبود وزن';
  static String normalWeight = 'وزن نرمال';
  static String overWeight = 'اضافه وزن';
  static String obesity = 'چاق';
  static String severeObesity = 'چاقی شدید';

  static String close = 'بستن';
  static String calculate = 'محاسبه';
  static String age = 'سن';
  static String yourStatus = 'وضعیت ';
  static String status = 'وضعیت';
  static String inRangeOfUnderWeight = 'در مرز کم‌وزنی';
  static String noData = 'اطلاعاتی جهت نمایش وجود ندارد.';
  static String gender = 'جنسیت';
  // image editor
  static String imageEditor = 'ادیت تصویر';
  static String camera_screen = 'صفحه دوربین';
  static String previewPage = 'پیش نمایش';

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

  static String menu = 'منو';
  // messagebox
}