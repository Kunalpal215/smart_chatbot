import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ScrollController _controller = ScrollController();
  String? userReply;
  StreamController chatController = StreamController();
  List<String> replies=[];

  Future<String> getChatbotReply(String userReply) async {
    var response = await http.get(Uri.parse("http://api.brainshop.ai/get?bid=166897&key=c5R1lM3QRvsNJ4Ah&uid=Kunalpal215&msg=${userReply}"));
    var data = jsonDecode(response.body);
    return data["cnt"];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: StreamBuilder(
            stream: chatController.stream,
            builder: (context, AsyncSnapshot snapshot){
              if(snapshot.hasData){
                return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index){
                              return Text(snapshot.data![index]);
                            }
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            width: 100,
                            margin: EdgeInsets.symmetric(horizontal: 16),
                            child: TextField(
                              onChanged: (value){
                                userReply=value;
                              },
                            ),
                          ),
                          ElevatedButton(
                              onPressed: () async {
                                if(userReply!=null && userReply!=""){
                                  replies.add(userReply!);
                                  var generatedReply = await getChatbotReply(userReply!);
                                  replies.add(generatedReply);
                                  chatController.sink.add(replies);
                                }
                              },
                              child: Text("Send")
                          )
                        ],
                      )
                    ],
                );
              }
              return Stack(
                children: [
                  Center(child: Text("Start chatting with me :)"),),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Row(
                      children: [
                        Container(
                          width: 100,
                          margin: EdgeInsets.symmetric(horizontal: 16),
                          child: TextFormField(
                            onChanged: (value){
                              userReply=value;
                            },
                          ),
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              if(userReply!=null && userReply!=""){
                                replies.add(userReply!);
                                var generatedReply = await getChatbotReply(userReply!);
                                replies.add(generatedReply);
                                chatController.sink.add(replies);
                              }
                            },
                            child: Text("Send")
                        )
                      ],
                    ),
                  )
                ],
              );
            },
          ),
        )
    );
  }
}
