import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

enum FormFieldType {
  email,
  password,
  confirmPassword,
  username,
}

class CustomFormField extends StatelessWidget {
  const CustomFormField({
    super.key,
    required this.outlinedInputBorder,
    required this.inputLabel,
    required this.nullValueErrorStringValidator,
    required this.validatorErrorString,
    required this.onSavedFunction,
    required this.formFieldType,
  });

  final OutlineInputBorder outlinedInputBorder;
  final String inputLabel;
  final String nullValueErrorStringValidator;
  final String validatorErrorString;
  final void Function(String value) onSavedFunction;
  final FormFieldType formFieldType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value == null) {
          return nullValueErrorStringValidator;
        }

        if (formFieldType == FormFieldType.email) {
          if (!EmailValidator.validate(value)) {
            return validatorErrorString;
          }
        } else if (formFieldType == FormFieldType.username) {
          if (value.length < 8) {
            return validatorErrorString;
          }

          print("TODO : Please setup additional validators for username!");
        }

        return null;
      },
      onSaved: (value) {
        onSavedFunction(value!);
      },
      autocorrect: false,
      decoration: InputDecoration(
        enabledBorder: outlinedInputBorder,
        focusedBorder: outlinedInputBorder,
        errorBorder: outlinedInputBorder,
        focusedErrorBorder: outlinedInputBorder,
        label: Padding(
          padding: const EdgeInsets.only(
            left: 8.0,
          ),
          child: Text(
            inputLabel,
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

class PasswordFormField extends StatefulWidget {
  const PasswordFormField({
    super.key,
    required this.outlinedInputBorder,
    required this.inputLabel,
    required this.nullValueErrorStringValidator,
    required this.validatorErrorString,
    required this.onSavedFunction,
  });

  final OutlineInputBorder outlinedInputBorder;
  final String inputLabel;
  final String nullValueErrorStringValidator;
  final String validatorErrorString;
  final void Function(String value) onSavedFunction;

  @override
  State<PasswordFormField> createState() => _PasswordFormFieldState();
}

class _PasswordFormFieldState extends State<PasswordFormField> {
  bool _isPWVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value == null) {
          return widget.nullValueErrorStringValidator;
        }

        if (value.length < 8) {
          return widget.validatorErrorString;
        }

        return null;
      },
      onSaved: (value) {
        widget.onSavedFunction(value!);
      },
      autocorrect: false,
      obscureText: !_isPWVisible,
      decoration: InputDecoration(
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              _isPWVisible = !_isPWVisible;
            });
          },
          child: _isPWVisible
              ? const Icon(HugeIcons.strokeRoundedView)
              : const Icon(HugeIcons.strokeRoundedViewOffSlash),
        ),
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
