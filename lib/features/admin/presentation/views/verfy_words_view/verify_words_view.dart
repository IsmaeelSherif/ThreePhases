import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:three_phases/core/utils/app_colors.dart';
import 'package:three_phases/core/widgets/gradient_scaffold.dart';
import 'package:three_phases/features/admin/data/models/unverified_word_model.dart';
import 'package:three_phases/features/admin/presentation/mangers/admin_cubit/admin_cubit.dart';

class VerifyWordsView extends StatelessWidget {
  const VerifyWordsView({super.key, required this.words});
  final UnverifiedWordModel words;

  Future<void> _showConfirmationDialog(BuildContext context, String word,AdminCubit cubit) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Word'),
        content: Text('Are you sure you want to remove "$word"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              cubit.removeWord(words,word);

              Navigator.pop(context, true);
            },
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminCubit, AdminState>(
      listener: (context, state) {
        if (state is AdminVerifyWordsSuccess) {
          context.pop();
        } else if (state is AdminError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: state is AdminVerifyWordsLoading,
          child: GradientScaffold(
            body: Column(
              children: [
                AppBar(
                  title:  Text('Verify Words',style: Theme.of(context).textTheme.bodyLarge,),
                  centerTitle: true,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: words.words.length,
                    itemBuilder: (context, index) {
                      final word = words.words[index];
                      return ListTile(
                        title: Text(word,style: Theme.of(context).textTheme.bodyLarge,),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete,color: Colors.red,),
                          onPressed: () async {
                           _showConfirmationDialog(context, word,context.read<AdminCubit>());
                           
                          },
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<AdminCubit>().verifyWords(words);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.kButtonBackgroundColorTransparent,
                      minimumSize: const Size(double.infinity, 50),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child:  Text(
                      'Verify Words',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ),
                SizedBox(height: 16,)
                ],
            ),
          ),
        );
      },
    );
  }
}