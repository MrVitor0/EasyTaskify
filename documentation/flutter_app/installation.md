# Instalação do Aplicativo Flutter

Este guia fornece instruções passo a passo sobre como configurar e executar o aplicativo Flutter EasyTaskify.

## Pré-requisitos

Antes de iniciar, certifique-se de ter o seguinte instalado em seu ambiente de desenvolvimento:

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- [Dart SDK](https://dart.dev/get-dart)

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

## Problemas Comuns

### **Problema:** O comando `flutter run` não funciona

  **Solução:** Verifique se o Flutter SDK está corretamente instalado e configurado no seu ambiente de desenvolvimento.

### **Problema:** O comando `flutter pub get` não funciona

    **Solução:** Verifique se o arquivo `pubspec.yaml` está no diretório do projeto e se o Flutter SDK está corretamente instalado e configurado no seu ambiente de desenvolvimento.

### **Problema:** O aplicativo não está se conectando ao `servidor do laravel`

    **Solução:** Verifique se o servidor do laravel está em execução e se o dispositivo ou emulador está conectado à mesma rede que o servidor de backend, verifique também que forneceu os paramentros corretamente e que porta 8000 (Pode utilizar outra) está aberta no firewall.

    `php artisan serve --host=0.0.0.0 --port=8000`
