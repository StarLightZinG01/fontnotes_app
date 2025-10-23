import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/font_note.dart';

class PreviewFontScreen extends StatefulWidget {
  final FontNote note;
  const PreviewFontScreen({super.key, required this.note});

  @override
  State<PreviewFontScreen> createState() => _PreviewFontScreenState();
}

class _PreviewFontScreenState extends State<PreviewFontScreen> {
  final _controller = TextEditingController(
    text: 'สวัสดี Font Notes\nHello World 123',
  );
  double _size = 28;
  bool _bold = true;
  bool _darkBg = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get _displayFont {
    final candidate = widget.note.name.trim();
    return GoogleFonts.asMap().containsKey(candidate) ? candidate : 'Prompt';
  }

  @override
  Widget build(BuildContext context) {
    final textColor = _darkBg ? Colors.white : Colors.black87;
    final panelBg = _darkBg ? const Color(0xFF1B1E22) : const Color(0xFFF6F7FB);

    return Scaffold(
      appBar: AppBar(title: Text('พรีวิว: ${widget.note.name}')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // แผงควบคุม
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  TextField(
                    controller: _controller,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'ข้อความตัวอย่าง',
                      hintText: 'พิมพ์ข้อความเพื่อดูตัวอย่าง',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Text('ขนาด'),
                      Expanded(
                        child: Slider(
                          value: _size,
                          min: 14,
                          max: 64,
                          onChanged: (v) => setState(() => _size = v),
                        ),
                      ),
                      Text(_size.toInt().toString()),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('ตัวหนา'),
                          value: _bold,
                          onChanged: (v) => setState(() => _bold = v ?? false),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // กล่องพรีวิวข้อความ
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: panelBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ตัวอย่างการแสดงผล',
                  style: GoogleFonts.prompt(
                    fontSize: 14,
                    color: textColor.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _controller.text,
                  style: GoogleFonts.getFont(
                    _displayFont,
                    fontSize: _size,
                    fontWeight: _bold ? FontWeight.bold : FontWeight.normal,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
