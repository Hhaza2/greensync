<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { onMounted } from 'vue';

defineOptions({
    layout: null,
});

const equipo = [
    { nombre: 'Daniela José Martínez Pérez', id: '032922', rol: 'Ingeniería y Desarrollo' },
    { nombre: 'Katherine Michelle Álvarez Henríquez', id: '041122', rol: 'Ingeniería y Desarrollo' },
    { nombre: 'Levi Hazael Ramos Reyes', id: '069622', rol: 'Ingeniería y Desarrollo' },
    { nombre: 'Fiorella Beatriz Campos Flores', id: '005722', rol: 'Ingeniería y Desarrollo' }
];

onMounted(() => {
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-fade-in-up');
            }
        });
    }, { threshold: 0.1 });

    document.querySelectorAll('.scroll-reveal').forEach((el) => observer.observe(el));
});
</script>

<template>
    <Head title="Sobre Nosotros - GreenSync" />

    <div class="min-h-screen bg-gray-50 dark:bg-gradient-to-br dark:from-[#0a2e2a] dark:via-[#0f3d35] dark:to-[#1a2e1a] text-gray-900 dark:text-white font-sans selection:bg-yellow-400 selection:text-black relative overflow-hidden transition-colors duration-300">
        
        <!-- Luces decorativas de fondo -->
        <div class="absolute top-0 left-0 w-full h-full pointer-events-none z-0 hidden dark:block">
            <div class="absolute -top-40 -left-40 w-[500px] h-[500px] bg-emerald-500/30 rounded-full blur-[120px]"></div>
            <div class="absolute top-1/2 right-0 w-[400px] h-[400px] bg-cyan-500/20 rounded-full blur-[120px]"></div>
            <div class="absolute -bottom-40 left-1/3 w-[600px] h-[600px] bg-yellow-500/10 rounded-full blur-[150px]"></div>
        </div>

        <!-- Navegación -->
        <nav class="relative z-50 w-full bg-white dark:bg-[#0a2e2a]/80 backdrop-blur-xl border-b border-gray-200 dark:border-emerald-500/20 transition-colors duration-300">
            <div class="max-w-7xl mx-auto px-4 h-20 flex justify-between items-center">
                <Link :href="route('home')" class="text-2xl font-bold flex items-center gap-3 group">
                    <div class="w-10 h-10 rounded-xl bg-gradient-to-br from-yellow-400 to-emerald-500 flex items-center justify-center shadow-lg shadow-emerald-500/40 group-hover:scale-110 transition-transform">
                        <svg class="w-6 h-6 text-[#0a2e2a]" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"></path></svg>
                    </div>
                    <span class="text-gray-900 dark:text-white">GreenSync</span>
                </Link>
                <div class="flex items-center gap-6 text-sm font-medium">
                    <Link :href="route('home')" class="text-gray-600 dark:text-emerald-100 hover:text-emerald-600 dark:hover:text-yellow-400 transition-colors">Calculadora</Link>
                    <Link :href="route('login')" class="text-gray-600 dark:text-emerald-100 hover:text-emerald-600 dark:hover:text-yellow-400 transition-colors">Iniciar Sesión</Link>
                    <Link :href="route('register')" class="bg-gradient-to-r from-yellow-400 to-emerald-500 text-[#0a2e2a] font-bold px-6 py-2.5 rounded-full hover:shadow-lg hover:shadow-yellow-400/30 transition-all">
                        Únete gratis
                    </Link>
                </div>
            </div>
        </nav>

        <!-- Hero Section -->
        <header class="relative pt-32 pb-20 px-6 z-10">
            <div class="max-w-5xl mx-auto text-center scroll-reveal">
                <span class="inline-flex items-center gap-2 text-yellow-600 dark:text-yellow-300 font-bold tracking-wider text-xs uppercase bg-yellow-100 dark:bg-yellow-500/20 px-5 py-2 rounded-full border border-yellow-200 dark:border-yellow-400/30 mb-8 backdrop-blur-sm">
                    <span class="w-2 h-2 rounded-full bg-yellow-500 dark:bg-yellow-400 animate-pulse"></span>
                    Nuestra Misión
                </span>
                <h1 class="text-5xl md:text-7xl font-extrabold text-gray-900 dark:text-white leading-tight tracking-tight drop-shadow-2xl">
                    Transformamos <br />
                    <span class="text-transparent bg-clip-text bg-gradient-to-r from-yellow-500 via-emerald-500 to-cyan-500 dark:from-yellow-300 dark:via-emerald-300 dark:to-cyan-300">métricas en decisiones.</span>
                </h1>
                <p class="mt-8 text-xl text-gray-600 dark:text-emerald-100 max-w-3xl mx-auto leading-relaxed font-light">
                    Dejamos atrás la confusión de la facturación tradicional. GreenSync centraliza el seguimiento inteligente de tu electricidad, protegiendo tu bolsillo y el planeta.
                </p>
            </div>
        </header>

        <!-- Sección: El Problema -->
        <section class="py-20 relative z-10">
            <div class="max-w-7xl mx-auto px-6">
                <div class="text-center mb-16 scroll-reveal">
                    <h2 class="text-4xl md:text-5xl font-bold text-gray-900 dark:text-white mb-4">¿Por qué nace GreenSync?</h2>
                    <p class="text-gray-600 dark:text-emerald-200 text-lg">Los tres grandes retos energéticos de la actualidad.</p>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
                    <!-- Tarjeta 1 -->
                    <div class="scroll-reveal bg-gradient-to-br from-yellow-400 to-amber-500 rounded-3xl p-8 shadow-xl shadow-yellow-500/20 hover:scale-[1.03] transition-transform duration-300">
                        <div class="w-16 h-16 bg-white/20 rounded-2xl flex items-center justify-center mb-6 backdrop-blur-sm border border-white/30">
                            <svg class="w-8 h-8 text-white icono-flotante" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 17h8m0 0V9m0 8l-8-8-4 4-6-6"></path></svg>
                        </div>
                        <h3 class="text-2xl font-bold text-white mb-3 drop-shadow-md">Tarifas al Alza</h3>
                        <p class="text-white/90 leading-relaxed font-medium">
                            La volatilidad de los mercados afecta directamente los presupuestos de hogares y empresas. Cada kilovatio cuenta.
                        </p>
                    </div>

                    <!-- Tarjeta 2 -->
                    <div class="scroll-reveal bg-gradient-to-br from-emerald-500 to-teal-600 rounded-3xl p-8 shadow-xl shadow-emerald-500/20 hover:scale-[1.03] transition-transform duration-300" style="transition-delay: 100ms;">
                        <div class="w-16 h-16 bg-white/20 rounded-2xl flex items-center justify-center mb-6 backdrop-blur-sm border border-white/30">
                            <svg class="w-8 h-8 text-white icono-flotante" style="animation-delay: 0.2s;" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3.055 11H5a2 2 0 012 2v1a2 2 0 002 2 2 2 0 012 2v2.945M8 3.935V5.5A2.5 2.5 0 0010.5 8h.5a2 2 0 012 2 2 2 0 104 0 2 2 0 012-2h1.064M15 20.488V18a2 2 0 012-2h3.064M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                        </div>
                        <h3 class="text-2xl font-bold text-white mb-3 drop-shadow-md">Impacto Ambiental</h3>
                        <p class="text-white/90 leading-relaxed font-medium">
                            La dependencia de combustibles fósiles daña nuestros ecosistemas. Optimizar la energía es proteger el mañana.
                        </p>
                    </div>

                    <!-- Tarjeta 3 -->
                    <div class="scroll-reveal bg-gradient-to-br from-cyan-400 to-blue-600 rounded-3xl p-8 shadow-xl shadow-cyan-500/20 hover:scale-[1.03] transition-transform duration-300" style="transition-delay: 200ms;">
                        <div class="w-16 h-16 bg-white/20 rounded-2xl flex items-center justify-center mb-6 backdrop-blur-sm border border-white/30">
                            <svg class="w-8 h-8 text-white icono-flotante" style="animation-delay: 0.4s;" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                        </div>
                        <h3 class="text-2xl font-bold text-white mb-3 drop-shadow-md">Falta de Información</h3>
                        <p class="text-white/90 leading-relaxed font-medium">
                            Los recibos de luz tradicionales son confusos y no te dicen qué aparato está consumiendo tu dinero.
                        </p>
                    </div>
                </div>
            </div>
        </section>

        <!-- Sección: La Solución -->
        <section class="py-24 relative z-10 bg-gradient-to-b from-transparent to-gray-100 dark:to-[#0d2e25] transition-colors duration-300">
            <div class="max-w-6xl mx-auto px-6">
                <div class="text-center mb-16 scroll-reveal">
                    <span class="text-yellow-600 dark:text-yellow-400 font-bold tracking-wider text-sm uppercase">La Solución</span>
                    <h2 class="text-4xl md:text-5xl font-bold text-gray-900 dark:text-white mt-4">Ingeniería que genera ahorros.</h2>
                    <p class="text-gray-600 dark:text-emerald-200 mt-6 max-w-3xl mx-auto text-lg">
                        Construimos GreenSync sobre <strong class="text-gray-900 dark:text-white">Laravel</strong>, logrando un despliegue perfecto en servidores Apache (Linux) e IIS (Windows). No es solo una calculadora, es un motor analítico avanzado.
                    </p>
                </div>

                <div class="space-y-8 max-w-4xl mx-auto">
                    <!-- Item 1 -->
                    <div class="scroll-reveal flex flex-col md:flex-row items-start gap-6 bg-white dark:bg-white/5 backdrop-blur-md border border-emerald-200 dark:border-emerald-500/30 p-8 rounded-3xl hover:bg-gray-50 dark:hover:bg-white/10 transition-colors shadow-sm dark:shadow-none">
                        <div class="w-20 h-20 flex-shrink-0 rounded-2xl bg-gradient-to-br from-emerald-400 to-teal-500 flex items-center justify-center shadow-lg shadow-emerald-500/40">
                            <svg class="w-10 h-10 text-white icono-flotante" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"></path></svg>
                        </div>
                        <div>
                            <h4 class="font-bold text-2xl text-gray-900 dark:text-white mb-2">Análisis Visual Interactivo</h4>
                            <p class="text-gray-600 dark:text-emerald-100 text-lg">Historiales de consumo diarios, semanales y mensuales en dashboards dinámicos.</p>
                        </div>
                    </div>

                    <!-- Item 2 -->
                    <div class="scroll-reveal flex flex-col md:flex-row items-start gap-6 bg-white dark:bg-white/5 backdrop-blur-md border border-cyan-200 dark:border-cyan-500/30 p-8 rounded-3xl hover:bg-gray-50 dark:hover:bg-white/10 transition-colors shadow-sm dark:shadow-none">
                        <div class="w-20 h-20 flex-shrink-0 rounded-2xl bg-gradient-to-br from-cyan-400 to-blue-500 flex items-center justify-center shadow-lg shadow-cyan-500/40">
                            <svg class="w-10 h-10 text-white icono-flotante" style="animation-delay: 0.3s;" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19.428 15.428a2 2 0 00-1.022-.547l-2.387-.477a6 6 0 00-3.86.517l-.318.158a6 6 0 01-3.86.517L6.05 15.21a2 2 0 00-1.806.547M8 4h8l-1 1v5.172a2 2 0 00.586 1.414l5 5c1.26 1.26.367 3.414-1.415 3.414H4.828c-1.782 0-2.674-2.154-1.414-3.414l5-5A2 2 0 009 10.172V5L8 4z"></path></svg>
                        </div>
                        <div>
                            <h4 class="font-bold text-2xl text-gray-900 dark:text-white mb-2">Detección de Anomalías</h4>
                            <p class="text-gray-600 dark:text-emerald-100 text-lg">Reglas heurísticas y umbrales que detectan si estás gastando más energía de la necesaria.</p>
                        </div>
                    </div>

                    <!-- Item 3 -->
                    <div class="scroll-reveal flex flex-col md:flex-row items-start gap-6 bg-white dark:bg-white/5 backdrop-blur-md border border-yellow-200 dark:border-yellow-500/30 p-8 rounded-3xl hover:bg-gray-50 dark:hover:bg-white/10 transition-colors shadow-sm dark:shadow-none">
                        <div class="w-20 h-20 flex-shrink-0 rounded-2xl bg-gradient-to-br from-yellow-400 to-amber-500 flex items-center justify-center shadow-lg shadow-yellow-500/40">
                            <svg class="w-10 h-10 text-white icono-flotante" style="animation-delay: 0.6s;" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9.75 17L9 20l-1 1h8l-1-1-.75-3M3 13h18M5 17h14a2 2 0 002-2V5a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"></path></svg>
                        </div>
                        <div>
                            <h4 class="font-bold text-2xl text-gray-900 dark:text-white mb-2">Multiplataforma Robusto</h4>
                            <p class="text-gray-600 dark:text-emerald-100 text-lg">Despliegue garantizado en entornos heterogéneos: Apache sobre Linux e IIS sobre Windows.</p>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Sección: Objetivos (REDISEÑADA PARA MODO OSCURO) -->
        <section class="py-24 relative z-10 bg-gray-100 dark:bg-[#0a2e2a] transition-colors duration-300">
            <div class="max-w-7xl mx-auto px-6">
                <div class="text-center mb-16 scroll-reveal">
                    <h2 class="text-4xl md:text-5xl font-bold text-gray-900 dark:text-white mb-4">Nuestros Objetivos</h2>
                    <p class="text-gray-600 dark:text-emerald-200 text-lg">Metas claras para un futuro energético eficiente.</p>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                    <!-- Objetivo 1 -->
                    <div class="scroll-reveal bg-white dark:bg-white/5 border border-gray-200 dark:border-white/10 border-t-4 border-t-emerald-500 dark:border-t-emerald-400 rounded-3xl p-8 hover:-translate-y-2 transition-all duration-300 shadow-sm dark:shadow-none">
                        <div class="w-14 h-14 bg-emerald-100 dark:bg-emerald-500/20 rounded-2xl flex items-center justify-center mb-6 border border-emerald-200 dark:border-emerald-400/30">
                            <svg class="w-7 h-7 text-emerald-600 dark:text-emerald-400 icono-flotante" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 7v10c0 2.21 3.582 4 8 4s8-1.79 8-4V7M4 7c0 2.21 3.582 4 8 4s8-1.79 8-4M4 7c0-2.21 3.582-4 8-4s8 1.79 8 4m0 5c0 2.21-3.582 4-8 4s-8-1.79-8-4"></path></svg>
                        </div>
                        <h3 class="text-xl font-bold text-gray-900 dark:text-white mb-3">Base de Datos Robusta</h3>
                        <p class="text-sm text-gray-600 dark:text-emerald-100 leading-relaxed">Diseño relacional normalizado para almacenamiento eficiente y escalable.</p>
                    </div>

                    <!-- Objetivo 2 -->
                    <div class="scroll-reveal bg-white dark:bg-white/5 border border-gray-200 dark:border-white/10 border-t-4 border-t-cyan-500 dark:border-t-cyan-400 rounded-3xl p-8 hover:-translate-y-2 transition-all duration-300 shadow-sm dark:shadow-none" style="transition-delay: 100ms;">
                        <div class="w-14 h-14 bg-cyan-100 dark:bg-cyan-500/20 rounded-2xl flex items-center justify-center mb-6 border border-cyan-200 dark:border-cyan-400/30">
                            <svg class="w-7 h-7 text-cyan-600 dark:text-cyan-400 icono-flotante" style="animation-delay: 0.2s;" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 20l4-16m4 4l4 4-4 4M6 16l-4-4 4-4"></path></svg>
                        </div>
                        <h3 class="text-xl font-bold text-gray-900 dark:text-white mb-3">Núcleo en Laravel</h3>
                        <p class="text-sm text-gray-600 dark:text-cyan-100 leading-relaxed">Gestión de usuarios, roles y procesamiento de series temporales en backend.</p>
                    </div>

                    <!-- Objetivo 3 -->
                    <div class="scroll-reveal bg-white dark:bg-white/5 border border-gray-200 dark:border-white/10 border-t-4 border-t-purple-500 dark:border-t-purple-400 rounded-3xl p-8 hover:-translate-y-2 transition-all duration-300 shadow-sm dark:shadow-none" style="transition-delay: 200ms;">
                        <div class="w-14 h-14 bg-purple-100 dark:bg-purple-500/20 rounded-2xl flex items-center justify-center mb-6 border border-purple-200 dark:border-purple-400/30">
                            <svg class="w-7 h-7 text-purple-600 dark:text-purple-400 icono-flotante" style="animation-delay: 0.4s;" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 12h14M5 12a2 2 0 01-2-2V6a2 2 0 012-2h14a2 2 0 012 2v4a2 2 0 01-2 2M5 12a2 2 0 00-2 2v4a2 2 0 002 2h14a2 2 0 002-2v-4a2 2 0 00-2-2m-2-4h.01M17 16h.01"></path></svg>
                        </div>
                        <h3 class="text-xl font-bold text-gray-900 dark:text-white mb-3">Servidores Multiplataforma</h3>
                        <p class="text-sm text-gray-600 dark:text-purple-100 leading-relaxed">Configuración de Apache e IIS en máquinas virtuales con balanceo de carga.</p>
                    </div>

                    <!-- Objetivo 4 -->
                    <div class="scroll-reveal bg-white dark:bg-white/5 border border-gray-200 dark:border-white/10 border-t-4 border-t-yellow-500 dark:border-t-yellow-400 rounded-3xl p-8 hover:-translate-y-2 transition-all duration-300 shadow-sm dark:shadow-none" style="transition-delay: 300ms;">
                        <div class="w-14 h-14 bg-yellow-100 dark:bg-yellow-500/20 rounded-2xl flex items-center justify-center mb-6 border border-yellow-200 dark:border-yellow-400/30">
                            <svg class="w-7 h-7 text-yellow-600 dark:text-yellow-400 icono-flotante" style="animation-delay: 0.6s;" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9.663 17h4.673M12 3v1m6.364 1.636l-.707.707M21 12h-1M4 12H3m3.343-5.657l-.707-.707m2.828 9.9a5 5 0 117.072 0l-.548.547A3.374 3.374 0 0014 18.469V19a2 2 0 11-4 0v-.531c0-.895-.356-1.754-.988-2.386l-.548-.547z"></path></svg>
                        </div>
                        <h3 class="text-xl font-bold text-gray-900 dark:text-white mb-3">Recomendaciones Automatizadas</h3>
                        <p class="text-sm text-gray-600 dark:text-yellow-100 leading-relaxed">Motor basado en umbrales dinámicos y detección de picos anómalos.</p>
                    </div>
                </div>
            </div>
        </section>

        <!-- Sección: El Equipo -->
        <section class="py-24 relative z-10 bg-gray-50 dark:bg-[#0d2e25] transition-colors duration-300">
            <div class="max-w-7xl mx-auto px-6">
                <div class="text-center mb-16 scroll-reveal">
                    <h2 class="text-4xl md:text-5xl font-bold text-gray-900 dark:text-white mb-2">Desarrolladores</h2>
                    <p class="text-yellow-600 dark:text-yellow-400 font-medium tracking-wide text-lg">Equipo 1</p>
                </div>

                <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
                    <div v-for="(miembro, index) in equipo" :key="index" 
                         class="scroll-reveal bg-white dark:bg-white/5 border border-emerald-200 dark:border-emerald-500/30 rounded-2xl p-6 text-center hover:bg-gray-50 dark:hover:bg-white/10 hover:-translate-y-2 transition-all duration-300 group shadow-sm dark:shadow-none"
                         :style="{ transitionDelay: index * 100 + 'ms' }">
                        
                        <div class="w-24 h-24 mx-auto rounded-full bg-gradient-to-br from-emerald-400 to-cyan-500 flex items-center justify-center mb-6 shadow-lg shadow-emerald-500/30 group-hover:scale-110 transition-transform duration-300">
                            <span class="text-4xl font-black text-white">
                                {{ miembro.nombre.charAt(0) }}
                            </span>
                        </div>
                        
                        <h3 class="text-lg font-bold text-gray-900 dark:text-white mb-1">{{ miembro.nombre }}</h3>
                        <p class="text-sm text-gray-600 dark:text-emerald-200 mb-4">{{ miembro.rol }}</p>
                        
                        <div class="pt-4 border-t border-gray-200 dark:border-emerald-500/20">
                            <span class="text-xs font-mono font-bold text-yellow-700 dark:text-yellow-300 bg-yellow-100 dark:bg-yellow-500/10 px-3 py-1.5 rounded-md border border-yellow-200 dark:border-yellow-500/20">
                                ID: {{ miembro.id }}
                            </span>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Footer -->
        <footer class="py-8 text-center text-gray-500 dark:text-emerald-300 text-sm border-t border-gray-200 dark:border-emerald-500/20 relative z-10 bg-white dark:bg-[#0a2e2a] transition-colors duration-300">
            <p>&copy; 2026 GreenSync. Proyecto Final.</p>
        </footer>

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

@keyframes fadeInUp {
    from {
        opacity: 0;
        transform: translateY(30px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

.animate-fade-in-up {
    animation: fadeInUp 0.8s cubic-bezier(0.16, 1, 0.3, 1) forwards;
}

.scroll-reveal {
    opacity: 0;
}

.scroll-reveal:nth-child(1) { animation-delay: 0ms; }
.scroll-reveal:nth-child(2) { animation-delay: 100ms; }
.scroll-reveal:nth-child(3) { animation-delay: 200ms; }
.scroll-reveal:nth-child(4) { animation-delay: 300ms; }
</style>