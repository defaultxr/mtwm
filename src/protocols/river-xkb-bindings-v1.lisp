;;;; river-xkb-bindings-v1.lisp - Auto-generated binding for River's "river-xkb-bindings-v1" protocol.

(UIOP/PACKAGE:DEFINE-PACKAGE "MTWM.RIVER-XKB-BINDINGS-V1"
                             (:USE #:CL
                              #:COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE
                              "MTWM.RIVER-WINDOW-MANAGEMENT-V1"))

(in-package #:MTWM.RIVER-XKB-BINDINGS-V1)

(PROGN
 "
    This protocol allows the river-window-management-v1 window manager to
    define key bindings in terms of xkbcommon keysyms and other configurable
    properties.

    The key words \"must\", \"must not\", \"required\", \"shall\", \"shall not\",
    \"should\", \"should not\", \"recommended\", \"may\", and \"optional\" in this
    document are to be interpreted as described in IETF RFC 2119.
  "
 (PROGN
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-INTERFACE
   "river_xkb_bindings_v1" :EXPORT T :DESCRIPTION "
      This global interface should only be advertised to the client if the
      river_window_manager_v1 global is also advertised.
    ")
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-ENUM ("river_xkb_bindings_v1"
                                                           "error" :DESCRIPTION
                                                           NIL :BITFIELD-P NIL
                                                           :EXPORT T)
    (:OBJECT-ALREADY-CREATED 0 NIL))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-REQUEST ("river_xkb_bindings_v1"
                                                              "destroy" :OPCODE
                                                              0 :DESCRIPTION "
        This request indicates that the client will no longer use the
        river_xkb_bindings_v1 object.
      "
                                                              :DESTRUCTOR-P T
                                                              :SINCE NIL
                                                              :EXPORT T))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-REQUEST ("river_xkb_bindings_v1"
                                                              "get_xkb_binding"
                                                              :OPCODE 1
                                                              :DESCRIPTION "
        Define a key binding for the given seat in terms of an xkbcommon keysym
        and other configurable properties.

        The new key binding is not enabled until initial configuration is
        completed and the enable request is made during a manage sequence.
      "
                                                              :DESTRUCTOR-P NIL
                                                              :SINCE NIL
                                                              :EXPORT T)
    ("seat" COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:OBJECT :ENUM NIL :INTERFACE
     "river_seat_v1" :ALLOW-NULL-P NIL)
    ("id" COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:NEW-ID :ENUM NIL
     :INTERFACE "river_xkb_binding_v1" :ALLOW-NULL-P NIL)
    ("keysym" COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:UINT :ENUM NIL :INTERFACE
     NIL :ALLOW-NULL-P NIL)
    ("modifiers" COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:UINT :ENUM
     "river_seat_v1.modifiers" :INTERFACE NIL :ALLOW-NULL-P NIL))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-REQUEST ("river_xkb_bindings_v1"
                                                              "get_seat"
                                                              :OPCODE 2
                                                              :DESCRIPTION "
        Create an object to manage seat-specific xkb bindings state.

        It is a protocol error to make this request more than once for a given
        river_seat_v1 object.
      "
                                                              :DESTRUCTOR-P NIL
                                                              :SINCE 2 :EXPORT
                                                              T)
    ("id" COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:NEW-ID :ENUM NIL
     :INTERFACE "river_xkb_bindings_seat_v1" :ALLOW-NULL-P NIL)
    ("seat" COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:OBJECT :ENUM NIL :INTERFACE
     "river_seat_v1" :ALLOW-NULL-P NIL)))
 (PROGN
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-INTERFACE
   "river_xkb_binding_v1" :EXPORT T :DESCRIPTION "
      This object allows the window manager to configure a xkbcommon key binding
      and receive events when the key binding is triggered.

      The new key binding is not enabled until the enable request is made during
      a manage sequence.

      Normally, all key events are sent to the surface with keyboard focus by
      the compositor. Key events that trigger a key binding are not sent to the
      surface with keyboard focus.

      If multiple key bindings would be triggered by a single physical key event
      on the compositor side, it is compositor policy which key binding(s) will
      receive press/release events or if all of the matched key bindings receive
      press/release events.

      Key bindings might be matched by the same physical key event due to shared
      keysym and modifiers. The layout override feature may also cause the same
      physical key event to trigger two key bindings with different keysyms and
      different layout overrides configured.
    ")
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-REQUEST ("river_xkb_binding_v1"
                                                              "destroy" :OPCODE
                                                              0 :DESCRIPTION "
        This request indicates that the client will no longer use the xkb key
        binding object and that it may be safely destroyed.
      "
                                                              :DESTRUCTOR-P T
                                                              :SINCE NIL
                                                              :EXPORT T))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-REQUEST ("river_xkb_binding_v1"
                                                              "set_layout_override"
                                                              :OPCODE 1
                                                              :DESCRIPTION "
        Specify an xkb layout that should be used to translate key events for
        the purpose of triggering this key binding irrespective of the currently
        active xkb layout.

        The layout argument is a 0-indexed xkbcommon layout number for the
        keyboard that generated the key event.

        If this request is never made, the currently active xkb layout of the
        keyboard that generated the key event will be used.

        This request modifies window management state and may only be made as
        part of a manage sequence, see the river_window_manager_v1 description.
      "
                                                              :DESTRUCTOR-P NIL
                                                              :SINCE NIL
                                                              :EXPORT T)
    ("layout" COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:UINT :ENUM NIL :INTERFACE
     NIL :ALLOW-NULL-P NIL))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-REQUEST ("river_xkb_binding_v1"
                                                              "enable" :OPCODE
                                                              2 :DESCRIPTION "
        This request should be made after all initial configuration has been
        completed and the window manager wishes the key binding to be able to be
        triggered.

        This request modifies window management state and may only be made as
        part of a manage sequence, see the river_window_manager_v1 description.
      "
                                                              :DESTRUCTOR-P NIL
                                                              :SINCE NIL
                                                              :EXPORT T))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-REQUEST ("river_xkb_binding_v1"
                                                              "disable" :OPCODE
                                                              3 :DESCRIPTION "
        This request may be used to temporarily disable the key binding. It may
        be later re-enabled with the enable request.

        This request modifies window management state and may only be made as
        part of a manage sequence, see the river_window_manager_v1 description.
      "
                                                              :DESTRUCTOR-P NIL
                                                              :SINCE NIL
                                                              :EXPORT T))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-EVENT ("river_xkb_binding_v1"
                                                            "pressed" :OPCODE 0
                                                            :DESCRIPTION "
        This event indicates that the physical key triggering the binding has
        been pressed.

        This event will be followed by a manage_start event after all other new
        state has been sent by the server.

        The compositor should wait for the manage sequence to complete before
        processing further input events. This allows the window manager client
        to, for example, modify key bindings and keyboard focus without racing
        against future input events. The window manager should of course respond
        as soon as possible as the capacity of the compositor to buffer incoming
        input events is finite.
      "
                                                            :DESTRUCTOR-P NIL
                                                            :SINCE NIL :EXPORT
                                                            T))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-EVENT ("river_xkb_binding_v1"
                                                            "released" :OPCODE
                                                            1 :DESCRIPTION "
        This event indicates that the physical key triggering the binding has
        been released.

        Releasing the modifiers for the binding without releasing the \"main\"
        physical key that produces the bound keysym does not trigger the release
        event. This event is sent when the \"main\" key is released, even if the
        modifiers have changed since the pressed event.

        This event will be followed by a manage_start event after all other new
        state has been sent by the server.

        The compositor should wait for the manage sequence to complete before
        processing further input events. This allows the window manager client
        to, for example, modify key bindings and keyboard focus without racing
        against future input events. The window manager should of course respond
        as soon as possible as the capacity of the compositor to buffer incoming
        input events is finite.
      "
                                                            :DESTRUCTOR-P NIL
                                                            :SINCE NIL :EXPORT
                                                            T))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-EVENT ("river_xkb_binding_v1"
                                                            "stop_repeat"
                                                            :OPCODE 2
                                                            :DESCRIPTION "
        This event indicates that repeating should be stopped for the binding if
        the window manager has been repeating some action since the pressed
        event.

        This event is generally sent when some other (possible unbound) key is
        pressed after the pressed event is sent and before the released event
        is sent for this binding.

        This event will be followed by a manage_start event after all other new
        state has been sent by the server.
      "
                                                            :DESTRUCTOR-P NIL
                                                            :SINCE 2 :EXPORT
                                                            T)))
 (PROGN
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-INTERFACE
   "river_xkb_bindings_seat_v1" :EXPORT T :DESCRIPTION "
      This object manages xkb bindings state associated with a specific seat.
    ")
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-REQUEST ("river_xkb_bindings_seat_v1"
                                                              "destroy" :OPCODE
                                                              0 :DESCRIPTION "
        This request indicates that the client will no longer use the object and
        that it may be safely destroyed.
      "
                                                              :DESTRUCTOR-P T
                                                              :SINCE 2 :EXPORT
                                                              T))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-REQUEST ("river_xkb_bindings_seat_v1"
                                                              "ensure_next_key_eaten"
                                                              :OPCODE 1
                                                              :DESCRIPTION "
        Ensure that the next non-modifier key press and corresponding release
        events for this seat are not sent to the currently focused surface.

        If the next non-modifier key press triggers a binding, the
        pressed/released events are sent to the river_xkb_binding_v1 object as
        usual.

        If the next non-modifier key press does not trigger a binding, the
        ate_unbound_key event is sent instead.

        Rationale: the window manager may wish to implement \"chorded\"
        keybindings where triggering a binding activates a \"submap\" with a
        different set of keybindings. Without a way to eat the next key
        press event, there is no good way for the window manager to know that it
        should error out and exit the submap when a key not bound in the submap
        is pressed.

        This request modifies window management state and may only be made as
        part of a manage sequence, see the river_window_manager_v1 description.
      "
                                                              :DESTRUCTOR-P NIL
                                                              :SINCE 2 :EXPORT
                                                              T))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-REQUEST ("river_xkb_bindings_seat_v1"
                                                              "cancel_ensure_next_key_eaten"
                                                              :OPCODE 2
                                                              :DESCRIPTION "
        This requests cancels the effect of the latest ensure_next_key_eaten
        request if no key has been eaten due to the request yet. This request
        has no effect if a key has already been eaten or no
        ensure_next_key_eaten was made.

        Rationale: the window manager may wish cancel an uncompleted \"chorded\"
        keybinding after a timeout of a few seconds. Note that since this
        timeout use-case requires the window manager to trigger a manage sequence
        with the river_window_manager_v1.manage_dirty request it is possible that
        the ate_unbound_key key event may be sent before the window manager has
        a chance to make the cancel_ensure_next_key_eaten request.

        This request modifies window management state and may only be made as
        part of a manage sequence, see the river_window_manager_v1 description.
      "
                                                              :DESTRUCTOR-P NIL
                                                              :SINCE 2 :EXPORT
                                                              T))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-EVENT ("river_xkb_bindings_seat_v1"
                                                            "ate_unbound_key"
                                                            :OPCODE 0
                                                            :DESCRIPTION "
        An unbound key press event was eaten due to the ensure_next_key_eaten
        request.

        This event will be followed by a manage_start event after all other new
        state has been sent by the server.
      "
                                                            :DESTRUCTOR-P NIL
                                                            :SINCE 2 :EXPORT
                                                            T)))
 (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:INITIALIZE-INTERFACE "river_xkb_bindings_v1"
     2
   (("destroy" NIL)
    ("get_xkb_binding" NIL
     (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:OBJECT NIL "river_seat_v1")
     (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:NEW-ID NIL
      "river_xkb_binding_v1")
     (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:UINT NIL NIL)
     (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:UINT NIL NIL))
    ("get_seat" 2
     (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:NEW-ID NIL
      "river_xkb_bindings_seat_v1")
     (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:OBJECT NIL "river_seat_v1")))
   NIL)
 (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:INITIALIZE-INTERFACE "river_xkb_binding_v1"
     2
   (("destroy" NIL)
    ("set_layout_override" NIL
     (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:UINT NIL NIL))
    ("enable" NIL) ("disable" NIL))
   (("pressed" NIL) ("released" NIL) ("stop_repeat" 2)))
 (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:INITIALIZE-INTERFACE "river_xkb_bindings_seat_v1"
     2
   (("destroy" 2) ("ensure_next_key_eaten" 2)
    ("cancel_ensure_next_key_eaten" 2))
   (("ate_unbound_key" 2))))