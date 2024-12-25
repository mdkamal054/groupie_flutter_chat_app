import 'dart:io';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:video_compress/video_compress.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:groupie_flutter_chat_app/pages/group_info.dart';
import 'package:groupie_flutter_chat_app/service/database_service.dart';
import 'package:groupie_flutter_chat_app/widgets/widgets.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/MessageTile.dart';

class ChatPage extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String userName;

  const ChatPage(
      {super.key,
      required this.groupId,
      required this.groupName,
      required this.userName});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ScrollController _scrollController = ScrollController();

  Stream<QuerySnapshot>? chats;
  Stream<QuerySnapshot>? media;

  String admin = "";
  TextEditingController messageController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  String? _downloadUrl;
  String imgUrl =
      "https://cdn.britannica.com/70/234870-050-D4D024BB/Orange-colored-cat-yawns-displaying-teeth.jpg";
  bool _isVideo = false;
  bool _isMidea = false;
  bool isLoading = false;
  final focusNode = FocusNode();

  String url = "";

  Future<void> pickAndUploadMedia() async {
    try {
      final XFile? pickedFile =
          await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile == null) {
        return;
      }

      final File file = File(pickedFile.path);
      final int fileSize = await file.length();
      const int maxFileSize = 5 * 1024 * 1024;

      File? compressedFile;

      if (fileSize > maxFileSize) {
        if (pickedFile.path.endsWith('.mp4') ||
            pickedFile.path.endsWith('.mov')) {
          _isVideo = true;
          final MediaInfo? info = await VideoCompress.compressVideo(
            pickedFile.path,
            quality: VideoQuality.MediumQuality,
          );
          compressedFile = File(info!.path!);
        } else {
          final Directory tempDir = await getTemporaryDirectory();
          final String targetPath =
              path.join(tempDir.path, path.basename(pickedFile.path));
          XFile _compressedFile = XFile(compressedFile!.path);
          _compressedFile = (await FlutterImageCompress.compressAndGetFile(
            file.path,
            targetPath,
            quality: 80,
          ))!;
        }
      } else {
        compressedFile = file;
        _isVideo = pickedFile.path.endsWith('.mp4') ||
            pickedFile.path.endsWith('.mov');
      }

      if (compressedFile == null) {
        throw Exception("File compression failed.");
      }

      final String fileName = path.basename(compressedFile.path);
      final Reference storageRef = FirebaseStorage.instance
          .ref("images")
          .child(DateTime.now().millisecondsSinceEpoch.toString());

      final UploadTask uploadTask = storageRef.putFile(compressedFile);

      final TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
      if (snapshot.state == TaskState.success) {
        final String downloadUrl = await snapshot.ref.getDownloadURL();

        setState(() {
          _downloadUrl = downloadUrl;
        });

        if (_downloadUrl!.isNotEmpty) {
          Map<String, dynamic> chatMessageMap = {
            "message": _downloadUrl,
            "sender": widget.userName,
            "time": DateTime.now().millisecondsSinceEpoch,
          };

          DatabaseService().sendMessage(widget.groupId, chatMessageMap);
          setState(() {
            messageController.clear();
          });

          // Scroll to the end of the list
        }

        print("File uploaded successfully. Download URL: $downloadUrl");
      } else {
        throw FirebaseException(
          plugin: "firebase_storage",
          message: "Upload task did not complete successfully.",
        );
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  void initState() {
    fetchDataIfUrlExists(widget.groupId);
    getChatAdmin();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  getChatAdmin() async {
    DatabaseService().getChats(widget.groupId).then((value) {
      setState(() {
        isLoading = true;
        chats = value;
      });
    });
    DatabaseService().getGroupAdmin(widget.groupId).then((value) {
      setState(() {
        admin = value;
      });
    });

    DatabaseService().getMedia(widget.groupId).then((value) {
      setState(() {
        media = value;
      });
    });

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection("groups")
        .doc(widget.groupId)
        .collection("messages")
        .orderBy("time")
        .get();

    await querySnapshot.docs.map((doc) => doc.data()).where((data) {
      if (data.containsKey('url')) {
        setState(() {
          imgUrl = data['url'];
          _isMidea = true;
        });
      }
      return _isMidea;
    });
  }

  List<Map<String, dynamic>> _mediaWithUrls = [];
  List<Map<String, dynamic>> msg = [];

  Future<void> fetchDataIfUrlExists(String groupId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection("groups")
              .doc(groupId)
              .collection("messages")
              .orderBy("time")
              .get();

      List<Map<String, dynamic>> mediaData = querySnapshot.docs
          .map((doc) => doc.data())
          .where((data) => data.containsKey('url'))
          .toList();

      List<Map<String, dynamic>> msgData = querySnapshot.docs
          .map((doc) => doc.data())
          .where((data) => data.containsKey('message'))
          .toList();

      setState(() {
        _mediaWithUrls = mediaData;
        msg = msgData;

        isLoading = false;
        _isMidea = true;
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(widget.groupName),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
              onPressed: () {
                nextScreen(
                    context,
                    GroupInfo(
                        groupId: widget.groupId,
                        groupName: widget.groupName,
                        adminName: admin));
              },
              icon: const Icon(Icons.info))
        ],
      ),
      body: Column(
        children: <Widget>[
          // chat messages here
          Expanded(
              child: isLoading == true
                  ? Center(child: CircularProgressIndicator())
                  : chatMessages()),

          Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
              width: MediaQuery.of(context).size.width,
              color: Colors.grey[700],
              child: Row(spacing: 10, children: [
                Expanded(
                    child: TextFormField(
                      focusNode: focusNode,
                  cursorColor: Colors.white,
                  controller: messageController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: " Send a message...",
                    hintStyle: TextStyle(color: Colors.white, fontSize: 16),
                    border: InputBorder.none,
                  ),
                )),
                const SizedBox(
                  width: 12,
                ),
                GestureDetector(
                  onTap: () {
                    sendMessage();
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Center(
                            child: Icon(
                          Icons.send,
                          color: Colors.white,
                        )),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: pickAndUploadMedia,
                  child: const Icon(Icons.image),
                )
              ]),
            ),
          )
        ],
      ),
    );
  }

  String? replyMessage; // State variable to store the message being replied to.

  chatMessages() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("groups")
          .doc(widget.groupId)
          .collection("messages")
          .orderBy("time")
          .snapshots(),
      builder: (context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text("No messages available."));
        }

        final mediaData = snapshot.data!.docs
            .where((doc) => doc.data().containsKey('url'))
            .map((doc) => doc.data())
            .toList();

        final msgData = snapshot.data!.docs
            .where((doc) => doc.data().containsKey('message'))
            .map((doc) => doc.data())
            .toList();

        List<Widget> messageTiles = List.generate(msgData.length, (index) {
          bool isMedia = msgData[index]['message'].toString().contains("https");
          String urll = isMedia == true
              ? msgData[index]['message']
              : "https://cdn.britannica.com/70/234870-050-D4D024BB/Orange-colored-cat-yawns-displaying-teeth.jpg";

          return SwipeTo(
            onRightSwipe: (details) {
              setState(() {
                replyMessage = msgData[index]['message'];
                focusNode.requestFocus();
                 // Set reply message
              });
            },
            child: MessageTile(
              isMedia: mediaData.isNotEmpty,
              imageUrl: urll,
              message: msgData[index]['message'],
              sender: widget.userName == msgData[index]['sender']
                  ? "You"
                  : msgData[index]['sender'],
              sentByMe: widget.userName == msgData[index]['sender'],
            ),
          );
        });

        return Column(
          children: [
            // Show the reply bar if a message is being replied to
            if (replyMessage != null)
              Container(
                color: Colors.grey[200],
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Replying to: $replyMessage",
                        style: TextStyle(color: Colors.black54),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        setState(() {
                          replyMessage = null; // Clear the reply message
                        });
                      },
                    ),
                  ],
                ),
              ),
            Expanded(
              child: SingleChildScrollView(
                reverse: true, // To maintain reverse scrolling behavior
                child: Column(
                  children: messageTiles,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageController.text,
        "sender": widget.userName,
        "time": DateTime.now().millisecondsSinceEpoch,
      };

      DatabaseService().sendMessage(widget.groupId, chatMessageMap);
      setState(() {
        messageController.clear();
      });

      // Scroll to the end of the list
    }
  }

  sendMedia() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": _downloadUrl,
        "sender": widget.userName,
        "time": DateTime.now().millisecondsSinceEpoch,
      };

      DatabaseService().sendMedia(widget.groupId, chatMessageMap);
      setState(() {
        messageController.clear();
      });

      // Scroll to the end of the list
    }
  }
}
