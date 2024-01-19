<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\ValidationException;

class AuthController extends Controller
{
    /**
     * Registro de um novo usuário.
     *
     * @param  Request  $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function register(Request $request)
    {
        try {
            $validatedData = $request->validate([
                'name' => 'required|string|max:255',
                'email' => 'required|string|email|max:255|unique:users',
                'password' => 'required|string|min:8',
            ], [
                'password.min' => 'A senha deve ter pelo menos 8 caracteres.',
                'password.required' => 'A senha é obrigatória.',
                'password.max' => 'A senha deve ter no máximo 255 caracteres.',
                'password.string' => 'A senha deve ser uma string.',

                'email.email' => 'O email deve ser um endereço de email válido.',
                'email.required' => 'O email é obrigatório.',
                'email.max' => 'O email deve ter no máximo 255 caracteres.',
                'email.string' => 'O email deve ser uma string.',
                'email.unique' => 'O email já está em uso.',

                'name.required' => 'O nome é obrigatório.',
                'name.max' => 'O nome deve ter no máximo 255 caracteres.',
                'name.string' => 'O nome deve ser uma string.',
            ]);

        } catch (ValidationException $e) {
            $errors = $e->validator->errors()->toArray();

            return response()->json(['error' => 'Erro ao validar dados', 'messages' => $errors], 422);
        } catch (\Throwable $th) {
            return response()->json(['error' => 'Erro ao validar dados', 'message' => $th->getMessage()], 500);
        }
     
        $user = User::create([
            'name' => $validatedData['name'],
            'email' => $validatedData['email'],
            'password' => bcrypt($validatedData['password']),
        ]);

        $token = $user->createToken('authToken')->accessToken;
        return response()->json(['token' => $token], 201);
    }


    public function logout(Request $request)
    {
        $request->user()->token()->revoke();
        return response()->json(['message' => 'Successfully logged out'], 200);
    }

    /**
     * @param Request $request
     * @description check if all the schema tables exists
     * @return \Illuminate\Http\JsonResponse
     */
    public function handshake(Request $request)
    {   
        //check if all the schema tables exists
        if (!Schema::hasTable('users') || !Schema::hasTable('tasks')) {
            return response()->json(['data' => 'Oops, parece que a tabela de usuários não foi encontrada, o banco de dados foi instalado corretamente?', 'code' => 500], 500);
        }

        //check request body, view if client_id and client_secret are present
        if (!$request->has('client_id') || !$request->has('client_secret')) {
            return response()->json(['data' => 'Client ID & Client Secret são necessários.', 'code' => 400], 400);
        }

        $clientId = $request->input('client_id');
        $clientSecret = $request->input('client_secret');

        // Consulta a tabela oauth_clients
        $client = DB::table('oauth_clients')
            ->where('id', $clientId)
            ->where('secret', $clientSecret)
            ->first();

        // Verificar se o cliente existe e se o segredo está correto
        if ($client) {
            return response()->json(['success' => 'Success', 'client' => $client, 'code' => 200], 200);
        }
        $errorMSG = "O Client ID informado não existe ou o Client Secret está incorreto. Verifique e tente novamente. Estes códigos são gerados no momento da instalação do Laravel Passport.";
        return response()->json(['data' => $errorMSG, 'code' => 401], 401);
    }
}