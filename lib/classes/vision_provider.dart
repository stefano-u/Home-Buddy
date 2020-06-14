import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:googleapis/vision/v1.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'credentials_provider.dart';

class VisionProvider {
  var _client = CredentialsProvider().getClient();

  Future<bool> search(String image, String itemToGuess) async {
    var _vision = VisionApi(await _client);
    var _api = _vision.images;
    var _response = await _api.annotate(BatchAnnotateImagesRequest.fromJson({
      "requests": [
        {
          "image": {
            "content": image,
          },
          "features": [
            {
              "maxResults": 10,
              "type": "OBJECT_LOCALIZATION",
            }
          ]
        }
      ]
    }));

    bool isFound = false;

    _response.responses.forEach((data) {
      data.localizedObjectAnnotations.forEach((element) {
        print(element.name);
        if (element.name.toLowerCase().contains(itemToGuess.toLowerCase())) {
          isFound = true;
        }
      });
    });

    return isFound;
  }
}
