import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:group_button/group_button.dart';
import 'package:ogretmentalepleri/core/constant/color_constant.dart';
import 'package:ogretmentalepleri/features/homepage/message_view_model.dart';
import 'package:ogretmentalepleri/product/widgets/my_checkbox.dart';
import 'package:ogretmentalepleri/product/widgets/my_toast_message_widget.dart';
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


  @override
  void initState() {
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
              context.emptySizedHeightBoxNormal,
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
                  onPressed: () {
                    print(FirebaseAuth.instance.currentUser!.uid);

                    if (formKey.currentState != null) {
                      if (formKey.currentState!.validate()) {
                        if (FirebaseAuth.instance.currentUser != null) {
                          MessageViewModel().sendMessage(
                              FirebaseAuth.instance.currentUser!.uid,
                              _textController.text,
                              _nameController.text,
                            selectedTitleList,

                          );
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
                  child: Text(TextConstant.send,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: ColorConstant.white)))
            ],
          ),
        ),
      ),
    );
  }

  Widget fetchSorunList() {
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


                      print(selectedTitleList);
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
