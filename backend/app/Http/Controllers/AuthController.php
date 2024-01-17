<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
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
}