#include "lets_split.h"
#include "action_layer.h"
#include "eeconfig.h"

#define CAPTURE LGUI(LSFT(LCTL(KC_4)))
#define PREV_TAB LGUI(LSFT(KC_LBRC))
#define NEXT_TAB LGUI(LSFT(KC_RBRC))
#define PREV_PANE LGUI(KC_LBRC)
#define NEXT_PANE LGUI(KC_RBRC)
#define CMD_EISU MT(MOD_LGUI,KC_LANG2)
#define CMD_KANA MT(MOD_RGUI,KC_LANG1)
#define NEXT_WORD LALT(KC_RIGHT)
#define PREV_WORD LALT(KC_LEFT)
#define NEXT_WIN LGUI(KC_GRAVE)
#define ELLIPSIS LALT(KC_SCLN)
#define SANDS SFT_T(KC_SPC)
#define CTL_ESC MT(MOD_LCTL,KC_ESC)

extern keymap_config_t keymap_config;

#define _QWERTY 0
#define _LOWER 1
#define _RAISE 2
#define _ADJUST 16

enum custom_keycodes {
  QWERTY = SAFE_RANGE,
  LOWER,
  RAISE,
  ADJUST,
};

#define _______ KC_TRNS
#define XXXXXXX KC_NO

const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {

[_QWERTY] = KEYMAP( \
  KC_TAB,  KC_Q,    KC_W,    KC_E,     KC_R,  KC_T,  KC_Y,   KC_U,  KC_I,     KC_O,    KC_P,    KC_BSPC, \
  CTL_ESC, KC_A,    KC_S,    KC_D,     KC_F,  KC_G,  KC_H,   KC_J,  KC_K,     KC_L,    KC_SCLN, KC_ENT, \
  KC_LSFT, KC_Z,    KC_X,    KC_C,     KC_V,  KC_B,  KC_N,   KC_M,  KC_COMM,  KC_DOT,  KC_SLSH, KC_QUOT , \
  RAISE,   KC_LCTL, KC_LALT, CMD_EISU, LOWER, SANDS, KC_SPC, RAISE, CMD_KANA, KC_DOWN, KC_UP,   KC_RGHT \
),

[_LOWER] = KEYMAP( \
  KC_GRV,  _______, _______, _______, ELLIPSIS, KC_SLSH, KC_BSLS, KC_LBRC, KC_RBRC, KC_LCBR, KC_RCBR, _______, \
  _______, KC_EXLM, KC_AT,   KC_HASH, KC_DLR,   KC_PERC, KC_CIRC, KC_AMPR, KC_ASTR, KC_LPRN, KC_RPRN, _______, \
  _______, _______, _______, KC_DQT,  KC_UNDS,  KC_GRV,  KC_QUOT, KC_MINS, KC_PLUS, KC_EQL,  _______, _______, \
  _______, _______, _______, _______, _______,  _______, _______, _______, _______, _______, _______, _______ \
),

[_RAISE] = KEYMAP( \
  KC_GRV,  _______, _______, KC_UP,   _______,  KC_F5,   _______, KC_P7,   KC_P8,   KC_P9,   _______, _______, \
  _______, _______, KC_LEFT, KC_DOWN, KC_RIGHT, _______, KC_PDOT, KC_P4,   KC_P5,   KC_P6,   _______, _______, \
  _______, _______, _______, _______, _______,  _______, KC_P0,   KC_P1,   KC_P2,   KC_P3,   _______, _______, \
  _______, _______, _______, _______, _______,  _______, _______, _______, _______, _______, _______, _______ \
),

[_ADJUST] = KEYMAP( \
  KC_GRV,  _______, _______, KC_WH_D,     _______,   _______,   _______,   KC_BTN1, KC_MS_U,  KC_BTN2, RGB_HUI, RGB_HUD, \
  _______, _______, KC_WH_R, KC_WH_U,     KC_WH_L,   PREV_TAB,  NEXT_TAB,  KC_MS_L, KC_MS_D,  KC_MS_R, RGB_SAI, RGB_SAD, \
  _______, RESET,   _______, KC__VOLDOWN, KC__VOLUP, PREV_PANE, NEXT_PANE, RGB_M_P, RGB_M_SW, RGB_M_X, RGB_VAI, RGB_VAD, \
  _______, _______, _______, _______,     _______,   CAPTURE,   NEXT_WIN,  _______, _______,  _______, _______, RGB_TOG \
)

};

#ifdef AUDIO_ENABLE
float tone_qwerty[][2] = SONG(QWERTY_SOUND);
#endif

void persistent_default_layer_set(uint16_t default_layer) {
  eeconfig_update_default_layer(default_layer);
  default_layer_set(default_layer);
}

bool process_record_user(uint16_t keycode, keyrecord_t *record) {
  switch (keycode) {
    case QWERTY:
      if (record->event.pressed) {
        #ifdef AUDIO_ENABLE
          PLAY_SONG(tone_qwerty);
        #endif
        persistent_default_layer_set(1UL<<_QWERTY);
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
    case ADJUST:
      if (record->event.pressed) {
        layer_on(_ADJUST);
      } else {
        layer_off(_ADJUST);
      }
      return false;
      break;
  }
  return true;
}
