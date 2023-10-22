import 'package:flutter/material.dart';
import 'package:lunasea/core.dart';
import 'package:lunasea/database/models/external_module.dart';
import 'package:lunasea/modules/settings.dart';
import 'package:lunasea/widgets/pages/invalid_route.dart';

class ConfigurationExternalModulesAddHeadersRoute extends StatefulWidget {
  final LunaExternalModule? externalModule;

  const ConfigurationExternalModulesAddHeadersRoute({
    Key? key,
    required this.externalModule,
  }) : super(key: key);

  @override
  State<ConfigurationExternalModulesAddHeadersRoute> createState() => _State();
}

class _State extends State<ConfigurationExternalModulesAddHeadersRoute>
    with LunaScrollControllerMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    if (widget.externalModule == null) {
      return InvalidRoutePage(
        title: 'settings.CustomHeaders'.tr(),
        message: 'settings.ModuleNotFound'.tr(),
      );
    }

    return LunaScaffold(
      scaffoldKey: _scaffoldKey,
      appBar: _appBar(),
      body: _body(),
      bottomNavigationBar: _bottomActionBar(),
    );
  }

  PreferredSizeWidget _appBar() {
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
          onTap: () async {
            await HeaderUtility()
                .addHeader(context, headers: widget.externalModule!.headers);
            if (mounted) setState(() {});
          },
        ),
      ],
    );
  }

  Widget _body() {
    return LunaListView(
      controller: scrollController,
      children: [
        if (widget.externalModule!.headers.isEmpty)
          LunaMessage.inList(text: 'settings.NoHeadersAdded'.tr()),
        ..._list(),
      ],
    );
  }

  List<Widget> _list() {
    final headers = widget.externalModule!.headers.cast<String, dynamic>();
    List<String> _sortedKeys = headers.keys.toList()..sort();
    return _sortedKeys
        .map<LunaBlock>((key) => _headerTile(key, headers[key]))
        .toList();
  }

  LunaBlock _headerTile(String key, String? value) {
    return LunaBlock(
      title: key.toString(),
      body: [TextSpan(text: value.toString())],
      trailing: LunaIconButton(
        icon: LunaIcons.DELETE,
        color: LunaColours.red,
        onPressed: () async {
          await HeaderUtility().deleteHeader(
            context,
            headers: widget.externalModule!.headers,
            key: key,
          );
          if (mounted) setState(() {});
        },
      ),
    );
  }
}
