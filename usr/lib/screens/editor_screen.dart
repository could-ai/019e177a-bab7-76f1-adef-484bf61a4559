import 'package:flutter/material.dart';
import '../models/presentation.dart';

class EditorScreen extends StatefulWidget {
  final Presentation presentation;

  const EditorScreen({super.key, required this.presentation});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  int _currentSlideIndex = 0;
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    if (widget.presentation.slides.isEmpty) {
      _titleController = TextEditingController();
      _contentController = TextEditingController();
      return;
    }
    final currentSlide = widget.presentation.slides[_currentSlideIndex];
    _titleController = TextEditingController(text: currentSlide.title);
    _contentController = TextEditingController(text: currentSlide.content);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _updateCurrentSlide() {
    if (widget.presentation.slides.isEmpty) return;
    setState(() {
      widget.presentation.slides[_currentSlideIndex] = Slide(
        id: widget.presentation.slides[_currentSlideIndex].id,
        title: _titleController.text,
        content: _contentController.text,
        type: widget.presentation.slides[_currentSlideIndex].type,
      );
    });
  }

  void _addNewSlide() {
    _updateCurrentSlide();
    setState(() {
      widget.presentation.slides.add(
        Slide(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: 'สไลด์ใหม่',
          content: '',
          type: SlideType.content,
        ),
      );
      _currentSlideIndex = widget.presentation.slides.length - 1;
      _initControllers();
    });
  }

  void _changeSlide(int index) {
    _updateCurrentSlide();
    setState(() {
      _currentSlideIndex = index;
      _initControllers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width > 800;

    Widget slideList = Container(
      width: isDesktop ? 250 : double.infinity,
      color: Colors.grey.shade100,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              onPressed: _addNewSlide,
              icon: const Icon(Icons.add),
              label: const Text('เพิ่มสไลด์'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 40),
              ),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              itemCount: widget.presentation.slides.length,
              itemBuilder: (context, index) {
                final slide = widget.presentation.slides[index];
                return ListTile(
                  selected: _currentSlideIndex == index,
                  selectedTileColor: Colors.blue.shade100,
                  leading: CircleAvatar(
                    child: Text('${index + 1}'),
                  ),
                  title: Text(slide.title.isEmpty ? 'ไม่มีชื่อ' : slide.title),
                  onTap: () => _changeSlide(index),
                );
              },
            ),
          ),
        ],
      ),
    );

    Widget editorArea = Padding(
      padding: const EdgeInsets.all(16.0),
      child: widget.presentation.slides.isEmpty
          ? const Center(child: Text('ไม่มีสไลด์'))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'หัวข้อสไลด์',
                    border: OutlineInputBorder(),
                  ),
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  onChanged: (_) => _updateCurrentSlide(),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: TextField(
                    controller: _contentController,
                    decoration: const InputDecoration(
                      labelText: 'เนื้อหาสไลด์',
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                    ),
                    maxLines: null,
                    expands: true,
                    onChanged: (_) => _updateCurrentSlide(),
                  ),
                ),
              ],
            ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.presentation.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.play_arrow),
            tooltip: 'นำเสนอ',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('กำลังพัฒนาโหมดนำเสนอ')),
              );
            },
          ),
        ],
      ),
      body: isDesktop
          ? Row(
              children: [
                slideList,
                const VerticalDivider(width: 1),
                Expanded(child: editorArea),
              ],
            )
          : Column(
              children: [
                SizedBox(height: 150, child: slideList),
                const Divider(height: 1),
                Expanded(child: editorArea),
              ],
            ),
    );
  }
}
