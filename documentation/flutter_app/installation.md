# Instalação do Aplicativo Flutter

Este guia fornece instruções passo a passo sobre como configurar e executar o aplicativo Flutter EasyTaskify.

## Pré-requisitos

Antes de iniciar, certifique-se de ter o seguinte instalado em seu ambiente de desenvolvimento:

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- [Dart SDK](https://dart.dev/get-dart)

Certifique-se também de ter um emulador ou dispositivo físico conectado para executar o aplicativo.

## Passos de Instalação

1. **Clonar o Repositório:**

   ```git clone https://github.com/MrVitor0/EasyTaskify.git```  

2. **Navegue até o diretório do flutter:**

    ```cd frontend```

3. **Instale as dependências:**

    ```flutter pub get```

### Executando o Aplicativo

1. **Certifique-se de ter um dispositivo conectado ou um emulador em execução.**

2. **Certifique-se de que o Servidor de Backend esteja em execução.**

3. **Execute o aplicativo:**

    ```flutter run```

### Como conseguir o Cliente ID e o Cliente Secret do Laravel Passport?

- Primeiro, você precisa instalar o Laravel Passport em seu projeto Laravel, verifique as instruções de instalação do backend deste repositório.

- Após a instalação do Passport, você pode encontrar o `Client ID` e o `Client Secret` no banco de dados na tabela `oauth_clients`, sendo respectivamente a coluna "ID" o `Client ID` e a coluna "Secret" o `Client Secret`.

- Copie o `Client ID` e o `Client Secret` e utilize-os no aplicativo Flutter (Será solicitado na primeira execução do aplicativo).

## Problemas Comuns

### **Problema:** O comando `flutter run` não funciona

  **Solução:** Verifique se o Flutter SDK está corretamente instalado e configurado no seu ambiente de desenvolvimento.

### **Problema:** O comando `flutter pub get` não funciona

    **Solução:** Verifique se o arquivo `pubspec.yaml` está no diretório do projeto e se o Flutter SDK está corretamente instalado e configurado no seu ambiente de desenvolvimento.

### **Problema:** O aplicativo não está se conectando ao `servidor do laravel`

    **Solução:** Verifique se o servidor do laravel está em execução e se o dispositivo ou emulador está conectado à mesma rede que o servidor de backend, verifique também que forneceu os paramentros corretamente e que porta 8000 (Pode utilizar outra) está aberta no firewall.

    `php artisan serve --host=0.0.0.0 --port=8000`
