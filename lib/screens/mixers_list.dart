import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:salah_construction/models/mixer_model.dart';
import 'package:salah_construction/services/mixer_db_service.dart';

class MixersList extends StatefulWidget {
  const MixersList({Key? key}) : super(key: key);

  @override
  State<MixersList> createState() => _MixersListState();
}

class _MixersListState extends State<MixersList> {
  MixerDBService mixerDBService = MixerDBService();
  Future<List<Mixer>>? mixersListFuture;
  List<Mixer>? retrievedMixersList;

  Future<void> _refresh() async {
    mixersListFuture = mixerDBService.retrieveMixers();
    retrievedMixersList = await mixerDBService.retrieveMixers();
    setState(() {});
  }

  Future<void> _initRetrieval() async {
    mixersListFuture = mixerDBService.retrieveMixers();
    retrievedMixersList = await mixerDBService.retrieveMixers();
  }

  @override
  void initState() {
    super.initState();
    _initRetrieval();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "الخلاطات",
          style: Theme.of(context).textTheme.headline6,
        ),
        backgroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder(
            future: mixersListFuture,
            builder:
                (BuildContext context, AsyncSnapshot<List<Mixer>> snapshot) {
              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                /////////// Refactor here //////////
                return GridView.builder(
                    itemCount: retrievedMixersList!.length,
                    scrollDirection: Axis.vertical,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemBuilder: (_, index) {
                      return Card(
                        color: Colors.blueGrey,
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/mixer_details',
                                arguments: retrievedMixersList![index]);
                          },
                          child: ClipRect(
                            child: Align(
                              alignment: Alignment.center,
                              heightFactor: 0.7,
                              child: Text(
                                retrievedMixersList![index].name,
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ),
                          ),
                        ),
                      );
                    });
                ///////////////////// END /////////////////////////
              } else if (snapshot.connectionState == ConnectionState.done &&
                  retrievedMixersList!.isEmpty) {
                return Center(
                  child: ListView(
                    children: const <Widget>[
                      Align(
                          alignment: AlignmentDirectional.center,
                          child: Text(
                            ' لا يوجد خلاطات',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          )),
                    ],
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddMixerPopup(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  _showAddMixerPopup(context) {
    final _formKey = GlobalKey<FormState>();
    final mixerNameController = TextEditingController();
    bool mixerAddedSuccessfully = false;
    final bool isLoading = false;
    Alert(
        context: context,
        title: "اضافة خلاطة",
        content: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: mixerNameController,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'رجاء ادخال اسم الخلاطة';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    hintText: 'اسم الخلاطة',
                    hintStyle: Theme.of(context).textTheme.bodyText1,
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue))),
              ),
            ],
          ),
        ),
        buttons: [
          DialogButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {}
              String mixerName = mixerNameController.text;
              Mixer mixer = Mixer(
                name: mixerName,
              );
              await mixerDBService.addMixer(mixer);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content:
                    Text("تمت اضافة الخلاطة بنجاح، قم باعادة تحميل الصفحة"),
                backgroundColor: Colors.green,
              ));
            },
            child: Text(
              "اضافة",
              style: Theme.of(context).textTheme.button,
            ),
          )
        ]).show();
  }
}
