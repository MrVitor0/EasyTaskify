# Endpoints da API - Laravel Backend

Este documento fornece informações sobre os endpoints da API no backend Laravel do projeto EasyTaskify. A API utiliza autenticação `auth:api` para proteger certas rotas, essa autenticação é feita através de OAuth2, utilizando tokens de acesso.

## Rotas que não exigem autenticação

### Handshake

- **Rota:** `POST /v1/handshake`
- **Controlador:** `AuthController@handshake`
- **Descrição:** Rota de handshake para autenticação.

### Registro de Usuário

- **Rota:** `POST /register`
- **Controlador:** `AuthController@register`
- **Descrição:** Rota para registrar um novo usuário.

## Autenticação OAuth2

O Laravel Passport é utilizado para implementar autenticação OAuth2 no backend.

### Solicitar Token de Acesso (Login)

- **Rota:** `POST /oauth/token`
- **Controlador:** `AuthController@login`
- **Descrição:** Rota para autenticação OAuth2 e obtenção do token de acesso. Requer as credenciais do cliente (client_id e client_secret), o nome do usuário, a senha e o escopo.

#### Parâmetros

- `grant_type`: `password`
- `client_id`: `seu_client_id`
- `client_secret`: `seu_client_secret`
- `username`: `nome_de_usuario`
- `password`: `senha`
- `scope`: `*` (ou escopos específicos, se aplicável)

### Atualizar Token de Acesso (Token Refresh)

- **Rota:** `POST /oauth/token`
- **Controlador:** `AuthController@refreshToken`
- **Descrição:** Rota para atualização do token de acesso usando o token de atualização.

#### Parâmetros Exigidos

- `grant_type`: `refresh_token`
- `refresh_token`: `seu_refresh_token`
- `client_id`: `seu_client_id`
- `client_secret`: `seu_client_secret`
- `scope`: `*` (ou escopos específicos, se aplicável)

## Tarefas (Tasks)

Todas as rotas relacionadas às tarefas exigem autenticação via `auth:api`.

### Listar Tarefas

- **Rota:** `GET /v1/tasks`
- **Controlador:** `TaskController@index`
- **Descrição:** Retorna todas as tarefas.

### Detalhes da Tarefa

- **Rota:** `GET /v1/tasks/{id}`
- **Controlador:** `TaskController@show`
- **Descrição:** Retorna detalhes de uma tarefa específica.

### Criar Tarefa

- **Rota:** `POST /v1/tasks`
- **Controlador:** `TaskController@store`
- **Descrição:** Cria uma nova tarefa.

### Atualizar Tarefa

- **Rota:** `PUT /v1/tasks/{id}`
- **Controlador:** `TaskController@update`
- **Descrição:** Atualiza os detalhes de uma tarefa existente.

### Excluir Tarefa

- **Rota:** `DELETE /v1/tasks/{id}`
- **Controlador:** `TaskController@destroy`
- **Descrição:** Exclui uma tarefa.

## Logout

- **Rota:** `POST /v1/logout`
- **Controlador:** `AuthController@logout`
- **Descrição:** Rota para efetuar logout.
