import 'package:floor/floor.dart';
import 'package:pricelet_app/entity/rate_entity.dart';

@dao
abstract class RateDAO {

  @Query('select * from rate where id= :id limit 1')
  Future<Rate?> findRateById(int id);
  
  @insert
  Future<void> insertRate(Rate rate);

  @update
  Future<void> updateRate(Rate rate);


}