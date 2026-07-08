#include <emacs-module.h>
#include <string.h>

static const int width = 400, height = 300;
static emacs_value Qnil;
int plugin_is_GPL_compatible;

#define min(x, y) ((x) < (y) ? (x) : (y))
#define max(x, y) ((x) > (y) ? (x) : (y))

static emacs_value render(emacs_env* env, ptrdiff_t nargs,
                          emacs_value args[], void* data) {
    emacs_value canvas = args[0];
    int tick = env->extract_integer(env, args[1]);
    uint32_t* pixel = env->canvas_data(env, canvas);
    if (pixel) {
        if (!tick)
            memset(pixel, 255, 4 * width * height);
        int y = tick % height;
        for (int x = 0; x < width; ++x) {
            pixel[(y * width) + x] = (tick % 4) == 0 ? 0xFF0000
                : (tick % 4) == 1 ? 0x00FF00
                : (tick % 4) == 2 ? 0x0000FF
                : 0xFFDD00;
        }
    }
    return Qnil;
}

int emacs_module_init(struct emacs_runtime *rt) {
    if ((size_t)rt->size < sizeof (*rt))
        return 1;
    emacs_env* env = rt->get_environment(rt);
    if ((size_t)env->size < sizeof (*env))
        return 2;
    Qnil = env->make_global_ref(env, env->intern(env, "nil"));
    env->funcall(env, env->intern(env, "defalias"), 2,
                 (emacs_value[]){
                     env->intern(env, "canvas-demo-render"),
                     env->make_function(env, 2, 2, render, 0, 0)
                 });
    return 0;
}
