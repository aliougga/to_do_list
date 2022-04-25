// import 'package:flutter/material.dart';

// class StatefulDialog extends StatefulWidget {
//   @override
//   _StatefulDialogState createState() => _StatefulDialogState();
// }

// class _StatefulDialogState extends State<StatefulDialog> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   final TextEditingController _textEditingController = TextEditingController();


//   Future<void> showInformationDialog(BuildContext context) async {
//     return await showDialog(
//         context: context,
//         builder: (context) {
//           return StatefulBuilder(builder: (context, setState) {
//             return AlertDialog(
//               content: Form(
//                   key: _formKey,
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text("Choice Box"),
//                       TextFormField(
//                         controller: _textEditingController,
//                         validator: (value) {
//                           return value.isNotEmpty ? null : "Enter any text";
//                         },
//                         decoration:
//                             InputDecoration(hintText: "Please Enter Text"),
//                       ),
                      
//                     ],
//                   )),
//               title: const Text('Stateful Dialog'),
//               actions: <Widget>[
//                 InkWell(
//                   child: const Text('Ajouter'),
//                   onTap: () {
//                     if (_formKey.currentState.validate()) {
//                       // Do something like updating SharedPreferences or User Settings etc.
//                       Navigator.of(context).pop();
//                     }
//                   },
//                 ),
//               ],
//             );
//           });
//         });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         child: Center(
//           child: FlatButton(
//               color: Colors.deepOrange,
//               onPressed: () async {
//                 await showInformationDialog(context);
//               },
//               child: Text(
//                 "Stateful Dialog",
//                 style: TextStyle(color: Colors.white, fontSize: 16),
//               )),
//         ),
//       ),
//     );
//   }
// }