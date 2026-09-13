<?php

namespace App\Http\Controllers;

use Illuminate\Support\Facades\DB;
use Illuminate\Http\Request;
use Inertia\Inertia;

class HomeController extends Controller
{
    public function index()
    {
        $catalogoEquipos = DB::table('catalogo_equipos')
            ->orderBy('categoria')
            ->orderBy('nombre')
            ->get();

        return Inertia::render('Welcome', [
            'catalogoEquipos' => $catalogoEquipos
        ]);
    }
}
