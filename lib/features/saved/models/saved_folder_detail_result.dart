class SavedFolderDetailResult {
  const SavedFolderDetailResult({
    required this.folderDeleted,
    required this.placeCount,
    this.coverImageUrl,
  });

  final bool folderDeleted;
  final int placeCount;
  final String? coverImageUrl;
}
