import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meditouch/app/app_exporter.dart';
import 'package:meditouch/common/utils/epharmacy_util.dart';
import 'package:meditouch/common/widgets/custom_loading_animation.dart';
import 'package:meditouch/features/dashboard/features/cart/models/cart_model.dart';
import 'package:meditouch/features/dashboard/features/cart/presentation/screens/parts/cart_appbar.dart';

import '../../../logics/cart_bloc.dart';
import '../../../logics/cart_event.dart';


class CartFilterBar extends StatefulWidget {
  final ColorScheme theme;

  const CartFilterBar({Key? key, required this.theme}) : super(key: key);

  @override
  State<CartFilterBar> createState() => _CartFilterBarState();
}

class _CartFilterBarState extends State<CartFilterBar> {
  String sortBy = 'createdAt';
  bool isAscending = true;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
              color: widget.theme.primary.withOpacity(.1),
              borderRadius: BorderRadius.circular(5)),
          child: DropdownButton<String>(
            underline: Container(
              height: 0,
              color: widget.theme.onSurface.withOpacity(0), // Underline color
            ),
            value: sortBy,
            elevation: 0,
            items: const [
              DropdownMenuItem(
                  value: 'createdAt', child: Text('By Added Time')),
              DropdownMenuItem(value: 'totalPrice', child: Text('By Price')),
            ],
            onChanged: (value) {
              setState(() {
                sortBy = value!;
              });
              context.read<CartBloc>().add(
                    FilterCart(
                      sortBy,
                      isAscending,
                    ),
                  );
            },
            dropdownColor: widget.theme.surfaceContainer,
            style: TextStyle(color: widget.theme.onSurface, fontSize: 16),
            icon: Icon(Icons.arrow_drop_down,
                color: widget.theme.primary.withOpacity(0.5)),
          ),
        ),
        Row(
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  isAscending = !isAscending;
                });
                context.read<CartBloc>().add(
                      FilterCart(
                        sortBy,
                        isAscending,
                      ),
                    );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.theme.primary.withOpacity(.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              icon: Padding(
                padding: const EdgeInsets.all(5),
                child: Icon(
                  isAscending ? Icons.arrow_upward : Icons.arrow_downward,
                  color: widget.theme.onSurface,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
