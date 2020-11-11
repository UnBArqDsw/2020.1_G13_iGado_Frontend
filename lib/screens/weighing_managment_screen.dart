import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:igado_front/components/icon_text_form_field.dart';
import 'package:igado_front/constants.dart';
import 'package:igado_front/services/management_service.dart';
import 'package:igado_front/utils/alert_utils.dart';

class WeighingManagmentScreen extends StatefulWidget {
  int bovineId;

  WeighingManagmentScreen({@required this.bovineId});
  @override
  _WeighingManagmentScreenState createState() =>
      _WeighingManagmentScreenState();
}

class _WeighingManagmentScreenState extends State<WeighingManagmentScreen> {
  Map<String, dynamic> managementData = {
    "actual_weight": "",
    "date_of_actual_weighing": "",
    "bovine_id": "",
  };
  List<Map<String, dynamic>> formInfoList = [
    {
      "title": "Peso",
      "icon": MaterialCommunityIcons.weight_kilogram,
      "placeholder": "Digite o peso atual do bovino",
      "obscureText": false,
      "onChange": "actual_weight",
    },
    {
      "title": "Data da pesagem",
      "icon": Icons.calendar_today,
      "placeholder": "Digite a data que o bovino foi pesado",
      "obscureText": false,
      "onChange": "date_of_actual_weighing",
    }
  ];
  var response;
  @override
  void initState() {
    super.initState();
    managementData["bovine_id"] = widget.bovineId;
  }

  bool checkFormResponse(formResponse) {
    if (formResponse["actual_weight"].isEmpty ||
        formResponse["bovine_id"].isEmpty ||
        formResponse["date_of_actual_weighing"].isEmpty) {
      return false;
    }
    return true;
  }

  Function changeDictData(String field) {
    return (text) {
      setState(() {
        managementData[field] = text;
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBrown2,
        automaticallyImplyLeading: false,
        title: Text('Manejo de Pesagem'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: kBackgroundTheme,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
          child: Form(
            child: Column(
              children: [
                Column(
                  children: formInfoList.map((Map<String, dynamic> formInfo) {
                    return IconTextFormField(
                      title: formInfo["title"],
                      icon: formInfo["icon"],
                      placeholder: formInfo["placeholder"],
                      obscureText: formInfo["obscureText"],
                      onChange: changeDictData(formInfo["onChange"]),
                    );
                  }).toList(),
                ),
                FlatButton(
                  onPressed: () {
                    response = ManagementService()
                        .createWeighingManagement(managementData)
                        .then((value) => showAlert(
                              "Manejo realizado com sucesso.",
                              context,
                              null,
                            ))
                        .catchError((e) {
                      print(e);
                      showAlert(
                        "Opa, não foi possível realizar seu manejo, verifique seus dados ou tente novamente mais tarde.",
                        context,
                        null,
                      );
                    });
                  },
                  child: Text(
                    'Manejar',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  color: kBrown2,
                  disabledColor: kDisabledButtonColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}