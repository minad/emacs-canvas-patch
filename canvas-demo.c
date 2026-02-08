#include <emacs-module.h>
#include <string.h>

static const int width = 400, height = 300;
static int last_x = width / 2, last_y = height / 2, dir = 0;
static emacs_value Qnil;
int plugin_is_GPL_compatible;

#define min(x, y) ((x) < (y) ? (x) : (y))
#define max(x, y) ((x) > (y) ? (x) : (y))

static emacs_value render(emacs_env* env, ptrdiff_t nargs,
                          emacs_value args[], void* data) {
    emacs_value canvas = args[0];
    int tick = env->extract_integer(env, args[1]);
    uint32_t* pixel = env->canvas_pixel(env, canvas);
    if (pixel) {
        if (!tick) {
            memset(pixel, 255, 4 * width * height);
            last_x = width / 2, last_y = height / 2;
        }
        int next_x = last_x, next_y = last_y;
        switch (dir) {
        case 0:  next_y -= 2 * tick; break;
        case 1:  next_x -= 2 * tick; break;
        case 2:  next_y += 2 * tick; break;
        default: next_x += 2 * tick; break;
        }
        for (int y = min(last_y, next_y); y <= max(last_y, next_y); ++y) {
            for (int x = min(last_x, next_x); x <= max(last_x, next_x); ++x) {
                if (y >= 0 && y < height && x >= 0 && x < width) {
                    pixel[(y * width) + x] = dir == 0 ? 0xFF0000
                        : dir == 1 ? 0x00FF00
                        : dir == 2 ? 0x0000FF
                        : 0xFFDD00;
                }
            }
        }
        last_x = next_x, last_y = next_y, dir = (dir + 1) & 3;
        env->canvas_refresh(env, canvas);
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
