import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:silkroute/methods/isauthenticated.dart';
import 'package:silkroute/methods/showdailog.dart';
import 'package:silkroute/model/services/ResellerHomeApi.dart';
import 'package:silkroute/view/widget/carousel_indicator.dart';
import 'package:silkroute/view/widget/footer.dart';
import 'package:silkroute/view/widget/horizontal_list_view.dart';
import 'package:silkroute/view/widget/navbar.dart';
import 'package:silkroute/view/widget/topIcon.dart';
import 'package:silkroute/view/widget/top_picks.dart';
import 'package:silkroute/view/widget/topbar.dart';

class ResellerHome extends StatefulWidget {
  @override
  _ResellerHomeState createState() => _ResellerHomeState();
}

class _ResellerHomeState extends State<ResellerHome> {
  bool loading = true;

  List<dynamic> adList = [];

  List<dynamic> categories = [];

  void loadVars() async {
    List<dynamic> categoriess = await ResellerHomeApi().getCategories();
    List<dynamic> adLists = await ResellerHomeApi().getOffers();
    setState(() {
      categories = categoriess;
      adList = adLists;
      loading = false;
    });
  }

  @override
  void initState() {
    if (!Methods().isAuthenticated()) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        NotRegisteredDialogMethod().check(context);
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        loadVars();
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {FocusManager.instance.primaryFocus.unfocus()},
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        drawer: Navbar(),
        primary: false,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/1.png"),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            children: <Widget>[
              //////////////////////////////
              ///                        ///
              ///         TopBar         ///
              ///                        ///
              //////////////////////////////

              TopBar(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.08),

              Expanded(
                child: CustomScrollView(slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate([
                      //////////////////////////////
                      ///                        ///
                      ///   Categories Section   ///
                      ///                        ///
                      //////////////////////////////

                      loading
                          ? Container(
                              height: MediaQuery.of(context).size.height * 0.2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    height: 30,
                                    width: 30,
                                    child: CircularProgressIndicator(
                                      color: Color(0xFF5B0D1B),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : HorizontalListView("CATEGORIES", categories),

                      SizedBox(height: 20),

                      //////////////////////////////
                      ///                        ///
                      ///    Carousel Section    ///
                      ///                        ///
                      //////////////////////////////

                      loading
                          ? Container(
                              height: MediaQuery.of(context).size.height * 0.2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    height: 30,
                                    width: 30,
                                    child: CircularProgressIndicator(
                                      color: Color(0xFF5B0D1B),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : CarouselWithIndicator(adList),

                      //////////////////////////////
                      ///                        ///
                      ///        TopPicks        ///
                      ///                        ///
                      //////////////////////////////

                      TopPicks(),
                    ]),
                  ),
                  SliverFillRemaining(hasScrollBody: false, child: Container()),
                ]),
              ),
              //////////////////////////////
              ///                        ///
              ///         Footer         ///
              ///                        ///
              //////////////////////////////
              Footer(),
            ],
          ),
        ),
        // bottomNavigationBar: Footer(),
      ),
    );
  }
}
