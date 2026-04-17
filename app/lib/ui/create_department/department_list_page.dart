import 'package:auto_route/auto_route.dart';
import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resources/resources.dart';
import '../../app.dart';
import 'bloc/create_department.dart';

@RoutePage()
class DepartmentListPage extends StatefulWidget {
  const DepartmentListPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _DepartmentListPageState();
  }
}

class _DepartmentListPageState
    extends BasePageState<DepartmentListPage, CreateDepartmentBloc> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    bloc.add(const LoadDepartments());
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) {
      return false;
    }
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _onScroll() {
    if (_isBottom && bloc.state.canLoadMore) {
      bloc.add(const LoadMoreDepartments());
    }
  }

  @override
  Widget buildPage(BuildContext context) {
    return CommonScaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result =
              await navigator.push(const AppRouteInfo.createDepartment());
          if (result == true) {
            bloc.add(const LoadDepartments());
          }
        },
        backgroundColor: AppColors.current.blackColor,
        child: Icon(
          Icons.add,
          color: AppColors.current.whiteColor,
        ),
      ),
      backgroundColor: AppColors.current.backgroundLayer1,
      appBar: CommonAppBar(
        text: 'Danh sách phòng ban',
        leadingIcon: LeadingIcon.newBack,
        onLeadingPressed: () => navigator.pop(useRootNavigator: true),
      ),
      body: BlocBuilder<CreateDepartmentBloc, CreateDepartmentState>(
        builder: (context, state) {
          if (state.getDepartmentStatus == LoadDataStatus.loading) {
            return _buildLoadingShimmer();
          }

          if (state.getDepartmentStatus == LoadDataStatus.fail &&
              state.departments.isEmpty) {
            return _buildErrorView(state.errorMessage);
          }

          if (state.departments.isEmpty) {
            return _buildEmptyView();
          }

          return RefreshIndicator(
            color: AppColors.current.blackColor,
            backgroundColor: AppColors.current.whiteColor,
            onRefresh: () async {
              bloc.add(const LoadDepartments(isRefresh: true));
            },
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(Dimens.d16.responsive()),
              itemCount:
                  state.departments.length + (state.isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == state.departments.length) {
                  return _buildLoadingMoreIndicator();
                }
                return _buildDepartmentCard(state.departments[index]);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildDepartmentCard(Department department) {
    return Container(
      margin: EdgeInsets.only(bottom: Dimens.d12.responsive()),
      padding: EdgeInsets.all(Dimens.d16.responsive()),
      decoration: BoxDecoration(
        color: AppColors.current.whiteColor,
        borderRadius: BorderRadius.circular(Dimens.d12.responsive()),
        boxShadow: [
          BoxShadow(
            color: AppColors.current.blackColor.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: Dimens.d48.responsive(),
            height: Dimens.d48.responsive(),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2563EB), Color(0xFF1E40AF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(Dimens.d8.responsive()),
            ),
            child: Center(
              child: Text(
                department.code.isNotEmpty
                    ? department.code.substring(0, 1).toUpperCase()
                    : 'D',
                style: AppTextStyles.titleTextDefault(
                  fontSize: Dimens.d20.responsive(),
                  fontWeight: FontWeight.bold,
                  color: AppColors.current.whiteColor,
                ),
              ),
            ),
          ),
          SizedBox(width: Dimens.d12.responsive()),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  department.name,
                  style: AppTextStyles.titleTextDefault(
                    fontSize: Dimens.d16.responsive(),
                    fontWeight: FontWeight.w600,
                    color: AppColors.current.blackColor,
                  ),
                ),
                SizedBox(height: Dimens.d4.responsive()),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimens.d8.responsive(),
                        vertical: Dimens.d4.responsive(),
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2563EB).withValues(alpha: 0.1),
                        borderRadius:
                            BorderRadius.circular(Dimens.d4.responsive()),
                      ),
                      child: Text(
                        department.code,
                        style: AppTextStyles.titleTextDefault(
                          fontSize: Dimens.d12.responsive(),
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2563EB),
                        ),
                      ),
                    ),
                    if (department.description.isNotEmpty) ...[
                      SizedBox(width: Dimens.d8.responsive()),
                      Expanded(
                        child: Text(
                          department.description,
                          style: AppTextStyles.titleTextDefault(
                            fontSize: Dimens.d12.responsive(),
                            color: AppColors.current.secondaryTextColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: AppColors.current.secondaryTextColor,
            size: Dimens.d24.responsive(),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingShimmer() {
    return ListView.builder(
      padding: EdgeInsets.all(Dimens.d16.responsive()),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: Dimens.d12.responsive()),
          padding: EdgeInsets.all(Dimens.d16.responsive()),
          decoration: BoxDecoration(
            color: AppColors.current.whiteColor,
            borderRadius: BorderRadius.circular(Dimens.d12.responsive()),
          ),
          child: Row(
            children: [
              Container(
                width: Dimens.d48.responsive(),
                height: Dimens.d48.responsive(),
                decoration: BoxDecoration(
                  color: AppColors.neutral200,
                  borderRadius: BorderRadius.circular(Dimens.d8.responsive()),
                ),
              ),
              SizedBox(width: Dimens.d12.responsive()),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: Dimens.d16.responsive(),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.neutral200,
                        borderRadius:
                            BorderRadius.circular(Dimens.d4.responsive()),
                      ),
                    ),
                    SizedBox(height: Dimens.d8.responsive()),
                    Container(
                      height: Dimens.d12.responsive(),
                      width: Dimens.d100.responsive(),
                      decoration: BoxDecoration(
                        color: AppColors.neutral200,
                        borderRadius:
                            BorderRadius.circular(Dimens.d4.responsive()),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoadingMoreIndicator() {
    return Padding(
      padding: EdgeInsets.all(Dimens.d16.responsive()),
      child:  Center(
        child: CircularProgressIndicator(
          color: AppColors.current.blackColor,
          strokeWidth: 2,
        ),
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.business_outlined,
            size: Dimens.d80.responsive(),
            color: AppColors.current.secondaryTextColor,
          ),
          SizedBox(height: Dimens.d16.responsive()),
          Text(
            'Chưa có phòng ban nào',
            style: AppTextStyles.titleTextDefault(
              fontSize: Dimens.d16.responsive(),
              fontWeight: FontWeight.w600,
              color: AppColors.current.blackColor,
            ),
          ),
          SizedBox(height: Dimens.d8.responsive()),
          Text(
            'Hãy tạo phòng ban đầu tiên',
            style: AppTextStyles.titleTextDefault(
              fontSize: Dimens.d14.responsive(),
              color: AppColors.current.secondaryTextColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView(String? errorMessage) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: Dimens.d80.responsive(),
            color: AppColors.current.errorTextColor,
          ),
          SizedBox(height: Dimens.d16.responsive()),
          Text(
            'Có lỗi xảy ra',
            style: AppTextStyles.titleTextDefault(
              fontSize: Dimens.d16.responsive(),
              fontWeight: FontWeight.w600,
              color: AppColors.current.blackColor,
            ),
          ),
          if (errorMessage != null) ...[
            SizedBox(height: Dimens.d8.responsive()),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: Dimens.d32.responsive()),
              child: Text(
                errorMessage,
                style: AppTextStyles.titleTextDefault(
                  fontSize: Dimens.d14.responsive(),
                  color: AppColors.current.secondaryTextColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
