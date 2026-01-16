import 'package:flutter/material.dart';
import 'package:inventur_mde/core/constants/colors.dart';
import 'package:inventur_mde/core/providers/index.dart';
import 'package:inventur_mde/data/models/requests/update_inventur_request.dart';
import 'package:inventur_mde/data/models/responses/inventur_response.dart';
import 'package:inventur_mde/presentation/widgets/button_widget.dart';
import 'package:provider/provider.dart';

class InventurPage extends StatefulWidget {
  final int artnr;
  final String? artbez;
  final bool isUpdate;
  final int? menge;

  const InventurPage({
    super.key,
    required this.artnr,
    this.artbez,
    required this.isUpdate,
    this.menge,
  });

    @override
  State<InventurPage> createState() => _InventurPageState();
}

class _InventurPageState extends State<InventurPage> {
  final TextEditingController mengeController = TextEditingController();

 @override
  void initState() {
    _initPage();
    super.initState();
  }

  Future<void> _initPage() async {
    final personalProvider = Provider.of<PersonalProvider>(context, listen: false);
    await personalProvider.loadUserData();
  }

  @override
  Widget build (BuildContext context){
    final provider = Provider.of<InventurProvider>(context, listen: false);
    final personalProvider = Provider.of<PersonalProvider>(context);
    if (widget.menge != null ){mengeController.text = widget.menge.toString();}
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Daten speichern',
          style: TextStyle(
            color: AppColors.backgroundColor,
          )
        ),
        backgroundColor: AppColors.primaryColor,
        iconTheme: IconThemeData(color: AppColors.backgroundColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Artikel:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColor,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${widget.artnr}",
                        style: const TextStyle(
                          color: AppColors.textColor,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        widget.artbez ?? "",
                        style: const TextStyle(
                          color: AppColors.textColor,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            const Divider(thickness: 1, color: AppColors.borderColor),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 120,
                    child: TextField(
                      controller: mengeController,
                      autofocus: true,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Menge',
                        floatingLabelStyle: TextStyle(color: AppColors.primaryColor),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.primaryColor),
                        ),
                      ),
                      onSubmitted: (menge) async {
                        if (mengeController.text != ""){
                          var menge = int.tryParse(mengeController.text);
                        InventurResponse response;
                        var ben = personalProvider.komnr;
                        if (widget.isUpdate){
                          var request = UpdateInventurRequest(artnr: widget.artnr, menge: menge ?? 0, benutzer: ben ?? 0, artbez: widget.artbez);
                          response = await provider.updateInventur(request);
                        }else{
                          var request = UpdateInventurRequest(artnr: widget.artnr, menge: menge ?? 0, benutzer: ben ?? 0, artbez: widget.artbez);
                          response = await provider.saveInventur(request);
                        } 
                        
                        if(!context.mounted) return;
                
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                            Text(response.nachricht)
                          ),
                        );
                        Navigator.pop(context);
                        }
                        else {
                          ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                            Text("Bitte Menge eingeben!"),
                          ),
                        );
                        }
                       },   
                    ),
                  ),
                  SizedBox(width:20),
                  ButtonWidget(
                    onPressed: () async {
                      var menge = int.tryParse(mengeController.text);
                      InventurResponse response;
                      var ben = personalProvider.komnr;
                      if (widget.isUpdate){
                        var request = UpdateInventurRequest(artnr: widget.artnr, menge: menge ?? 0, benutzer: ben ?? 0, artbez: widget.artbez);
                        response = await provider.updateInventur(request);
                      }else{
                        var request = UpdateInventurRequest(artnr: widget.artnr, menge: menge ?? 0, benutzer: ben ?? 0, artbez: widget.artbez);
                        response = await provider.saveInventur(request);
                      } 
                      
                      if(!context.mounted) return;
              
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                          Text(response.nachricht)
                        ),
                      );
                      Navigator.pop(context);
                    }, 
                    title: "Speichern",
                  )
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}