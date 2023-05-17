import 'package:floor/floor.dart';

@Entity(tableName: 'rate')
class Rate {
  @PrimaryKey(autoGenerate: true)
  final int id =1;
  final double rate;
 
  Rate(this.rate);
}
