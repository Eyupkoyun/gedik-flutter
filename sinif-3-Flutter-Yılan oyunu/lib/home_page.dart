import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:fyilanoyunu/bos_piksel.dart';
import 'package:fyilanoyunu/puanlar_tile.dart';
import 'package:fyilanoyunu/yemek_piksel.dart';
import 'package:fyilanoyunu/yilanpiksel.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}):super(key:key);

  @override
  State<HomePage> createState() => _HomePageState();
}

enum yilan_yonu {YUKARI, ASAGI,SOL,SAG}

class _HomePageState extends State<HomePage> {
  //alanlar
  int satirBoyu=10;
  int toplamKareSayisi=100;
  bool oyunBaslatildi=false;
  String kullaniciAdi = '';
  final _isimKontrolcu=TextEditingController();

  //puan
  int suankiPuan=0;
  //yılan pozisyonu
  List<int> yilanPos=[
    0,
    1,
    2,

  ];

  //yilan su anda sağa gidiyo
  var suankiYon=yilan_yonu.SAG;

  //yemek posizyonu
  int yemekPos=52;

  //en yuksek puanlar listesi
  List <String> puanlar_DocIds=[];
  late final Future ? letsgetDocIds;

  @override
  void initState() {
    letsgetDocIds=DocIdAl();
    super.initState();
}

Future DocIdAl() async {
    await FirebaseFirestore.instance.collection("puanlar")
        .orderBy("puan",descending: true)
        .limit(10).get().then((value)=> value.docs.forEach((element) {puanlar_DocIds.add(element.reference.id); }));
}

  //oyunubaslat
  void oyunaBasla() {
    oyunBaslatildi=true;
    Timer.periodic(Duration(milliseconds: 210), (timer){
      setState(() {
        //yilan hareket etsin
        yilaniHareketEt();

        //yılan kendini yedi mi?
        if(oyunBitti()) {
          timer.cancel();
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context){
                return AlertDialog(
              title: Text('oyun bitti'),
               content: Column(
                 children: [
                   Text('skorunuz:'+ suankiPuan.toString()),
                   TextField(
                     controller: _isimKontrolcu,
                     decoration: InputDecoration(hintText:'isim giriniz' ),
                   )
                 ],
               ),
                  actions: [MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                      puaniKaydet();
                      yeniOyun();


                    },
                    child: Text('Kaydet'),
                    color: Colors.red,
                  )
                  ],
                );
              }
          );
        }



      });
    });
  }

  void puaniKaydet() async{
  var database=FirebaseFirestore.instance;

  //database veri ekle
  database.collection('puanlar').add({
    "isim" :_isimKontrolcu.text,
    "puan": suankiPuan,
  });
  }
  Future yeniOyun()  async{
    puanlar_DocIds=[];
    await DocIdAl();
    setState(() {
      yilanPos=[
        0,
        1,
        2,

      ];
      yemekPos=50;
      suankiYon=yilan_yonu.SAG;
      oyunBaslatildi=false;
      suankiPuan=0;

    });
  }

  void yemekYedi() {
    suankiPuan++;
    //yilanin yeni yemegi yemediginden emin olmak için
  while(yilanPos.contains(yemekPos)) {
  yemekPos=Random().nextInt(toplamKareSayisi);
    }
  }

  void yilaniHareketEt() {
    switch(suankiYon) {
      case yilan_yonu.SAG:{
        //yilan sağ duvarda mı evetse aynı rowa girsin
        if(yilanPos.last % satirBoyu==9) {
          yilanPos.add(yilanPos.last+1-satirBoyu);
        } else {
          yilanPos.add(yilanPos.last+1);
        }

        //bas ekle


      } break;
      case yilan_yonu.SOL:{
        //bas ekle
        //yilan sağ duvarda mı evetse aynı rowa girsin
        if(yilanPos.last % satirBoyu==0) {
          yilanPos.add(yilanPos.last-1+satirBoyu);
        } else {
          yilanPos.add(yilanPos.last-1);
        }

      } break;
      case yilan_yonu.YUKARI:{
        //bas ekle
        if(yilanPos.last<satirBoyu) {
          yilanPos.add(yilanPos.last-satirBoyu+toplamKareSayisi);
        } else {yilanPos.add(yilanPos.last-satirBoyu);}

      } break;
      case yilan_yonu.ASAGI:{
        //bas ekle
        if(yilanPos.last+satirBoyu>toplamKareSayisi) {
          yilanPos.add(yilanPos.last+satirBoyu-toplamKareSayisi);
        } else {yilanPos.add(yilanPos.last+satirBoyu);}

      } break;
      default:
    }

    //yilan yemek yiyorsa


    if(yilanPos.last==yemekPos) {
      yemekYedi();
    } else {
      //kuruk yoket
      yilanPos.removeAt(0);

    }

  }
  // oyun bitişi

  bool oyunBitti() {
    //yilan kendini yiyince
    List<int> yilanVucudu=yilanPos.sublist(0, yilanPos.length-1);
    if(yilanVucudu.contains(yilanPos.last)) {
      return true;
    }
    return false;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Column(
        children: [
          //puanlar
          Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [

          //kullanıcının şu anki puanı
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Şu Anki Skor', style: TextStyle(color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,),),
                Text(suankiPuan.toString(),
                style:TextStyle(fontSize: 40, color: Colors.white ) ),
              ],
            ),
          ),


          //en yuksek puan
          Expanded(
            child: oyunBaslatildi ? Container()
                : FutureBuilder(
              future: letsgetDocIds,
              builder: (context , snapshot) {
                return ListView.builder(
                  itemCount: puanlar_DocIds.length,
                  itemBuilder: ((context, index) {
                    return PuanlarTile(documentId: puanlar_DocIds[index]);

                  }),
                );


              },
            ) ,
          )
          ],

              ),
          ),

          //oyun şeması
          Expanded(
            flex: 4,
             child: GestureDetector(
               onVerticalDragUpdate:(details) {
                 if(details.delta.dy>0 && suankiYon!=yilan_yonu.YUKARI){
                   suankiYon=yilan_yonu.ASAGI;
                 }

                 else if(details.delta.dy<0 && suankiYon!=yilan_yonu.ASAGI){
                   suankiYon=yilan_yonu.YUKARI;
                 }
               } ,

               onHorizontalDragUpdate:(details) {
                 if(details.delta.dx>0 && suankiYon!=yilan_yonu.SOL){
                   suankiYon=yilan_yonu.SAG;
                 }

                 else if(details.delta.dx<0 && suankiYon!=yilan_yonu.SAG) {
                   suankiYon=yilan_yonu.SOL;
                 }
               } ,
               child: GridView.builder(
                itemCount: toplamKareSayisi,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: satirBoyu),
                itemBuilder:(context,index){
                if(yilanPos.contains(index)){
                  return  const YilanPiksel();
                }
                else if(yemekPos==index) {
                  return const YemekPiksel();
               
                }
                else {
                  return const BosPiksel();
                }
                } ),
             )
          ),
          //oyun butonu
          Expanded(
            child: Container(
             child: Center(
                 child :MaterialButton(
                   child: Text('oyna'),
                 color: oyunBaslatildi ? Colors.blueGrey: Colors.pink,
                 onPressed:oyunBaslatildi ? () {} :oyunaBasla ,)),

          ))
        ],

      ),
    );
  }
}


