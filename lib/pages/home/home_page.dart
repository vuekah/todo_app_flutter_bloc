import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:todo_app_flutter_bloc/bloc/home/home_state.dart';
import 'package:todo_app_flutter_bloc/common/widgets/button_widget.dart';
import 'package:todo_app_flutter_bloc/l10n/language_bloc.dart';
import 'package:todo_app_flutter_bloc/bloc/home/home_bloc.dart';
import 'package:todo_app_flutter_bloc/pages/add_task/add_task.page.dart';
import 'package:todo_app_flutter_bloc/utils/dimens_util.dart';
import 'package:todo_app_flutter_bloc/gen/assets.gen.dart';
import 'package:todo_app_flutter_bloc/model/task_model.dart';
import 'package:todo_app_flutter_bloc/pages/home/items/task_item.dart';
import 'package:todo_app_flutter_bloc/pages/auth/login/login_page.dart';
import 'package:todo_app_flutter_bloc/theme/color_style.dart';
import 'package:todo_app_flutter_bloc/theme/text_style.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Dimens.init(context);
    return Scaffold(
        backgroundColor: MyAppColors.greyColor,
        body: SingleChildScrollView(
          child: Stack(
            children: [
              _buildBackground(),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimens.screenHeight < Dimens.screenWidth
                      ? Dimens.padding.left
                      : 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    AppBar(
                      backgroundColor: MyAppColors.transparentColor,
                      centerTitle: true,
                      leading: IconButton(
                        onPressed: () {
                          BlocProvider.of<LanguageBloc>(context)
                              .changeLanguage();
                        },
                        icon: const Icon(
                          Icons.language,
                          size: 30,
                          color: MyAppColors.whiteColor,
                        ),
                      ),
                      title: BlocSelector<LanguageBloc, LanguageState, Locale>(
                        builder: (context, locale) {
                          return Text(
                            locale.languageCode == 'en'
                                ? DateFormat("MMMM dd, yyyy")
                                    .format(DateTime.now())
                                : DateFormat("dd MMMM, yyyy", 'vi')
                                    .format(DateTime.now()),
                            textAlign: TextAlign.center,
                            style: MyAppStyles.formattedDateTextStyle,
                          );
                        },
                        selector: (p0) => p0.locale,
                      ),
                      actions: [
                        GestureDetector(
                          onTap: () {
                            BlocProvider.of<HomeBloc>(context).logout();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const LoginPage()),
                              (route) => false,
                            );
                          },
                          child: const Icon(
                            Icons.logout,
                            color: MyAppColors.whiteColor,
                            size: 28,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),
                    Text(
                      AppLocalizations.of(context)!.myToDoList,
                      textAlign: TextAlign.center,
                      style: MyAppStyles.todoListTitleTextStyle,
                    ),
                    const SizedBox(height: 15),
                    // First Todo List Item
                    todoListContainer(context),
                    const SizedBox(height: 10),
                    Text(
                      AppLocalizations.of(context)!.completed,
                      textAlign: TextAlign.start,
                      style: MyAppStyles.completedTextStyle,
                    ),
                    const SizedBox(height: 10),
                    // Second Todo List Item
                    completedListContainer(context),
                    const SizedBox(height: 60),
                    // Add Task button for landscape layout
                    if (Dimens.screenHeight < Dimens.screenWidth)
                      addNewTaskButton(context),
                  ],
                ),
              ),
              // Add Task button for portrait layout (positioned at the bottom)
              if (Dimens.screenHeight > Dimens.screenWidth)
                Positioned(
                  bottom: Dimens.padding.bottom,
                  left: Dimens.screenHeight < Dimens.screenWidth
                      ? Dimens.padding.left
                      : 16,
                  right: Dimens.screenHeight < Dimens.screenWidth
                      ? Dimens.padding.left
                      : 16,
                  child: addNewTaskButton(context),
                ),
            ],
          ),
        ));
  }

  SizedBox _buildBackground() {
    return SizedBox(
      width: Dimens.screenWidth,
      height: Dimens.screenHeight,
      child: Column(
        children: [
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Container(
              width: Dimens.screenWidth,
              color: MyAppColors.backgroundColor,
              child: Stack(
                children: [
                  Positioned(
                    top: Dimens.padding.top,
                    left: Dimens.screenHeight < Dimens.screenWidth
                        ? -Dimens.screenWidth / 6
                        : -Dimens.screenWidth / 2,
                    child: Image.asset(
                      Assets.images.circle.path,
                      width: 342,
                    ),
                  ),
                  Positioned(
                    right: -60,
                    top: -10,
                    child: Image.asset(
                      Assets.images.circle2.path,
                      width: 145,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            flex: Dimens.screenHeight > Dimens.screenWidth ? 3 : 1,
            fit: FlexFit.tight,
            child: Container(
              color: MyAppColors.greyColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget addNewTaskButton(BuildContext context) {
    return ButtonWidget(
      callback: () async {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const AddTaskPage()));
      },
      title: AppLocalizations.of(context)!.addNewTask,
    );
  }

  Widget todoListContainer(BuildContext context) {
    BlocProvider.of<HomeBloc>(context).fetchTodos();
    return Container(
      padding: const EdgeInsets.all(8),
      width: Dimens.screenWidth,
      height: 242,
      decoration: BoxDecoration(
        color: MyAppColors.whiteColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          switch (state.todoStatus) {
            case Status.loading:
              return Skeletonizer(
                enabled: true,
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: 7,
                  itemBuilder: (context, index) {
                    return TaskItem(task: fakeItem);
                  },
                ),
              );
            case Status.completed:
              return ListView.separated(
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  final task = state.listTask![index];
                  return TaskItem(
                    callback: () async {
                      await BlocProvider.of<HomeBloc>(context)
                          .updateTask(task.id ?? 0);
                    },
                    task: task,
                  );
                },
                separatorBuilder: (context, index) => Container(
                  height: 1,
                  color: MyAppColors.grayColor,
                ),
                itemCount: state.listTask!.length,
              );

            case Status.error:
              return Center(
                child: Text(AppLocalizations.of(context)!.errorLoading),
              );
            default:
              return Container();
          }
        },
      ),
    );
  }

  Widget completedListContainer(BuildContext context) {
    BlocProvider.of<HomeBloc>(context).fetchCompletedTodos();
    return Container(
      padding: const EdgeInsets.all(8),
      width: Dimens.screenWidth,
      height: 242,
      decoration: BoxDecoration(
        color: MyAppColors.whiteColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          switch (state.completedStatus) {
            case Status.loading:
              return Skeletonizer(
                enabled: true,
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: 7,
                  itemBuilder: (context, index) {
                    return TaskItem(
                      task: fakeItem,
                    );
                  },
                ),
              );
            case Status.completed:
              return ListView.separated(
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  final task = state.listTaskCompleted![index];
                  return TaskItem(
                    task: task,
                  );
                },
                separatorBuilder: (context, index) => Container(
                  height: 1,
                  color: MyAppColors.grayColor,
                ),
                itemCount: state.listTaskCompleted!.length,
              );
            default:
              return Container();
          }
        },
      ),
    );
  }
}
