import 'video_model.dart';
import 'user_model.dart';

class MockVideos {
  static final list = [
    VideoModel(
      id: '1',
      userId: 'u1',
      videoUrl: 'assets/videos/video1.mp4',
      thumbnailUrl: '',
      description: 'Vidéo locale 1',
      duration: 12,
      createdAt: DateTime.now(),
      user: UserModel(
        id: 'u1',
        username: 'local_user',
        email: 'local1@test.com',
        createdAt: DateTime.now(),
      ),
    ),
    VideoModel(
      id: '2',
      userId: 'u2',
      videoUrl: 'assets/videos/video2.mp4',
      thumbnailUrl: '',
      description: 'Vidéo locale 2',
      duration: 15,
      createdAt: DateTime.now(),
      user: UserModel(
        id: 'u2',
        username: 'local_user2',
        email: 'local2@test.com',
        createdAt: DateTime.now(),
      ),
    ),
  ];
}
