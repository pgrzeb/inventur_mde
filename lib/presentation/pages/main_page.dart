import 'package:flutter/material.dart';
import 'package:inventur_mde/core/providers/index.dart';
import 'package:inventur_mde/presentation/pages/index.dart';
import 'package:provider/provider.dart';
import '../../core/constants/colors.dart';
import '../widgets/button_widget.dart';

class MainPage extends StatefulWidget{

  const MainPage({super.key});

      @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
    final TextEditingController eanController = TextEditingController();
    final FocusNode eanFocusNode = FocusNode();

 @override
  void initState() {
    _initPage();
    super.initState();
  }

  Future<void> _initPage() async {
    final personalProvider = Provider.of<PersonalProvider>(context, listen: false);
    await personalProvider.loadUserData();
  }

  void onScanFinish(){
    setState(() {
      eanFocusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context){
    final personalProvider = Provider.of<PersonalProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Inventur",
          style: TextStyle(
            color: AppColors.backgroundColor,
          )
        ),
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: AppColors.backgroundColor),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_outlined),
            onPressed: () {
              Navigator.push( 
                context,
                MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ),
              );
            },
          ),
        ],
      backgroundColor: AppColors.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(Icons.account_circle_outlined , color: AppColors.primaryColor, size: 30),
                const SizedBox(width: 5),
                Text(personalProvider.komna ?? '', overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 16, color: AppColors.textColor)),    
              ]
            ),
            Text('Artikelnummer einscannen:'),
            SizedBox(height: 20),
            TextField(
              controller: eanController,
              autofocus: true,
              focusNode: eanFocusNode,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.go,
              decoration: const InputDecoration(
                labelText: 'Artnr',
                floatingLabelStyle: TextStyle(color: AppColors.primaryColor),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primaryColor),
                ),
              ),
              onSubmitted: (ean) async {
                //onScanCompleted(ean.trim());
                final provider = Provider.of<ScanProvider>(context, listen: false);
                final trimmedEan = ean.trim();
                if (trimmedEan == ""){
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                      Text('Bitte geben Sie eine gültige Artikelnummer ein!')),
                    );
                } else {
                  final response = await provider.loadArtikel(trimmedEan);
        
                  if(!context.mounted) return;
        
                  if (response.nachricht != null){
                    if (response.nachricht == "Artikelnummer nicht gefunden!"){
                      ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                        Text(response.nachricht ?? 'Fehler. Dienst nicht aktiv!')),
                      );
                    }else {
                      showDialog(
                        context: context,
                        builder: (context) =>  AlertDialog(
                          title: const Text("Artikel bearbeiten?"),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: const BorderSide(color: AppColors.primaryColor, width: 2
                            ),
                          ),
                          content: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(response.nachricht ?? "Für diesen Artikel existiert bereits ein Eintrag für das heutige Datum."),
                              SizedBox(height: 5),
                              Text("Möchten Sie ihn bearbeiten?"),
                              SizedBox(height: 5),
                              response.menge != null ? Text('Aktuelle Menge: ${response.menge}') : SizedBox(),
                            ],
                          ),
                          actions: [
                            ButtonWidget(
                              onPressed: () {
                                Navigator.pop(context);
                                eanController.clear();
                              },
                              title: "Abbrechen",
                            ),
                            ButtonWidget(
                              onPressed: () {
                                Navigator.pop(context);
                                eanController.clear();
                                Navigator.push( 
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => InventurPage(artnr: response.artnr, artbez:response.artbez, isUpdate: true, menge: response.menge),
                                  ),
                                );
                              }, 
                              title: "Weiter",
                            ),
                          ],
                        ),
                      );
                    }                
                  }
                  else{
                    eanController.clear();
                    Navigator.push( 
                      context,
                      MaterialPageRoute(
                        builder: (context) => InventurPage(artnr: response.artnr, artbez:response.artbez, isUpdate: false,),
                      ),
                    );
                  }
                } 
                onScanFinish();      
              },
            ),
          ],
        ),
      ),
      floatingActionButton: ButtonWidget(
        title: 'Weiter', 
        onPressed: () async {
          var ean = eanController.text.trim();
          final provider = Provider.of<ScanProvider>(context, listen: false);

          if (ean == ""){
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                Text('Bitte geben Sie eine gültige Artikelnummer ein!')),
              );
          } else {
            final response = await provider.loadArtikel(ean);
  
            if(!context.mounted) return;
  
            if (response.nachricht != null){
              if (response.nachricht != "Für diesen Artikel existiert bereits ein Eintrag für das heutige Datum."){
                ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:
                  Text(response.nachricht ?? 'Fehler. Dienst nicht aktiv!')),
                );
              }else{
                showDialog(
                  context: context,
                  builder: (context) =>  AlertDialog(
                    title: const Text("Artikel bearbeiten?"),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(color: AppColors.primaryColor, width: 2
                      ),
                    ),
                    content: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(response.nachricht ?? "Für diesen Artikel existiert bereits ein Eintrag für das heutige Datum."),
                        SizedBox(height: 5),
                        Text("Möchten Sie ihn bearbeiten?"),
                        SizedBox(height: 5),
                        response.menge != null ? Text('Aktuelle Menge: ${response.menge}') : SizedBox(),
                      ],
                    ),
                    actions: [
                      ButtonWidget(
                        onPressed: () {
                          Navigator.pop(context);
                          eanController.clear();
                        },
                        title: "Abbrechen",
                      ),
                      ButtonWidget(
                        onPressed: () {
                          Navigator.pop(context);
                          eanController.clear();
                          Navigator.push( 
                            context,
                            MaterialPageRoute(
                              builder: (context) => InventurPage(artnr: response.artnr, artbez:response.artbez, isUpdate: true, menge: response.menge),
                            ),
                          );
                        }, 
                        title: "Weiter",
                      ),
                    ],
                  ),
                );
              }             
            }
            else{
              eanController.clear();
              Navigator.push( 
                context,
                MaterialPageRoute(
                  builder: (context) => InventurPage(artnr: response.artnr, artbez:response.artbez, isUpdate: false,),
                ),
              );
            } 
          } 
          onScanFinish();      
        },
      ),
    );
  }
}
