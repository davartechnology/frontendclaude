import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import '../../data/models/live_stream_model.dart';
import '../../core/services/agora_service.dart';
import 'widgets/live_chat.dart';
import 'widgets/gift_picker.dart';
import 'widgets/viewers_list.dart';

class WatchLiveScreen extends ConsumerStatefulWidget {
  final LiveStreamModel stream;

  const WatchLiveScreen({
    super.key,
    required this.stream,
  });

  @override
  ConsumerState<WatchLiveScreen> createState() => _WatchLiveScreenState();
}

class _WatchLiveScreenState extends ConsumerState<WatchLiveScreen> {
  final AgoraService _agoraService = AgoraService();
  bool _isJoined = false;
  int _remoteUid = 0;

  @override
  void initState() {
    super.initState();
    _joinLive();
  }

  Future<void> _joinLive() async {
    await _agoraService.initialize();
    
    _agoraService.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (connection, elapsed) {
          setState(() => _isJoined = true);
        },
        onUserJoined: (connection, uid, elapsed) {
          setState(() => _remoteUid = uid);
        },
        onUserOffline: (connection, uid, reason) {
          setState(() => _remoteUid = 0);
        },
      ),
    );

    await _agoraService.joinChannel(
      token: widget.stream.agoraToken ?? '',
      channelName: widget.stream.channelName,
      uid: 0,
      isBroadcaster: false,
    );
  }

  @override
  void dispose() {
    _agoraService.leaveChannel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (_remoteUid != 0)
            AgoraVideoView(
              controller: VideoViewController.remote(
                rtcEngine: _agoraService.engine!,
                canvas: VideoCanvas(uid: _remoteUid),
                connection: RtcConnection(channelId: widget.stream.channelName),
              ),
            )
          else
            const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.grey[800],
                        backgroundImage: widget.stream.user.avatarUrl.isNotEmpty
                            ? NetworkImage(widget.stream.user.avatarUrl)
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.stream.user.username,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              widget.stream.title,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.visibility, color: Colors.white, size: 16),
                            const SizedBox(width: 6),
                            Text(
                              '${widget.stream.viewersCount}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                const LiveChat(),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: Colors.white30),
                            ),
                            child: const Text(
                              'Ajouter un commentaire...',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        icon: const Icon(Icons.card_giftcard, color: Colors.white),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            builder: (context) => const GiftPicker(),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.people, color: Colors.white),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            builder: (context) => const ViewersList(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}