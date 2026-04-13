import 'package:resources/resources.dart';

import '../app.dart';
import 'ui_button.dart';

class RejectReasonDialog extends StatefulWidget {
  const RejectReasonDialog({
    required this.onConfirm,
    super.key,
    this.onCancel,
    this.title,
    this.hintText,
    this.confirmText,
    this.cancelText,
  });

  final Function(String reason) onConfirm;
  final VoidCallback? onCancel;
  final String? title;
  final String? hintText;
  final String? confirmText;
  final String? cancelText;

  @override
  State<RejectReasonDialog> createState() => _RejectReasonDialogState();
}

class _RejectReasonDialogState extends State<RejectReasonDialog> {
  final TextEditingController _reasonController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String? _errorText;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _reasonController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleConfirm() {
    final reason = _reasonController.text.trim();
    if (reason.isEmpty) {
      setState(() {
        _errorText = 'Vui lòng nhập lý do từ chối';
      });
      return;
    }
    widget.onConfirm(reason);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: Dimens.d18.responsive()),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.current.whiteColor,
          borderRadius: BorderRadius.circular(Dimens.d24.responsive()),
        ),
        padding: EdgeInsets.all(Dimens.d20.responsive()),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Lý do từ chối',
              style: AppTextStyles.s14w500Primary().copyWith(
                color: AppColors.current.secondaryTextColor,
              ),
            ),
            SizedBox(height: Dimens.d8.responsive()),
            TextField(
              controller: _reasonController,
              focusNode: _focusNode,
              maxLines: 4,
              maxLength: 500,
              style: AppTextStyles.s14w400Primary(),
              decoration: InputDecoration(
                hintText: widget.hintText ?? 'Nhập lý do từ chối...',
                hintStyle: AppTextStyles.s14w400Primary().copyWith(
                  color: AppColors.current.secondaryTextColor,
                ),
                errorText: _errorText,
                filled: true,
                fillColor: AppColors.current.whiteColor,
                contentPadding: EdgeInsets.all(Dimens.d12.responsive()),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Dimens.d12.responsive()),
                  borderSide: BorderSide(
                    color: AppColors.neutral200,
                    width: Dimens.d1.responsive(),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Dimens.d12.responsive()),
                  borderSide: BorderSide(
                    color: AppColors.neutral200,
                    width: Dimens.d1.responsive(),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Dimens.d12.responsive()),
                  borderSide:  BorderSide(
                    color: AppColors.neutral400,
                    width: Dimens.d1.responsive(),
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Dimens.d12.responsive()),
                  borderSide: BorderSide(
                    color: AppColors.current.redColor,
                    width: 1.5,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Dimens.d12.responsive()),
                  borderSide: BorderSide(
                    color: AppColors.current.redColor,
                    width: 1.5,
                  ),
                ),
              ),
              onChanged: (value) {
                if (_errorText != null && value.trim().isNotEmpty) {
                  setState(() {
                    _errorText = null;
                  });
                }
              },
            ),
            SizedBox(height: Dimens.d20.responsive()),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: UIButton(
                    radius: Dimens.d12.responsive(),
                    enableShadow: false,
                    height: Dimens.d48.responsive(),
                    border: Border.all(
                      color: AppColors.neutral300,
                      width: Dimens.d1.responsive(),
                    ),
                    color: AppColors.current.whiteColor,
                    onTap: widget.onCancel ?? () => Navigator.of(context).pop(),
                    text: widget.cancelText ?? S.current.cancel,
                    textColor: AppColors.current.blackColor,
                  ),
                ),
                SizedBox(width: Dimens.d12.responsive()),
                Expanded(
                  child: UIButton(
                    height: Dimens.d48.responsive(),
                    radius: Dimens.d12.responsive(),
                    color: AppColors.current.redColor,
                    enableShadow: false,
                    onTap: _handleConfirm,
                    text: widget.confirmText ?? S.current.confirm,
                    textColor: AppColors.current.whiteColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
