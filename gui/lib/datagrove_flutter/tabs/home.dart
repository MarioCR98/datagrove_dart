// display a view, maybe editable
import 'dart:typed_data';

import 'package:cupertino_list_tile/cupertino_list_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:universal_html/html.dart';
import '../client/datagrove_flutter.dart';
import '../ui/menu.dart';
import 'package:provider/provider.dart';

import 'range.dart';

// is the state for this kept alive?
class HomeTab extends StatefulWidget {
  Widget title;
  String label;
  Function()? add;

  HomeTab({required this.title, required this.label, Key? key, this.add})
      : super(key: key);

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final controller = RangeController<DirectoryEntry>();
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  // pins show on the top/recent page
  @override
  initState() {
    super.initState();
    controller.range(context.read<Dgf>());
  }

  Widget build2(BuildContext context) {
    final fileMenu = [
      Cmd(id: "share", label: "Share"),
    ];
    // this would be cheaper as a global?
    FileStyle style = Dgf.of(context).fileStyle;
    return RangeBuilder<DirectoryEntry>(
        controller: controller,
        // this is the builder for RangeBuilder's animated list.
        builder: (c, DirectoryEntry d) {
          return CupertinoListTile(
            leading: style.folder,
            trailing: CupertinoButton(
              child: Icon(CupertinoIcons.ellipsis),
              onPressed: () {},
            ),
            title: Text(d.name ?? "untitled"),
            //subtitle: Text("${d.size??0} bytes"),
            onTap: () {
              if (fileMenu != null) {
                showCmd(context, fileMenu!);
              }
            },
            onLongPress: () {},
          );
        });
  }

  // when the search bar or magnifying clicked we should route to the search
  // page with relevant arguments. How do we feel about the hidden search of apple?
  // the slide up/fade effect is nice instead of a full route slide

  // we need a cursor or table or something here for listing
  @override
  Widget build(BuildContext context) {
    final addMenu = [
      Cmd(label: "Community", then: () async {}),
    ];

    final pageMenu = [
      Cmd(id: "share", label: "Share"),
      Cmd(
          label: "Open in Finder",
          then: () async {
            final d = Dgf.of(context);
            // bool ok = await launchUrl(
            //     Uri.parse("file://${d.localFileServer.localRoot}"));
          })
    ];

    return PageScaffold(
        leading: Container(),
        title: widget.title,
        add: () async {
          // we should skip this if there is exactly one thing to create.
          // but we might want to always support folders

          final m = await showCmd(context, addMenu);
          // could create a datum, a stream (of some kind), or a file of some kind
          // depending on the context.
          // this is is creating an object in the namespace of this page.
          // the top namespace
          if (m != null) {
            await m.then!();
          }
        },
        // menu at top of the page.
        menu: () async {
          final m = await showCmd(context, pageMenu);
          if (m != null) {
            await m.then!();
          }
        },
        search: "",
        slivers: [build2(context)]);
  }
}

/*
 HeadingSliver("📌 Pin", first: true),
        _title("🕒 Featured"),
        _list(),
        _title("🏘️ More"),
        _list(),
*/

// these tabs must be able to get their trees from the user's app controller
// maybe with a delegate? maybe force their controller to extend one we know?
const friend = "🤝";

Widget HeadingSliver(String s, {bool first = false}) {
  return SliverToBoxAdapter(
      child: Padding(
    padding: EdgeInsets.only(left: 8.0, top: first ? 0 : 20, bottom: 8),
    child: Text(s, style: headerStyle),
  ));
}

// abstract class AppDelegate {
//   TreeController<ChatThread> get chatThread;
// }

// late AppDelegate dgapp;

class ChatTab extends StatefulWidget {
  const ChatTab({Key? key}) : super(key: key);

  @override
  State<ChatTab> createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> {
  @override
  Widget build(BuildContext context) {
    return PageScaffold(
        leading: Container(),
        title: Text('💬 Chat'),
        search: 'Chats',
        slivers: [HeadingSliver("📌 Pin", first: true), ListSliver2()]);
  }
}

class ContactTab extends StatefulWidget {
  const ContactTab({Key? key}) : super(key: key);

  @override
  State<ContactTab> createState() => _ContactTabState();
}

class _ContactTabState extends State<ContactTab> {
  @override
  Widget build(BuildContext context) {
    return PageScaffold(
        leading: Container(),
        title: Text('$friend Contact'),
        search: 'Contacts',
        slivers: [HeadingSliver("📌 Pin", first: true), ListSliver2()]);
  }
}

// this is a temporary thing, needed to keep things compiling.

/*
          ListSliver2(),
          HeadingSliver("🕒 Recent"),
          ListSliver2(),
          HeadingSliver("👍 Favorites"),
          ListSliver2(),
          HeadingSliver("🤗 Awesome"),
          ListSliver2(),
CustomScrollView(
      slivers: [
        CupertinoSliverNavigationBar(
            largeTitle: widget.title,
            leading: Container(),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
              CupertinoButton(
                  child: Icon(CupertinoIcons.add_circled), onPressed: _add),
              CupertinoButton(
                  child: Icon(CupertinoIcons.ellipsis_vertical),
                  onPressed: () {
                    showActionSheet(
                        context, <Cmd>[Cmd(id: 'import', label: 'Import')]);
                  }),
            ])),

        */
