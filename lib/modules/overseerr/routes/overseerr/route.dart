import 'package:flutter/material.dart';
import 'package:lunasea/core.dart';
import 'package:lunasea/modules/overseerr.dart';

class OverseerrRoute extends StatefulWidget {
  const OverseerrRoute({
    Key? key,
  }) : super(key: key);

  @override
  State<OverseerrRoute> createState() => _State();
}

class _State extends State<OverseerrRoute> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  LunaPageController? _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = LunaPageController(
      initialPage: OverseerrDatabase.NAVIGATION_INDEX.read(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LunaScaffold(
      scaffoldKey: _scaffoldKey,
      module: LunaModule.OVERSEERR,
      drawer: _drawer(),
      appBar: _appBar(),
      bottomNavigationBar: _bottomNavigationBar(),
      body: _body(),
    );
  }

  Widget _drawer() {
    return LunaDrawer(page: LunaModule.OVERSEERR.key);
  }

  Widget? _bottomNavigationBar() {
    if (context.read<OverseerrState>().enabled) {
      return OverseerrNavigationBar(pageController: _pageController);
    }
    return null;
  }

  PreferredSizeWidget _appBar() {
    List<String> profiles = LunaBox.profiles.keys.fold(
      [],
      (value, element) {
        if (LunaBox.profiles.read(element)!.overseerrEnabled) {
          value.add(element);
        }
        return value;
      },
    );
    List<Widget>? actions;
    if (context.watch<OverseerrState>().enabled) actions = [];
    return LunaAppBar.dropdown(
      title: LunaModule.OVERSEERR.title,
      useDrawer: true,
      profiles: profiles,
      actions: actions,
      pageController: _pageController,
      scrollControllers: OverseerrNavigationBar.scrollControllers,
    );
  }

  Widget _body() {
    return Selector<OverseerrState, bool?>(
      selector: (_, state) => state.enabled,
      builder: (context, enabled, _) {
        if (!enabled!) {
          return LunaMessage.moduleNotEnabled(
            context: context,
            module: LunaModule.OVERSEERR.title,
          );
        }
        return LunaPageView(
          controller: _pageController,
          children: const [
            OverseerrRequestsRoute(),
            OverseerrIssuesRoute(),
            OverseerrUserRoute(),
          ],
        );
      },
    );
  }
}
