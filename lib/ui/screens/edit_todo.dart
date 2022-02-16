import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:test_app/controllers/edit_todo_controller.dart';
import 'package:test_app/data/models/todo.dart';

class EditTodo extends StatelessWidget {
  EditTodo({Key? key, this.todo}) : super(key: key);
  static const id = '/Edit_todo_screen';


  final Todo? todo;
  final EditTodoController editTodoController = Get.find<EditTodoController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            todo == null
              ? 'Add new Task'
              : 'Update Task',
        ),
      ),

      body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _TitleField(),
                      _DescriptionField()
                    ],
                  ),
                ),
              ),
      floatingActionButton: FloatingActionButton(
        tooltip: todo != null ? 'Save changes' : 'Add Todo',
        child: Obx(
            () => editTodoController.status.value == editTodoStatus.loading
                ? const CupertinoActivityIndicator()
                : Icon(todo != null ? Icons.check : Icons.add)
        ),
        onPressed: () async{
            await editTodoController.onSubmitted(todo);
            if(editTodoController.status.value == editTodoStatus.error){
              Get.snackbar("Error", "Can't edit task");
            }
            if(editTodoController.status.value == editTodoStatus.success){
              Get.back();
            }
          }
      ),
    );
  }
}

class _TitleField extends StatelessWidget {
   _TitleField({Key? key}) : super(key: key);
  final EditTodoController editTodoController = Get.find<EditTodoController>();
  @override
  Widget build(BuildContext context) {

    return Obx(()
     => TextFormField(
       key: const Key('editTodoView_title_textFormField'),
       initialValue: editTodoController.todoTitle.value,
       decoration: InputDecoration(
         enabled: !(editTodoController.status.value == editTodoStatus.loading),
         labelText: 'What are you going to do? ',
         hintText: editTodoController.todoTitle.value.isEmpty
             ? 'Ex: Meeting, Catch bus,...' : '',
       ),
       maxLength: 50,
       inputFormatters: [
         LengthLimitingTextInputFormatter(50)
       ],
       onChanged: (value) {
         editTodoController.onTitleChange(value);
       },
     ));
  }
}

class _DescriptionField extends StatelessWidget {
   _DescriptionField({Key? key}) : super(key: key);

  final EditTodoController editTodoController = Get.find<EditTodoController>();

   @override
  Widget build(BuildContext context) {

    return Obx(()
      => TextFormField(
        key: const Key('editTodoView_description_textFormField'),
        initialValue: editTodoController.todoDesc.value,
        decoration: InputDecoration(
          enabled: !(editTodoController.status.value == editTodoStatus.loading),
          labelText: 'Describe your task',
          hintText: editTodoController.todoDesc.value.isEmpty
              ? 'Ex: Going with friend...' : '',
        ),
        maxLength: 300,
        maxLines: 7,
        inputFormatters: [
          LengthLimitingTextInputFormatter(300)
        ],
        onChanged: (value) {
          editTodoController.onDescChange(value);
        },
      )
    );

  }
}

