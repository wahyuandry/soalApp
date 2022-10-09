import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latihan_soal/constants/r.dart';
import 'package:latihan_soal/models/banner_list.dart';
import 'package:latihan_soal/models/mapel_list.dart';
import 'package:latihan_soal/models/network_response.dart';
import 'package:latihan_soal/repository/latihan_soal_api.dart';
import 'package:latihan_soal/view/main/latihan_soal/mapel_page.dart';
import 'package:latihan_soal/view/main/latihan_soal/paket_soal_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  MapelList? mapelList;
  getMapel() async {
    final mapelResult = await LatihanSoalApi().getMapel();
    if (mapelResult.status == Status.success) {
      mapelList = MapelList.fromJson(mapelResult.data!);
      setState(() {});
    }
  }

  BannerList? bannerList;
  getBanner() async {
    final mapelResult = await LatihanSoalApi().getBanner();
    if (mapelResult.status == Status.success) {
      bannerList = BannerList.fromJson(mapelResult.data!);
      setState(() {});
    }
  }

  setupFcm() async {
// Get any messages which caused the application to open from
    // a terminated state.
    final tokenFcm = await FirebaseMessaging.instance.getToken();
    print("tokenfcm: $tokenFcm");
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    // if (initialMessage != null) {
    //   _handleMessage(initialMessage);
    // }

    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');
    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen((event) {});
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMapel();
    getBanner();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: R.colors.grey,
      body: SafeArea(
        child: ListView(
          children: [
            _buildUserHomeProfile(),
            _buildTopBanner(context),
            _buildHomeListMapel(mapelList),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Terbaru",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  bannerList == null
                      ? Container(
                          height: 70,
                          width: double.infinity,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : Container(
                          height: 150,
                          child: ListView.builder(
                            itemCount: bannerList!.data!.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: ((context, index) {
                              final currentBanner = bannerList!.data![index];
                              return Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      currentBanner.eventImage!,
                                    ),
                                  ));
                            }),
                          ),
                        ),
                  SizedBox(height: 35),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Container _buildHomeListMapel(MapelList? list) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 21),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Pilih Pelajaran",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Spacer(),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return MapelPage(mapel: mapelList!);
                      },
                    ),
                  );
                },
                child: Text(
                  "Lihat Semua",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: R.colors.primary,
                  ),
                ),
              ),
            ],
          ),
          list == null
              ? Container(
                  height: 70,
                  width: double.infinity,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: list.data!.length > 3 ? 3 : list.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    final currentMapel = list.data![index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: ((context) =>
                                PaketSoalPage(id: currentMapel.courseId!)),
                          ),
                        );
                      },
                      child: MapelWidget(
                        title: currentMapel.courseName!,
                        totalPacket: currentMapel.jumlahMateri!,
                        totalDone: currentMapel.jumlahDone!,
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }

  Container _buildTopBanner(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 20.0,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 15,
      ),
      decoration: BoxDecoration(
        color: R.colors.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      height: 147,
      width: double.infinity,
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.5,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 15,
              ),
              child: Text(
                "Mau kerjain latihan soal apa hari ini?",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Image.asset(
              R.assets.imgHome,
              width: MediaQuery.of(context).size.width * 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Padding _buildUserHomeProfile() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 15,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hi, ",
                  style: GoogleFonts.poppins().copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  "Selamat Datang",
                  style: GoogleFonts.poppins().copyWith(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Image.asset(
            R.assets.imgUser,
            width: 35,
            height: 35,
          ),
        ],
      ),
    );
  }
}

class MapelWidget extends StatelessWidget {
  const MapelWidget({
    Key? key,
    required this.title,
    required this.totalDone,
    required this.totalPacket,
  }) : super(key: key);

  final String title;
  final int? totalDone;
  final int? totalPacket;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 21),
      child: Row(
        children: [
          Container(
            height: 53,
            width: 53,
            padding: EdgeInsets.all(13),
            child: Image.asset(R.assets.icAtom),
          ),
          SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                Text(
                  "$totalDone/$totalPacket Paket latihan soal",
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 12,
                    color: R.colors.greySubtitle,
                  ),
                ),
                SizedBox(height: 5),
                Stack(
                  children: [
                    Container(
                      height: 10,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: R.colors.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    Container(
                      height: 10,
                      width: MediaQuery.of(context).size.width * 0.4,
                      decoration: BoxDecoration(
                        color: R.colors.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
