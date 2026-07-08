#include <emacs-module.h>
#include <string.h>

static const int width = 400, height = 300;
static int last_x = width / 2, last_y = height / 2, dir = 0, tick = 0;
static emacs_value Qnil;
int plugin_is_GPL_compatible;

#define min(x, y) ((x) < (y) ? (x) : (y))
#define max(x, y) ((x) > (y) ? (x) : (y))

static emacs_value render(emacs_env* env, ptrdiff_t nargs,
                          emacs_value args[], void* data) {
    emacs_value canvas1 = args[0], canvas2 = args[1];
    uint32_t* pixel1 = env->canvas_data(env, canvas1);
    uint32_t* pixel2 = env->canvas_data(env, canvas2);
    if (pixel1 && pixel2) {
        if (tick >= height) {
            tick = 0;
            memset(pixel1, 255, 4 * width * height);
            memset(pixel2, 255, 4 * width * height);
            last_x = width / 2, last_y = height / 2;
        } else {
            ++tick;
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
                    pixel1[(y * width) + x] = dir == 0 ? 0xFF0000
                        : dir == 1 ? 0x00FF00
                        : dir == 2 ? 0x0000FF
                        : 0xFFDD00;
                    pixel2[(y * width) + x] = dir == 0 ? 0x00FF00
                        : dir == 1 ? 0x0000FF
                        : dir == 2 ? 0xFFDD00
                        : 0xFF0000;
                }
            }
        }
        last_x = next_x, last_y = next_y, dir = (dir + 1) & 3;
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
