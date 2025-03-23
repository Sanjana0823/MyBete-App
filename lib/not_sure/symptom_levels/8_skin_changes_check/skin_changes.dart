import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Symptom8Screen extends StatefulWidget {
  @override
  _SkinChangesCheckerState createState() => _SkinChangesCheckerState();
}

class _SkinChangesCheckerState extends State<Symptom8Screen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _records = [];
  List<String> _selectedSkinChanges = [];
  final List<Map<String, String>> _skinChangesOptions = [
    {'name': 'Blisters', 'image': 'assets/images/blisters.png'},
    {'name': 'Brown Patches (Dermopathy)', 'image': 'assets/images/dermopathy.png'},
    {'name': 'Thick, Waxy Skin', 'image': 'assets/images/waxy_skin.png'},
    {'name': 'Red Shiny Patches (NLD)', 'image': 'assets/images/nld.png'},
    {'name': 'Dark Velvety Skin (AN)', 'image': 'assets/images/an.png'},
    {'name': 'Firm Yellow Bumps', 'image': 'assets/images/yellow_bumps.png'},
    {'name': 'White Patches (Vitiligo)', 'image': 'assets/images/vitiligo.png'},
    {'name': 'Other', 'image': 'assets/images/other.png'},
  ];

  @override
  void initState() {
    super.initState();
    _fetchRecords();
  }

  Future<void> _fetchRecords() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('skin_changes_records')
          .orderBy('timestamp', descending: true)
          .get();
      setState(() {
        _records = querySnapshot.docs.map((doc) {
          return {
            'id': doc.id,
            'date': doc['timestamp'],
            'skinChanges': doc['skinChanges'],
          };
        }).toList();
      });
    } catch (e) {
      print('Error fetching records: $e');
    }
  }

  Future<void> _addRecord() async {
    if (_selectedSkinChanges.isEmpty) return;

    try {
      final timestamp = DateTime.now().toIso8601String();
      await _firestore.collection('skin_changes_records').add({
        'timestamp': timestamp,
        'skinChanges': _selectedSkinChanges,
      });
      _fetchRecords();
      setState(() {
        _selectedSkinChanges.clear(); // Clear local selection after saving
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Skin changes saved successfully!')),
      );
    } catch (e) {
      print('Error adding record: $e');
    }
  }

  Future<void> _clearRecords() async {
    try {
      QuerySnapshot querySnapshot =
      await _firestore.collection('skin_changes_records').get();
      for (var doc in querySnapshot.docs) {
        await _firestore.collection('skin_changes_records').doc(doc.id).delete();
      }
      _fetchRecords();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('All records cleared successfully!')),
      );
    } catch (e) {
      print('Error clearing records: $e');
    }
  }

  void _generateReport() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Skin Changes Report'),
          content: Text(
            _records.isNotEmpty
                ? 'You have ${_records.length} recorded skin change events.'
                : 'No records available to generate a report.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
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
        title: Text(
          'Skin Changes Checker',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Color(0xFF06333B),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: _skinChangesOptions.length,
                itemBuilder: (context, index) {
                  final option = _skinChangesOptions[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (_selectedSkinChanges.contains(option['name']!)) {
                          _selectedSkinChanges.remove(option['name']!);
                        } else {
                          _selectedSkinChanges.add(option['name']!);
                        }
                      });
                    },
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: _selectedSkinChanges.contains(option['name']!)
                          ? Color(0xFF96D8E3)
                          : Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            option['image']!,
                            height: 60,
                            width: 60,
                          ),
                          SizedBox(height: 8),
                          Text(
                            option['name']!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF288994),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addRecord,
              child: Text('Save Record'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF35B4C9),
                foregroundColor: Colors.white,
              ),
            ),
            ElevatedButton(
              onPressed: _clearRecords,
              child: Text('Clear Records'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFE28869),
                foregroundColor: Colors.white,
              ),
            ),
            ElevatedButton(
              onPressed: _generateReport,
              child: Text('Generate Report'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF245D6B),
                foregroundColor: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: _records.isEmpty
                  ? Center(
                child: Text(
                  'No records yet. Log your first skin change event!',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
                  : ListView.builder(
                itemCount: _records.length,
                itemBuilder: (context, index) {
                  final record = _records[index];
                  return ListTile(
                    title: Text('Date: ${record['date']}'),
                    subtitle: Text(
                      'Skin Changes: ${record['skinChanges'].join(', ')}',
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
