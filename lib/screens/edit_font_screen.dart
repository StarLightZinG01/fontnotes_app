import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/font_note.dart';
import '../providers/font_provider.dart';

class EditFontScreen extends StatefulWidget {
  final FontNote note;
  const EditFontScreen({super.key, required this.note});

  @override
  State<EditFontScreen> createState() => _EditFontScreenState();
}

class _EditFontScreenState extends State<EditFontScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _usage;
  String? _tags;

  @override
  void initState() {
    super.initState();
    _name = widget.note.name;
    _usage = widget.note.usage;
    _tags = widget.note.tags;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('แก้ไขข้อมูลฟอนต์'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ยกเลิก', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // ชื่อฟอนต์ (บังคับ)
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(
                  labelText: 'ชื่อฟอนต์',
                  hintText: 'เช่น Kanit / Sarabun / Prompt',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'กรอกชื่อฟอนต์' : null,
                onSaved: (v) => _name = v!.trim(),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 12),

              // การนำไปใช้งาน (บังคับ)
              TextFormField(
                initialValue: _usage,
                decoration: const InputDecoration(
                  labelText: 'การนำไปใช้งาน',
                  hintText: 'เช่น ใช้เป็นหัวข้อโปสเตอร์, UI แอป, เอกสารทางการ',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'กรอกการใช้งาน' : null,
                onSaved: (v) => _usage = v!.trim(),
                textInputAction: TextInputAction.newline,
              ),
              const SizedBox(height: 12),

              // แท็ก (ไม่บังคับ)
              TextFormField(
                initialValue: _tags,
                decoration: const InputDecoration(
                  labelText: 'แท็ก (ไม่บังคับ)',
                  hintText: 'ตัวอย่าง: มินิมอล, เรียบง่าย, โมเดิร์น',
                  border: OutlineInputBorder(),
                ),
                onSaved: (v) =>
                    _tags = (v == null || v.trim().isEmpty) ? null : v.trim(),
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 20),

              // ปุ่มบันทึกการแก้ไข
              SizedBox(
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      context
                          .read<FontProvider>()
                          .updateNote(widget.note.id!, _name, _usage, _tags)
                          .then((_) => Navigator.pop(context));
                    }
                  },
                  icon: const Icon(Icons.check),
                  label: const Text('บันทึกการแก้ไข'),
                ),
              ),
              const SizedBox(height: 8),

              // ปุ่มยกเลิก (สำรองด้านล่าง)
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('ยกเลิกการแก้ไข'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
