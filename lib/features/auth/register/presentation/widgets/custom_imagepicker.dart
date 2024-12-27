import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/image_cubit.dart';

class CustomImagePicker extends StatelessWidget {
  const CustomImagePicker({
    super.key,
    required this.width,
    required this.height,
    required this.bgColor,
    required this.fgColor,
    required this.hasBorder,
    this.borderColor,
  });

  final double width;
  final double height;
  final Color bgColor;
  final Color fgColor;
  final bool hasBorder;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final imagePickerCubit = context.watch<ImagePickerCubit>();

    return InkWell(
      onTap: () => imagePickerCubit.pickImage(),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: height,
        width: width,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: bgColor,
          border: hasBorder && borderColor != null
              ? Border.all(color: borderColor!, width: 2)
              : null,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            imagePickerCubit.state == null
                ? 'Pick an image'
                : imagePickerCubit.state!.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: fgColor),
          ),
        ),
      ),
    );
  }
}
