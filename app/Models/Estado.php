<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Estado extends Model
{
    protected $table = 'estados';
    
    // Asignación masiva permitida
    protected $fillable = ['nombre', 'descripcion'];

    // Mapeo de marcas de tiempo en español
    const CREATED_AT = 'creado_en';
    const UPDATED_AT = 'actualizado_en';
}