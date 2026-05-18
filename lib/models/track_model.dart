class Track {
  final String title;
  final String artist;
  final String coverUrl;
  final String previewUrl;

  Track({
    required this.title,
    required this.artist,
    required this.coverUrl,
    required this.previewUrl,
  });

  // Factory to parse the JSON from the Deezer API
  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      title: json['title'] ?? 'Unknown Title',
      artist: json['artist']['name'] ?? 'Unknown Artist',
      coverUrl: json['album']['cover_medium'] ?? '',
      previewUrl: json['preview'] ?? '',
    );
  }
}
