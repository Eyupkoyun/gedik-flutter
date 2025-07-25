import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PuanlarTile extends StatelessWidget {
  final String documentId;
  const PuanlarTile ({
    Key ? key,
    required this.documentId
  }):super(key:key);

  @override
  Widget build(BuildContext context) {

    //puanların koleksiyonunu al
    CollectionReference puanlar=FirebaseFirestore.instance.collection('puanlar');

    return FutureBuilder<DocumentSnapshot>(
      future: puanlar.doc(documentId).get(),
    builder:(context,snapshot) {
        if(snapshot.connectionState==ConnectionState.done) {
          Map<String , dynamic> data =
          snapshot.data!.data() as Map<String , dynamic>;
          return Row(children: [
            Text(data['puan'].toString(),style: TextStyle(color: Colors.white,fontSize: 15,
              fontWeight: FontWeight.bold,),),
            SizedBox(width:10,),
            Text(data['isim'],style: TextStyle(color: Colors.white,fontSize: 15,
              fontWeight: FontWeight.bold,)),

          ],


          );
        } else {
          return Text('database den veri yükleniyor bekleyiniz');
        }
    },
    );
  }
}





