import 'package:flutter/material.dart';
import '../models/presentation.dart';
import 'editor_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Presentation> _presentations = [
    Presentation(
      id: '1',
      title: 'ผลกระทบของ AI ต่องานวิจัย',
      author: 'นักศึกษา ป.โท',
      date: DateTime.now(),
      slides: [
        Slide(
          id: 's1',
          title: 'บทนำ',
          content: 'ความสำคัญและที่มาของปัญหา...',
          type: SlideType.title,
        ),
      ],
    )
  ];

  void _createNewPresentation() {
    final newPresentation = Presentation(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'งานนำเสนอใหม่',
      author: '',
      date: DateTime.now(),
      slides: [
        Slide(
          id: 's_${DateTime.now().millisecondsSinceEpoch}',
          title: 'หน้าปก',
          content: 'ชื่อเรื่อง...',
          type: SlideType.title,
        ),
      ],
    );
    
    setState(() {
      _presentations.add(newPresentation);
    });
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditorScreen(presentation: newPresentation),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('งานนำเสนอวิจัยและวิทยานิพนธ์'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _presentations.isEmpty
          ? const Center(child: Text('ยังไม่มีงานนำเสนอ กด + เพื่อสร้างใหม่'))
          : LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount = constraints.maxWidth > 800 ? 4 : constraints.maxWidth > 500 ? 2 : 1;
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: 16 / 9,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: _presentations.length,
                  itemBuilder: (context, index) {
                    final presentation = _presentations[index];
                    return Card(
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditorScreen(presentation: presentation),
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: Container(
                                color: Colors.blueGrey.shade100,
                                child: Center(
                                  child: Icon(Icons.slideshow, size: 48, color: Colors.blueGrey.shade700),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    presentation.title,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${presentation.slides.length} สไลด์',
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewPresentation,
        child: const Icon(Icons.add),
      ),
    );
  }
}
