import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/database.dart';

class AddUserPage extends StatefulWidget {
  const AddUserPage({super.key});

  static Future<void> show(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AddUserPage(),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  State<AddUserPage> createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: const Text(
          "New Users",
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              "Save",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
      body: _buildContents(context),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContents(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(context),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(context),
      ),
    );
  }

  List<Widget> _buildFormChildren(BuildContext context) {
    List<String> menuItems = ["Trainer", "Admin", "Member"];
    List<String> menuMemberShip = ["Personal Training", "Normal"];
    final databases = Provider.of<Database>(context, listen: false);
    final roleStreamList = databases.getAllRole();
    roleStreamList.listen((listOfRole) {
      for (var role in listOfRole) {
        menuItems.add(role.roleName);
      }
    });

    String selectedValue = "Member";
    String selectedMemberShipValue = "Normal";
    return [
      TextFormField(
        decoration: const InputDecoration(
          labelText: "User Name",
        ),
      ),
      TextFormField(
        decoration: const InputDecoration(
          labelText: "Email",
        ),
        keyboardType: TextInputType.emailAddress,
      ),
      TextFormField(
        decoration: const InputDecoration(
          labelText: "Phone number",
        ),
        keyboardType: TextInputType.phone,
      ),
      DropdownButtonFormField(
        hint: const Text("Select the role"),
        value: selectedValue,
        items: menuItems.map((e) {
          return DropdownMenuItem(
            value: e,
            child: Text(e), //value of item
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            selectedValue = newValue!;
          });
        },
      ),
      TextFormField(
        decoration: const InputDecoration(
          labelText: "Age",
        ),
        keyboardType: const TextInputType.numberWithOptions(
            decimal: false, signed: false),
      ),
      TextFormField(
        decoration: const InputDecoration(
          labelText: "Blood Pressure",
          hintText: "Example: 165/100",
        ),
        keyboardType:
            const TextInputType.numberWithOptions(decimal: true, signed: true),
      ),
      TextFormField(
        decoration: const InputDecoration(
          labelText: "Weight",
          hintText: "Example: 80 kg",
        ),
      ),
      TextFormField(
        decoration: const InputDecoration(
          labelText: "Height",
          hintText: "Example: 180 cm",
        ),
      ),
      DropdownButtonFormField(
        hint: const Text("Select the Member Ship Plan"),
        value: selectedMemberShipValue,
        items: menuMemberShip.map((e) {
          return DropdownMenuItem(
            value: e,
            child: Text(e), //value of item
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            selectedMemberShipValue = newValue!;
          });
        },
      ),
      TextFormField(
        // focusNode: _focusNode,
        keyboardType: TextInputType.phone,
        autocorrect: false,
        //controller: intialdateval,
        onSaved: (value) {
          // data.registrationdate = value;
        },
        onTap: () {
          // _selectDate();
          FocusScope.of(context).requestFocus(FocusNode());
        },

        maxLines: 1,
        //initialValue: 'Aseem Wangoo',
        validator: (value) {
          return null;
        },
        decoration: const InputDecoration(
          labelText: 'Registration Date.',
          //filled: true,
          icon: Icon(Icons.calendar_today),
          labelStyle: TextStyle(decorationStyle: TextDecorationStyle.solid),
        ),
      ),
      const SizedBox(
        height: 20,
      )
    ];
  }
}
