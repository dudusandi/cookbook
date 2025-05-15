import 'dart:io';
import 'package:path/path.dart' as path;

void main() async {
  // Cria o diretório de ícones se não existir
  final iconDir = Directory('assets/icon');
  if (!await iconDir.exists()) {
    await iconDir.create(recursive: true);
  }

  // Converte SVG para PNG usando o Inkscape (precisa estar instalado)
  final svgPath = path.join('assets', 'icon', 'icon.svg');
  final pngPath = path.join('assets', 'icon', 'icon.png');
  
  try {
    final result = await Process.run('inkscape', [
      '--export-filename=$pngPath',
      '--export-width=1024',
      '--export-height=1024',
      svgPath
    ]);

    if (result.exitCode != 0) {
      print('Erro ao converter SVG para PNG: ${result.stderr}');
      exit(1);
    }

    print('Ícone gerado com sucesso em: $pngPath');
    
    // Gera o ícone para Android
    final flutterResult = await Process.run('flutter', ['pub', 'run', 'flutter_launcher_icons']);
    
    if (flutterResult.exitCode != 0) {
      print('Erro ao gerar ícone do Android: ${flutterResult.stderr}');
      exit(1);
    }

    print('Ícone do Android gerado com sucesso!');
  } catch (e) {
    print('Erro ao executar o script: $e');
    exit(1);
  }
} 