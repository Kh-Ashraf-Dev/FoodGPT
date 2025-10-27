import '../../models/meal_model.dart';

class MealRepository {
  static final meals = [
    Meal(
      id: '1',
      title: 'توست بالأفوكادو',
      category: 'فطور',
      imageUrl: 'https://picsum.photos/200/300?1',
    ),
    Meal(
      id: '2',
      title: 'سلطة سيزر',
      category: 'غداء',
      imageUrl: 'https://picsum.photos/200/300?2',
    ),
    Meal(
      id: '3',
      title: 'سالمون مشوي',
      category: 'عشاء',
      imageUrl: 'https://picsum.photos/200/300?3',
    ),
  ];
}
