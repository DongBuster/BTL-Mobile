import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_btl/pages/addItemPage/add_item_page.dart';

import '../../API/api.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _api = API();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Center(
          child: Text(
            'List items',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: _api.getListItem(),
          builder: (context, snapshot) {
            // print(snapshot.data);

            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return const Center(
                  child: Text(
                    'No item, please add a new item',
                    style: TextStyle(color: Colors.blue, fontSize: 16),
                  ),
                );
              }
              return Center(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 30),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        splashColor: Colors.blue.withAlpha(30),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => AddItemPage(
                                      isChange: true,
                                      item: snapshot.data![index])));
                        },
                        child: ListTile(
                          shape: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey.shade200)),
                          leading: Text(
                            '${index + 1}',
                            style: const TextStyle(
                                color: Colors.green, fontSize: 14),
                          ),
                          title: Text(
                            snapshot.data![index].name,
                            style: const TextStyle(
                                color: Colors.blue, fontSize: 14),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                snapshot.data![index].email,
                                style: TextStyle(
                                    color: Colors.grey.shade500, fontSize: 14),
                              ),
                              // const SizedBox(height: 5),
                              Text(
                                snapshot.data![index].address,
                                style: TextStyle(
                                    color: Colors.grey.shade500, fontSize: 14),
                              ),
                              // const SizedBox(height: 5),
                              Text(
                                snapshot.data![index].createdAt,
                                style: TextStyle(
                                    color: Colors.grey.shade500, fontSize: 14),
                              ),
                            ],
                          ),
                          trailing: GestureDetector(
                            onTap: () async {
                              await _api.deleteItem(snapshot.data![index].id);
                            },
                            child: const Icon(
                              Icons.delete_outlined,
                              size: 18,
                              color: Colors.redAccent,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            }
            return Center(
              child: Container(
                color: Colors.white,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.circle, size: 8, color: Colors.blue)
                        .animate(
                            delay: 100.milliseconds,
                            onPlay: (controller) => controller.repeat())
                        .moveY(begin: 1, end: -1),
                    const SizedBox(width: 2),
                    const Icon(Icons.circle, size: 8, color: Colors.blue)
                        .animate(
                            delay: 200.milliseconds,
                            onPlay: (controller) => controller.repeat())
                        .moveY(begin: 2, end: -2),
                    const SizedBox(width: 2),
                    const Icon(Icons.circle, size: 8, color: Colors.blue)
                        .animate(
                            delay: 300.milliseconds,
                            onPlay: (controller) => controller.repeat())
                        .moveY(begin: 3, end: -3),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
