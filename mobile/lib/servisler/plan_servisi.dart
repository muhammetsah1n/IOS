import '../modeller/plan.dart';
import '../yardimcilar/tarih.dart';
import 'api_servisi.dart';

// /plans uç noktalarıyla konuşur
class PlanServisi {
  static Future<List<Plan>> gunPlanlari(String token, DateTime gun) async {
    final liste = await ApiServisi.getListe('/plans?tarih=${Tarih.apiBicimi(gun)}', token: token);
    return liste.map((json) => Plan.fromJson(json as Map<String, dynamic>)).toList();
  }

  static Future<Plan> guncelle(String token, Plan plan) async {
    final json = await ApiServisi.put('/plans/${plan.id}', plan.toJson(), token: token);
    return Plan.fromJson(json);
  }
}
