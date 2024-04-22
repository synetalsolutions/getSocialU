import 'dart:collection';
import 'dart:convert';
import "dart:core";
import 'dart:io';
import 'dart:math';

import 'package:firebase_remote_config/firebase_remote_config.dart';

import 'package:crypto/crypto.dart' as crypto;
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/configs.dart';
import 'package:socialv/main.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/utils/common.dart';
import 'package:socialv/utils/constants.dart';
import 'package:socialv/utils/woo_commerce/query_string.dart';

import '../models/api_responses.dart';

Map<String, String> buildHeaderTokens({required bool requiredNonce, required bool requiredToken}) {
  Map<String, String> header = {
    HttpHeaders.cacheControlHeader: 'no-cache',
    'Access-Control-Allow-Headers': '*',
    'Access-Control-Allow-Origin': '*',
  };

  header.putIfAbsent(HttpHeaders.contentTypeHeader, () => 'application/json; charset=utf-8');
  if (appStore.token.isNotEmpty && requiredToken) header.putIfAbsent(HttpHeaders.authorizationHeader, () => 'Bearer ${appStore.token}');
  header.putIfAbsent(HttpHeaders.acceptHeader, () => 'application/json; charset=utf-8');
  if (requiredNonce) header.putIfAbsent('Nonce', () => appStore.nonce);

  return header;
}

/// for passing woo commerce parameters
String _getOAuthURL(String requestMethod, String endpoint) {
  var consumerKey = CONSUMER_KEY;
  var consumerSecret = CONSUMER_SECRET;

  var tokenSecret = "";
  var url = BASE_URL + endpoint;

  var containsQueryParams = url.contains("?");

  if (url.startsWith("https")) {
    return url + (containsQueryParams == true ? "&consumer_key=" + consumerKey + "&consumer_secret=" + consumerSecret : "?consumer_key=" + consumerKey + "&consumer_secret=" + consumerSecret);
  } else {
    var rand = new Random();
    var codeUnits = new List.generate(10, (index) {
      return rand.nextInt(26) + 97;
    });

    var nonce = new String.fromCharCodes(codeUnits);
    int timestamp = new DateTime.now().millisecondsSinceEpoch ~/ 1000;

    var method = requestMethod;
    var parameters = "oauth_consumer_key=$consumerKey" + "&oauth_nonce=$nonce" + "&oauth_signature_method=HMAC-SHA1&oauth_timestamp=$timestamp" + "&oauth_version=1.0&";

    if (containsQueryParams == true) {
      parameters = parameters + url.split("?")[1];
    } else {
      parameters = parameters.substring(0, parameters.length - 1);
    }

    Map<dynamic, dynamic> params = QueryString.parse(parameters);
    Map<dynamic, dynamic> treeMap = new SplayTreeMap<dynamic, dynamic>();
    treeMap.addAll(params);

    String parameterString = "";

    for (var key in treeMap.keys) {
      parameterString = parameterString + Uri.encodeQueryComponent(key) + "=" + treeMap[key] + "&";
    }

    parameterString = parameterString.substring(0, parameterString.length - 1);

    var baseString = method + "&" + Uri.encodeQueryComponent(containsQueryParams == true ? url.split("?")[0] : url) + "&" + Uri.encodeQueryComponent(parameterString);

    var signingKey = consumerSecret + "&" + tokenSecret;
    var hmacSha1 = new crypto.Hmac(crypto.sha1, utf8.encode(signingKey)); // HMAC-SHA1
    var signature = hmacSha1.convert(utf8.encode(baseString));

    var finalSignature = base64Encode(signature.bytes);

    var requestUrl = "";

    if (containsQueryParams == true) {
      requestUrl = url.split("?")[0] + "?" + parameterString + "&oauth_signature=" + Uri.encodeQueryComponent(finalSignature);
    } else {
      requestUrl = url + "?" + parameterString + "&oauth_signature=" + Uri.encodeQueryComponent(finalSignature);
    }

    return requestUrl;
  }
}

Future<Response> buildHttpResponse(
  String endPoint, {
  HttpMethod method = HttpMethod.GET,
  Map? request,
  bool isAuth = false,
  List<dynamic>? requestList,
  bool passParameters = false,
  bool requiredNonce = false,
  bool passHeaders = true,
  bool passToken = true,
}) async {
  if (await isNetworkAvailable()) {
    var headers = buildHeaderTokens(requiredNonce: requiredNonce, requiredToken: passToken);

    late String url;
    if (endPoint.startsWith("http")) {
      url = endPoint;
    } else if (passParameters) {
      url = _getOAuthURL(method.toString(), endPoint);
    } else {
      url = '$BASE_URL$endPoint';
    }

    Response response;

    if (method == HttpMethod.POST) {
      response = await post(Uri.parse(url),
          body: requestList.validate().isNotEmpty
              ? jsonEncode(requestList)
              : isAuth
                  ? request
                  : jsonEncode(request),
          headers: isAuth ? null : headers);
    } else if (method == HttpMethod.DELETE) {
      response = await delete(Uri.parse(url), headers: passHeaders ? headers : {}, body: jsonEncode(request));
    } else if (method == HttpMethod.PUT) {
      response = await put(Uri.parse(url), body: jsonEncode(request), headers: headers);
    } else {
      response = await get(Uri.parse(url), headers: passHeaders ? headers : {});
    }

    apiPrint(
      url: url.toString(),
      endPoint: endPoint,
      headers: jsonEncode(headers),
      hasRequest: method == HttpMethodType.POST || method == HttpMethodType.PUT,
      request: jsonEncode(request),
      statusCode: response.statusCode,
      responseBody: response.body,
      methodtype: method.name,
    );

    if (appStore.isLoggedIn && response.statusCode == 401 && !endPoint.startsWith('http')) {
      ApiResponses res = ApiResponses.fromJson(jsonDecode(response.body));
      if (!res.code.validate().contains('wocommerce_rest') && !res.code.validate().contains('woocommerce_rest'))
      {
        return await reGenerateToken().then((value) async {
          return await buildHttpResponse(
            endPoint,
            method: method,
            request: request,
            requiredNonce: requiredNonce,
            isAuth: isAuth,
            passHeaders: passHeaders,
            passParameters: passParameters,
            passToken: passToken,
            requestList: requestList,
          );
        }).catchError((e) {
          throw errorSomethingWentWrong;
        });
      }
      else {
        return response;
      }
    } else {
      return response;
    }
  } else {
    throw errorInternetNotAvailable;
  }
}

Future handleResponse(Response response,{bool? isFriendList,bool? avoidTokenError}) async {
  bool isFriend=isFriendList??false;
  if (!await isNetworkAvailable()) {
    throw errorInternetNotAvailable;
  }
  if (response.statusCode == 401) {
    if (!avoidTokenError.validate()) LiveStream().emit(tokenStream, true);
    throw 'Token Expired';
  }

  if (response.statusCode.isSuccessful()) {
    if (jsonDecode(response.body.trim()).runtimeType != (List<dynamic>) && jsonDecode(response.body.trim()).runtimeType != bool) {
      Map body = jsonDecode(response.body.trim());

      if (body.containsKey('status') && body['status'].runtimeType == bool) {
        if (body['status']) {
          if(isFriend){
            return jsonDecode(response.body);

          } else{
            if (body['data'] != null) {
              return body['data'];
            } else {
              return jsonDecode(response.body);
            }
          }
        } else {
          throw body['message'] ?? errorSomethingWentWrong;
        }
      } else {
        return jsonDecode(response.body);
      }
    } else {
      return jsonDecode(response.body);
    }
  } else {
    try {
      var body = jsonDecode(response.body);
      log('body: $body');
      throw body['message'] is String ? parseHtmlString(body['message']) : body['message'];
    } on Exception catch (e) {
      log(e);
      throw errorSomethingWentWrong;
    }
  }
}

Future<MultipartRequest> getMultiPartRequest(String endPoint, {String? baseUrl}) async {
  late String url;
  if (endPoint.startsWith("http")) {
    url = endPoint;
  } else {
    url = '$BASE_URL$endPoint';
  }

  log('Url: $url');

  return MultipartRequest('POST', Uri.parse(url));
}

Future<void> sendMultiPartRequest(MultipartRequest multiPartRequest, {Function(dynamic)? onSuccess, Function(dynamic)? onError}) async {
  Response response = await Response.fromStream(await multiPartRequest.send());
  print("statusCode: ${response.statusCode}");
  print("body: ${response.body}");

  if (response.statusCode.isSuccessful()) {
    onSuccess?.call(response.body);
  } else {
    onError?.call(errorSomethingWentWrong);
  }

  apiPrint(
    url: multiPartRequest.url.toString(),
    headers: jsonEncode(multiPartRequest.headers),
    request: jsonEncode(multiPartRequest.fields),
    hasRequest: true,
    statusCode: response.statusCode,
    responseBody: response.body,
    methodtype: "MultiPart",
  );


}

enum HttpMethod { GET, POST, DELETE, PUT }

Future<void> reGenerateToken() async {
  log('Regenerating Token');

  Map request = {
    Users.username: appStore.loginEmail,
    Users.password: appStore.password,
  };

  return await loginUser(request: request, isSocialLogin: appStore.isSocialLogin).then((value) async {
    //
  }).catchError((e) {
    throw e;
  });
}

void apiPrint({
  String url = "",
  String endPoint = "",
  String headers = "",
  String request = "",
  int statusCode = 0,
  String responseBody = "",
  String methodtype = "",
  bool hasRequest = false,
}) {
  log("┌───────────────────────────────────────────────────────────────────────────────────────────────────────");
  log("\u001b[93m Url: \u001B[39m $url");
  log("\u001b[93m Header: \u001B[39m \u001b[96m$headers\u001B[39m");
  if (request.isNotEmpty) log("\u001b[93m Request: \u001B[39m \u001b[96m$request\u001B[39m");
  log("${statusCode.isSuccessful() ? "\u001b[32m" : "\u001b[31m"}");
  log('Response ($methodtype) $statusCode: $responseBody');
  log("\u001B[0m");
  log("└───────────────────────────────────────────────────────────────────────────────────────────────────────");
}

Future<FirebaseRemoteConfig> setupFirebaseRemoteConfig() async {
  final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;

  remoteConfig.setConfigSettings(RemoteConfigSettings(fetchTimeout: Duration.zero, minimumFetchInterval: Duration.zero));
  await remoteConfig.fetch();
  await remoteConfig.fetchAndActivate();

  return remoteConfig;
}
