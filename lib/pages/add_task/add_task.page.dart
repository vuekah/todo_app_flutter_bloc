import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app_flutter_bloc/bloc/add_task/add_task_bloc.dart';
import 'package:todo_app_flutter_bloc/bloc/add_task/add_task_state.dart';
import 'package:todo_app_flutter_bloc/bloc/home/home_bloc.dart';
import 'package:todo_app_flutter_bloc/common/widgets/button_widget.dart';
import 'package:todo_app_flutter_bloc/common/widgets/category_widget.dart';
import 'package:todo_app_flutter_bloc/common/widgets/textfield_widget.dart';
import 'package:todo_app_flutter_bloc/l10n/language_bloc.dart';
import 'package:todo_app_flutter_bloc/model/task_model.dart';
import 'package:todo_app_flutter_bloc/theme/text_style.dart';
import 'package:todo_app_flutter_bloc/utils/dimens_util.dart';
import 'package:todo_app_flutter_bloc/gen/assets.gen.dart';
import 'package:todo_app_flutter_bloc/theme/color_style.dart';
import 'package:todo_app_flutter_bloc/utils/date_util.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _taskTitleController = TextEditingController();
  final _notesController = TextEditingController();
  late DateTime _dateTime;
  TaskModel? taskModel;
  @override
  void initState() {
    _dateTime = DateTime.now();
    super.initState();
  }

  @override
  void dispose() {
    _taskTitleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Dimens.init(context);
    return BlocProvider(
      create: (context) => AddTaskBloc(),
      child: Builder(builder: (context) {
        return BlocListener<AddTaskBloc, AddTaskState>(
          listener: (context, state) {
            if (state.status == AddTaskStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content:
                      Text(AppLocalizations.of(context)!.emptyFieldError)));
            }
            if (state.status == AddTaskStatus.completed) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(AppLocalizations.of(context)!.addSuccess)));
              if (taskModel != null) {
                BlocProvider.of<HomeBloc>(context).addNewTask(taskModel!);
              }
            }
          },
          child: Scaffold(
            backgroundColor: MyAppColors.greyColor,
            body: Stack(
              children: [
                _buildBackground(context),
                _buildSaveButton(context),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return Positioned(
        bottom: Dimens.padding.bottom,
        left:
            Dimens.screenHeight < Dimens.screenWidth ? Dimens.padding.left : 16,
        right:
            Dimens.screenHeight < Dimens.screenWidth ? Dimens.padding.left : 16,
        child: BlocSelector<AddTaskBloc, AddTaskState, AddTaskStatus>(
            selector: (p0) => p0.status,
            builder: (context, state) {
              if (state == AddTaskStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }
              return ButtonWidget(
                callback: () async {
                  final date = DateFormat("MMMM dd, yyyy", 'en')
                      .format(_dateTime)
                      .toFormattedDateString();
                  if (date != null) {
                    taskModel = await BlocProvider.of<AddTaskBloc>(context)
                        .addTask(_taskTitleController.text,
                            _notesController.text, date);

                    _notesController.clear();
                    _taskTitleController.clear();
                  }
                },
                title: AppLocalizations.of(context)!.save,
              );
            }));
  }

  SizedBox _buildBackground(BuildContext context) {
    return SizedBox(
      width: Dimens.screenWidth,
      height: Dimens.screenHeight,
      child: Column(
        children: [
          _buildHeader(),
          _buildForm(context),
        ],
      ),
    );
  }

  Flexible _buildForm(BuildContext context) {
    return Flexible(
      flex: Dimens.screenHeight > Dimens.screenWidth ? 5 : 3,
      fit: FlexFit.tight,
      child: Container(
        padding: EdgeInsets.only(
          bottom: 60,
          left: Dimens.screenHeight < Dimens.screenWidth
              ? Dimens.padding.left
              : 16,
          right: Dimens.screenHeight < Dimens.screenWidth
              ? Dimens.padding.left
              : 16,
        ),
        color: MyAppColors.greyColor,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              TextFieldWidget(
                hint: AppLocalizations.of(context)!.taskTitle,
                controller: _taskTitleController,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!.category,
                    style: MyAppStyles.hintTextStyle,
                  ),
                  const SizedBox(width: 8),
                  CategoryWidget(
                    index: 1,
                    callBack: () {
                      BlocProvider.of<AddTaskBloc>(context).setSelected(1);
                    },
                    selected:
                        BlocProvider.of<AddTaskBloc>(context, listen: true)
                            .state
                            .selectedButton,
                    assets: Assets.images.book.path,
                  ),
                  const SizedBox(width: 12),
                  CategoryWidget(
                    index: 2,
                    callBack: () {
                      BlocProvider.of<AddTaskBloc>(context).setSelected(2);
                    },
                    selected:
                        BlocProvider.of<AddTaskBloc>(context, listen: true)
                            .state
                            .selectedButton,
                    assets: Assets.images.schedule.path,
                  ),
                  const SizedBox(width: 12),
                  CategoryWidget(
                    index: 3,
                    callBack: () {
                      BlocProvider.of<AddTaskBloc>(context).setSelected(3);
                    },
                    selected:
                        BlocProvider.of<AddTaskBloc>(context, listen: true)
                            .state
                            .selectedButton,
                    assets: Assets.images.cup.path,
                  )
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Flexible(
                    child: TextFieldWidget(
                      hint: AppLocalizations.of(context)!.date,
                      isReadOnly: true,
                      placeholder: BlocProvider.of<LanguageBloc>(context)
                                  .state
                                  .locale ==
                              const Locale('en')
                          ? DateFormat("MMMM dd, yyyy", 'en')
                              .format(_dateTime)
                              .toFormattedDateString()
                          : DateFormat("dd-MM-yyyy", 'vi').format(_dateTime),
                      suffixIcon: GestureDetector(
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            firstDate: DateTime.now(),
                            initialEntryMode: DatePickerEntryMode.calendarOnly,
                            lastDate: DateTime(2999),
                          );
                          if (!context.mounted) return;
                          if (date != null) {
                            setState(() {
                              _dateTime = date;
                            });
                          }
                        },
                        child: const Icon(
                          Icons.date_range,
                          color: MyAppColors.backgroundColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Flexible(
                    child: TextFieldWidget(
                      isReadOnly: true,
                      hint: AppLocalizations.of(context)!.time,
                      placeholder: BlocProvider.of<AddTaskBloc>(context)
                          .state
                          .formattedTime,
                      suffixIcon: GestureDetector(
                        onTap: () async {
                          final time = await showTimePicker(
                              context: context, initialTime: TimeOfDay.now());
                          if (!context.mounted) return;

                          BlocProvider.of<AddTaskBloc>(context)
                              .setTimeSelected(time);
                        },
                        child: const Icon(
                          Icons.schedule,
                          color: MyAppColors.backgroundColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextFieldWidget(
                hint: AppLocalizations.of(context)!.notes,
                controller: _notesController,
                height: 177,
                maxLines: 10,
              ),
              SizedBox(height: Dimens.padding.bottom + 20),
            ],
          ),
        ),
      ),
    );
  }

  Flexible _buildHeader() {
    return Flexible(
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
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: Dimens.screenHeight > Dimens.screenWidth ? 0 : 10),
              child: AppBar(
                leading: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: MyAppColors.whiteColor,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Icon(Icons.close),
                  ),
                ),
                backgroundColor: MyAppColors.transparentColor,
                title: Text(AppLocalizations.of(context)!.addNewTask,style: MyAppStyles.titleAppbarTextStyle,),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
