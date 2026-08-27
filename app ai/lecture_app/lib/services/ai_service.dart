import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  // يرجى استبدال هذا المفتاح بمفتاحك الحقيقي من OpenAI لاحقاً
  static const String _openAIApiKey = "YOUR_OPENAI_API_KEY_HERE";

  // تحويل الصوت إلى نص باستخدام Whisper API
  static Future<String> transcribeAudio(String filePath) async {
    await Future.delayed(const Duration(seconds: 2)); // محاكاة وقت المعالجة

    // الكود الفعلي (تم إيقافه حتى تضع مفتاح API حقيقي):
    /*
    var request = http.MultipartRequest('POST', Uri.parse('https://api.openai.com/v1/audio/transcriptions'));
    request.headers.addAll({'Authorization': 'Bearer $_openAIApiKey'});
    request.fields['model'] = 'whisper-1';
    request.files.add(await http.MultipartFile.fromPath('file', filePath));
    var response = await request.send();
    if (response.statusCode == 200) {
      final res = await http.Response.fromStream(response);
      final json = jsonDecode(res.body);
      return json['text'];
    }
    */
    
    return "هذا النص تم توليده تلقائياً كتجربة (Placeholder) لتمثيل تفريغ المحاضرة. عند إضافة مفتاح OpenAI ستظهر المحاضرة الحقيقية هنا.";
  }

  // تلخيص النص باستخدام GPT-3.5/GPT-4
  static Future<String> summarizeText(String transcript) async {
    await Future.delayed(const Duration(seconds: 2)); // محاكاة وقت المعالجة

    // الكود الفعلي:
    /*
    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Authorization': 'Bearer $_openAIApiKey',
      },
      body: jsonEncode({
        "model": "gpt-3.5-turbo",
        "messages": [
          {"role": "system", "content": "أنت مساعد ذكي وظيفتك تلخيص المحاضرات بشكل دقيق."},
          {"role": "user", "content": "لخص النص التالي:\n$transcript"}
        ]
      }),
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(utf8.decode(response.bodyBytes));
      return json['choices'][0]['message']['content'];
    }
    */

    return "هذا ملخص تجريبي للنص المفرغ من المحاضرة. يمكنك التركيز هنا على أهم النقاط التي ذُكرت في المحاضرة.";
  }
}
