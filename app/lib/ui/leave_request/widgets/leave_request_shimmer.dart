import 'package:shared/shared.dart';
import '../../../app.dart';

class LeaveRequestShimmer extends StatelessWidget {
  const LeaveRequestShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(Dimens.d16.responsive()),
      itemCount: UiConstants.shimmerItemCount,
      itemBuilder: (context, index) {
        return _buildShimmerItem();
      },
    );
  }

  Widget _buildShimmerItem() {
    return Container(
      margin: EdgeInsets.only(bottom: Dimens.d12.responsive()),
      padding: EdgeInsets.all(Dimens.d16.responsive()),
      decoration: BoxDecoration(
        color: AppColors.current.whiteColor,
        borderRadius: BorderRadius.circular(Dimens.d12.responsive()),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with avatar and status
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    ShimmerLoading(
                      isLoading: true,
                      child: CircleShimmer(
                        diameter: Dimens.d40.responsive(),
                      ),
                    ),
                    SizedBox(width: Dimens.d12.responsive()),
                    Expanded(
                      child: ShimmerLoading(
                        isLoading: true,
                        child: RounedRectangleShimmer(
                          width: Dimens.d120.responsive(),
                          height: Dimens.d16.responsive(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: Dimens.d5.responsive()),
              ShimmerLoading(
                isLoading: true,
                child: RounedRectangleShimmer(
                  width: Dimens.d80.responsive(),
                  height: Dimens.d24.responsive(),
                ),
              ),
            ],
          ),
          SizedBox(height: Dimens.d12.responsive()),

          // Date row
          Row(
            children: [
              ShimmerLoading(
                isLoading: true,
                child: CircleShimmer(
                  diameter: Dimens.d16.responsive(),
                ),
              ),
              SizedBox(width: Dimens.d8.responsive()),
              Expanded(
                child: ShimmerLoading(
                  isLoading: true,
                  child: RounedRectangleShimmer(
                    height: Dimens.d14.responsive(),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: Dimens.d8.responsive()),

          // Description row
          Row(
            children: [
              ShimmerLoading(
                isLoading: true,
                child: CircleShimmer(
                  diameter: Dimens.d16.responsive(),
                ),
              ),
              SizedBox(width: Dimens.d8.responsive()),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerLoading(
                      isLoading: true,
                      child: RounedRectangleShimmer(
                        height: Dimens.d14.responsive(),
                      ),
                    ),
                    SizedBox(height: Dimens.d4.responsive()),
                    ShimmerLoading(
                      isLoading: true,
                      child: RounedRectangleShimmer(
                        width: Dimens.d200.responsive(),
                        height: Dimens.d14.responsive(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
