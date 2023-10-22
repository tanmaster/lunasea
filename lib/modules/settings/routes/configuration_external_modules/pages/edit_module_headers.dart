import 'package:flutter/material.dart';
import 'package:lunasea/core.dart';
import 'package:lunasea/modules/settings.dart';
import 'package:lunasea/widgets/pages/invalid_route.dart';
import 'package:lunasea/database/models/external_module.dart';

class ConfigurationExternalModulesEditHeadersRoute extends StatefulWidget {
  final int id;

  const ConfigurationExternalModulesEditHeadersRoute({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<ConfigurationExternalModulesEditHeadersRoute> createState() => _State();
}

class _State extends State<ConfigurationExternalModulesEditHeadersRoute>
    with LunaScrollControllerMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  LunaExternalModule? _externalModule;

  @override
  Widget build(BuildContext context) {
    if (widget.id < 0 || !LunaBox.externalModules.contains(widget.id)) {
      return InvalidRoutePage(
        title: 'settings.CustomHeaders'.tr(),
        message: 'settings.ModuleNotFound'.tr(),
      );
    }

    return LunaScaffold(
      scaffoldKey: _scaffoldKey,
      appBar: _appBar() as PreferredSizeWidget?,
      body: _body(),
      bottomNavigationBar: _bottomActionBar(),
    );
  }

  Widget _appBar() {
    return LunaAppBar(
      title: 'settings.CustomHeaders'.tr(),
      scrollControllers: [scrollController],
    );
  }

  Widget _bottomActionBar() {
    return LunaBottomActionBar(
      actions: [
        LunaButton.text(
          text: 'settings.AddHeader'.tr(),
          icon: Icons.add_rounded,
          onTap: () async => HeaderUtility().addHeader(context,
              headers: _externalModule!.headers, externalModule: _externalModule),
        ),
      ],
    );
  }

  Widget _body() {
    return LunaBox.externalModules.listenableBuilder(
      selectKeys: [widget.id],
      builder: (context, _) {
        if (!LunaBox.externalModules.contains(widget.id)) return Container();
        _externalModule = LunaBox.externalModules.read(widget.id);
        return LunaListView(
          controller: scrollController,
          children: [
            if (_externalModule!.headers.isEmpty)
              LunaMessage.inList(text: 'settings.NoHeadersAdded'.tr()),
            ..._list(),
          ],
        );
      },
    );
  }

  List<Widget> _list() {
    final headers = _externalModule!.headers.cast<String, dynamic>();
    List<String> _sortedKeys = headers.keys.toList()..sort();
    return _sortedKeys
        .map<LunaBlock>((key) => _headerBlock(key, headers[key]))
        .toList();
  }

  LunaBlock _headerBlock(String key, String? value) {
    return LunaBlock(
      title: key.toString(),
      body: [TextSpan(text: value.toString())],
      trailing: LunaIconButton(
        icon: LunaIcons.DELETE,
        color: LunaColours.red,
        onPressed: () async => HeaderUtility().deleteHeader(
          context,
          headers: _externalModule!.headers,
          key: key,
          externalModule: _externalModule,
        ),
      ),
    );
  }
}
