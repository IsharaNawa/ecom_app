import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ecom_app/services/icon_manager.dart';

enum FormFieldType {
  email,
  password,
  confirmPassword,
  fullname,
}

class AppFormField extends StatefulWidget {
  const AppFormField({
    super.key,
    required this.outlinedInputBorder,
    required this.inputLabel,
    required this.nullValueErrorStringValidator,
    required this.formFieldType,
    required this.controller,
    this.comparisonValue,
  });

  final OutlineInputBorder outlinedInputBorder;
  final String inputLabel;
  final String nullValueErrorStringValidator;
  final FormFieldType formFieldType;
  final TextEditingController controller;
  final String? comparisonValue;

  @override
  State<AppFormField> createState() => _AppFormFieldState();
}

class _AppFormFieldState extends State<AppFormField> {
  late TextInputType keyboardType = TextInputType.name;
  late bool isInputVisible;

  @override
  void initState() {
    super.initState();
    if (widget.formFieldType == FormFieldType.email) {
      keyboardType = TextInputType.emailAddress;
    }
    if (widget.formFieldType == FormFieldType.password ||
        widget.formFieldType == FormFieldType.confirmPassword) {
      isInputVisible = true;
    } else {
      isInputVisible = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value == null) {
          return widget.nullValueErrorStringValidator;
        }

        if (widget.formFieldType == FormFieldType.email) {
          if (!EmailValidator.validate(value)) {
            return "Please enter a valid email!";
          }
        } else if (widget.formFieldType == FormFieldType.fullname) {
          final regex = RegExp(r'^[A-Za-z]+(\s+)[A-Za-z]+$');

          if (!regex.hasMatch(value.trim())) {
            return "Correct Name Ex : Alexander James.";
          }
        } else if (widget.formFieldType == FormFieldType.password) {
          if (value.trim().length < 8) {
            return "Password should be at least 8 characters!";
          }
        } else if (widget.formFieldType == FormFieldType.confirmPassword) {
          if (value.trim() != widget.comparisonValue) {
            return "Both passwords should be similar!";
          }
        }

        return null;
      },
      obscureText: isInputVisible,
      controller: widget.controller,
      autocorrect: false,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        suffixIcon: widget.formFieldType == FormFieldType.password ||
                widget.formFieldType == FormFieldType.confirmPassword
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    isInputVisible = !isInputVisible;
                  });
                },
                child: !isInputVisible
                    ? Icon(IconManager.pwVisibleIcon)
                    : Icon(IconManager.pwNotVisibleIcon),
              )
            : null,
        enabledBorder: widget.outlinedInputBorder,
        focusedBorder: widget.outlinedInputBorder,
        errorBorder: widget.outlinedInputBorder,
        focusedErrorBorder: widget.outlinedInputBorder,
        label: Padding(
          padding: const EdgeInsets.only(
            left: 8.0,
          ),
          child: Text(
            widget.inputLabel,
            style: GoogleFonts.ubuntu(
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
