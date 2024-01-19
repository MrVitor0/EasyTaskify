# Integração com API - Flutter App

Este guia fornece informações sobre como o aplicativo EasyTaskify integra-se com APIs para obter e enviar dados. Certifique-se de ter concluído o processo de instalação do Laravel antes de prosseguir com a integração da API.

## Configuração da API

Antes de começar a integração, verifique se você possui as seguintes informações:

- URL base da API
- Endpoints disponíveis

## Pacote de Requisições HTTP

O aplicativo EasyTaskify utiliza o pacote `Dio` para realizar requisições HTTP. Certifique-se de verificar a dependência no seu arquivo `pubspec.yaml`, e instale-a caso não esteja presente.

Exemplo:

```yaml
dependencies:
  dio: ^3.0.9
```

- Em seguida, execute:
  - ```flutter pub get```

## Como adicionar o URL base da API no aplicativo?

- A funcionalidade de URL Base foi pensanda de forma que facilite que multiplos usuários testem localmente o aplicativo, utilizando-se apenas do APK, de forma fácil e eficiente, **sem a necessidade de alterar o código fonte do aplicativo.**

- Para adicionar o URL base da API, basta abrir o aplicativo, o que naturalmente ocorre após executar o comando `flutter run`, a primeira página que aparecerá será a de configuração do URL base da API, onde o usuário poderá inserir o URL base da API e salvar, lembre-se de utilizar o endereço local do servidor do Laravel, caso esteja testando localmente, por exemplo: `http://192.168.0.5:8000`.

## Instruções de uso da API

- Para utilizar a API, você deve criar uma instância do `Dio` e adicionar um `Interceptor` para autenticação, o interceptor é responsável por adicionar o token de autenticação em todas as requisições, como também, adicionar o URL base da API.

### Exemplo de Requisição POST

- Aqui está um exemplo simples de como fazer uma requisição GET para a API:

    ```dart
    import 'package:dio/dio.dart';
    import '/utils/dio_interceptor.dart';

     Dio dio = Dio();
     dio.interceptors.add(AuthInterceptor());

      await dio.post(
        '/api/register',
        data: {
          'grant_type': 'password',
          'name': 'John Doe',
          'email': 'Johndoe@tests.com',
          'password': '123321',
        },
      );
    ```
