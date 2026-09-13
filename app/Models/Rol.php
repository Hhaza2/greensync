<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Rol extends Model
{
    protected $table = 'roles';
    
    protected $fillable = ['nombre'];

    const CREATED_AT = 'creado_en';
    const UPDATED_AT = 'actualizado_en';
}