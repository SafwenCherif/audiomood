import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../../models/mood_history_model.dart';

class HistoryDetailScreen extends StatefulWidget {
  const HistoryDetailScreen({super.key, required this.history});

  final MoodHistoryModel history;

  @override
  State<HistoryDetailScreen> createState() => _HistoryDetailScreenState();
}

class _HistoryDetailScreenState extends State<HistoryDetailScreen> {
  final AudioPlayer _player = AudioPlayer();
  bool _isLoading = true;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    if (widget.history.previewUrl.isEmpty) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      await _player.setUrl(widget.history.previewUrl);
      await _player.play();
      setState(() {
        _isLoading = false;
        _isPlaying = true;
      });
    } catch (_) {
      setState(() {
        _isLoading = false;
        _isPlaying = false;
      });
    }
  }

  Future<void> _stopAudio() async {
    await _player.stop();
  }

  @override
  void dispose() {
    _stopAudio();
    _player.dispose();
    super.dispose();
  }

  Future<bool> _handleBack() async {
    await _stopAudio();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final date = widget.history.createdAt.toDate();
    final formatted =
        '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';

    return WillPopScope(
      onWillPop: _handleBack,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mood Details'),
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              await _stopAudio();
              if (mounted) {
                Navigator.pop(context);
              }
            },
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  widget.history.imageUrl,
                  height: 260,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 260,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.image_not_supported, size: 64),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                widget.history.mood.toUpperCase(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text('Saved on $formatted'),
              const SizedBox(height: 24),
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else if (widget.history.previewUrl.isEmpty)
                const Text('No preview audio available for this mood.')
              else
                ElevatedButton.icon(
                  onPressed: () async {
                    if (_isPlaying) {
                      await _player.pause();
                    } else {
                      await _player.play();
                    }
                    setState(() {
                      _isPlaying = !_isPlaying;
                    });
                  },
                  icon: Icon(
                    _isPlaying ? Icons.pause_circle : Icons.play_circle_fill,
                  ),
                  label: Text(_isPlaying ? 'Pause' : 'Play preview'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
