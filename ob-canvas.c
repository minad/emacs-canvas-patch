#include <emacs-module.h>
#include <math.h>

int plugin_is_GPL_compatible;
static int t = 0;

static uint32_t f(int x, int y, int t) {
    return (EXP);
}

static emacs_value render(emacs_env* env, ptrdiff_t nargs,
                          emacs_value args[], void* data) {
    uint32_t* pixel = env->canvas_pixel(env, args[0]);
    if (pixel) {
        for (int y = 0; y < 300; ++y)
            for (int x = 0; x < 300; ++x)
                pixel[y * 300 + x] = f(x, y, t);
        env->canvas_refresh(env, args[0]);
        ++t;
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
                     env->make_function(env, 1, 1, render, 0, 0)
                 });
    return 0;
}
