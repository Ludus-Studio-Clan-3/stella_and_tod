shader_type canvas_item;

// TEXTURE DE BRUIT
uniform sampler2D noise_texture : repeat_enable, filter_linear;

// CONTROLES PRINCIPAUX
uniform float density : hint_range(0.0, 5.0) = 0.0;      // Opacité globale
uniform float intensity : hint_range(0.5, 5.0) = 1.8;    // Contraste / densité visuelle
uniform float base_fog : hint_range(0.0, 1.0) = 0.2;     // Brouillard minimum

// ANIMATION DU FOG
uniform vec2 speed = vec2(0.02, 0.01);


// ======================
//     FRAGMENT SHADER
// ======================
void fragment() {

    // MOUVEMENT DU FOG
    vec2 uv = UV + speed * TIME;

    // SAMPLE DU NOISE
    float noise = texture(noise_texture, uv).r;

    // TRANSFORMATION DU NOISE
    float fog = clamp(base_fog + (noise * 2.0 - 1.0) * intensity, 0.0, 1.0);

    // APPLICATION DU FOG
    COLOR.a *= fog * density;
}
