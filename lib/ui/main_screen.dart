import 'package:dictionary_flutter/data/database_helper.dart';
import 'package:dictionary_flutter/data/word_data.dart';
import 'package:dictionary_flutter/ui/di.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final db = getIt.get<DatabaseHelper>();
  final controller = TextEditingController();
  var words = <WordModel>[];
  var isEng = true;

  @override
  void initState() {
    controller.addListener(() {
      search();
    });
    initWords();
    super.initState();
  }

  void search() {
    EasyDebounce.debounce("tag", const Duration(milliseconds: 300), () async {
      if (isEng) {
        words = await db.findByEng(controller.text);
      } else {
        words = await db.findByUz(controller.text);
      }
      setState(() {});
    });
  }

  Future<void> initWords() async {
    words = await db.getAll();
  }

  @override
  void dispose() {
    EasyDebounce.cancel("tag");
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Dictionary"),
          actions: [
            MaterialButton(
                onPressed: () {
                  isEng = !isEng;
                  setState(() {});
                  search();
                },
                child: Text(
                  isEng ? "Eng-Uz" : "Uz-Eng",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                )),
            const SizedBox(
              width: 6,
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.indigo, width: 1),
                          color: Colors.white54,
                          borderRadius: BorderRadius.circular(12)),
                      child: TextField(
                        controller: controller,
                        scrollPadding: const EdgeInsets.all(0),
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(0),
                          border: InputBorder.none,
                          icon: Icon(CupertinoIcons.search),
                          // suffixIcon: Icon(CupertinoIcons.clear)
                        ),
                        cursorColor: Colors.pink,
                        style: const TextStyle(
                            color: Colors.indigo,
                            fontWeight: FontWeight.w500,
                            fontSize: 18),
                        maxLines: 1,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(child: Builder(
                builder: (context) {
                  if (words.isEmpty) {
                    return const Center(
                        child: Text(
                      "no data",
                      style: TextStyle(fontSize: 24, color: Colors.black),
                    ));
                  }
                  return ListView.separated(
                    itemCount: words.length,
                    separatorBuilder: (_, index) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => Scaffold.of(context)
                            .showBottomSheet((context) => Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  padding: const EdgeInsets.all(16),
                                  decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(8),
                                          topRight: Radius.circular(8)),
                                      color: Colors.blue),
                                  child: Text(
                                    isEng
                                        ? words[index].uzbek
                                        : words[index].english,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w600),
                                    textAlign: TextAlign.center,
                                  ),
                                )),
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 3),
                          decoration: BoxDecoration(
                              color: Colors.white30,
                              borderRadius: BorderRadius.circular(8)),
                          child: Row(
                            children: [
                              Text(
                                isEng
                                    ? words[index].english
                                    : words[index].uzbek,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              Text(
                                isEng ? words[index].transcript : "",
                                style: const TextStyle(
                                    color: Colors.pink,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              Text(
                                words[index].type.substring(0, 1),
                                style: const TextStyle(
                                    color: Colors.blueGrey,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                                textAlign: TextAlign.center,
                              ),
                              const Expanded(
                                flex: 1,
                                child: SizedBox(
                                  width: 16,
                                ),
                              ),
                              Text(
                                words[index].countable,
                                style: const TextStyle(
                                    color: Colors.blue,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                width: 16,
                              )
                            ],
                          ),
                        ),
                      );

                      // ItemWord(isEng: isEng,
                      //     uzbek: words[index].uzbek,
                      //     english: words[index].english,
                      //     type: words[index].type,
                      //     countable: words[index].countable,
                      //     transcript: words[index].transcript);
                    },
                  );
                },
              ))
            ],
          ),
        ),
      ),
    );
  }
}
