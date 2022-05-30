import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CarriagePriceTextFormField extends StatefulWidget {
  const CarriagePriceTextFormField({Key? key}) : super(key: key);

  @override
  State<CarriagePriceTextFormField> createState() =>
      _CarriagePriceTextFormFieldState();
}

class _CarriagePriceTextFormFieldState
    extends State<CarriagePriceTextFormField> {
  final carriagePriceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'برجاء ادخال سعر المشال';
            }
            if (int.parse(value) <= 0) {
              return "برجاء ادخال عدد صحيح موجب";
            }
            return null;
          },
          controller: carriagePriceController,
          decoration: InputDecoration(
            label: Text("المشال"),
          ),
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
