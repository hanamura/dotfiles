#include "planck.h"
#include "action_layer.h"

#define CAPTURE LGUI(LSFT(LCTL(KC_4)))
#define PREV_TAB LGUI(LSFT(KC_LBRC))
#define NEXT_TAB LGUI(LSFT(KC_RBRC))
#define PREV_PANE LGUI(KC_LBRC)
#define NEXT_PANE LGUI(KC_RBRC)
#define CMD_EISU MT(MOD_LGUI,KC_LANG2)
#define CMD_KANA MT(MOD_RGUI,KC_LANG1)
#define NEXT_WIN LGUI(KC_GRV)
#define ELLIPSIS LALT(KC_SCLN)
#define CTL_ESC MT(MOD_LCTL,KC_ESC)
#define TRU_DQT LALT(KC_LBRC)
#define TRU_QT LALT(KC_RBRC)
#define NUMPAD_A LT(_NUMPAD,KC_A)

extern keymap_config_t keymap_config;

enum planck_layers {
  _QWERTY,
  _LOWER,
  _RAISE,
  _NUMPAD,
  _ADJUST
};

enum planck_keycodes {
  QWERTY = SAFE_RANGE,
  LOWER,
  RAISE,
  NUMPAD
};

const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {

[_QWERTY] = {
  {KC_TAB,  KC_Q,     KC_W,    KC_E,     KC_R,  KC_T,    KC_Y,   KC_U,  KC_I,     KC_O,    KC_P,    KC_BSPC},
  {CTL_ESC, NUMPAD_A, KC_S,    KC_D,     KC_F,  KC_G,    KC_H,   KC_J,  KC_K,     KC_L,    KC_SCLN, KC_ENT},
  {KC_LSFT, KC_Z,     KC_X,    KC_C,     KC_V,  KC_B,    KC_N,   KC_M,  KC_COMM,  KC_DOT,  KC_SLSH, KC_RSFT},
  {XXXXXXX, KC_LCTL,  KC_LALT, CMD_EISU, LOWER, KC_LSFT, KC_SPC, RAISE, CMD_KANA, XXXXXXX, XXXXXXX, XXXXXXX}
},

[_LOWER] = {
  {KC_GRV,  KC_EXLM, KC_AT,   KC_HASH, KC_DLR,  KC_PERC, KC_CIRC, KC_AMPR,  KC_ASTR, KC_LPRN, KC_RPRN, KC_BSLS},
  {_______, KC_TILD, KC_GRV,  KC_DQT,  KC_QUOT, KC_UNDS, KC_MINS, _______,  _______, KC_LBRC, KC_RBRC, _______},
  {_______, _______, _______, TRU_DQT, TRU_QT,  KC_PLUS, KC_EQL,  ELLIPSIS, KC_PIPE, KC_LCBR, KC_RCBR, _______},
  {_______, _______, _______, _______, _______, _______, _______, _______,  _______, _______, _______, _______}
},

[_RAISE] = {
  {KC_GRV,  KC_EXLM, KC_AT,   KC_HASH, KC_DLR,  KC_PERC, KC_CIRC, KC_AMPR,  KC_ASTR, KC_LPRN, KC_RPRN, KC_BSLS},
  {_______, KC_TILD, KC_GRV,  KC_DQT,  KC_QUOT, KC_UNDS, KC_MINS, _______,  _______, KC_LBRC, KC_RBRC, _______},
  {_______, _______, _______, TRU_DQT, TRU_QT,  KC_PLUS, KC_EQL,  ELLIPSIS, KC_PIPE, KC_LCBR, KC_RCBR, _______},
  {_______, _______, _______, _______, _______, _______, _______, _______,  _______, _______, _______, _______}
},

[_NUMPAD] = {
  {_______, _______, _______, KC_UP,   _______, _______, _______, KC_P7,   KC_P8, KC_P9,   KC_PSLS, _______},
  {_______, _______, KC_LEFT, KC_DOWN, KC_RGHT, _______, KC_PMNS, KC_P4,   KC_P5, KC_P6,   KC_PAST, _______},
  {_______, _______, _______, _______, _______, _______, KC_PEQL, KC_P1,   KC_P2, KC_P3,   KC_PPLS, _______},
  {_______, _______, _______, _______, _______, _______, _______, _______, KC_P0, KC_PDOT, KC_PCMM, _______}
},

[_ADJUST] = {
  {_______, _______, _______, KC_WH_D,     _______,   _______,   _______,   KC_BTN1, KC_MS_U,  KC_BTN2, _______, _______},
  {_______, _______, KC_WH_R, KC_WH_U,     KC_WH_L,   PREV_TAB,  NEXT_TAB,  KC_MS_L, KC_MS_D,  KC_MS_R, _______, _______},
  {_______, RESET,   _______, KC__VOLDOWN, KC__VOLUP, PREV_PANE, NEXT_PANE, RGB_M_P, RGB_M_SW, RGB_M_X, _______, _______},
  {_______, _______, _______, _______,     _______,   CAPTURE,   NEXT_WIN,  _______, _______,  _______, _______, _______}
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
  }
  return true;
}
