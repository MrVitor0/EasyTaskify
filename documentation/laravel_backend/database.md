# Configuração do Banco de Dados - Laravel

Este documento fornece informações sobre a configuração do banco de dados para o backend Laravel do projeto EasyTaskify. O Laravel utiliza migrations e models para gerenciar a estrutura do banco de dados de forma eficiente.

## Configuração do Arquivo .env

O Laravel usa o arquivo `.env` para configurar variáveis de ambiente, incluindo as configurações do banco de dados. Certifique-se de que o arquivo `.env` contenha as seguintes configurações, o recomendado é fazer uma cópia do arquivo .env.example e renomeá-lo para .env.

```env
DB_CONNECTION=mysql
DB_HOST=seu_host_mysql
DB_PORT=sua_porta_mysql
DB_DATABASE=seu_nome_de_banco
DB_USERNAME=seu_usuario_mysql
DB_PASSWORD=sua_senha_mysql
```

## Migrations

O Laravel utiliza migrations para versionar o banco de dados. As migrations são arquivos PHP localizados no diretório database/migrations. Elas definem as alterações na estrutura do banco de dados.

Exemplo de criação de uma tabela através de uma migration:

```php
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateExemploTable extends Migration
{
    public function up()
    {
        Schema::create('exemplo', function (Blueprint $table) {
            $table->id();
            $table->string('nome');
            $table->timestamps();
        });
    }

    public function down()
    {
        Schema::dropIfExists('exemplo');
    }
}
```

Execute as migrations utilizando o Artisan:

```bash
php artisan migrate
```

Este comando aplicará todas as migrations pendentes.

## Models

  Os models representam as tabelas do banco de dados e são usados para interagir com os dados. Eles são armazenados no diretório app/Models.

Exemplo de um model:  

```php
    use Illuminate\Database\Eloquent\Model;

    class Exemplo extends Model
    {
        protected $table = 'exemplo';
        protected $fillable = ['nome'];
    }
```

Lembre-se de configurar corretamente o $table e $fillable conforme a estrutura da sua tabela.
