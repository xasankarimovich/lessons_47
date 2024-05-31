import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/todo_model.dart';

class TodoDialogBox extends StatefulWidget {
  final TodoModel? todo;
  const TodoDialogBox({
    super.key,
    this.todo,
  });

  @override
  State<TodoDialogBox> createState() => _TodoDialogBoxState();
}

class _TodoDialogBoxState extends State<TodoDialogBox> {
  final formKey = GlobalKey<FormState>();
  String title = "";
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();

    if (widget.todo != null) {
      title = widget.todo!.title;
      try {
        selectedDate = DateFormat('yyyy-MM-dd').parse(widget.todo!.time);
      } catch (e) {
        selectedDate = DateTime.now();
      }
    }
  }

  void submit() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      Navigator.pop(context, {
        "title": title,
        "time": DateFormat('yyyy-MM-dd').format(selectedDate!),
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Text(
        widget.todo != null ? "Taskni tahrirlash" : "Task qo'shish",
      ),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: title,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Task nomi",
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Iltimos Task nomini kiriting";
                }
                return null;
              },
              onSaved: (newValue) {
                title = newValue!;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              readOnly: true,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: "Sana tanlang",
                hintText: selectedDate != null
                    ? DateFormat('yyyy-MM-dd').format(selectedDate!)
                    : 'Sana tanlanmagan',
              ),
              onTap: () => _selectDate(context),
              validator: (value) {
                if (selectedDate == null) {
                  return "Iltimos sana tanlang";
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Bekor qilish"),
        ),
        ElevatedButton(
          onPressed: submit,
          child: Text(widget.todo != null ? "Saqlash" : "Qo'shish"),
        ),
      ],
    );
  }
}
