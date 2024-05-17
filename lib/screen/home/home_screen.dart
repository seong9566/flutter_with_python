import 'package:flutter/material.dart';
import 'package:serious_python/serious_python.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _pyResult = "Running...";
  final String _pyFileName = "app/test.py";

  @override
  void initState() {
    super.initState();
  }

  Future<void> initPlatformState() async {
    String? pyResult;

    Directory tempDir =
        await (await getTemporaryDirectory()).createTemp("seong_test");
    print("tempDir: ${tempDir.path}");
    String out = path.join(tempDir.path, "output.text");
    print("out: ${out}");

    await SeriousPython.run(
      _pyFileName,
      environmentVariables: {
        "RESULT_FILENAME": out,
      },
      sync: true,
    );

    var outFile = File(out);
    print("outFile: ${outFile.path}");

    /// out 파일 존재 여부 exists()
    if (await outFile.exists()) {
      pyResult = await outFile.readAsString();

      /// 데이터 모두 read했으면 생성된 파일 삭제
      outFile.delete();
      tempDir.delete();
    }

    if (!mounted) return;

    setState(() {
      _pyResult = pyResult ?? "Error: No output from Python script";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Python Sum Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Result: $_pyResult"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: initPlatformState,
              child: const Text("Run Python Script"),
            ),
          ],
        ),
      ),
    );
  }
}
