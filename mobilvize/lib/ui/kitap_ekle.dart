// ignore_for_file: prefer_interpolation_to_compose_strings, unused_catch_clause

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class KitapEkle extends StatefulWidget {
  const KitapEkle({super.key, this.kitap});

  final Map<String, dynamic>? kitap;

  @override
  State<KitapEkle> createState() => _KitapEkleState();
}

class _KitapEkleState extends State<KitapEkle> {
  TextEditingController _kitapAdiController = TextEditingController();
  TextEditingController _yayineviController = TextEditingController();
  TextEditingController _yazarlarController = TextEditingController();
  TextEditingController _kategoriController = TextEditingController();
  TextEditingController _sayfaSayisiControlller = TextEditingController();
  TextEditingController _basimYiliController = TextEditingController();
  bool _checkboxControl = false;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    if (widget.kitap != null) {
      _kitapAdiController.text = widget.kitap!['Kitap Adi'];
      _yayineviController.text = widget.kitap!['Yayinevi'];
      _yazarlarController.text = widget.kitap!['Yazarlar'];
      _kategoriController.text = widget.kitap!['Kategori'];
      _sayfaSayisiControlller.text = widget.kitap!['Sayfa Sayisi'];
      _basimYiliController.text = widget.kitap!['Basim Yili'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kitap Ekle'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Flexible(
            child: Column(
              children: [
                TextFormField(
                  controller: _kitapAdiController,
                  decoration: InputDecoration(label: Text('Kitap Adi')),
                ),
                TextFormField(
                  controller: _yayineviController,
                  decoration: InputDecoration(label: Text('Yayinevi')),
                ),
                TextFormField(
                  controller: _yazarlarController,
                  decoration: InputDecoration(label: Text('Yazarlar')),
                ),
                TextFormField(
                  controller: _kategoriController,
                  decoration: InputDecoration(label: Text('Kategori')),
                ),
                TextFormField(
                  controller: _sayfaSayisiControlller,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(label: Text('Sayfa Sayisi')),
                ),
                TextFormField(
                  controller: _basimYiliController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(label: Text('Basim Yili')),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'Listede Yayinlanacak mi?',
                      style: TextStyle(fontSize: 18),
                    ),
                    Checkbox(
                        value: _checkboxControl,
                        onChanged: (veri) {
                          setState(() {
                            _checkboxControl = veri!;
                          });
                        })
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 270, top: 20),
                  child: ElevatedButton(
                      onPressed: () {
                        veriEkleme();
                      },
                      child: Text('Kaydet')),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void veriEkleme() async {
    Map<String, dynamic> _guncellenecekKitap = <String, dynamic>{};

    if (widget.kitap != null) {
      final kitapId =
          _firestore.collection('Kitaplar').doc(widget.kitap!['kitapId']);

      _guncellenecekKitap['Kitap Adi'] = _kitapAdiController.text;
      _guncellenecekKitap['Yayinevi'] = _yayineviController.text;
      _guncellenecekKitap['Yazarlar'] = _yazarlarController.text;
      _guncellenecekKitap['Kategori'] = _kategoriController.text;
      _guncellenecekKitap['Sayfa Sayisi'] = _sayfaSayisiControlller.text;
      _guncellenecekKitap['Basim Yili'] = _basimYiliController.text;

      try {
        await _firestore.collection('Kitaplar').doc('"'+kitapId.toString()+'"').update(_guncellenecekKitap);
      } on FirebaseException catch (e) {
        print('Hata: Id yi bulamiyor');
      }
    } else {
      Map<String, dynamic> _eklenecekKitap = <String, dynamic>{};
      if (_eklenecekKitap['yayinlanacakMi'] = _checkboxControl) {
        _eklenecekKitap['Kitap Adi'] = _kitapAdiController.text;
        _eklenecekKitap['Yayinevi'] = _yayineviController.text;
        _eklenecekKitap['Yazarlar'] = _yazarlarController.text;
        _eklenecekKitap['Kategori'] = _kategoriController.text;
        _eklenecekKitap['Sayfa Sayisi'] = _sayfaSayisiControlller.text;
        _eklenecekKitap['Basim Yili'] = _basimYiliController.text;
        _eklenecekKitap['KitapId'] =
            FirebaseFirestore.instance.collection('Kitaplar').doc().id;

        await _firestore.collection('Kitaplar').add(_eklenecekKitap);
      }
    }
    
    Navigator.pop(context);
    
  }
}
