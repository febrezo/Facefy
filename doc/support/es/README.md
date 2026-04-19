# Ayuda en línea

## Sobre la tecnología…

### ¿Facefy utiliza una plataforma en la nube para realizar las búsquedas?

No. Una vez descargado e instalado, todo el trabajo se lleva a cabo en tu equipo. Personalmente, odio el paradigma del Service as a Software Substitute hasta el punto de que intento hacer con mi trabajo _software_ que sea usable de forma independiente por todos.

### ¿Así que nunca se envía ninguna fotografía a ningún proveedor de la nube?

No.

### ¡Eso está bien! Entonces, ¿has escrito un sistema de reconocimiento facial completo?

No. Facefy es una aplicación que incluye las capacidades de tecnologías conocidas como `Dlib` y` face_recognition` utilizando un demonio JSON RPC personalizado y creado ad-hoc en Python 3.6+ (llamado `pyfaces`) y un entorno de escritorio basado en GTK.

### ¿Dónde puedo encontrar imágenes de prueba para probarlo?

Hay una base de datos abierta de caras etiquetadas listas para usar [aquí] (http://vis-www.cs.umass.edu/lfw/).

### ¿Por qué usar Python para JSON RPC?

Porque "face_recognition" está escrito en Python y tengo soltura con el lenguaje de programación.

### ¿Y por qué no usar Python para la GUI?

Porque me gusta Vala para crear aplicaciones de escritorio en los entornos de escritorio que uso, principalmente elementary OS y otros sistemas operativos basados ​​en Gnome.

### ¡Pero vamos! ¡Casi nadie conoce a Vala!

Nadie impide escribir tu propia GUI sobre `pyfaces` o sobre` face_recognition`.

### Me he dado cuenta de que `pyfaces` usa el sistema de archivos para almacenar los detalles. ¡Eso es bastante lento!

Es verdad. Pero actualmente no necesito algo más complejo para que funcione. De todos modos, el _backoffice_ puede usar MongoDB o SQLite para almacenar la información. Si se mantiene la compatibilidad con el cliente del servidor JSON RPC utilizado en Vala, es muy posible que esto no sea un trabajo difícil.

## Acerca de la ética…

### Entonces, ¿cuál es el objetivo si la mayor parte del código central no es tuyo?

Tan simple como hacer que el reconocimiento facial esté disponible para cualquiera que use un par de comandos usando una rutina de empaquetado lista para usar. Por lo tanto, podemos crear conciencia sobre el estado de la tecnología para cualquier persona, incluso cuando se utilizan los motores de reconocimiento facial disponibles.

### Pero, si quieres crear conciencia, ¿hacer público el código fuente no permitiría que las personas malas hagan cosas malas con él?

Ese es un punto, pero esta es una forma de hacer que la gente sea consciente de lo cerca que está esta tecnología de nosotros. No es el futuro sino el presente.

### He oído algo de que los sistemas de reconocimiento facial tienen cierto sesgo racial. ¡No me gusta implicarme con la tecnología de esta manera!

Tienes razón. La tecnología tiene algunas problemas y se ha observado que los modelos actuales funcionan mejor con personas de algunos grupos étnicos. En el caso de `face_recognition` se explica el porqué [aquí](https://github.com/ageitgey/face_recognition/wiki/Face-Recognition-Accuracy-Problems#question-face-recognition-works-well-with-european-individuals-but-overall-accuracy-is-lower-with-asian-individuals) y está asociado al conjunto de datos utilizado para entrenar los modelos.  

## Acerca de cómo se distribuye ...

### ¿Por qué Flatpak y no Snap?

Porque ambos comparten enfoques de aislamiento de aplicaciones y se pueden ejecutar en sistemas GNU/Linux, pero Flatpak no está vinculado a un repositorio concreto como lo hace Canonical con Snap Store. Vea problemas similares a los de las tiendas centralizadas que ya han implicado a algunos videojuegos como [Fortnite](https://www.youtube.com/watch?v=85Q3D-qIwVw).

### ¿Esta aplicación estará disponible para sistemas Windows?

De ningún modo.

### ¿Por qué?

Porque requiere mucho trabajo mantener las versiones de múltiples sistemas operativos y hacer que las cosas se compilen de forma cruzada.

### Pero soy usuario de Windows y me gustaría ejecutar la aplicación. ¿Qué puedo hacer?

Puedes ejecutarlo en un entorno virtualizado utilizando VirtualBox o un software similar si la eficiencia no es un problema para tí. La comunidad GNU/Linux te ayudará en tu tránsito a entornos de escritorio y plataformas bonitas y flexibles. Si tu principal razón para permanecer en Windows es la compatibilidad con Microsoft Office, plantéate si esto es una mera coincidencia.

### ¿Y para usuarios de MacOS?

El mismo problema. Las mismas respuestas.

### ¿Y qué hay de hacerlo móvil? ¡Sería genial!

De hecho, puede ser móvil usando teléfonos basados ​​en GNU/Linux. Muchos proyectos están trabajando en ello ya como [Pinepphone de Pine64](https://www.pine64.org/pinephone/) y [Librem 5 de Purism](https://puri.sm/products/librem-5/). Dales una oportunidad.

### Entonces, tengo una solicitud para una nueva funcionalidad. ¿Dónde puedo proponerlo?

¡Eso es genial! Abra un nuevo _issue_ en la [página del proyecto de Github](https://github.com/febrezo/Facefy).

### ¿Cuánto tiempo llevará incluirlo?

Depende de si hay alguien que quiera dedicarle tiempo. Pero para ser claros: no esperes que nadie programe gratis para ti si no necesita la función en absoluto.
