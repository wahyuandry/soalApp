import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:latihan_soal/constants/r.dart';
import 'package:latihan_soal/models/kerjakan_soal_list.dart';
import 'package:latihan_soal/models/network_response.dart';
import 'package:latihan_soal/repository/latihan_soal_api.dart';

class KerjakanLatihanSoalPage extends StatefulWidget {
  const KerjakanLatihanSoalPage({
    Key? key,
    required this.id,
  }) : super(key: key);
  final String id;

  @override
  State<KerjakanLatihanSoalPage> createState() =>
      _KerjakanLatihanSoalPageState();
}

class _KerjakanLatihanSoalPageState extends State<KerjakanLatihanSoalPage>
    with SingleTickerProviderStateMixin {
  KerjakanSoalList? soalList;
  getQuestionList() async {
    final result = await LatihanSoalApi().postQuestionList(widget.id);
    if (result.status == Status.success) {
      soalList = KerjakanSoalList.fromJson(result.data!);
      _controller = TabController(length: soalList!.data!.length, vsync: this);
      _controller!.addListener(() {
        setState(() {});
      });
      setState(() {});
    }
  }

  TabController? _controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getQuestionList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Latihan Soal"),
      ),
      //tombol selanjutnya/submit
      bottomNavigationBar: _controller == null
          ? SizedBox(height: 0)
          : Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: R.colors.primary,
                      fixedSize: Size(153, 33),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () async {
                      if (_controller!.index == soalList!.data!.length - 1) {
                        final result = await showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return BottomsheetConfirmation();
                            });
                        if (result == true) {
                          print("kirim");
                        }
                      } else {
                        _controller!.animateTo(_controller!.index + 1);
                      }
                    },
                    child: Text(
                      _controller?.index == soalList!.data!.length - 1
                          ? "Kumpulin"
                          : "Selanjutnya",
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
      body: soalList == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                //tabBar nomor soal
                Container(
                  child: TabBar(
                    controller: _controller,
                    tabs: List.generate(
                      soalList!.data!.length,
                      (index) => Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                //tabBar soal
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: TabBarView(
                      controller: _controller,
                      children: List.generate(
                        soalList!.data!.length,
                        (index) => SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Soal no ${index + 1}",
                                style: TextStyle(
                                  color: R.colors.greySubtitleHome,
                                  fontSize: 12,
                                ),
                              ),
                              if (soalList!.data![index].questionTitle != null)
                                Html(
                                    data: soalList!.data![index].questionTitle!,
                                    style: {
                                      "body": Style(
                                        padding: EdgeInsets.zero,
                                      ),
                                      "p": Style(
                                        fontSize: FontSize(12),
                                      )
                                    }),
                              if (soalList!.data![index].questionTitleImg !=
                                  null)
                                Image.network(
                                    soalList!.data![index].questionTitleImg!),
                              _buildOption(
                                "A",
                                soalList!.data![index].optionA,
                                soalList!.data![index].optionAImg,
                                index,
                              ),
                              _buildOption(
                                "B",
                                soalList!.data![index].optionB,
                                soalList!.data![index].optionBImg,
                                index,
                              ),
                              _buildOption(
                                "C",
                                soalList!.data![index].optionC,
                                soalList!.data![index].optionCImg,
                                index,
                              ),
                              _buildOption(
                                "D",
                                soalList!.data![index].optionD,
                                soalList!.data![index].optionDImg,
                                index,
                              ),
                              _buildOption(
                                "E",
                                soalList!.data![index].optionE,
                                soalList!.data![index].optionEImg,
                                index,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildOption(
      String option, String? answer, String? answerImg, int index) {
    final answerCheck = soalList!.data![index].studentAnswer == option;

    return GestureDetector(
      onTap: () {
        soalList!.data![index].studentAnswer = option;
        setState(() {});
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        margin: EdgeInsets.symmetric(vertical: 2),
        decoration: BoxDecoration(
            color: answerCheck ? Colors.blue.withOpacity(0.4) : Colors.white,
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            Text(
              option + ".",
              style: TextStyle(
                color: answerCheck ? Colors.white : Colors.black,
              ),
            ),
            if (answer != null)
              Expanded(
                  child: Html(
                data: answer,
                style: {
                  "p": Style(
                    color: answerCheck ? Colors.white : Colors.black,
                  )
                },
              )),
            if (answerImg != null) Expanded(child: Image.network(answerImg)),
          ],
        ),
      ),
    );
  }
}

class BottomsheetConfirmation extends StatefulWidget {
  const BottomsheetConfirmation({
    Key? key,
  }) : super(key: key);

  @override
  State<BottomsheetConfirmation> createState() =>
      _BottomsheetConfirmationState();
}

class _BottomsheetConfirmationState extends State<BottomsheetConfirmation> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            width: 100,
            height: 5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: R.colors.greySubtitle,
            ),
          ),
          SizedBox(height: 15),
          Image.asset(R.assets.icConfirmatio),
          SizedBox(height: 15),
          Text("Kumpulkan latihan soal sekarang?"),
          Text("Boleh langsung kumpulin dong"),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text("Nanti dulu"),
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text("Ya"),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
