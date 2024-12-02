import 'package:flutter/material.dart';
import 'package:r_icon_pro/r_icon_pro.dart';

class CustomPasswordfield extends StatefulWidget {
  const CustomPasswordfield({
    super.key,
    required this.hint,
    required this.size,
    required this.bgColor,
    required this.fgColor,
    required this.controller,
  });

  final String hint;
  final Size size;
  final Color bgColor;
  final Color fgColor;
  final TextEditingController controller;

  @override
  _CustomPasswordfieldState createState() => _CustomPasswordfieldState();
}

class _CustomPasswordfieldState extends State<CustomPasswordfield> {
  late FocusNode _focusNode;
  bool _isObscure = true;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode()
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size.width,
      height: widget.size.height,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: widget.bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(Icons.password,color: Theme.of(context).colorScheme.primary,),
          const SizedBox(width: 10,),
          Expanded(
            child: TextField(
              controller: widget.controller,
              obscureText: _isObscure,
              focusNode: _focusNode,
              style: TextStyle(
                color: widget.fgColor,
                fontSize: 14,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: widget.hint,
                hintStyle: TextStyle(
                  color: widget.fgColor.withOpacity(0.4),
                ),
              ),
            ),
          ),
          if (_focusNode.hasFocus)
            IconButton(
              icon: Icon(
                _isObscure ? RIcon.Eye_Closed:RIcon.Eye,
                color: widget.fgColor.withOpacity(.7),
              ),
              onPressed: () {
                setState(() {
                  _isObscure = !_isObscure;
                });
              },
            ),
        ],
      ),
    );
  }
}
