import 'package:flutter/material.dart';

class ItemWord extends StatelessWidget {
  const ItemWord(
      {Key? key,
      required this.isEng,
      required this.uzbek,
      required this.english,
      required this.type,
      required this.countable,
      required this.transcript})
      : super(key: key);
  final bool isEng;
  final String uzbek, english, type, countable, transcript;

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      // margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      decoration: BoxDecoration(
          color: Colors.white30, borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          Text(
            isEng ? english : uzbek,
            style: const TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            width: 16,
          ),
          Text(
            isEng ? transcript : "",
            style: const TextStyle(
                color: Colors.pink, fontSize: 16, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            width: 16,
          ),
          Text(
            type,
            style: const TextStyle(
                color: Colors.deepOrange,
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
            countable,
            style: const TextStyle(
                color: Colors.indigo,
                fontSize: 16,
                fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            width: 16,
          )
        ],
      ),
    );
  }
}
