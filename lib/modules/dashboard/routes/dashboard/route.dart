import 'package:flutter/material.dart';
import 'package:lunasea/core.dart';

import '../../core/database.dart';
import '../../core/router.dart';
import '../calendar/route.dart';
import '../modules/route.dart';
import 'widgets/appbar_switch_view_action.dart';
import 'widgets/navigation_bar.dart';

class HomeRouter extends DashboardPageRouter {
  HomeRouter() : super('/dashboard');

  @override
  Home widget() => const Home();

  @override
  void defineRoute(FluroRouter router) =>
      super.noParameterRouteDefinition(router);
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _State();
}

class _State extends State<Home> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  LunaPageController? _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = LunaPageController(
      initialPage: DashboardDatabaseValue.NAVIGATION_INDEX.data,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LunaScaffold(
      scaffoldKey: _scaffoldKey,
      module: LunaModule.DASHBOARD,
      body: _body(),
      drawer: _drawer(),
      appBar: _appBar() as PreferredSizeWidget?,
      bottomNavigationBar: _bottomNavigationBar(),
    );
  }

  Widget _drawer() => LunaDrawer(page: LunaModule.DASHBOARD.key);

  Widget _bottomNavigationBar() =>
      DashboardNavigationBar(pageController: _pageController);

  Widget _appBar() {
    return LunaAppBar(
      title: 'LunaSea',
      useDrawer: true,
      scrollControllers: DashboardNavigationBar.scrollControllers,
      pageController: _pageController,
      actions: [
        DashboardAppBarSwitchViewAction(pageController: _pageController)
      ],
    );
  }

  Widget _body() {
    return LunaDatabaseValue.ENABLED_PROFILE.listen(
      builder: (context, _, __) => LunaPageView(
        controller: _pageController,
        children: _tabs,
      ),
    );
  }

  List<Widget> get _tabs => [
        const DashboardModulesRoute(),
        const DashboardCalendarRoute(),
      ];
}
