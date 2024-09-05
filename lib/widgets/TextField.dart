// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CustomFormTextField extends StatefulWidget {
  String? hint;
  Function(String)? onChange;
  bool isPassword;

  CustomFormTextField(
      {required this.hint, required this.onChange, required this.isPassword});

  @override
  State<CustomFormTextField> createState() => _CustomFormTextFieldState();
}

class _CustomFormTextFieldState extends State<CustomFormTextField> {
  bool isObscure = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: widget.isPassword ? !isObscure : isObscure,
      validator: (data) {
        if (data!.isEmpty) {
          return "this field is required";
        }
      },
      onChanged: widget.onChange,
      decoration: InputDecoration(
        suffixIcon: widget.isPassword
            ? IconButton(
                onPressed: () {
                  isObscure = !isObscure;
                  setState(() {});
                },
                icon: isObscure
                    ? Icon(
                        Icons.visibility,
                        color: Colors.white,
                      )
                    : Icon(Icons.visibility_off, color: Colors.white))
            : null,
        hintText: widget.hint,
        hintStyle: TextStyle(color: Colors.white),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
    );
  }
}
