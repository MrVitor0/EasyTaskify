<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Task;

class TaskController extends Controller
{
    public function index(Request $request)
    {
        $tasks = Task::all();
        return response()->json(['tasks' => $tasks]);
    }

    public function show($id)
    {
        return response()->json(['example' => 'show']);
    }

    public function store(Request $request)
    {
        return response()->json(['example' => 'store']);
    }

    public function update(Request $request, $id)
    {
        return response()->json(['example' => 'update']);
    }

    public function destroy($id)
    {
        return response()->json(['example' => 'destroy']);
    }
}
