// @dart=2.9
import 'package:avatar_glow/avatar_glow.dart';
import "package:flutter/material.dart";
import 'package:highlight_text/highlight_text.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:clipboard/clipboard.dart';

void main() => runApp(VoiceApp());

class VoiceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Speech to Text",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Speech(),
    );
  }
}

class Speech extends StatefulWidget {
  @override
  State<Speech> createState() => _SpeechState();
}

class _SpeechState extends State<Speech> {
  final Map<String, HighlightedWord> _highlights = {
    'zee': HighlightedWord(
      onTap: () => print('flutter'),
      textStyle: const TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.bold,
        fontSize: 28.0,
      ),
    ),
    'sony': HighlightedWord(
      onTap: () => print('voice'),
      textStyle: const TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.bold,
        fontSize: 28.0,
      ),
    ),
    'subscription': HighlightedWord(
      onTap: () => print('subscribe'),
      textStyle: const TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
        fontSize: 28.0,
      ),
    ),
    'colors': HighlightedWord(
      onTap: () => print('like'),
      textStyle: const TextStyle(
        color: Colors.blueAccent,
        fontWeight: FontWeight.bold,
        fontSize: 28.0,
      ),
    ),
    'star': HighlightedWord(
      onTap: () => print('comment'),
      textStyle: const TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.bold,
        fontSize: 28.0,
      ),
    ),
  };

  stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = "Listening...";
  double _confidence = 1.0;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _listen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "FOFI-VOICE",
        ), //Text('Confidence: ${(_confidence * 100.0).toStringAsFixed(1)}%'),
        actions: [
          Builder(builder: (context) {
            return IconButton(
              onPressed: () async {
                await FlutterClipboard.copy(_text);
                Scaffold.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Copied to Clipboard'),
                    duration: Duration(milliseconds: 400),
                  ),
                );
              },
              icon: const Icon(Icons.content_copy),
            );
          })
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: Theme.of(context).primaryColor,
        endRadius: 75.0,
        duration: const Duration(
          milliseconds: 2000,
        ),
        repeatPauseDuration: const Duration(
          milliseconds: 100,
        ),
        repeat: true,
        child: FloatingActionButton(
          onPressed: _listen,
          child: Icon(
            _isListening ? Icons.mic : Icons.mic_off,
          ),
        ),
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            reverse: true,
            child: Container(
              padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
              child: TextHighlight(
                text: _text,
                words: _highlights,
                textStyle: const TextStyle(
                  fontSize: 28.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onError(SpeechRecognitionError val) async {
    print('onError(): ${val.errorMsg}');
    _listen();
  }

  void onSuccess(SpeechRecognitionError val) async {
    print('onSuccess(): ${val.errorMsg}');
    _listen();
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => onError(val),
      );

      print('available-$available');
      if (available) {
        _text = 'Listening...';
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
              _isListening = false;
            }
          }),
        );
      }
    } else {
      setState(
          () => {_isListening = false, _text = 'Didn\'t hear that. Try again'});
      _speech.stop();
    }
  }
}
