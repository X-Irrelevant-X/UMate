import 'dart:convert';
import 'package:http/http.dart';
import 'dart:math';

class FetchMeme {
  static final List<String> subredList = [
    'ProgrammerHumor',
    'wholesomememes', 
    'mathmemes',
    'StoicMemes',
    'engineeringmemes',
  ];

  static Future<String> fetchNewMeme() async {
    try {
      String randomSubreddit;
      
      randomSubreddit = subredList[Random().nextInt(subredList.length)];
      
      Response response = await get(Uri.parse("https://meme-api.com/gimme/$randomSubreddit"));
      Map bodydata = jsonDecode(response.body);
      String memeUrl = bodydata["url"];


      return memeUrl;
    } catch (e) {
      print("Error fetching meme: $e");
      throw Exception("Failed to fetch meme");
    }
  }
}

