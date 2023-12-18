import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobilvize/ui/kitap_ekle.dart';

class Anasayfa extends StatefulWidget {
  const Anasayfa({super.key, this.kitap});

  final Map<String, dynamic>? kitap;

  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  Future<List<Map<String, dynamic>>> verileriGetir() async {
    final kitaplarQuery = FirebaseFirestore.instance.collection('Kitaplar');
    final kitaplarSnap = await kitaplarQuery.get();
    return kitaplarSnap.docs.map((doc) => doc.data()).toList();
  }

  Future<void> _kitapSil({required String kitapId}) async {
    if (kitapId.isEmpty) {
      return;
    }
    await FirebaseFirestore.instance
        .collection('Kitaplar')
        .doc(kitapId)
        .delete();

    setState(() {
      verileriGetir();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ahmet Demir Evrensel Kutuphane Yonetimi',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.menu_book))
        ],
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: verileriGetir(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final kitaplar = snapshot.data!;
            return ListView.builder(
              itemCount: kitaplar.length,
              itemBuilder: (context, index) {
                final kitap = kitaplar[index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              kitap['Kitap Adi'] ?? '',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                Text('Yazar Adi:' + ' ' + kitap['Yazarlar']),
                                const Text(','),
                                Text('Sayfa Sayisi:' +
                                    kitap['Sayfa Sayisi'].toString()),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                final kitap = snapshot.data![index];
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        KitapEkle(kitap: kitap),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.edit),
                            ),
                            IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title:
                                        const Text('Kitabı Silmeyi Onaylayın'),
                                    content: Text(
                                      '"${kitap['Kitap Adi']}" adlı kitabı silmek istediğinizden emin misiniz? Bu işlem geri alınamaz.',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('İptal'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          String kitapId =
                                              kitap['kitapId'] ?? '';
                                          if (kitapId.isNotEmpty) {
                                            _kitapSil(kitapId: kitapId);
                                          }
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Sil'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              icon: const Icon(Icons.delete),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('Hata: ${snapshot.error}');
          }
          return const CircularProgressIndicator();
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const KitapEkle(),
                ));
          },
          child: const Icon(Icons.add)),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Kitaplar'),
          BottomNavigationBarItem(icon: Icon(Icons.shop), label: 'Satin Al'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Ayarlar'),
        ],
      ),
    );
  }
}
