import 'dart:math';

class SuggestionData {
  static String getImageForCategory(String category) {
    switch (category) {
      case 'فطور':
        return 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=600&q=80';
      case 'غداء':
        return 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?auto=format&fit=crop&w=600&q=80';
      case 'عشاء':
        return 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=600&q=80';
      case 'حلويات':
        return 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?auto=format&fit=crop&w=600&q=80';
      case 'سناكس':
        return 'https://plus.unsplash.com/premium_photo-1679591002405-13fec066bd53?auto=format&fit=crop&q=60&w=600';
      case 'صحي':
        return 'https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&q=60&w=600';
      default:
        return 'https://source.unsplash.com/600x400/?food';
    }
  }

  static final Map<String, List<Map<String, String>>> _categoryMeals = {
    'فطور': [
      {'name': 'توست بالأفوكادو'},
      {'name': 'فطائر بالشراب'},
      {'name': 'زبادي يوناني بالفاكهة'},
      {'name': 'عجة بالسبانخ والجبن'},
      {'name': 'سموثي التوت'},
      {'name': 'شوفان بالموز'},
      {'name': 'فرنش توست'},
      {'name': 'بوريتو الفطور'},
      {'name': 'توست بزبدة الفول السوداني'},
      {'name': 'بيض مقلي بالنقانق'},
    ],
    'غداء': [
      {'name': 'ساندويتش دجاج مشوي'},
      {'name': 'سلطة سيزر'},
      {'name': 'سباغيتي بولونيز'},
      {'name': 'وعاء كينوا'},
      {'name': 'ساندويتش تركي'},
      {'name': 'خضار سوتيه'},
      {'name': 'تاكو السمك'},
      {'name': 'أرز مقلي بالدجاج'},
      {'name': 'بيتزا مارجريتا'},
      {'name': 'شوربة العدس'},
    ],
    'عشاء': [
      {'name': 'ستيك مع بطاطس مهروسة'},
      {'name': 'سلمون مشوي وهليون'},
      {'name': 'مكرونة ألفريدو بالدجاج'},
      {'name': 'لحم بقري مقلي بالخضار'},
      {'name': 'فلفل محشي'},
      {'name': 'جمبري بالزبدة والثوم'},
      {'name': 'وعاء نباتي بودا'},
      {'name': 'سباغيتي كاربونارا'},
      {'name': 'فطيرة الراعي'},
      {'name': 'زيتي مخبوز'},
    ],
    'حلويات': [
      {'name': 'كيكة الشوكولاتة السائلة'},
      {'name': 'تشيز كيك فانيليا'},
      {'name': 'تيراميسو'},
      {'name': 'تارت الفواكه'},
      {'name': 'فطيرة التفاح'},
      {'name': 'براونيز'},
      {'name': 'موس الليمون'},
      {'name': 'كب كيك'},
      {'name': 'بانا كوتا'},
      {'name': 'فطيرة الموز والكراميل'},
    ],
    'سناكس': [
      {'name': 'فشار'},
      {'name': 'ألواح الجرانولا'},
      {'name': 'شرائح فواكه'},
      {'name': 'حمص وبسكويت مملح'},
      {'name': 'طبق جبن'},
      {'name': 'رقائق خضار'},
      {'name': 'كرات البروتين'},
      {'name': 'كعك الأرز بزبدة الفول السوداني'},
      {'name': 'ناتشوز'},
      {'name': 'صوص الأفوكادو'},
    ],
    'صحي': [
      {'name': 'سلطة كينوا وكرنب'},
      {'name': 'وعاء دجاج مشوي'},
      {'name': 'سموثي أفوكادو'},
      {'name': 'شوفان منقوع'},
      {'name': 'بودينغ بذور الشيا'},
      {'name': 'خضار مشوية مع حمص'},
      {'name': 'لفائف تونة صحية'},
      {'name': 'عصير ديتوكس الأخضر'},
      {'name': 'نودلز الكوسة'},
      {'name': 'بطاطا حلوة مشوية'},
    ],
  };

  static Map<String, String> getRandomMeal(String category) {
    final meals = _categoryMeals[category];
    if (meals == null || meals.isEmpty) {
      return {'name': '', 'image': getImageForCategory(category)};
    }
    final random = Random();
    final selectedMeal = meals[random.nextInt(meals.length)];
    return {
      'name': selectedMeal['name'] ?? '',
      'image': getImageForCategory(category),
    };
  }
}
