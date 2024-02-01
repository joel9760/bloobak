import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
class DbManager {
  late Database _datebase;

  Future openDB() async {
    _datebase = await openDatabase(
        join(await getDatabasesPath(), "MyDonnor.db"),
        version: 1, onCreate: (Database db, int version) async {
      await db.execute(
          "CREATE TABLE donors(id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT,age TEXT,bgroup TEXT,phone TEXT)");
    });
  }

  Future<int> insertDonor(Donor donor) async {
    await openDB();
    return await _datebase.insert('donors', donor.toMap());
  }

  Future<List<Donor>> getDonorList() async {
    await openDB();
    final List<Map<String, dynamic>> maps = await _datebase.query('donors');
    return List.generate(maps.length, (index) {
      return Donor(
          id: maps[index]['id'],
          name: maps[index]['name'],
          age: maps[index]['age'],
          bgroup: maps[index]['bgroup'],
          phone: maps[index]['phone']);
    });
  }

  Future<int> updateDonor(Donor donor) async {
    await openDB();
    return await _datebase.update('donors', donor.toMap(),
        where: 'id=?', whereArgs: [donor.id]);
  }

  Future<void> deleteDonor(int? id) async {
    await openDB();
    await _datebase.delete("donors", where: "id = ? ", whereArgs: [id]);
  }

}
class Donor{
  int? id;
  late String name,age,phone,bgroup;

  Donor({this.id,
      required this.name,
      required this.age,
      required this.phone,
      required this.bgroup});
  Map<String,dynamic>toMap(){
    return{"name":name,"age":age,"phone":phone,"bgroup":bgroup};
  }
}