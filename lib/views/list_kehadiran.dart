import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tugas_13/dashboard/drawer.dart';
import 'package:tugas_13/models/kehadiran.dart';
import 'package:tugas_13/sqflite/db_helper.dart';
import 'package:tugas_13/preference/login.dart';

class ListKehadiran extends StatefulWidget {
  const ListKehadiran({super.key});

  @override
  State<ListKehadiran> createState() => _ListKehadiranState();
}

class _ListKehadiranState extends State<ListKehadiran> {
  final _formKey = GlobalKey<FormState>();
  DateTime? selectedDate;
  String? dropdownSelect;
  List<Kehadiran> kehadiran = [];
  
  @override
  void initState() {
    super.initState();
    _loadKehadiran();
  }

  Future<void> _loadKehadiran() async {
    final userId = await PreferenceHandler.getUserId();
    if (userId == null) return;
    
    final data = await DbHelper.getKehadiranByUser(userId);
    setState(() {
      kehadiran = data;
    });
  }

  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _tanggalController = TextEditingController();
  final TextEditingController _kelasController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();

  Future<void> _pilihTanggal(BuildContext context) async {
    final DateTime? pickerDate = await showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
      locale: const Locale('id', 'ID'),
    );
    if (pickerDate != null) {
      setState(() {
        selectedDate = pickerDate;
        _tanggalController.text = DateFormat('dd-MM-yyyy', 'id').format(pickerDate);
      });
    }
  }

  void _showFormDialog({Kehadiran? dataToEdit}) {
    if (dataToEdit != null) {
      _namaController.text = dataToEdit.nama;
      _tanggalController.text = dataToEdit.tanggal;
      _kelasController.text = dataToEdit.kelas;
      _statusController.text = dataToEdit.status ?? "";
    } else {
      _namaController.clear();
      _tanggalController.clear();
      _kelasController.clear();
      _statusController.clear();
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              title: Text(dataToEdit == null ? "Tambah Kehadiran" : "Edit Kehadiran"),
              content: Form(
                key: _formKey,
                child: SizedBox(
                  height: 380,
                  width: 500,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _namaController,
                        decoration: const InputDecoration(
                          labelText: "Nama Siswa",
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(141, 177, 175, 175),
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Nama tidak boleh kosong";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _tanggalController,
                        decoration: InputDecoration(
                          labelText: 'Pilih Tanggal',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(141, 177, 175, 175),
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.calendar_month),
                            onPressed: () => _pilihTanggal(context),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Tanggal tidak boleh kosong";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _kelasController,
                        decoration: const InputDecoration(
                          labelText: "Kelas Siswa",
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(141, 177, 175, 175),
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Kelas tidak boleh kosong";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        width: 300,
                        child: DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Status Kehadiran",
                          ),
                          value: _statusController.text.isEmpty ? null : _statusController.text,
                          hint: const Text("Pilih Status Kehadiran"),
                          items: ["Hadir", "Izin", "Sakit", "Alpha"].map((String value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _statusController.text = newValue!;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Status kehadiran tidak boleh kosong";
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Batal"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final userId = await PreferenceHandler.getUserId();
                      Kehadiran kehadiranData = Kehadiran(
                        idKehadiran: dataToEdit?.idKehadiran,
                        userId: userId ?? 0,
                        nama: _namaController.text,
                        tanggal: _tanggalController.text,
                        kelas: _kelasController.text,
                        status: _statusController.text
                      );

                      if (dataToEdit == null) {
                        await DbHelper.registerKehadiran(kehadiranData);
                      } else {
                        await DbHelper.registerKehadiran(kehadiranData);
                      }
                      
                      Navigator.pop(context);
                      _loadKehadiran();
                      _namaController.clear();
                      _tanggalController.clear();
                      _kelasController.clear();
                      _statusController.clear();
                    }
                  },
                  child: const Text("Simpan"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _deleteKehadiran(int id) async {
    await DbHelper.deleteKehadiran(id);
    _loadKehadiran();                   
  }


  Future<void> _confirmDelete(int id) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Konfirmasi Hapus"),
          content: const Text("Apakah kamu yakin ingin menghapus data ini?"),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context); 
                await _deleteKehadiran(id); 
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text("Hapus"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kehadiran", style: TextStyle(fontFamily: "Gilroy_Regular", fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 15, 216, 166),
        centerTitle: true,
      ),
      drawer: DrawerMenu(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showFormDialog(),
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Container(
              height: 150,
              width: 382,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 15, 216, 166),
                borderRadius: BorderRadius.circular(8)
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 120, top: 55, bottom: 50, right: 50),
                child: Text("Absen Yuk!", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, fontFamily: "Gilroy_Regular")),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: kehadiran.length,
              itemBuilder: (context, index) {
                final data = kehadiran[index];
                return Card(
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    leading: Icon(Icons.person, color: const Color.fromARGB(255, 15, 216, 166)),
                    title: Text(data.nama, style: TextStyle(fontSize: 18),),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(data.kelas, style: TextStyle(fontSize: 14),),
                        Text(data.tanggal, style: TextStyle(fontSize: 14)),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(data.status!, style: TextStyle(fontSize: 18),),
                        Card(
                          child: IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _showFormDialog(dataToEdit: data),
                          ),
                        ),
                        Card(
                          child: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () =>  _confirmDelete(data.idKehadiran!),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}