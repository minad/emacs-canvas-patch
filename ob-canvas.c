#include <emacs-module.h>
#include <math.h>

int plugin_is_GPL_compatible;

static uint32_t f(float x, float y, float t) {
    float r;
    float g;
    float b;
    EXP
    if (r < 0) r = 0;
    if (g < 0) g = 0;
    if (b < 0) b = 0;
    if (r > 1) r = 1;
    if (g > 1) g = 1;
    if (b > 1) b = 1;
    return ((uint32_t)(r * 255) << 16) |
        ((uint32_t)(g * 255) << 8) |
        (uint32_t)(b * 255);
}

static emacs_value render(emacs_env* env, ptrdiff_t nargs,
                          emacs_value args[], void* data) {
    uint32_t* pixel = env->canvas_pixel(env, args[0]);
    float time = env->extract_float(env, args[1]);
    if (pixel) {
        for (int y = 0; y < 300; ++y)
            for (int x = 0; x < 300; ++x)
                pixel[y * 300 + x] = f(x/300.0-0.5, y/300.0-0.5, time);
        env->canvas_refresh(env, args[0]);
    }
    return env->intern(env, "nil");
}

int emacs_module_init(struct emacs_runtime *rt) {
    if ((size_t)rt->size < sizeof (*rt))
        return 1;
    emacs_env* env = rt->get_environment(rt);
    if ((size_t)env->size < sizeof (*env))
        return 2;
    env->funcall(env, env->intern(env, "defalias"), 2,
                 (emacs_value[]){
                     env->intern(env, "ob-canvas-render"),
                     env->make_function(env, 2, 2, render, 0, 0)
                 });
    return 0;
}
