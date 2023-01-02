import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_app/App/home/model/user.dart';

import '../../../services/database.dart';
import '../../common_widgets/show_exception_alert_dialog.dart';

class AddUserPage extends StatefulWidget {
  const AddUserPage({super.key, this.users});
  final Users? users;

  static Future<void> show(BuildContext context, {Users? users}) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddUserPage(
          users: users,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  State<AddUserPage> createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final _formkey = GlobalKey<FormState>();

  String _name = '';
  String _email = '';
  String _phoneNumber = '';
  String _role = 'Member';
  String _age = '';
  String _height = '';
  String _weight = '';
  String _bp = '';
  String _membership = 'Normal';

  @override
  void initState() {
    super.initState();
    if (widget.users != null) {
      _name = widget.users!.name;
      _email = widget.users!.email;

      _phoneNumber = widget.users!.phoneNumber;
      _role = widget.users!.roleUid;
      _age = widget.users!.age;
      _height = widget.users!.height;
      _weight = widget.users!.weight;
      _membership = widget.users!.memberShipUid!;
      _bp = widget.users!.bp;
    }
  }

  bool _validateAndSaveForm() {
    final form = _formkey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit(BuildContext context) async {
    if (_validateAndSaveForm()) {
      try {
        final database = Provider.of<Database>(context, listen: false);
        await database.createUser(
          Users(
              age: _age,
              bp: _bp,
              dateOfJoining: DateTime.now().toString(),
              email: _email,
              height: _height,
              name: _name,
              phoneNumber: _phoneNumber,
              roleUid: _role,
              weight: _weight,
              memberShipUid: _membership),
        );
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      } on Exception catch (e) {
        showExceptionAlertDialog(
          context,
          title: "Operation failed",
          exception: e,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(
          widget.users == null ? "New Users" : "Edit Users",
        ),
        actions: [
          TextButton(
            onPressed: () => _submit(context),
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
      key: _formkey,
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
        initialValue: _name,
        decoration: const InputDecoration(
          labelText: "User Name",
        ),
        validator: (value) => value!.isNotEmpty ? null : "Name can't be empty.",
        onSaved: (newValue) => _name = newValue!,
      ),
      TextFormField(
        initialValue: _email,
        decoration: const InputDecoration(
          labelText: "Email",
        ),
        validator: (value) {
          if (!value!.isNotEmpty) {
            return "Email can't be empty.";
          }
          if (!value.contains('@') || !value.contains('.')) {
            return 'Enter Valid Email';
          }
          return null;
        },
        onSaved: (newValue) => _email = newValue!,
        keyboardType: TextInputType.emailAddress,
      ),
      TextFormField(
        initialValue: _phoneNumber,
        decoration: const InputDecoration(
          labelText: "Phone number",
        ),
        validator: (value) {
          if (!value!.isNotEmpty) {
            return "Phone number can't be empty.";
          }
          return null;
        },
        onSaved: (newValue) => _phoneNumber = newValue!,
        keyboardType: TextInputType.phone,
      ),
      DropdownButtonFormField(
        hint: const Text("Select the role"),
        value: _role,
        items: menuItems.map((e) {
          return DropdownMenuItem(
            value: e,
            child: Text(e), //value of item
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _role = newValue!;
          });
        },
        validator: (value) => value!.isNotEmpty ? null : "Role can't be empty.",
        onSaved: (newValue) => _role = newValue!,
      ),
      TextFormField(
        initialValue: _age,
        decoration: const InputDecoration(
          labelText: "Age",
        ),
        keyboardType: const TextInputType.numberWithOptions(
            decimal: false, signed: false),
        validator: (value) => value!.isNotEmpty ? null : "Age can't be empty.",
        onSaved: (newValue) => _age = newValue!,
      ),
      TextFormField(
        initialValue: _bp,
        decoration: const InputDecoration(
          labelText: "Blood Pressure",
          hintText: "Example: 165/100",
        ),
        keyboardType:
            const TextInputType.numberWithOptions(decimal: true, signed: true),
        validator: (value) =>
            value!.isNotEmpty ? null : "Blood Pressure can't be empty.",
        onSaved: (newValue) => _bp = newValue!,
      ),
      TextFormField(
        initialValue: _weight,
        decoration: const InputDecoration(
          labelText: "Weight",
          hintText: "Example: 80 kg",
        ),
        validator: (value) =>
            value!.isNotEmpty ? null : "Weight can't be empty.",
        onSaved: (newValue) => _weight = newValue!,
      ),
      TextFormField(
        initialValue: _height,
        decoration: const InputDecoration(
          labelText: "Height",
          hintText: "Example: 180 cm",
        ),
        validator: (value) =>
            value!.isNotEmpty ? null : "Height can't be empty.",
        onSaved: (newValue) => _height = newValue!,
      ),
      DropdownButtonFormField(
        hint: const Text("Select the Member Ship Plan"),
        value: _membership,
        items: menuMemberShip.map((e) {
          return DropdownMenuItem(
            value: e,
            child: Text(e), //value of item
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _membership = newValue!;
          });
        },
        validator: (value) =>
            value!.isNotEmpty ? null : "Membership can't be empty.",
        onSaved: (newValue) => _membership = newValue!,
      ),
      const SizedBox(
        height: 20,
      )
    ];
  }
}
