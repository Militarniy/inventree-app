import "package:inventree/app_colors.dart";
import "package:inventree/settings/settings.dart";
import "package:inventree/user_profile.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";

import "package:inventree/l10.dart";

import "package:font_awesome_flutter/font_awesome_flutter.dart";

import "package:inventree/barcode.dart";
import "package:inventree/api.dart";

import "package:inventree/settings/login.dart";

import "package:inventree/widget/category_display.dart";
import "package:inventree/widget/company_list.dart";
import "package:inventree/widget/location_display.dart";
import "package:inventree/widget/purchase_order_list.dart";
import 'package:inventree/widget/search.dart';
import "package:inventree/widget/snacks.dart";
import "package:inventree/widget/drawer.dart";

class InvenTreeHomePage extends StatefulWidget {

  const InvenTreeHomePage({Key? key}) : super(key: key);

  @override
  _InvenTreeHomePageState createState() => _InvenTreeHomePageState();
}

class _InvenTreeHomePageState extends State<InvenTreeHomePage> {

  _InvenTreeHomePageState() : super() {

    // Initially load the profile and attempt server connection
    _loadProfile();
  }

  final GlobalKey<_InvenTreeHomePageState> _homeKey = GlobalKey<_InvenTreeHomePageState>();

  // Selected user profile
  UserProfile? _profile;

  void _search(BuildContext context) {
    if (!InvenTreeAPI().checkConnection(context)) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchWidget()
      )
    );

  }

  void _scan(BuildContext context) {
    if (!InvenTreeAPI().checkConnection(context)) return;

    scanQrCode(context);
  }

  void _showParts(BuildContext context) {
    if (!InvenTreeAPI().checkConnection(context)) return;

    Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryDisplayWidget(null)));
  }

  void _showSettings(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => InvenTreeSettingsWidget()));
  }

  /*
  void _showStarredParts(BuildContext context) {
    if (!InvenTreeAPI().checkConnection(context)) return;

    // TODO
    // Navigator.push(context, MaterialPageRoute(builder: (context) => StarredPartWidget()));
  }
   */

  void _showStock(BuildContext context) {
    if (!InvenTreeAPI().checkConnection(context)) return;

    Navigator.push(context, MaterialPageRoute(builder: (context) => LocationDisplayWidget(null)));
  }

  void _showPurchaseOrders(BuildContext context) {
    if (!InvenTreeAPI().checkConnection(context)) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PurchaseOrderListWidget()
      )
    );
  }


  void _showSuppliers(BuildContext context) {
    if (!InvenTreeAPI().checkConnection(context)) return;

    Navigator.push(context, MaterialPageRoute(builder: (context) => CompanyListWidget(L10().suppliers, {"is_supplier": "true"})));
  }

  void _showManufacturers(BuildContext context) {
    if (!InvenTreeAPI().checkConnection(context)) return;

    Navigator.push(context, MaterialPageRoute(builder: (context) => CompanyListWidget(L10().manufacturers, {"is_manufacturer": "true"})));
  }

  void _showCustomers(BuildContext context) {
    if (!InvenTreeAPI().checkConnection(context)) return;

    Navigator.push(context, MaterialPageRoute(builder: (context) => CompanyListWidget(L10().customers, {"is_customer": "true"})));
  }

  void _selectProfile() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => InvenTreeLoginSettingsWidget())
    ).then((context) {
      // Once we return
      _loadProfile();
    });
  }

  Future <void> _loadProfile() async {

    _profile = await UserProfileDBManager().getSelectedProfile();

    // A valid profile was loaded!
    if (_profile != null) {
      if (!InvenTreeAPI().isConnected() && !InvenTreeAPI().isConnecting()) {

        // Attempt server connection
        InvenTreeAPI().connectToServer().then((result) {
          setState(() {});
        });
      }
    }

    setState(() {});
  }


  Widget _iconButton(BuildContext context, String label, IconData icon, {Function()? callback, String role = "", String permission = ""}) {

    bool connected = InvenTreeAPI().isConnected();

    bool allowed = true;

    if (role.isNotEmpty || permission.isNotEmpty) {
      allowed = InvenTreeAPI().checkPermission(role, permission);
    }

    return GestureDetector(
      child: Card(
        margin: EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 10
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              icon,
              color: connected && allowed ? COLOR_CLICK : Colors.grey,
            ),
            Divider(
              height: 10,
              thickness: 0,
            ),
            Text(
              label,
            ),
          ]
        )
      ),
      onTap: () {

        if (!allowed) {
          showSnackIcon(
            L10().permissionRequired,
            icon: FontAwesomeIcons.exclamationCircle,
            success: false,
          );

          return;
        }

        if (callback != null) {
          callback();
        }

      },
    );
  }

  List<Widget> getGridTiles(BuildContext context) {
    return [
      _iconButton(
          context,
          L10().scanBarcode,
          FontAwesomeIcons.barcode,
          callback: () {
            _scan(context);
          }
      ),
      _iconButton(
          context,
          L10().search,
          FontAwesomeIcons.search,
          callback: () {
            _search(context);
          }
      ),
      _iconButton(
          context,
          L10().parts,
          FontAwesomeIcons.shapes,
          callback: () {
            _showParts(context);
          }
      ),

      // TODO - Re-add starred parts link
      /*
            Column(
              children: <Widget>[
                IconButton(
                  icon: FaIcon(FontAwesomeIcons.solidStar),
                  onPressed: () {

                  },
                ),
                Text("Starred Parts"),
              ]
            ),
             */

      _iconButton(
          context,
          L10().stock,
          FontAwesomeIcons.boxes,
          callback: () {
            _showStock(context);
          }
      ),
      _iconButton(
          context,
          L10().purchaseOrders,
          FontAwesomeIcons.shoppingCart,
          callback: () {
            _showPurchaseOrders(context);
          }
      ),
      /*
      _iconButton(
        context,
        L10().salesOrders,
        FontAwesomeIcons.truck,
      ),
       */
      _iconButton(
          context,
          L10().suppliers,
          FontAwesomeIcons.building,
          callback: () {
            _showSuppliers(context);
          }
      ),
      _iconButton(
          context,
          L10().manufacturers,
          FontAwesomeIcons.industry,
          callback: () {
            _showManufacturers(context);
          }
      ),
      _iconButton(
          context,
          L10().customers,
          FontAwesomeIcons.userTie,
          callback: () {
            _showCustomers(context);
          }
      ),
      _iconButton(
        context,
        L10().settings,
        FontAwesomeIcons.cogs,
        callback: () {
          _showSettings(context);
        }
      )
    ];
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _homeKey,
      appBar: AppBar(
        title: Text(L10().appTitle),
        actions: [
          IconButton(
            icon: FaIcon(
              FontAwesomeIcons.server,
              color: InvenTreeAPI().isConnected() ? COLOR_SUCCESS : COLOR_DANGER,
            ),
            onPressed: _selectProfile,
          )
        ],
      ),
      drawer: InvenTreeDrawer(context),
      body: ListView(
        children: [
          GridView.extent(
            maxCrossAxisExtent: 140,
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            children: getGridTiles(context),
          ),
        ],
      ),
    );
  }
}
