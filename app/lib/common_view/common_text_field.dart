import 'package:flutter/services.dart';
import '../app.dart';

class CommonTextField extends StatefulWidget {
  const CommonTextField({
    super.key,
    this.controller,
    this.hintText,
    this.hintStyle,
    this.suffixText,
    this.textStyle,
    this.keyboardType,
    this.onChanged,
    this.validator,
    this.inputFormatters,
    this.focusNode,
    this.enabled,
    this.color,
    this.onSave,
    this.maxLength,
    this.prefixIcon,
    this.initialValue,
    this.inputBorder,
    this.minLines = 1,
    this.maxLines = 1,
    this.contentPadding,
    this.autoValidateMode,
    this.textAlign = TextAlign.start,
    this.suffix,
    this.suffixIcon,
    this.enableSuffixIcon = false,
    this.errorText,
    this.borderColor,
    this.isEmpty,
    this.height,
    this.onTap,
    this.readOnly,
    this.autofocus,
    this.prefix,
    this.bgTextField,
    this.labelText,
    this.label,
    this.obscureText,
  });

  final String? initialValue;
  final TextEditingController? controller;
  final String? hintText;
  final TextStyle? hintStyle;
  final String? suffixText;
  final TextStyle? textStyle;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final bool? enabled;
  final Function(String)? onSave;
  final Color? color;
  final int? maxLength;
  final Icon? prefixIcon;
  final InputBorder? inputBorder;
  final int minLines;
  final int maxLines;
  final TextAlign textAlign;
  final Widget? suffix;
  final Widget? suffixIcon;
  final bool enableSuffixIcon;
  final String? errorText;
  final EdgeInsets? contentPadding;
  final AutovalidateMode? autoValidateMode;
  final Color? borderColor;
  final bool? isEmpty;
  final double? height;
  final Function()? onTap;
  final bool? readOnly;
  final bool? autofocus;
  final Widget? prefix;
  final Color? bgTextField;
  final String? labelText;
  final Widget? label;
  final bool? obscureText;

  @override
  State<CommonTextField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CommonTextField> {
  final double borderRadius = 6.0;
  final double smallSpacing = 8.0;
  final double mediumSpacing = 16.0;
  final double iconSize = 16.0;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
    widget.controller?.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height ?? Dimens.d35.responsive(),
      width: double.infinity,
      decoration: BoxDecoration(
        color: widget.bgTextField ?? AppColors.current.whiteColor,
        borderRadius: const BorderRadius.all(Radius.circular(Dimens.d8)),
        border: Border.all(
          color: widget.borderColor ?? AppColors.defaultAppColor.primaryColor,
          width: 1,
        ),
      ),
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          TextFormField(
            obscureText: widget.obscureText ?? false,
            autofocus: widget.autofocus ?? false,
            readOnly: widget.readOnly ?? false,
            onTap: widget.onTap,
            textAlignVertical: TextAlignVertical.center,
            onChanged: (_value) {
              if (widget.onChanged != null) {
                widget.onChanged!(_value);
              }
            },
            focusNode: _focusNode,
            cursorColor: AppColors.defaultAppColor.primaryColor,
            controller: widget.controller,
            initialValue: widget.initialValue,
            style: widget.textStyle ?? AppTextStyles.body2Regular(),
            textAlign: widget.textAlign,
            keyboardType: widget.keyboardType,
            minLines: widget.minLines,
            maxLines: widget.maxLines,
            maxLength: widget.maxLength,
            enabled: widget.enabled,
            onFieldSubmitted: (_value) {
              if (widget.onSave != null) {
                widget.onSave!(_value);
              }
            },
            autovalidateMode: widget.autoValidateMode,
            validator: (String? text) {
              if (widget.validator != null) {
                return widget.validator!(text);
              }
              return null;
            },
            inputFormatters: widget.inputFormatters,
            decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                labelText: widget.labelText,
                label: widget.label,
                isDense: true,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                border: InputBorder.none,
                errorText: widget.errorText,
                labelStyle: AppTextStyles.titleTextDefault(color: widget.color),
                hintText: widget.hintText,
                hintStyle: widget.hintStyle ??
                    AppTextStyles.titleTextDefault(
                      fontSize: Dimens.d14.responsive(),
                      color: AppColors.defaultAppColor.secondaryColor,
                      fontWeight: FontWeight.w400,
                    ),
                prefixIcon: widget.prefixIcon,
                suffix: widget.suffix,
                fillColor: Colors.transparent,
                contentPadding: widget.contentPadding ??
                    const EdgeInsets.symmetric(
                        horizontal: Dimens.d10, vertical: Dimens.d0),
                filled: true,
                prefix: widget.prefix,
                suffixIcon: widget.suffixIcon),
          ),
        ],
      ),
    );
  }
}
