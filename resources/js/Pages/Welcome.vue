<script setup>
import { ref, computed, watch } from 'vue';
import { Head, Link } from '@inertiajs/vue3';
import { Chart as ChartJS, ArcElement, Tooltip, Legend } from 'chart.js';
import { Pie } from 'vue-chartjs';

ChartJS.register(ArcElement, Tooltip, Legend);

const props = defineProps({
    catalogoEquipos: {
        type: Array,
        default: () => []
    }
});

const equiposAgrupados = computed(() => {
    return props.catalogoEquipos.reduce((acumulador, equipo) => {
        if (!acumulador[equipo.categoria]) acumulador[equipo.categoria] = [];
        acumulador[equipo.categoria].push(equipo);
        return acumulador;
    }, {});
});

const listaCategorias = computed(() => Object.keys(equiposAgrupados.value));

const categoriaSeleccionada = ref(listaCategorias.value[0] || '');
const equipoSeleccionado = ref(null);
const busquedaEquipo = ref('');
const mostrarDropdown = ref(false);

const equiposFiltrados = computed(() => {
    const equiposDeCategoria = equiposAgrupados.value[categoriaSeleccionada.value] || [];
    if (!busquedaEquipo.value) return equiposDeCategoria;
    
    return equiposDeCategoria.filter(eq => 
        eq.nombre.toLowerCase().includes(busquedaEquipo.value.toLowerCase())
    );
});

const seleccionarEquipo = (equipo) => {
    equipoSeleccionado.value = equipo;
    mostrarDropdown.value = false;
    busquedaEquipo.value = '';
};

watch(categoriaSeleccionada, (nuevaCategoria) => {
    if (equiposAgrupados.value[nuevaCategoria] && equiposAgrupados.value[nuevaCategoria].length > 0) {
        seleccionarEquipo(equiposAgrupados.value[nuevaCategoria][0]);
    }
}, { immediate: true });

const usarRangoHorario = ref(false);
const horaInicio = ref('08:00');
const horaFin = ref('17:00');

const cantidad = ref(1);
const tiempoUso = ref(1);
const diasAlMes = ref(30);

const validarEntero = (variable) => {
    if (variable.value !== '' && variable.value !== null) {
        variable.value = Math.floor(Number(variable.value));
        if (variable.value < 1) variable.value = 1;
    }
};

const validarDias = () => {
    if (diasAlMes.value !== '' && diasAlMes.value !== null) {
        diasAlMes.value = Math.floor(Number(diasAlMes.value));
        if (diasAlMes.value > 30) diasAlMes.value = 30;
        if (diasAlMes.value < 1) diasAlMes.value = 1;
    }
};

const calcularHorasRango = (inicio, fin) => {
    if (!inicio || !fin) return 0;
    const [h1, m1] = inicio.split(':').map(Number);
    const [h2, m2] = fin.split(':').map(Number);
    
    let diferencia = (h2 + m2 / 60) - (h1 + m1 / 60);
    if (diferencia < 0) diferencia += 24; 
    
    return diferencia;
};

const inventario = ref([]);

const agregarEquipo = () => {
    if (!equipoSeleccionado.value) return;
    
    validarEntero(cantidad);
    validarDias();
    if (!usarRangoHorario.value) validarEntero(tiempoUso);

    const horasCalculadas = usarRangoHorario.value 
        ? calcularHorasRango(horaInicio.value, horaFin.value) 
        : tiempoUso.value;

    inventario.value.push({
        id: Date.now(),
        nombre: equipoSeleccionado.value.nombre,
        watts: equipoSeleccionado.value.watts,
        cantidad: cantidad.value || 1,
        tiempoUso: horasCalculadas,
        diasAlMes: diasAlMes.value || 1,
        esRango: usarRangoHorario.value,
        rangoTexto: usarRangoHorario.value ? `${horaInicio.value} a ${horaFin.value}` : null
    });
    
    cantidad.value = 1;
    if (!usarRangoHorario.value) tiempoUso.value = 1;
    diasAlMes.value = 30;
};

const eliminarEquipo = (id) => {
    inventario.value = inventario.value.filter(item => item.id !== id);
};

const calcularKwhItem = (item) => {
    return (item.watts * item.cantidad * item.tiempoUso * item.diasAlMes) / 1000;
};

const totalKwh = computed(() => inventario.value.reduce((total, item) => total + calcularKwhItem(item), 0));

const chartData = computed(() => ({
    labels: inventario.value.map(item => item.nombre),
    datasets: [{
        backgroundColor: ['#10B981', '#3B82F6', '#F59E0B', '#EF4444', '#8B5CF6', '#EC4899', '#14B8A6', '#F97316'],
        data: inventario.value.map(item => calcularKwhItem(item).toFixed(2))
    }]
}));

const chartOptions = computed(() => ({ 
    responsive: true, 
    maintainAspectRatio: false, 
    plugins: { 
        legend: { 
            position: 'bottom', 
            labels: { 
                color: document.documentElement.classList.contains('dark') ? '#A7F3D0' : '#374151' 
            } 
        } 
    } 
}));

const desglose = computed(() => {
    const kwh = totalKwh.value;
    const tarifaEnergia = 0.16, cargoComercializacion = 1.44, tarifaDistribucion = 0.035;
    const cargoEnergia = kwh * tarifaEnergia, cargoDistribucion = kwh * tarifaDistribucion;
    const fodes = kwh * 0.005, rnvm = kwh * 0.002, iva = (cargoEnergia + cargoDistribucion) * 0.13;
    
    let subsidio = 0;
    if (kwh > 0 && kwh < 105) subsidio = -(cargoEnergia * 0.20);
    const totalPagar = cargoEnergia + cargoDistribucion + cargoComercializacion + fodes + rnvm + iva + subsidio;

    return {
        cargoEnergia: cargoEnergia.toFixed(2),
        cargoDistribucion: cargoDistribucion.toFixed(2),
        cargoComercializacion: cargoComercializacion.toFixed(2),
        impuestos: (fodes + rnvm + iva).toFixed(2),
        subsidio: subsidio.toFixed(2),
        total: totalPagar > 0 ? totalPagar.toFixed(2) : '0.00'
    };
});
</script>

<template>
    <Head title="Simulador de Consumo - GreenSync" />
    
    <!-- Fondo adaptativo -->
    <div class="min-h-screen bg-gray-50 dark:bg-gradient-to-br dark:from-[#0a2e2a] dark:via-[#0f3d35] dark:to-[#1a2e1a] text-gray-900 dark:text-white font-sans selection:bg-yellow-400 selection:text-black relative overflow-hidden transition-colors duration-300">
        
        <!-- Luces decorativas de fondo -->
        <div class="absolute top-0 left-0 w-full h-full pointer-events-none z-0 hidden dark:block">
            <div class="absolute -top-40 -left-40 w-[500px] h-[500px] bg-emerald-500/20 rounded-full blur-[120px]"></div>
            <div class="absolute top-1/3 right-0 w-[400px] h-[400px] bg-cyan-500/15 rounded-full blur-[120px]"></div>
            <div class="absolute -bottom-40 left-1/3 w-[600px] h-[600px] bg-yellow-500/10 rounded-full blur-[150px]"></div>
        </div>

        <!-- Navegación -->
        <nav class="relative z-50 w-full bg-white dark:bg-[#0a2e2a]/80 backdrop-blur-xl border-b border-gray-200 dark:border-emerald-500/20 transition-colors duration-300">
            <div class="max-w-7xl mx-auto px-4 h-20 flex justify-between items-center">
                <div class="text-2xl font-bold flex items-center gap-3 group">
                    <div class="w-10 h-10 rounded-xl bg-gradient-to-br from-yellow-400 to-emerald-500 flex items-center justify-center shadow-lg shadow-emerald-500/40 group-hover:scale-110 transition-transform">
                        <svg class="w-6 h-6 text-[#0a2e2a]" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"></path></svg>
                    </div>
                    <span class="text-gray-900 dark:text-white">GreenSync</span>
                </div>
                <div class="flex items-center gap-6 text-sm font-medium">
                    <Link :href="route('about')" class="text-gray-600 dark:text-emerald-100 hover:text-emerald-600 dark:hover:text-yellow-400 transition-colors">Sobre Nosotros</Link>
                    <Link :href="route('login')" class="text-gray-600 dark:text-emerald-100 hover:text-emerald-600 dark:hover:text-yellow-400 transition-colors">Iniciar Sesión</Link>
                    <Link :href="route('register')" class="bg-gradient-to-r from-yellow-400 to-emerald-500 text-[#0a2e2a] font-bold px-6 py-2.5 rounded-full hover:shadow-lg hover:shadow-yellow-400/30 transition-all">
                        Regístrate
                    </Link>
                </div>
            </div>
        </nav>

        <main class="max-w-7xl mx-auto py-10 px-4 sm:px-6 lg:px-8 relative z-10">
            <div class="grid grid-cols-1 lg:grid-cols-12 gap-8">
                
                <!-- Columna Izquierda: Formulario e Inventario/Gráfico -->
                <div class="lg:col-span-7 space-y-6">
                    
                    <!-- Tarjeta de Selección de Equipos -->
                    <div class="bg-white dark:bg-white/5 backdrop-blur-md border border-gray-200 dark:border-emerald-500/20 p-8 rounded-3xl shadow-xl transition-colors duration-300">
                        <h2 class="text-2xl font-bold text-gray-900 dark:text-white mb-6 flex items-center gap-3">
                            <span class="w-8 h-8 rounded-full bg-emerald-100 dark:bg-emerald-500/20 flex items-center justify-center text-emerald-600 dark:text-emerald-400 text-sm border border-emerald-200 dark:border-emerald-500/30">1</span>
                            Selecciona tus equipos
                        </h2>
                        
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-6 border-b border-gray-200 dark:border-emerald-500/20 pb-6">
                            <div>
                                <label class="flex items-center text-sm font-medium text-gray-600 dark:text-emerald-200 mb-1">
                                    Categoría
                                    <div class="relative group ml-1">
                                        <svg class="w-4 h-4 text-gray-400 dark:text-emerald-400 hover:text-emerald-600 dark:hover:text-yellow-400 cursor-help" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                                        <div class="absolute bottom-full left-1/2 -translate-x-1/2 mb-2 hidden group-hover:block w-48 p-2 bg-gray-900 dark:bg-[#0a2e2a] text-white dark:text-emerald-100 text-xs rounded-xl shadow-xl z-50 text-center border border-transparent dark:border-emerald-500/30">Filtra los equipos por familia.<div class="absolute top-full left-1/2 -translate-x-1/2 border-4 border-transparent border-t-gray-900 dark:border-t-[#0a2e2a]"></div></div>
                                    </div>
                                </label>
                                <select v-model="categoriaSeleccionada" class="w-full bg-gray-50 dark:bg-[#0d2e25] border border-gray-300 dark:border-emerald-500/30 rounded-xl text-gray-900 dark:text-white focus:ring-emerald-500 focus:border-emerald-500 py-2.5 px-3">
                                    <option v-for="cat in listaCategorias" :key="cat" :value="cat" class="bg-white dark:bg-[#0d2e25]">{{ cat }}</option>
                                </select>
                            </div>
                            
                            <div class="relative">
                                <label class="flex items-center text-sm font-medium text-gray-600 dark:text-emerald-200 mb-1">
                                    Electrodoméstico
                                    <div class="relative group ml-1">
                                        <svg class="w-4 h-4 text-gray-400 dark:text-emerald-400 hover:text-emerald-600 dark:hover:text-yellow-400 cursor-help" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                                        <div class="absolute bottom-full left-1/2 -translate-x-1/2 mb-2 hidden group-hover:block w-56 p-2 bg-gray-900 dark:bg-[#0a2e2a] text-white dark:text-emerald-100 text-xs rounded-xl shadow-xl z-50 text-center border border-transparent dark:border-emerald-500/30">Selecciona el aparato. Los vatios (W) definen cuánta energía consume.<div class="absolute top-full left-1/2 -translate-x-1/2 border-4 border-transparent border-t-gray-900 dark:border-t-[#0a2e2a]"></div></div>
                                    </div>
                                </label>
                                <div v-if="mostrarDropdown" @click="mostrarDropdown = false" class="fixed inset-0 z-0"></div>
                                
                                <div class="relative z-10">
                                    <button type="button" @click="mostrarDropdown = !mostrarDropdown" class="w-full text-left bg-gray-50 dark:bg-[#0d2e25] border border-gray-300 dark:border-emerald-500/30 rounded-xl py-2.5 px-3 shadow-sm focus:ring-emerald-500 focus:border-emerald-500 flex justify-between items-center text-gray-900 dark:text-white">
                                        <span class="truncate">{{ equipoSeleccionado ? equipoSeleccionado.nombre : 'Seleccionar...' }}</span>
                                        <svg class="h-4 w-4 text-gray-400 dark:text-emerald-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"></path></svg>
                                    </button>

                                    <div v-if="mostrarDropdown" class="absolute z-10 w-full mt-1 bg-white dark:bg-[#0d2e25] border border-gray-200 dark:border-emerald-500/30 rounded-xl shadow-2xl overflow-hidden">
                                        <div class="p-2 border-b border-gray-100 dark:border-emerald-500/20">
                                            <input type="text" v-model="busquedaEquipo" placeholder="Buscar equipo..." class="w-full bg-gray-50 dark:bg-[#0a2e2a] border border-gray-200 dark:border-emerald-500/20 rounded-lg text-sm text-gray-900 dark:text-white focus:ring-emerald-500 focus:border-emerald-500 py-2 px-3">
                                        </div>
                                        <ul class="max-h-48 overflow-y-auto py-1">
                                            <li v-for="equipo in equiposFiltrados" :key="equipo.id" @click="seleccionarEquipo(equipo)" class="px-4 py-2 hover:bg-emerald-50 dark:hover:bg-emerald-500/20 cursor-pointer text-sm text-gray-700 dark:text-emerald-100">
                                                {{ equipo.nombre }} <span class="text-gray-400 dark:text-emerald-400 text-xs">({{ equipo.watts }}W)</span>
                                            </li>
                                            <li v-if="equiposFiltrados.length === 0" class="px-4 py-3 text-sm text-gray-500 dark:text-emerald-300 text-center">No se encontraron equipos</li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div>
                            <div class="flex justify-start mb-4 relative z-0">
                                <div class="flex items-center space-x-3 bg-gray-50 dark:bg-[#0d2e25] px-4 py-2 rounded-xl border border-gray-200 dark:border-emerald-500/30 group">
                                    <span class="text-sm font-medium" :class="!usarRangoHorario ? 'text-emerald-600 dark:text-yellow-400' : 'text-gray-400 dark:text-emerald-300'">Horas Manuales</span>
                                    <label class="relative inline-flex items-center cursor-pointer">
                                        <input type="checkbox" v-model="usarRangoHorario" class="sr-only peer">
                                        <div class="w-11 h-6 bg-gray-200 dark:bg-emerald-900 peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-emerald-500"></div>
                                    </label>
                                    <span class="text-sm font-medium mr-2" :class="usarRangoHorario ? 'text-emerald-600 dark:text-yellow-400' : 'text-gray-400 dark:text-emerald-300'">Usar Reloj</span>
                                </div>
                            </div>

                            <div :class="usarRangoHorario ? 'md:grid-cols-4' : 'md:grid-cols-3'" class="grid grid-cols-1 gap-4 items-end relative z-0">
                                <div>
                                    <label class="flex items-center text-sm font-medium text-gray-600 dark:text-emerald-200 mb-1">
                                        Cantidad
                                        <div class="relative group ml-1">
                                            <svg class="w-4 h-4 text-gray-400 dark:text-emerald-400 hover:text-emerald-600 dark:hover:text-yellow-400 cursor-help" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                                            <div class="absolute bottom-full left-1/2 -translate-x-1/2 mb-2 hidden group-hover:block w-32 p-2 bg-gray-900 dark:bg-[#0a2e2a] text-white dark:text-emerald-100 text-xs rounded-xl shadow-xl z-50 text-center border border-transparent dark:border-emerald-500/30">Nº de aparatos idénticos.<div class="absolute top-full left-1/2 -translate-x-1/2 border-4 border-transparent border-t-gray-900 dark:border-t-[#0a2e2a]"></div></div>
                                        </div>
                                    </label>
                                    <input v-model="cantidad" @input="validarEntero(cantidad)" type="number" min="1" class="w-full bg-gray-50 dark:bg-[#0d2e25] border border-gray-300 dark:border-emerald-500/30 rounded-xl text-gray-900 dark:text-white text-center py-2.5 focus:ring-emerald-500 focus:border-emerald-500">
                                </div>
                                
                                <template v-if="!usarRangoHorario">
                                    <div>
                                        <label class="flex items-center text-sm font-medium text-gray-600 dark:text-emerald-200 mb-1">
                                            Horas al día
                                            <div class="relative group ml-1">
                                                <svg class="w-4 h-4 text-gray-400 dark:text-emerald-400 hover:text-emerald-600 dark:hover:text-yellow-400 cursor-help" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                                                <div class="absolute bottom-full left-1/2 -translate-x-1/2 mb-2 hidden group-hover:block w-32 p-2 bg-gray-900 dark:bg-[#0a2e2a] text-white dark:text-emerald-100 text-xs rounded-xl shadow-xl z-50 text-center border border-transparent dark:border-emerald-500/30">Promedio diario de uso.<div class="absolute top-full left-1/2 -translate-x-1/2 border-4 border-transparent border-t-gray-900 dark:border-t-[#0a2e2a]"></div></div>
                                            </div>
                                        </label>
                                        <input v-model="tiempoUso" @input="validarEntero(tiempoUso)" type="number" min="1" class="w-full bg-gray-50 dark:bg-[#0d2e25] border border-gray-300 dark:border-emerald-500/30 rounded-xl text-gray-900 dark:text-white text-center py-2.5 focus:ring-emerald-500 focus:border-emerald-500">
                                    </div>
                                </template>
                                <template v-else>
                                    <div>
                                        <label class="flex items-center text-sm font-medium text-emerald-600 dark:text-yellow-400 mb-1">
                                            Hora Inicio
                                            <div class="relative group ml-1">
                                                <svg class="w-4 h-4 text-emerald-500 dark:text-yellow-400 hover:text-emerald-700 dark:hover:text-yellow-300 cursor-help" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                                                <div class="absolute bottom-full left-1/2 -translate-x-1/2 mb-2 hidden group-hover:block w-36 p-2 bg-gray-900 dark:bg-[#0a2e2a] text-white dark:text-emerald-100 text-xs rounded-xl shadow-xl z-50 text-center border border-transparent dark:border-emerald-500/30">Hora a la que enciendes el equipo.<div class="absolute top-full left-1/2 -translate-x-1/2 border-4 border-transparent border-t-gray-900 dark:border-t-[#0a2e2a]"></div></div>
                                            </div>
                                        </label>
                                        <input v-model="horaInicio" type="time" class="w-full bg-yellow-50 dark:bg-yellow-500/10 border border-yellow-300 dark:border-yellow-500/50 rounded-xl text-yellow-700 dark:text-yellow-300 text-center py-2.5 focus:ring-yellow-500 focus:border-yellow-500">
                                    </div>
                                    <div>
                                        <label class="flex items-center text-sm font-medium text-emerald-600 dark:text-yellow-400 mb-1">
                                            Hora Fin
                                            <div class="relative group ml-1">
                                                <svg class="w-4 h-4 text-emerald-500 dark:text-yellow-400 hover:text-emerald-700 dark:hover:text-yellow-300 cursor-help" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                                                <div class="absolute bottom-full left-1/2 -translate-x-1/2 mb-2 hidden group-hover:block w-40 p-2 bg-gray-900 dark:bg-[#0a2e2a] text-white dark:text-emerald-100 text-xs rounded-xl shadow-xl z-50 text-center border border-transparent dark:border-emerald-500/30">Hora a la que apagas el equipo.<div class="absolute top-full left-1/2 -translate-x-1/2 border-4 border-transparent border-t-gray-900 dark:border-t-[#0a2e2a]"></div></div>
                                            </div>
                                        </label>
                                        <input v-model="horaFin" type="time" class="w-full bg-yellow-50 dark:bg-yellow-500/10 border border-yellow-300 dark:border-yellow-500/50 rounded-xl text-yellow-700 dark:text-yellow-300 text-center py-2.5 focus:ring-yellow-500 focus:border-yellow-500">
                                    </div>
                                </template>

                                <div>
                                    <label class="flex items-center text-sm font-medium text-gray-600 dark:text-emerald-200 mb-1">
                                        Días de uso
                                        <div class="relative group ml-1">
                                            <svg class="w-4 h-4 text-gray-400 dark:text-emerald-400 hover:text-emerald-600 dark:hover:text-yellow-400 cursor-help" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                                            <div class="absolute bottom-full left-1/2 -translate-x-1/2 mb-2 hidden group-hover:block w-40 p-2 bg-gray-900 dark:bg-[#0a2e2a] text-white dark:text-emerald-100 text-xs rounded-xl shadow-xl z-50 text-center border border-transparent dark:border-emerald-500/30">Días al mes que se enciende (máximo 30).<div class="absolute top-full left-1/2 -translate-x-1/2 border-4 border-transparent border-t-gray-900 dark:border-t-[#0a2e2a]"></div></div>
                                        </div>
                                    </label>
                                    <input v-model="diasAlMes" @input="validarDias" type="number" min="1" max="30" class="w-full bg-gray-50 dark:bg-[#0d2e25] border border-gray-300 dark:border-emerald-500/30 rounded-xl text-gray-900 dark:text-white text-center py-2.5 focus:ring-emerald-500 focus:border-emerald-500" placeholder="Ej. 30">
                                </div>
                            </div>

                            <div class="mt-6">
                                <button @click="agregarEquipo" class="w-full bg-gradient-to-r from-yellow-400 to-emerald-500 text-[#0a2e2a] font-bold px-4 py-3 rounded-xl hover:shadow-lg hover:shadow-yellow-400/30 transition-all transform hover:-translate-y-0.5">
                                    Añadir al Inventario
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- Tarjeta de Inventario (Movida aquí, debajo del formulario) -->
                    <div v-if="inventario.length > 0" class="bg-white dark:bg-white/5 backdrop-blur-md border border-gray-200 dark:border-emerald-500/20 p-8 rounded-3xl shadow-xl transition-colors duration-300">
                        <div class="flex justify-between items-center mb-6">
                            <h2 class="text-2xl font-bold text-gray-900 dark:text-white flex items-center gap-3">
                                <span class="w-8 h-8 rounded-full bg-emerald-100 dark:bg-emerald-500/20 flex items-center justify-center text-emerald-600 dark:text-emerald-400 text-sm border border-emerald-200 dark:border-emerald-500/30">2</span>
                                Tu Inventario
                            </h2>
                            <span class="text-sm bg-emerald-100 dark:bg-emerald-500/20 text-emerald-700 dark:text-emerald-300 px-3 py-1 rounded-full font-medium border border-emerald-200 dark:border-emerald-500/30">{{ inventario.length }} equipos</span>
                        </div>
                        
                        <ul class="divide-y divide-gray-200 dark:divide-emerald-500/20 mb-6 max-h-64 overflow-y-auto pr-2">
                            <li v-for="item in inventario" :key="item.id" class="py-4 flex justify-between items-center group">
                                <div>
                                    <p class="font-semibold text-gray-900 dark:text-white text-lg">{{ item.nombre }} <span class="text-sm font-normal text-gray-500 dark:text-emerald-300">x{{ item.cantidad }}</span></p>
                                    <p class="text-sm text-gray-600 dark:text-emerald-200 mt-1 flex flex-wrap items-center gap-2">
                                        <span v-if="item.esRango" class="text-blue-700 dark:text-cyan-300 bg-blue-100 dark:bg-cyan-500/20 px-2 py-0.5 rounded text-xs font-medium border border-blue-200 dark:border-cyan-500/30">⏰ {{ item.rangoTexto }}</span>
                                        <span v-else class="text-emerald-700 dark:text-emerald-300 bg-emerald-100 dark:bg-emerald-500/20 px-2 py-0.5 rounded text-xs border border-emerald-200 dark:border-emerald-500/30">{{ item.tiempoUso }} hrs/día</span>
                                        <span class="text-gray-400 dark:text-emerald-500">•</span> 
                                        <span>{{ item.diasAlMes }} días/mes</span>
                                        <span class="text-gray-400 dark:text-emerald-500">•</span> 
                                        <span class="text-emerald-600 dark:text-yellow-400 font-bold">{{ calcularKwhItem(item).toFixed(1) }} kWh</span>
                                    </p>
                                </div>
                                <button @click="eliminarEquipo(item.id)" class="text-red-500 dark:text-red-400 hover:text-red-700 dark:hover:text-red-300 text-sm font-medium opacity-0 group-hover:opacity-100 transition-opacity bg-red-50 dark:bg-red-500/10 px-3 py-1 rounded-lg border border-red-200 dark:border-red-500/20">Eliminar</button>
                            </li>
                        </ul>

                        <!-- GRÁFICO MOVIDO AQUÍ -->
                        <div class="h-64 border-t border-gray-200 dark:border-emerald-500/20 pt-6 mt-4">
                            <Pie :data="chartData" :options="chartOptions" />
                        </div>
                    </div>
                </div>

                <!-- Columna Derecha: Desglose Mensual (Movido aquí) -->
                <div class="lg:col-span-5">
                    <div class="bg-white dark:bg-white/5 backdrop-blur-md border border-gray-200 dark:border-emerald-500/20 border-t-4 border-t-emerald-500 dark:border-t-yellow-400 p-8 rounded-3xl shadow-2xl sticky top-6 transition-colors duration-300">
                        <h2 class="text-2xl font-bold text-gray-900 dark:text-white mb-6 border-b border-gray-200 dark:border-emerald-500/20 pb-4">Desglose Mensual Estimado</h2>
                        
                        <div class="flex justify-between items-center mb-6 bg-emerald-50 dark:bg-emerald-500/10 p-4 rounded-2xl border border-emerald-100 dark:border-emerald-500/20">
                            <span class="flex items-center text-emerald-800 dark:text-emerald-200 font-medium">
                                Consumo Total
                                <div class="relative group ml-2">
                                    <svg class="w-4 h-4 text-emerald-500 dark:text-emerald-400 hover:text-emerald-700 dark:hover:text-yellow-400 cursor-help" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                                    <div class="absolute bottom-full right-0 mb-2 hidden group-hover:block w-56 p-2 bg-gray-900 dark:bg-[#0a2e2a] text-white dark:text-emerald-100 text-xs rounded-xl shadow-xl z-50 text-center border border-transparent dark:border-emerald-500/30">Suma de todos los Kilovatios-hora (kWh) procesados.<div class="absolute top-full right-4 border-4 border-transparent border-t-gray-900 dark:border-t-[#0a2e2a]"></div></div>
                                </div>
                            </span>
                            <span class="text-3xl font-bold text-gray-900 dark:text-white">{{ totalKwh.toFixed(2) }} <span class="text-lg text-emerald-600 dark:text-emerald-400 font-normal">kWh</span></span>
                        </div>
                        
                        <div class="space-y-4 text-sm text-gray-600 dark:text-emerald-100">
                            <div class="flex justify-between items-center">
                                <span class="flex items-center">
                                    Cargo por Energía
                                    <div class="relative group ml-2">
                                        <svg class="w-3.5 h-3.5 text-gray-400 dark:text-emerald-400 hover:text-emerald-600 dark:hover:text-yellow-400 cursor-help" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                                        <div class="absolute bottom-full left-1/2 -translate-x-1/2 mb-2 hidden group-hover:block w-48 p-2 bg-gray-900 dark:bg-[#0a2e2a] text-white dark:text-emerald-100 text-xs rounded-xl shadow-xl z-50 text-center border border-transparent dark:border-emerald-500/30">Costo directo por generar los kWh.<div class="absolute top-full left-1/2 -translate-x-1/2 border-4 border-transparent border-t-gray-900 dark:border-t-[#0a2e2a]"></div></div>
                                    </div>
                                </span>
                                <span class="font-mono text-gray-900 dark:text-white">${{ desglose.cargoEnergia }}</span>
                            </div>
                            
                            <div class="flex justify-between items-center">
                                <span class="flex items-center">
                                    Cargo de Distribución
                                    <div class="relative group ml-2">
                                        <svg class="w-3.5 h-3.5 text-gray-400 dark:text-emerald-400 hover:text-emerald-600 dark:hover:text-yellow-400 cursor-help" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                                        <div class="absolute bottom-full left-1/2 -translate-x-1/2 mb-2 hidden group-hover:block w-56 p-2 bg-gray-900 dark:bg-[#0a2e2a] text-white dark:text-emerald-100 text-xs rounded-xl shadow-xl z-50 text-center border border-transparent dark:border-emerald-500/30">Cobro por usar la red de postes y cables.<div class="absolute top-full left-1/2 -translate-x-1/2 border-4 border-transparent border-t-gray-900 dark:border-t-[#0a2e2a]"></div></div>
                                    </div>
                                </span>
                                <span class="font-mono text-gray-900 dark:text-white">${{ desglose.cargoDistribucion }}</span>
                            </div>
                            
                            <div class="flex justify-between items-center">
                                <span class="flex items-center">
                                    Comercialización
                                    <div class="relative group ml-2">
                                        <svg class="w-3.5 h-3.5 text-gray-400 dark:text-emerald-400 hover:text-emerald-600 dark:hover:text-yellow-400 cursor-help" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                                        <div class="absolute bottom-full left-1/2 -translate-x-1/2 mb-2 hidden group-hover:block w-56 p-2 bg-gray-900 dark:bg-[#0a2e2a] text-white dark:text-emerald-100 text-xs rounded-xl shadow-xl z-50 text-center border border-transparent dark:border-emerald-500/30">Cargo fijo por administración y facturación.<div class="absolute top-full left-1/2 -translate-x-1/2 border-4 border-transparent border-t-gray-900 dark:border-t-[#0a2e2a]"></div></div>
                                    </div>
                                </span>
                                <span class="font-mono text-gray-900 dark:text-white">${{ desglose.cargoComercializacion }}</span>
                            </div>
                            
                            <div class="flex justify-between items-center">
                                <span class="flex items-center">
                                    Impuestos
                                    <div class="relative group ml-2">
                                        <svg class="w-3.5 h-3.5 text-gray-400 dark:text-emerald-400 hover:text-emerald-600 dark:hover:text-yellow-400 cursor-help" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                                        <div class="absolute bottom-full left-1/2 -translate-x-1/2 mb-2 hidden group-hover:block w-48 p-2 bg-gray-900 dark:bg-[#0a2e2a] text-white dark:text-emerald-100 text-xs rounded-xl shadow-xl z-50 text-center border border-transparent dark:border-emerald-500/30">Incluye 13% de IVA y tributos FODES/RNVM.<div class="absolute top-full left-1/2 -translate-x-1/2 border-4 border-transparent border-t-gray-900 dark:border-t-[#0a2e2a]"></div></div>
                                    </div>
                                </span>
                                <span class="font-mono text-gray-900 dark:text-white">${{ desglose.impuestos }}</span>
                            </div>
                            
                            <div v-if="desglose.subsidio < 0" class="flex justify-between items-center text-emerald-600 dark:text-emerald-400 font-medium pt-4 border-t border-gray-200 dark:border-emerald-500/20">
                                <span class="flex items-center">
                                    Subsidio Gubernamental
                                    <div class="relative group ml-2">
                                        <svg class="w-3.5 h-3.5 text-emerald-500 dark:text-emerald-400 hover:text-emerald-700 dark:hover:text-emerald-300 cursor-help" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                                        <div class="absolute bottom-full left-1/2 -translate-x-1/2 mb-2 hidden group-hover:block w-56 p-2 bg-emerald-900 text-white text-xs rounded-xl shadow-xl z-50 text-center border border-emerald-500/30">Descuento del Estado al consumir menos de 105 kWh.<div class="absolute top-full left-1/2 -translate-x-1/2 border-4 border-transparent border-t-emerald-900"></div></div>
                                    </div>
                                </span>
                                <span class="font-mono">${{ desglose.subsidio }}</span>
                            </div>
                        </div>
                        
                        <!-- Total a Pagar (Arreglado para modo oscuro) -->
                        <div class="mt-8 pt-6 border-t border-gray-200 dark:border-emerald-500/20 flex justify-between items-center bg-emerald-50 dark:bg-white/5 p-4 rounded-2xl border border-emerald-100 dark:border-emerald-500/30">
                            <span class="text-xl font-bold text-gray-900 dark:text-white">Total a Pagar</span>
                            <span class="text-4xl font-extrabold text-transparent bg-clip-text bg-gradient-to-r from-emerald-500 to-emerald-700 dark:from-yellow-300 dark:to-emerald-400">${{ desglose.total }}</span>
                        </div>
                    </div>
                </div>
                
            </div>
        </main>
    </div>
</template>

<style scoped>
@keyframes flotar {
    0%, 100% { transform: translateY(0); }
    50% { transform: translateY(-6px); }
}

.icono-flotante {
    animation: flotar 3s ease-in-out infinite;
}

::-webkit-scrollbar {
    width: 8px;
}
::-webkit-scrollbar-track {
    background: transparent;
}
::-webkit-scrollbar-thumb {
    background: #10B981;
    border-radius: 4px;
}
::-webkit-scrollbar-thumb:hover {
    background: #34D399;
}
</style>