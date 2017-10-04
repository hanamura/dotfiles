#include "planck.h"
#include "action_layer.h"

extern keymap_config_t keymap_config;

#define CAPTURE LGUI(LSFT(LCTL(KC_4)))
#define PREV_TAB LGUI(LSFT(KC_LBRC))
#define NEXT_TAB LGUI(LSFT(KC_RBRC))
#define PREV_PANE LGUI(KC_LBRC)
#define NEXT_PANE LGUI(KC_RBRC)
#define CMD_EISU MT(MOD_LGUI,KC_LANG2)
#define CMD_KANA MT(MOD_RGUI,KC_LANG1)
#define NEXT_WORD LALT(KC_RIGHT)
#define PREV_WORD LALT(KC_LEFT)

enum planck_layers {
  _QWERTY,
  _LOWER,
  _RAISE,
  _ADJUST
};

enum planck_keycodes {
  QWERTY = SAFE_RANGE,
  COLEMAK,
  DVORAK,
  PLOVER,
  LOWER,
  RAISE,
  BACKLIT
};

const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {

[_QWERTY] = {
  {KC_TAB,  KC_Q,    KC_W,    KC_E,     KC_R,  KC_T,   KC_Y,   KC_U,  KC_I,     KC_O,    KC_P,    KC_BSPC},
  {KC_LCTL, KC_A,    KC_S,    KC_D,     KC_F,  KC_G,   KC_H,   KC_J,  KC_K,     KC_L,    KC_SCLN, KC_ENT},
  {KC_LSFT, KC_Z,    KC_X,    KC_C,     KC_V,  KC_B,   KC_N,   KC_M,  KC_COMM,  KC_DOT,  KC_SLSH, KC_QUOT},
  {BACKLIT, KC_LCTL, KC_LALT, CMD_EISU, LOWER, KC_SPC, KC_SPC, RAISE, CMD_KANA, KC_RALT, KC_RCTL, _______}
},

[_LOWER] = {
  {KC_ESC,  _______, KC_AMPR, KC_ASTR, _______, KC_SLASH, KC_BSLS, KC_KP_7, KC_KP_8, KC_KP_9,   _______, _______},
  {_______, _______, KC_DLR,  KC_PERC, KC_CIRC, KC_MINS,  KC_EQL,  KC_KP_4, KC_KP_5, KC_KP_6,   _______, _______},
  {_______, _______, KC_EXLM, KC_AT,   KC_HASH, KC_GRAVE, KC_QUOT, KC_KP_1, KC_KP_2, KC_KP_3,   _______, _______},
  {_______, _______, _______, _______, _______, _______, _______, _______,  KC_KP_0, KC_KP_DOT, _______, _______}
},

[_RAISE] = {
  {KC_ESC,  _______,   _______, KC_UP,   _______,  KC_F5,     _______, KC_LPRN, KC_RPRN, _______, _______, _______},
  {_______, PREV_WORD, KC_LEFT, KC_DOWN, KC_RIGHT, NEXT_WORD, _______, KC_LBRC, KC_RBRC, _______, _______, _______},
  {_______, _______,   _______, _______, _______,  _______,   _______, KC_LT,   KC_GT,   _______, _______, _______},
  {_______, _______,   _______, _______, _______,  _______,   _______, _______, _______, _______, _______, _______}
},

[_ADJUST] = {
  {KC_ESC,  _______, KC_BTN1, KC_MS_U,     KC_BTN2,   _______,   _______,   _______, KC_WH_D, _______, _______, _______},
  {_______, _______, KC_MS_L, KC_MS_D,     KC_MS_R,   PREV_TAB,  NEXT_TAB,  KC_WH_R, KC_WH_U, KC_WH_L, _______, _______},
  {_______, RESET,   _______, KC__VOLDOWN, KC__VOLUP, PREV_PANE, NEXT_PANE, _______, _______, _______, _______, _______},
  {_______, _______, _______, _______,     _______,   CAPTURE,   _______,   _______, _______, _______, _______, _______}
}

};

#ifdef AUDIO_ENABLE
  float plover_song[][2]     = SONG(PLOVER_SOUND);
  float plover_gb_song[][2]  = SONG(PLOVER_GOODBYE_SOUND);
#endif

bool process_record_user(uint16_t keycode, keyrecord_t *record) {
  switch (keycode) {
    case QWERTY:
      if (record->event.pressed) {
        print("mode just switched to qwerty and this is a huge string\n");
        set_single_persistent_default_layer(_QWERTY);
      }
      return false;
      break;
    case LOWER:
      if (record->event.pressed) {
        layer_on(_LOWER);
        update_tri_layer(_LOWER, _RAISE, _ADJUST);
      } else {
        layer_off(_LOWER);
        update_tri_layer(_LOWER, _RAISE, _ADJUST);
      }
      return false;
      break;
    case RAISE:
      if (record->event.pressed) {
        layer_on(_RAISE);
        update_tri_layer(_LOWER, _RAISE, _ADJUST);
      } else {
        layer_off(_RAISE);
        update_tri_layer(_LOWER, _RAISE, _ADJUST);
      }
      return false;
      break;
    case BACKLIT:
      if (record->event.pressed) {
        register_code(KC_RSFT);
        #ifdef BACKLIGHT_ENABLE
          backlight_step();
        #endif
      } else {
        unregister_code(KC_RSFT);
      }
      return false;
      break;
  }
  return true;
}
