import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:booster/core/config/cognito_config.dart';
import 'package:booster/core/error/exceptions.dart';

Future<void> configureAmplify() async {
    try {
      if (Amplify.isConfigured) {
        return;
      }

      final auth = AmplifyAuthCognito();
      await Amplify.addPlugins([auth]);
      
      const amplifyConfig = '''{
        "UserAgent": "aws-amplify-cli/2.0",
        "Version": "1.0",
        "auth": {
          "plugins": {
            "awsCognitoAuthPlugin": {
              "UserAgent": "aws-amplify-cli/0.1.0",
              "Version": "0.1.0",
              "IdentityManager": {
                "Default": {}
              },
              "CredentialsProvider": {
                "CognitoIdentity": {
                  "Default": {
                    "PoolId": "${CognitoConfig.identityPoolId}",
                    "Region": "${CognitoConfig.region}"
                  }
                }
              },
              "CognitoUserPool": {
                "Default": {
                  "PoolId": "${CognitoConfig.userPoolId}",
                  "AppClientId": "${CognitoConfig.appClientId}",
                  "Region": "${CognitoConfig.region}"
                }
              },
              "Auth": {
                "Default": {
                  "authenticationFlowType": "ALLOW_USER_PASSWORD_AUTH"
                }
              }
            }
          }
        }
      }''';

      await Amplify.configure(amplifyConfig);
    } catch (e) {
      print('Error al configurar Amplify: ${e.toString()}');
      throw ServerException('Error al configurar Amplify: ${e.toString()}');
    }
  }