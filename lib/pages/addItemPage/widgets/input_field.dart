import 'package:flutter/material.dart';

class InputField extends StatefulWidget {
  TextEditingController controller;
  final FocusNode focusNode;
  final String hintText;
  InputField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.hintText,
  });

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 40,
      // height: 50,
      constraints: const BoxConstraints(minHeight: 50, maxHeight: 70),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,

        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
        onTapOutside: (event) {
          widget.focusNode.unfocus();
        },
        onChanged: (value) {
          setState(() {
            widget.controller.text = value;
          });
        },
        //---  ----
        focusNode: widget.focusNode,
        controller: widget.controller,
        cursorColor: Colors.blue,
        cursorWidth: 1,
        style: TextStyle(fontSize: 16, color: Colors.black.withOpacity(0.7)),

        //--- ---
        decoration: InputDecoration(
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
          border: const OutlineInputBorder(),
          label: Text(
            widget.hintText,
            style: const TextStyle(fontSize: 15),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}
