import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class QuantityBottomSheet extends StatelessWidget {
  const QuantityBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 15, bottom: 10),
          height: 5,
          width: 60,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
            color: Colors.grey,
          ),
        ),
        Expanded(
          child: ListView.builder(
              itemCount: 25,
              itemBuilder: (context, index) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        print(index + 1);
                        Navigator.of(context).canPop()
                            ? Navigator.of(context).pop()
                            : null;
                      },
                      child: Text(
                        (index + 1).toString(),
                        style: GoogleFonts.lato(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }
}
