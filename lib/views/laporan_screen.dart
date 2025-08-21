import 'package:flutter/material.dart';
import 'package:tugas_13/dashboard/drawer.dart';
import 'package:tugas_13/models/kehadiran.dart';
import 'package:tugas_13/sqflite/db_helper.dart';
import 'package:tugas_13/preference/login.dart';

class LaporanScreen extends StatefulWidget {
  const LaporanScreen({super.key});

  @override
  State<LaporanScreen> createState() => _LaporanScreenState();
}

class _LaporanScreenState extends State<LaporanScreen> {
  final List<String> bulan = [
    "Januari",
    "Februari",
    "Maret",
    "April",
    "Mei",
    "Juni",
    "Juli",
    "Agustus",
    "September",
    "Oktober",
    "November",
    "Desember",
  ];

  List<Kehadiran> laporan = [];
  int totalHadir = 0;
  int totalSakit = 0;
  int totalIzin = 0;
  int totalAlpha = 0;

  @override
  void initState() {
    super.initState();
    _loadLaporan("08"); // default bulan Agustus
  }

  Future<void> _loadLaporan(String bulan) async {
    final userId = await PreferenceHandler.getUserId();
    if (userId == null) return;

    final data = await DbHelper.getKehadiranByUserAndMonth(userId, bulan);

    int hadir = 0;
    int sakit = 0;
    int izin = 0;
    int alpha = 0;

    for (var d in data) {
      switch (d.status) {
        case "Hadir":
          hadir++;
          break;
        case "Sakit":
          sakit++;
          break;
        case "Izin":
          izin++;
          break;
        case "Alpha":
          alpha++;
          break;
      }
    }

    setState(() {
      laporan = data;
      totalHadir = hadir;
      totalSakit = sakit;
      totalIzin = izin;
      totalAlpha = alpha;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Laporan", style: TextStyle(fontFamily:"Gilroy_Regular", fontWeight: FontWeight.bold),),
        backgroundColor: const Color.fromARGB(255, 15, 216, 166),
        centerTitle: true,
      ),
      drawer: const DrawerMenu(),
      body: Column(
        children: [
          // Tombol bulan
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: bulan.asMap().entries.map((entry) {
                  int index = entry.key;
                  String namaBulan = entry.value;

                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: SizedBox(
                      height: 40,
                      width: 120,
                      child: ElevatedButton(
                        onPressed: () {
                          String bulanParam = (index + 1).toString().padLeft(
                            2,
                            "0",
                          );
                          _loadLaporan(bulanParam);
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.amber,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: Colors.greenAccent,
                              width: 2,
                            ),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            namaBulan,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Container total status
          Padding(
            padding: const EdgeInsets.all(10),
            child: Card(
              color: Colors.greenAccent,
              child: SizedBox(
                height: 200,
                width: 400,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Rekap Kehadiran",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text("Total Hadir: $totalHadir"),
                    Text("Total Sakit: $totalSakit"),
                    Text("Total Izin: $totalIzin"),
                    Text("Total Alpha: $totalAlpha"),
                  ],
                ),
              ),
            ),
          ),

          // Riwayat
          Expanded(
            child: Center(
              child: Text("Lihat riwayat kehadiran di menu Kehadiran"),
            ),
          ),
        ],
      ),
    );
  }
}
