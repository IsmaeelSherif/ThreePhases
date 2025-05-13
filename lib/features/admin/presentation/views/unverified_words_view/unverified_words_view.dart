import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:three_phases/core/utils/app_colors.dart';
import 'package:three_phases/core/utils/app_routes.dart';
import 'package:three_phases/core/widgets/gradient_scaffold.dart';
import 'package:three_phases/features/admin/presentation/mangers/admin_cubit/admin_cubit.dart';

class UnverifiedWordsView extends StatelessWidget {
  const UnverifiedWordsView({super.key});

  Future<void> _onRefresh(BuildContext context) async {
    await context.read<AdminCubit>().getUnverifiedWords();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return RefreshIndicator(
      onRefresh: () => _onRefresh(context),
      child: GradientScaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              leading: BackButton(),
              title: const Text('Unverified Words'),
              centerTitle: true,
            ),
            BlocBuilder<AdminCubit, AdminState>(
              builder: (context, state) {
                if (state is AdminLoading) {
                  return SliverToBoxAdapter(
                    child: Column(
                      children: [
                        SizedBox(height: height * 0.3),
                        const Center(child: CircularProgressIndicator()),
                      ],
                    ),
                  );
                }
                if (state is AdminError) {
                  return SliverToBoxAdapter(
                    child: Column(
                      children: [
                        SizedBox(height: height * 0.3),
                        Center(child: Text(state.message)),
                      ],
                    ),
                  );
                }

                return SliverList.builder(
                  itemBuilder: (context, index) {
                    final words = context.read<AdminCubit>().unverifiedWords[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: InkWell(
                        onTap: () {
                          context.push(AppRoutes.verifyWordsView, extra: {
                            'words': words,
                            'cubit': context.read<AdminCubit>(),
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: AppColors.kButtonBackgroundColorTransparent,
                            borderRadius: BorderRadius.circular(12.0),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.kButtonBackgroundColorTransparent,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.folder, color: Colors.amber[800]),
                              SizedBox(width: 12),
                              Text(
                                words.date.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.brown[800],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: context.read<AdminCubit>().unverifiedWords.length,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
