import 'package:flutter/material.dart';
import 'package:personal_task_manager/models/task_model.dart';
import 'package:intl/intl.dart';

class AddTaskScreen extends StatefulWidget {
  final String userId;
  final TaskModel? existingTask;
  const AddTaskScreen({super.key, this.existingTask, required this.userId});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final formkey = GlobalKey<FormState>();

  String _title = "";
  String _description = "";
  DateTime? _dueDate;
  Priority _priority = Priority.low;
  String? _categoryId;

  @override
  void initState() {
    super.initState();
    if (widget.existingTask != null) {
      _title = widget.existingTask!.title;
      _description = widget.existingTask!.description!;
      _dueDate = widget.existingTask!.dueDate;
      _priority = widget.existingTask!.priority;
      _categoryId = widget.existingTask!.categoryId;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  //To submit task
  void _submitTask() {
    if (formkey.currentState!.validate()) {
      formkey.currentState!.save();
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.existingTask != null
            ? Text('Edit Task')
            : Text('Create Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formkey,
          child: ListView(
            children: [
              //Input field for task title
              TextFormField(
                initialValue: _title,
                decoration: InputDecoration(
                  labelText: 'Task Title',
                  border: InputBorder.none,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a title";
                  }
                  return null;
                },
                onSaved: (newValue) {
                  _title = newValue!;
                },
              ),

              SizedBox(
                height: 16,
              ),

              //Input field for description
              TextFormField(
                initialValue: _description,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: InputBorder.none,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a description";
                  }
                  return null;
                },
                onSaved: (newValue) {
                  _title = newValue!;
                },
              ),

              SizedBox(
                height: 16,
              ),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: TextEditingController(
                          text: _dueDate != null
                              ? DateFormat('yyyy-MM-dd').format(_dueDate!)
                              : ''),
                      decoration: InputDecoration(
                        labelText: 'Due date',
                        border: InputBorder.none,
                      ),
                      readOnly: true,
                      onTap: () => _selectDate(context),
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  DropdownButton<Priority>(
                    value: _priority,
                    hint: Text('Priority'),
                    items: Priority.values
                        .map<DropdownMenuItem<Priority>>((Priority priority) {
                      return DropdownMenuItem<Priority>(
                        value: priority,
                        child: Text(priority.toString().split('.').last),
                      );
                    }).toList(),
                    onChanged: (Priority? newValue) {
                      setState(() {
                        _priority = newValue!;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitTask,
                child: Text('Save Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
