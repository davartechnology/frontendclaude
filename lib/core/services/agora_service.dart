import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import '../../config/env.dart';

class AgoraService {
  static final AgoraService _instance = AgoraService._internal();
  factory AgoraService() => _instance;
  AgoraService._internal();

  RtcEngine? _engine;
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    _engine = createAgoraRtcEngine();
    await _engine!.initialize(RtcEngineContext(
      appId: Env.agoraAppId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));

    _isInitialized = true;
  }

  Future<void> joinChannel({
    required String token,
    required String channelName,
    required int uid,
    bool isBroadcaster = false,
  }) async {
    if (_engine == null) await initialize();

    await _engine!.setClientRole(
      role: isBroadcaster
          ? ClientRoleType.clientRoleBroadcaster
          : ClientRoleType.clientRoleAudience,
    );

    await _engine!.startPreview();

    await _engine!.joinChannel(
      token: token,
      channelId: channelName,
      uid: uid,
      options: const ChannelMediaOptions(
        publishCameraTrack: true,
        publishMicrophoneTrack: true,
      ),
    );
  }

  Future<void> leaveChannel() async {
    if (_engine == null) return;
    await _engine!.leaveChannel();
  }

  Future<void> switchCamera() async {
    if (_engine == null) return;
    await _engine!.switchCamera();
  }

  Future<void> muteLocalAudio(bool muted) async {
    if (_engine == null) return;
    await _engine!.muteLocalAudioStream(muted);
  }

  Future<void> muteLocalVideo(bool muted) async {
    if (_engine == null) return;
    await _engine!.muteLocalVideoStream(muted);
  }

  Future<void> enableVideo() async {
    if (_engine == null) return;
    await _engine!.enableVideo();
  }

  Future<void> disableVideo() async {
    if (_engine == null) return;
    await _engine!.disableVideo();
  }

  void registerEventHandler(RtcEngineEventHandler handler) {
    if (_engine == null) return;
    _engine!.registerEventHandler(handler);
  }

  void unregisterEventHandler(RtcEngineEventHandler handler) {
    if (_engine == null) return;
    _engine!.unregisterEventHandler(handler);
  }

  Future<void> dispose() async {
    if (_engine == null) return;
    await _engine!.leaveChannel();
    await _engine!.release();
    _engine = null;
    _isInitialized = false;
  }

  RtcEngine? get engine => _engine;
}