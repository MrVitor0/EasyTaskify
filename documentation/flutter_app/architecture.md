# Arquitetura do Aplicativo Flutter

Este documento fornece uma visão geral da arquitetura do aplicativo Flutter Easy Taskify.

## Estrutura de Arquivos

O projeto do aplicativo Flutter segue uma estrutura de arquivos organizada. Abaixo estão os principais diretórios e sua finalidade:

- **lib/:** Contém as principais classes do aplicativo, como telas e widgets.
- **assets/:** Armazena os recursos estáticos, como imagens e fontes. (Atualmente não utilizado)

## Estrutura de Pastas

```plaintext
EasyTaskify/
|-- lib/
|   |-- main.dart
|   |-- screens/
|       |-- auth/
|           |-- login_screen.dart
|           |-- register_screen.dart
|       |-- dashboard/
|           |-- home_screen.dart
|           |-- backend_screen.dart
|           |-- tasks/
|               |-- create_screen.dart
|               |-- update_screen.dart
|               |-- view_screen.dart
|-- assets/
|   |-- images/
|       |-- (Empty)
