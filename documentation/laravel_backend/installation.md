# Instalação do Laravel Backend

Este guia fornece instruções passo a passo sobre como configurar o backend Laravel para o projeto EasyTaskify. Certifique-se de ter um ambiente de desenvolvimento configurado com PHP, Composer e um servidor web (por exemplo, Apache ou Nginx).

## Clonando o Repositório

Caso ainda não tenha clonado o repositório do projeto, faça isso agora:

```bash
git clone https://github.com/MrVitor0/EasyTaskify.git
```

## Instalando Dependências

Após clonar o repositório, navegue até o diretório `backend` e instale as dependências do Laravel utilizando o Composer:

```bash
cd backend
composer install
```

## Configuração do Banco de Dados

- Copie o arquivo de exemplo .env:

```bash
cp .env.example .env
```

## Configure as informações do banco de dados no arquivo .env

```env
DB_CONNECTION=mysql
DB_HOST=seu_host_mysql
DB_PORT=sua_porta_mysql
DB_DATABASE=seu_nome_de_banco
DB_USERNAME=seu_usuario_mysql
DB_PASSWORD=sua_senha_mysql
```

Execute as migrations para criar as tabelas do banco de dados:

```bash
php artisan migrate
```

## Configuração do Laravel Passport

Instale e configure o Laravel Passport:

```bash
php artisan passport:install
```

Adicione as chaves de cliente geradas ao seu arquivo .env:

```env
PASSPORT_CLIENT_ID=client-id
PASSPORT_CLIENT_SECRET=seu_client_secret
```

## Geração de Chave de Aplicação

Gere a chave de aplicação do Laravel:

```bash
php artisan key:generate
```

## Servidor de Desenvolvimento

Inicie o servidor de desenvolvimento do Laravel, porém, utilize o host `0.0.0.0`, desta forma o servidor estará disponível para acesso externo, podendo ser acessado pelo frontend Flutter:

```bash
php artisan serve --host=0.0.0.0 --port=8000 
```
