/// Imagen (dibujo) de cada tarjeta interactiva, según su título. Se muestra
/// en la tarjeta pequeña y en grande junto con la descripción.
const imagenesTarjetas = <String, String>{
  // Biología · respiración y defensas
  'Árboles y plantas': '🌳', 'Jugar al aire libre': '⚽', 'Ventilar tu casa': '🪟', 'Lugares sin humo': '🚭',
  'Humo de cigarro': '🚬', 'Humo de autos y fábricas': '🏭', 'Quemar basura': '🔥', 'Polvo y polen': '🌼',
  'Aire muy frío': '🥶', 'Mucha altura': '🏔️', 'Frutas y verduras': '🥦', 'Dormir bien': '😴', 'Hacer ejercicio': '🏃',
  'Lavarte las manos': '🧼', 'Ponerte tus vacunas': '💉', 'Tomar agua': '💧', 'No lavarse las manos': '🦠',
  'Compartir vasos y cubiertos': '🥤', 'Dormir poco': '🥱', 'Comer mucha comida chatarra': '🍟', 'Toser sin taparse': '🤧',
  'Tomar medicinas sin receta': '💊',
  // Células
  'Diminutas': '🔬', 'Se nutren': '🍎', 'Crecen': '🌱', 'Se reproducen': '🧫', 'Responden': '⚡', 'Vienen de otra célula': '🧬',
  'Neuronas': '🧠', 'Glóbulos rojos': '🩸', 'Células musculares': '💪', 'Células de la piel': '✋',
  // Alimentación
  'Tortilla y pan': '🫓', 'Arroz y avena': '🍚', 'Aguacate y nueces': '🥑', 'Huevo, pollo y pescado': '🍳', 'Frijoles y lentejas': '🫘',
  'Leche y queso': '🧀', 'Verduras': '🥕', 'Frutas': '🍉', 'Agua simple': '💧', 'Desayunar': '🥣', 'Tomar agua simple': '💧',
  'Dormir de 9 a 11 horas': '🛌', 'Lavarse las manos': '🧼', 'Tomar refrescos': '🥤', 'Comer chatarra seguido': '🍔',
  'Muchas horas de pantalla': '📱', 'Saltarse comidas': '🍽️',
  // Seres vivos
  'Plantas': '🪴', 'Animales': '🐾', 'Respiración': '🫁', 'Ovíparos': '🥚', 'Vivíparos': '🐄', 'Pulmones': '🫁', 'Branquias': '🐟',
  'Tráqueas': '🐞', 'Piel': '🐸', 'Vuelan': '🦅', 'Nadan': '🐠', 'Caminan o saltan': '🐇', 'Se arrastran': '🐍',
  // Ecosistemas
  'Selva': '🌴', 'Bosque': '🌲', 'Desierto': '🌵', 'Pastizal': '🌾', 'Mar y arrecifes': '🪸', 'Ríos y lagos': '🏞️', 'Manglares': '🌿',
  'Ajolote': '🦎', 'Vaquita marina': '🐬', 'Quetzal': '🦜', 'Jaguar': '🐆', 'Mariposa monarca': '🦋', 'Tala de árboles': '🪓',
  'Contaminación': '🏭', 'Caza y pesca ilegal': '🎣', 'Cambio climático': '🌡️',
  // Electrónica
  'Un programa gratuito': '💻', 'Circuits': '🔌', 'Simular': '▶️', 'Sin peligro': '🦺', 'Sin gastar': '💰', 'Nuestro taller': '🧰',
  'Pila de 9 V': '🔋', 'Portapilas': '🔋', 'Pila de botón': '🪙', 'Interruptor': '🔘', 'Botón': '🔴', 'Potenciómetro': '🎛️',
  'LED y foco': '💡', 'Zumbador': '🔔', 'Motor': '⚙️', 'Corriente': '〰️', 'Voltaje': '⚡', 'Resistencia': '🟫',
  'Circuito cerrado': '🔁', 'Circuito abierto': '✂️', 'Multímetro': '📟', 'Vista': '👀', 'Tacto': '✋', 'Oído': '👂',
  'Sensor de luz': '🌗', 'Sensor de temperatura': '🌡️', 'Micrófono': '🎤', 'Ultrasónico': '🦇', 'Control remoto': '📺',
  'Detector de humo': '🚨', 'Termostato': '🌡️', 'Alumbrado público': '🏮', 'Puertas automáticas': '🚪', 'Sensor de reversa': '🚗',
  'Huella digital': '☝️', 'Giro de pantalla': '📱', 'Brillo automático': '🔆', 'Ventilador': '🌀', 'Licuadora': '🥤',
  'Lavadora': '🧺', 'Refrigerador': '🧊', 'Robot aspiradora': '🤖', 'Escalera eléctrica': '🛗', 'Carrito a control': '🏎️',
  'Puerta de cochera': '🏠', 'Sensores': '📡', 'Botones': '🔘', 'Arduino': '🖥️', 'Programa': '📝', 'Luz': '💡', 'Movimiento': '🏃',
  'Sonido': '🔊',
  // Física
  'La magnetita': '🪨', 'La primera brújula': '🧭', 'Trenes que flotan': '🚄', 'El calor': '🔥', 'Bocinas': '🔊',
  'Grúas de chatarra': '🏗️', 'Resonancia magnética': '🏥', 'Isaac Newton': '🍎', 'En la Luna': '🌕', 'Las mareas': '🌊',
  'Los astronautas': '👩‍🚀', 'Mexicali': '☀️', 'El Sol': '☀️', 'La Antártida': '🐧', 'El Pico de Orizaba': '🏔️', 'Ollas': '🍲',
  'Termos': '🧴', 'Ropa de lana': '🧶', 'Iglús': '🛖', 'Solar': '🔆', 'Eólica': '🌬️', 'Hidroeléctrica': '💧', 'Petróleo y gas': '🛢️',
  'Carbón': '⚫', 'Cerro Prieto': '♨️', 'Focos LED': '💡', 'Interiores': '🪨', 'La Tierra': '🌍', 'Gigantes': '🪐', 'Anillos': '🪐',
  'Lunas': '🌙', 'Venus': '🟠', 'Plutón': '🌑',
  // IA
  '1943: la primera neurona': '🧠', '1950: Alan Turing': '👨‍🔬', '1956: nace el nombre': '🏷️', 'Ramon Llull': '📜', 'Ajedrez': '♟️',
  'Correo basura': '📧', 'IA particular': '🎯', 'IA general': '🌐', 'IA social': '💬', 'Tu cerebro': '🧠', 'Huellas digitales': '☝️',
  'Lectores de placas': '🚗', 'Las abejas': '🐝', 'Supervisado': '👩‍🏫', 'No supervisado': '🧩', 'Por refuerzo': '🏆',
  'Anti-spam': '🛡️', 'Leer letras': '🔤', 'Muchos datos': '📊', 'Buscadores': '🔎', 'Tiendas en línea': '🛒', 'Traductores': '🌍',
  'La burbuja': '🫧', 'Medicina': '🩺', 'Tutores inteligentes': '📚', 'Cuidar bosques': '🌲', 'Desastres': '🌪️',
  'Semáforos inteligentes': '🚦', 'Fábricas inteligentes': '🏭', 'La nube': '☁️', 'Tu cara es un dato': '🙂', 'Los chats con IA': '💬',
  'Contenido falso': '🎭', 'Noticias falsas': '📰', 'Respuestas inventadas': '❓', 'Para ideas': '💡', 'Verifica': '✅',
  'Ayuda a incluir': '🤝',
  // Programación
  'Televisión': '📺', 'Microondas': '♨️', 'Videojuegos': '🎮', 'Apps': '📱', 'Calculadora': '🧮', 'Semáforos': '🚦', 'Cajero': '🏧',
  'Elevador': '🛗', 'Uno tras otro': '➡️', 'Una sola vez': '1️⃣', 'El orden importa': '🔢', 'Avanzar': '⬆️', 'Girar': '↪️',
  'Recoger': '🖐️', 'Scratch': '🐱', 'Code.org': '💻', 'Tinkercad': '🧱', 'MakeCode': '🧩', 'Arrastrar': '👆', 'Encajar': '🧩',
  'Ejecutar': '▶️', 'Cuadrado': '⬜', 'Observa el modelo': '👀', 'Ponte en su lugar': '🤖', 'Prueba de escritorio': '📝',
  'Explícalo en voz alta': '🗣️', 'Prueba con datos': '🧪', 'El orden': '🔢', 'Las condiciones': '❓', 'Los ciclos': '🔁',
  'La escritura': '✍️',
  // Química
  'El diamante': '💎', 'El plástico': '🧴', 'El vidrio': '🫙', 'El aluminio': '🥫', 'Barro': '🏺', 'Fibras naturales': '🧶',
  'Impermeable': '☔', 'Duro': '🪨', 'Flexible': '🎗️', 'Permeable': '🧽', 'La seda de araña': '🕸️', 'Reciclar': '♻️',
  'El gas de la estufa': '🔥', 'Las burbujas': '🫧', 'El aire pesa': '⚖️', 'El helio': '🎈', 'Oxígeno': '💨', 'Dióxido de carbono': '🌫️',
  'Vapor de agua': '♨️', 'Inflar llantas': '🛞', 'Bucear': '🤿', 'Cocinar': '🍳', 'Volar en globo': '🎈', 'Globos en Teotihuacan': '🎈',
  'Palomitas': '🍿', 'Cambia de color': '🎨', 'Sale gas o humo': '💨', 'Cambia el olor o sabor': '👃', 'Libera luz o calor': '🔥',
  'El pan': '🍞', 'El volcán de bicarbonato': '🌋', 'Tres estados': '🧊', 'El hielo flota': '🧊', 'Puntos clave': '📌',
  'Refrigerar y congelar': '❄️', 'Deshidratar': '🌞', 'Salar y endulzar': '🧂', 'Enlatar y pasteurizar': '🥫',
  'Los pueblos antiguos': '🏺', 'Louis Pasteur': '🔬', 'La miel': '🍯', 'Calentamiento global': '🌡️', 'Contaminación del aire': '🏭',
  'Incendios forestales': '🔥', 'La mayoría de los incendios': '🚒', 'Los árboles': '🌳', 'El extintor': '🧯',
};

/// Imagen de una tarjeta (o null si no tiene una propia).
String? imagenDeTarjeta(String titulo) => imagenesTarjetas[titulo];
