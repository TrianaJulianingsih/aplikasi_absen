import 'package:flutter/material.dart';
import 'package:tugas_13/dashboard/drawer.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:tugas_13/sqflite/db_helper.dart';
import 'package:tugas_13/models/kehadiran.dart';
import 'package:tugas_13/preference/login.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  static const id = "/home";

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> titles = ['Hadir', 'Izin', 'Sakit', 'Alpha'];
  List<Color> colors = [Colors.blue, Colors.amber, Colors.green, Colors.red];
  List<double> values = [0, 0, 0, 0]; // default kosong dulu
  String? userName;
  int isSelectedIdx = -1;

  @override
  void initState() {
    super.initState();
    _loadData(); 
    _loadUserData();// ambil data dari DB saat pertama kali masuk
  }

  Future<void> _loadData() async {
  final userId = await PreferenceHandler.getUserId();
  if (userId == null) return;

  final data = await DbHelper.getKehadiranByUser(userId);

  int hadir = data.where((e) => e.status == "Hadir").length;
  int izin = data.where((e) => e.status == "Izin").length;
  int sakit = data.where((e) => e.status == "Sakit").length;
  int alpha = data.where((e) => e.status == "Alpha").length;

  setState(() {
    values = [hadir.toDouble(), izin.toDouble(), sakit.toDouble(), alpha.toDouble()];
  });
}


  Future<void> _loadUserData() async {
    final nama = await PreferenceHandler.getNama(); // Ambil nama, bukan email
    setState(() {
      userName = nama ?? "User"; // Default ke "User" jika null
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Home",
          style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Gilroy_Regular"),
        ),
        backgroundColor: const Color.fromARGB(255, 15, 216, 166),
        centerTitle: true,
      ),
      drawer: const DrawerMenu(),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(10),
              child: Text("Selamat Datang, "),
            ),

            // --- Card Profil ---
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 150,
                width: 330,
                child: Card(
                  color: const Color.fromARGB(255, 15, 216, 166),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          height: 80,
                          width: 80,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/images/jiso.jpg"),
                              fit: BoxFit.cover,
                            ),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                       Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userName ?? "Loading...", // Tampilkan NAMA user
                              style: TextStyle(
                                color: Colors.white, 
                                fontFamily: "Montserrat",
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Admin", 
                              style: TextStyle(
                                color: Colors.white, 
                                fontFamily: "Montserrat",
                                fontSize: 14
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 250,
                width: 350,
                child: Card(
                  color: const Color.fromARGB(255, 15, 216, 166),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Pie Chart
                      SizedBox(
                        height: 150,
                        width: 150,
                        child: PieChart(
                          PieChartData(
                            centerSpaceRadius: 30,
                            pieTouchData: PieTouchData(
                              enabled: true,
                              touchCallback: (event, response) {
                                if (!event.isInterestedForInteractions ||
                                    response == null ||
                                    response.touchedSection == null) {
                                  setState(() {
                                    isSelectedIdx = -1;
                                  });
                                  return;
                                }
                                setState(() {
                                  isSelectedIdx = response.touchedSection!.touchedSectionIndex;
                                });
                              },
                            ),
                            sections: List.generate(
                              titles.length,
                              (index) {
                                bool isSelected = index == isSelectedIdx;
                                return PieChartSectionData(
                                  title: titles[index],
                                  value: values[index],
                                  color: colors[index],
                                  radius: isSelected ? 70 : 50,
                                );
                              },
                            ),
                          ),
                        ),
                      ),

                      // Keterangan
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(titles.length, (index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              children: [
                                Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 1),
                                    color: colors[index],
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Text("${titles[index]}: ${values[index].toInt()}"),
                              ],
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
