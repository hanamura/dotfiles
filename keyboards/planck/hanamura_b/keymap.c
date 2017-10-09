#include "planck.h"
#include "action_layer.h"

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

extern keymap_config_t keymap_config;

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
  {KC_TAB,  KC_Q,     KC_W,    KC_E,     KC_R,  KC_T,   KC_Y,   KC_U,  KC_I,     KC_O,    KC_P,    KC_BSPC},
  {KC_LCTL, KC_A,     KC_S,    KC_D,     KC_F,  KC_G,   KC_H,   KC_J,  KC_K,     KC_L,    KC_SCLN, KC_ENT},
  {KC_LSFT, KC_Z,     KC_X,    KC_C,     KC_V,  KC_B,   KC_N,   KC_M,  KC_COMM,  KC_DOT,  KC_SLSH, KC_QUOT},
  {RAISE,   KC_LCTL,  KC_LALT, CMD_EISU, LOWER, KC_SPC, KC_SPC, RAISE, CMD_KANA, KC_RALT, KC_RCTL, KC_LEAD}
},

[_LOWER] = {
  {KC_ESC,  _______, _______, _______, _______, KC_SLASH, KC_BSLS, KC_LBRC, KC_RBRC, KC_LCBR, KC_RCBR, _______},
  {_______, KC_EXLM, KC_AT,   KC_HASH, KC_DLR,  KC_PERC,  KC_CIRC, KC_AMPR, KC_ASTR, KC_LPRN, KC_RPRN, _______},
  {_______, _______, _______, _______, _______, KC_GRAVE, KC_QUOT, KC_MINS, KC_PLUS, KC_EQL,  _______, _______},
  {_______, _______, _______, _______, _______, _______,  _______, _______, _______, _______, _______, _______}
},

[_RAISE] = {
  {KC_ESC,  _______, _______, KC_UP,   _______,  KC_F5,   KC_PSLS, KC_P7,   KC_P8,   KC_P9,   KC_P0,   _______},
  {_______, _______, KC_LEFT, KC_DOWN, KC_RIGHT, _______, KC_PAST, KC_P4,   KC_P5,   KC_P6,   KC_PDOT, _______},
  {_______, _______, _______, _______, _______,  _______, KC_PMNS, KC_P1,   KC_P2,   KC_P3,   KC_PEQL, _______},
  {_______, _______, _______, _______, _______,  _______, KC_PPLS, _______, _______, _______, _______, _______}
},

[_ADJUST] = {
  {KC_ESC,  _______, _______, KC_WH_D,     _______,   _______,   _______,   KC_BTN1, KC_MS_U, KC_BTN2, _______, _______},
  {_______, _______, KC_WH_R, KC_WH_U,     KC_WH_L,   PREV_TAB,  NEXT_TAB,  KC_MS_L, KC_MS_D, KC_MS_R, _______, _______},
  {_______, RESET,   _______, KC__VOLDOWN, KC__VOLUP, PREV_PANE, NEXT_PANE, _______, _______, _______, _______, _______},
  {_______, _______, _______, _______,     _______,   CAPTURE,   NEXT_WIN,  _______, _______, _______, _______, _______}
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

LEADER_EXTERNS();

void matrix_scan_user(void) {
  LEADER_DICTIONARY() {
    leading = false;
    leader_end();

    // window alignment with divvy

    // expand
    SEQ_ONE_KEY(KC_D) {
      register_code(KC_LGUI);
      register_code(KC_LALT);
      register_code(KC_LCTL);
      register_code(KC_ENT);
      unregister_code(KC_ENT);
      unregister_code(KC_LCTL);
      unregister_code(KC_LALT);
      unregister_code(KC_LGUI);

      register_code(KC_LGUI);
      register_code(KC_LALT);
      register_code(KC_LCTL);
      register_code(KC_D);
      unregister_code(KC_D);
      unregister_code(KC_LCTL);
      unregister_code(KC_LALT);
      unregister_code(KC_LGUI);
    }

    // left
    SEQ_ONE_KEY(KC_S) {
      register_code(KC_LGUI);
      register_code(KC_LALT);
      register_code(KC_LCTL);
      register_code(KC_ENT);
      unregister_code(KC_ENT);
      unregister_code(KC_LCTL);
      unregister_code(KC_LALT);
      unregister_code(KC_LGUI);

      register_code(KC_LGUI);
      register_code(KC_LALT);
      register_code(KC_LCTL);
      register_code(KC_S);
      unregister_code(KC_S);
      unregister_code(KC_LCTL);
      unregister_code(KC_LALT);
      unregister_code(KC_LGUI);
    }

    // right
    SEQ_ONE_KEY(KC_F) {
      register_code(KC_LGUI);
      register_code(KC_LALT);
      register_code(KC_LCTL);
      register_code(KC_ENT);
      unregister_code(KC_ENT);
      unregister_code(KC_LCTL);
      unregister_code(KC_LALT);
      unregister_code(KC_LGUI);

      register_code(KC_LGUI);
      register_code(KC_LALT);
      register_code(KC_LCTL);
      register_code(KC_F);
      unregister_code(KC_F);
      unregister_code(KC_LCTL);
      unregister_code(KC_LALT);
      unregister_code(KC_LGUI);
    }

    // top
    SEQ_ONE_KEY(KC_E) {
      register_code(KC_LGUI);
      register_code(KC_LALT);
      register_code(KC_LCTL);
      register_code(KC_ENT);
      unregister_code(KC_ENT);
      unregister_code(KC_LCTL);
      unregister_code(KC_LALT);
      unregister_code(KC_LGUI);

      register_code(KC_LGUI);
      register_code(KC_LALT);
      register_code(KC_LCTL);
      register_code(KC_E);
      unregister_code(KC_E);
      unregister_code(KC_LCTL);
      unregister_code(KC_LALT);
      unregister_code(KC_LGUI);
    }

    // bottom
    SEQ_ONE_KEY(KC_C) {
      register_code(KC_LGUI);
      register_code(KC_LALT);
      register_code(KC_LCTL);
      register_code(KC_ENT);
      unregister_code(KC_ENT);
      unregister_code(KC_LCTL);
      unregister_code(KC_LALT);
      unregister_code(KC_LGUI);

      register_code(KC_LGUI);
      register_code(KC_LALT);
      register_code(KC_LCTL);
      register_code(KC_C);
      unregister_code(KC_C);
      unregister_code(KC_LCTL);
      unregister_code(KC_LALT);
      unregister_code(KC_LGUI);
    }

    // top left
    SEQ_ONE_KEY(KC_W) {
      register_code(KC_LGUI);
      register_code(KC_LALT);
      register_code(KC_LCTL);
      register_code(KC_ENT);
      unregister_code(KC_ENT);
      unregister_code(KC_LCTL);
      unregister_code(KC_LALT);
      unregister_code(KC_LGUI);

      register_code(KC_LGUI);
      register_code(KC_LALT);
      register_code(KC_LCTL);
      register_code(KC_W);
      unregister_code(KC_W);
      unregister_code(KC_LCTL);
      unregister_code(KC_LALT);
      unregister_code(KC_LGUI);
    }

    // top right
    SEQ_ONE_KEY(KC_R) {
      register_code(KC_LGUI);
      register_code(KC_LALT);
      register_code(KC_LCTL);
      register_code(KC_ENT);
      unregister_code(KC_ENT);
      unregister_code(KC_LCTL);
      unregister_code(KC_LALT);
      unregister_code(KC_LGUI);

      register_code(KC_LGUI);
      register_code(KC_LALT);
      register_code(KC_LCTL);
      register_code(KC_R);
      unregister_code(KC_R);
      unregister_code(KC_LCTL);
      unregister_code(KC_LALT);
      unregister_code(KC_LGUI);
    }

    // bottom left
    SEQ_ONE_KEY(KC_X) {
      register_code(KC_LGUI);
      register_code(KC_LALT);
      register_code(KC_LCTL);
      register_code(KC_ENT);
      unregister_code(KC_ENT);
      unregister_code(KC_LCTL);
      unregister_code(KC_LALT);
      unregister_code(KC_LGUI);

      register_code(KC_LGUI);
      register_code(KC_LALT);
      register_code(KC_LCTL);
      register_code(KC_X);
      unregister_code(KC_X);
      unregister_code(KC_LCTL);
      unregister_code(KC_LALT);
      unregister_code(KC_LGUI);
    }

    // bottom right
    SEQ_ONE_KEY(KC_V) {
      register_code(KC_LGUI);
      register_code(KC_LALT);
      register_code(KC_LCTL);
      register_code(KC_ENT);
      unregister_code(KC_ENT);
      unregister_code(KC_LCTL);
      unregister_code(KC_LALT);
      unregister_code(KC_LGUI);

      register_code(KC_LGUI);
      register_code(KC_LALT);
      register_code(KC_LCTL);
      register_code(KC_V);
      unregister_code(KC_V);
      unregister_code(KC_LCTL);
      unregister_code(KC_LALT);
      unregister_code(KC_LGUI);
    }
  }
}
