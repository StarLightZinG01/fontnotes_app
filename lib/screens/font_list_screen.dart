import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/font_provider.dart';
import '../providers/theme_provider.dart';
import '../models/font_note.dart';
import 'add_font_screen.dart';
import 'edit_font_screen.dart';
import 'preview_font_screen.dart';

class FontListScreen extends StatefulWidget {
  const FontListScreen({super.key});

  @override
  State<FontListScreen> createState() => _FontListScreenState();
}

class _FontListScreenState extends State<FontListScreen> {
  String _query = '';
  bool _onlyFav = false;

  late Future<void> _initialLoad;

  @override
  void initState() {
    super.initState();
    _initialLoad = context.read<FontProvider>().loadNotes();
  }

  Future<void> _confirmDelete(
    BuildContext context,
    FontProvider provider,
    FontNote note,
  ) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('ยืนยันการลบ'),
        content: Text('ต้องการลบ “${note.name}” ใช่ไหม?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('ยกเลิก'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('ลบ', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (ok == true) {
      await provider.deleteNote(note.id!);
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('ลบ "${note.name}" แล้ว')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FontProvider>();
    final theme = context.watch<ThemeProvider>();
    final notes = provider.notes;

    // กรองรายการตาม search + เฉพาะ favorite
    final filtered = notes.where((n) {
      if (_onlyFav && !(n.isFavorite)) return false;
      final q = _query.trim().toLowerCase();
      if (q.isEmpty) return true;
      final inName = n.name.toLowerCase().contains(q);
      final inTag = (n.tags ?? '').toLowerCase().contains(q);
      final inUsage = n.usage.toLowerCase().contains(q);
      return inName || inTag || inUsage;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Font Notes'),
        actions: [
          // Toggle Dark/Light
          IconButton(
            tooltip: theme.isDark ? 'โหมดสว่าง' : 'โหมดมืด',
            icon: Icon(theme.isDark ? Icons.wb_sunny : Icons.dark_mode),
            onPressed: () => context.read<ThemeProvider>().toggleTheme(),
          ),
          // เฉพาะ Favorite
          IconButton(
            tooltip: _onlyFav ? 'แสดงทั้งหมด' : 'แสดงเฉพาะที่ชื่นชอบ',
            icon: Icon(
              _onlyFav ? Icons.favorite : Icons.favorite_border,
              color: _onlyFav ? Colors.red : null,
            ),
            onPressed: () => setState(() => _onlyFav = !_onlyFav),
          ),
          // ไปหน้า Add
          IconButton(
            tooltip: 'เพิ่มฟอนต์',
            icon: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddFontScreen()),
              );
              if (!mounted) return;
              await provider.loadNotes();
            },
          ),
        ],
      ),

      body: FutureBuilder(
        future: _initialLoad,
        builder: (context, snapshot) {
          return Column(
            children: [
              // ค้นหา
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'ค้นหาชื่อฟอนต์ / แท็ก / การใช้งาน',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onChanged: (v) => setState(() => _query = v),
                ),
              ),

              // เนื้อหา
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => provider.loadNotes(),
                  child: filtered.isEmpty
                      ? ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            const SizedBox(height: 80),
                            Center(
                              child: Column(
                                children: [
                                  const Icon(
                                    Icons.font_download,
                                    size: 56,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    _query.isEmpty
                                        ? (_onlyFav
                                              ? 'ยังไม่มีฟอนต์ที่กดหัวใจ'
                                              : 'ยังไม่มีรายการฟอนต์')
                                        : 'ไม่พบผลลัพธ์สำหรับ “$_query”',
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                  const SizedBox(height: 10),
                                  if (_query.isNotEmpty)
                                    TextButton(
                                      onPressed: () =>
                                          setState(() => _query = ''),
                                      child: const Text('ล้างการค้นหา'),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : ListView.builder(
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            final note = filtered[index];
                            final tagList =
                                (note.tags != null &&
                                    note.tags!.trim().isNotEmpty)
                                ? note.tags!
                                      .split(',')
                                      .map((t) => t.trim())
                                      .where((t) => t.isNotEmpty)
                                      .toList()
                                : [];

                            return Card(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              child: ListTile(
                                // แตะทั้งแถว -> ไปหน้า Preview
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          PreviewFontScreen(note: note),
                                    ),
                                  );
                                },

                                // หัวใจ favorite
                                leading: IconButton(
                                  icon: Icon(
                                    note.isFavorite
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: note.isFavorite
                                        ? Colors.red
                                        : Colors.grey,
                                  ),
                                  onPressed: () => context
                                      .read<FontProvider>()
                                      .toggleFavorite(note),
                                ),

                                title: Text(
                                  note.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.blue.shade900,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(note.usage),
                                    const SizedBox(height: 6),
                                    if (tagList.isNotEmpty)
                                      Wrap(
                                        spacing: 6,
                                        runSpacing: 4,
                                        children: tagList
                                            .map(
                                              (tag) => Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: Colors.blue.shade50,
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                ),
                                                child: Text(
                                                  '• $tag',
                                                  style: const TextStyle(
                                                    color: Colors.blue,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                      ),
                                  ],
                                ),

                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      tooltip: 'แก้ไข',
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.grey,
                                      ),
                                      iconSize: 22,
                                      padding: EdgeInsets.zero,
                                      visualDensity: const VisualDensity(
                                        horizontal: -4,
                                        vertical: -4,
                                      ),
                                      onPressed: () async {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                EditFontScreen(note: note),
                                          ),
                                        );
                                        if (!mounted) return;
                                        await provider.loadNotes();
                                      },
                                    ),
                                    IconButton(
                                      tooltip: 'ลบ',
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      iconSize: 22,
                                      padding: EdgeInsets.zero,
                                      visualDensity: const VisualDensity(
                                        horizontal: -4,
                                        vertical: -4,
                                      ),
                                      onPressed: () => _confirmDelete(
                                        context,
                                        provider,
                                        note,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
