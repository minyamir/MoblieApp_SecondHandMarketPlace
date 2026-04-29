class Verification {
  final String userId;
  final String frontIdPath;
  final String backIdPath;
  final List<String> selfiePaths; // front, left, right
  final String livenessVideoPath;

  Verification({
    required this.userId,
    required this.frontIdPath,
    required this.backIdPath,
    required this.selfiePaths,
    required this.livenessVideoPath,
  });
}