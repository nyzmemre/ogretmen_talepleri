import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:group_button/group_button.dart';
import 'package:ogretmentalepleri/core/constant/color_constant.dart';
import 'package:ogretmentalepleri/features/homepage/message_model.dart';
import 'package:ogretmentalepleri/features/homepage/message_view_model.dart';
import 'package:ogretmentalepleri/product/services/fetch_sorun_list_widget.dart';
import 'package:ogretmentalepleri/product/widgets/my_checkbox.dart';
import 'package:ogretmentalepleri/product/widgets/my_toast_message_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constant/text_constant.dart';
import '../../product/widgets/my_scaffold.dart';
import 'package:kartal/kartal.dart';

import '../../product/widgets/my_textformfield.dart';

class HomepageView extends StatefulWidget {
  const HomepageView({Key? key}) : super(key: key);

  @override
  State<HomepageView> createState() => _HomepageViewState();
}

class _HomepageViewState extends State<HomepageView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _textController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<String>? selectedTitleList;
  final Uri _url = Uri.parse('https://www.instagram.com/ogretmenailesi/');
 bool _isSend=false;

 void selectedList(List<String> list) {
   selectedTitleList=list;
   print(list.length.toString());
 }
  @override
  void initState() {
    fetchMessageList();
    MessageViewModel().signAnonymmously();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.text;
    _textController.text;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              context.emptySizedHeightBoxHigh,
              Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                TextConstant.welcomeLetter,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.bold),
              ),
                  )),
              context.emptySizedHeightBoxLow,
              InkWell(

                onTap: _launchUrl,
                child: SizedBox(
                    height: context.width*.1,
                    child: Image.asset('assets/logo.png')),
              ),
              context.emptySizedHeightBoxLow,
              MyTextFormField(
                controller: _nameController,
                hintText: TextConstant.formName,
              ),
              context.emptySizedHeightBoxLow,
              context.emptySizedHeightBoxLow,
              MyTextFormField(
                maxLines: 5,
                controller: _textController,
                hintText: TextConstant.opAndSug,
              ),
              context.emptySizedHeightBoxLow,
              fetchSorunList(),
              context.emptySizedHeightBoxLow,
              ElevatedButton(
                  onPressed: (_isSend) ? null: () async {
                    print(FirebaseAuth.instance.currentUser!.uid);

                    if (formKey.currentState != null) {
                      if (formKey.currentState!.validate()) {
                        if (FirebaseAuth.instance.currentUser != null) {
                          MessageViewModel().sendMessage(
                              FirebaseAuth.instance.currentUser!.uid,
                              _textController.text,
                              _nameController.text,
                            selectedTitleList,

                          ).then((value) => CircularProgressIndicator());

                          _isSend=true;
                          setState(() {

                          });

                        } else {
                          MyToastMessageWidget().toast(
                              msg:
                                  'Bir sorun oluştu. Daha sonra tekrar deneyiniz.');
                        }
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorConstant.primaryBlue,
                  ),
                  child: (_isSend) ? Text(TextConstant.messageSend,style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: ColorConstant.white)) : Text(TextConstant.send,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: ColorConstant.white))),
/*             StreamBuilder(
               stream: FirebaseFirestore.instance.collection('message').snapshots(),
               builder: (context, snapshot) {

              if(snapshot.hasData && snapshot.data != null) {
                return SingleChildScrollView(
                    child: SizedBox(
                      height: 50000000,
                      child:
                      ListView(
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        children: snapshot.data!.docs.map((document) {
                       // debugPrint('--------------------------------');

                           // debugPrint(' ${document['message']} \n----------------\n');


                       // debugPrint(' ${document['messageTitle']}');
                          return Container(
                            padding: context.paddingLow,
                            child: Center(

                                child: SelectableText(document['message']??''),
                             ),
                          );
                        }).toList(),),
                    )

                );
              } else {return CircularProgressIndicator();}

                *//* return ElevatedButton(onPressed: () async {
                   

                  }, child: Text('verileri getir'));*//*
               }
             )*/
            ],
          ),
        ),
      ),
    );
  }



  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  Future<void> fetchMessageList () async {
    var col= await FirebaseFirestore.instance.collection('message').get().then((value) => value.size);
    print(col.toString());
  }

  Widget fetchSorunList(){
    double pageWidth = (context.width > 450) ? .6 : .8;

    return Container(
       decoration: BoxDecoration(
         border: Border.all(color: ColorConstant.grey),
         borderRadius: BorderRadius.circular(10),
       ),
       width: context.width * pageWidth,
       child: ExpansionTile(

         title: const Text(TextConstant.selectMessageTitle),
         children: [
           const Text(
             TextConstant.selectSorunText,
             textAlign: TextAlign.center,
           ),
           StreamBuilder<DocumentSnapshot>(
             stream: FirebaseFirestore.instance
                 .collection(TextConstant.sorunlarColName)
                 .doc(TextConstant.sorunListDocID)
                 .snapshots(),
             builder: (BuildContext context,
                 AsyncSnapshot<DocumentSnapshot> snapshot) {

               if (snapshot.hasError) {
                 return Text('Hata: ${snapshot.error}');
               }

               if (snapshot.connectionState == ConnectionState.waiting) {
                 return CircularProgressIndicator();
               }

               if (!snapshot.hasData || !snapshot.data!.exists) {
                 return Text('Veri güncellenemedi.');
               }

               List<dynamic>? sorunList = (snapshot.data?.data() as Map<String,
                   dynamic>?)?[TextConstant.sorunListFieldName]
                   ?.cast<dynamic>()
                   ?.toList();
               // List<String> sorunList=['ora', "bura",];
               return SingleChildScrollView(
                 child: SizedBox(
                   child: Padding(
                     padding: context.paddingLow,
                     child: GroupButton(
                       isRadio: false,

                       onSelected: (dynamic, index, isSelected,) {
                         if (selectedTitleList == null) {
                           selectedTitleList = [sorunList![index]];
                         } else {
                           if (selectedTitleList!.contains(sorunList![index])) {
                             selectedTitleList!.remove(sorunList[index]);
                           } else {
                             selectedTitleList!.add(sorunList[index]);
                           }
                         }


                         print('selicenler: $selectedTitleList');
                       },
                       buttons: sorunList ?? [''],
                     ),
                   ),
                 ),
               );
             },
           ),

         ],)
   );
  }

}
