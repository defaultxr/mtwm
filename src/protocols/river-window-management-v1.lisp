;;;; river-window-management-v1.lisp - Generated River protocol binding


(UIOP/PACKAGE:DEFINE-PACKAGE "MTWM.RIVER-WINDOW-MANAGEMENT-V1"
                             (:USE #:CL
                              "COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE"))(in-package #:MTWM.RIVER-WINDOW-MANAGEMENT-V1)


(PROGN
 "
    This protocol allows a single \"window manager\" client to determine the
    window management policy of the compositor. State is globally
    double-buffered allowing for frame perfect state changes involving multiple
    windows.

    The key words \"must\", \"must not\", \"required\", \"shall\", \"shall not\",
    \"should\", \"should not\", \"recommended\", \"may\", and \"optional\" in this
    document are to be interpreted as described in IETF RFC 2119.
  "
 (PROGN
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-INTERFACE
   "river_window_manager_v1" :EXPORT T :DESCRIPTION "
      This global interface should only be advertised to the window manager
      process. Only one window management client may be active at a time. The
      compositor should use the unavailable event if necessary to enforce this.

      There are two disjoint categories of state managed by this protocol:

      Window management state influences the communication between the server
      and individual window clients (e.g. xdg_toplevels). Window management
      state includes window dimensions, fullscreen state, keyboard focus,
      keyboard bindings, and more.

      Rendering state only affects the rendered output of the compositor and
      does not influence communication between the server and individual window
      clients. Rendering state includes the position and rendering order of
      windows, shell surfaces, decoration surfaces, borders, and more.

      Window management state may only be modified by the window manager as part
      of a manage sequence. A manage sequence is started with the manage_start
      event and ended with the manage_finish request. It is a protocol error to
      modify window management state outside of a manage sequence.

      A manage sequence is always followed by at least one render sequence. A
      render sequence is started with the render_start event and ended with the
      render_finish request.

      Rendering state may be modified by the window manager during a manage
      sequence or a render sequence. Regardless of when the rendering state is
      modified, it is applied with the next render_finish request. It is a
      protocol error to modify rendering state outside of a manage or render
      sequence.

      The server will start a manage sequence by sending new state and the
      manage_start event as soon as possible whenever there is a change in state
      that must be communicated with the window manager.

      If the window manager client needs to ensure a manage sequence is started
      due to a state change the compositor is not aware of, it may send the
      manage_dirty request.

      The server will start a render sequence by sending new state and the
      render_start event as soon as possible whenever there is a change in
      window dimensions that must be communicated with the window manager.
      Multiple render sequences may be made consecutively without a manage
      sequence in between, for example if a window independently changes its own
      dimensions.

      To summarize, the main loop of this protocol is as follows:

      1. The server sends events indicating all changes since the last
         manage sequence followed by the manage_start event.

      2. The client sends requests modifying window management state or
         rendering state (as defined above) followed by the manage_finish
         request.

      3. The server sends new state to windows and waits for responses.

      4. The server sends new window dimensions to the client followed by the
         render_start event.

      5. The client sends requests modifying rendering state (as defined above)
         followed by the render_finish request.

      6. If window dimensions change, loop back to step 4.
         If state that requires a manage sequence changes or if the client makes
         a manage_dirty request, loop back to step 1.

      For the purposes of frame perfection, the server may delay rendering new
      state committed by the windows in step 3 until after step 5 is finished.

      It is a protocol error for the client to make a manage_finish or
      render_finish request that violates this ordering.
    ")
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-ENUM ("river_window_manager_v1"
                                                           "error" :DESCRIPTION
                                                           NIL :BITFIELD-P NIL
                                                           :EXPORT T)
    (:SEQUENCE-ORDER 0 "request violates manage/render sequence ordering")
    (:ROLE 1 "given wl_surface already has a role")
    (:UNRESPONSIVE 2 "window manager unresponsive"))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-REQUEST ("river_window_manager_v1"
                                                              "stop" :OPCODE 0
                                                              :DESCRIPTION "
        This request indicates that the client no longer wishes to receive
        events on this object.

        The Wayland protocol is asynchronous, which means the server may send
        further events until the stop request is processed. The client must wait
        for a river_window_manager_v1.finished event before destroying this
        object.
      "
                                                              :DESTRUCTOR-P NIL
                                                              :SINCE NIL
                                                              :EXPORT T))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-REQUEST ("river_window_manager_v1"
                                                              "destroy" :OPCODE
                                                              1 :DESCRIPTION "
        This request should be called after the finished event has been received
        to complete destruction of the object.

        If a client wishes to destroy this object it should send a
        river_window_manager_v1.stop request and wait for a
        river_window_manager_v1.finished event. Once the finished event is
        received it is safe to destroy this object and any other objects created
        through this interface.
      "
                                                              :DESTRUCTOR-P T
                                                              :SINCE NIL
                                                              :EXPORT T))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-REQUEST ("river_window_manager_v1"
                                                              "manage_finish"
                                                              :OPCODE 2
                                                              :DESCRIPTION "
        This request indicates that the client has made all changes to window
        management state it wishes to include in the current manage sequence and
        that the server should atomically send these state changes to the
        windows and continue with the manage sequence.

        After sending this request, it is a protocol error for the client to
        make further changes to window management state until the next
        manage_start event is received.

        See the description of the river_window_manager_v1 interface for a
        complete overview of the manage/render sequence loop.
      "
                                                              :DESTRUCTOR-P NIL
                                                              :SINCE NIL
                                                              :EXPORT T))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-REQUEST ("river_window_manager_v1"
                                                              "manage_dirty"
                                                              :OPCODE 3
                                                              :DESCRIPTION "
        This request ensures a manage sequence is started and that a
        manage_start event is sent by the server. If this request is made during
        an ongoing manage sequence, a new manage sequence will be started as
        soon as the current one is completed.

        The client may want to use this request due to an internal state change
        that the compositor is not aware of (e.g. a dbus event) which should
        affect window management or rendering state.
      "
                                                              :DESTRUCTOR-P NIL
                                                              :SINCE NIL
                                                              :EXPORT T))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-REQUEST ("river_window_manager_v1"
                                                              "render_finish"
                                                              :OPCODE 4
                                                              :DESCRIPTION "
        This request indicates that the client has made all changes to rendering
        state it wishes to include in the current manage sequence and that the
        server should atomically apply and display these state changes to the
        user.

        After sending this request, it is a protocol error for the client to
        make further changes to rendering state until the next manage_start or
        render_start event is received, whichever comes first.

        See the description of the river_window_manager_v1 interface for a
        complete overview of the manage/render sequence loop.
      "
                                                              :DESTRUCTOR-P NIL
                                                              :SINCE NIL
                                                              :EXPORT T))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-REQUEST ("river_window_manager_v1"
                                                              "get_shell_surface"
                                                              :OPCODE 5
                                                              :DESCRIPTION "
        Create a new shell surface for window manager UI and assign the
        river_shell_surface_v1 role to the surface.

        Providing a wl_surface which already has a role or already has a buffer
        attached or committed is a protocol error.
      "
                                                              :DESTRUCTOR-P NIL
                                                              :SINCE NIL
                                                              :EXPORT T)
    ("id" COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:NEW-ID :ENUM NIL
     :INTERFACE "river_shell_surface_v1" :ALLOW-NULL-P NIL)
    ("surface" COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:OBJECT :ENUM NIL
     :INTERFACE "wl_surface" :ALLOW-NULL-P NIL))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-EVENT ("river_window_manager_v1"
                                                            "unavailable"
                                                            :OPCODE 0
                                                            :DESCRIPTION "
        This event indicates that window management is not available to the
        client, perhaps due to another window management client already running.
        The circumstances causing this event to be sent are compositor policy.

        If sent, this event is guaranteed to be the first and only event sent by
        the server.

        The server will send no further events on this object. The client should
        destroy this object and all objects created through this interface.
      "
                                                            :DESTRUCTOR-P NIL
                                                            :SINCE NIL :EXPORT
                                                            T))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-EVENT ("river_window_manager_v1"
                                                            "finished" :OPCODE
                                                            1 :DESCRIPTION "
        This event indicates that the server will send no further events on this
        object. The client should destroy the object. See
        river_window_manager_v1.destroy for more information.
      "
                                                            :DESTRUCTOR-P NIL
                                                            :SINCE NIL :EXPORT
                                                            T))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-EVENT ("river_window_manager_v1"
                                                            "manage_start"
                                                            :OPCODE 2
                                                            :DESCRIPTION "
        This event indicates that the server has sent events indicating all
        state changes since the last manage sequence.

        In response to this event, the client should make requests modifying
        window management state as it chooses. Then, the client must make the
        manage_finish request.

        See the description of the river_window_manager_v1 interface for a
        complete overview of the manage/render sequence loop.
      "
                                                            :DESTRUCTOR-P NIL
                                                            :SINCE NIL :EXPORT
                                                            T))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-EVENT ("river_window_manager_v1"
                                                            "render_start"
                                                            :OPCODE 3
                                                            :DESCRIPTION "
        This event indicates that the server has sent all river_node_v1.position
        and river_window_v1.dimensions events necessary.

        In response to this event, the client should make requests modifying
        rendering state as it chooses. Then, the client must make the
        render_finish request.

        See the description of the river_window_manager_v1 interface for a
        complete overview of the manage/render sequence loop.
      "
                                                            :DESTRUCTOR-P NIL
                                                            :SINCE NIL :EXPORT
                                                            T))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-EVENT ("river_window_manager_v1"
                                                            "session_locked"
                                                            :OPCODE 4
                                                            :DESCRIPTION "
        This event indicates that the session has been locked.

        The window manager may wish to restrict which key bindings are available
        while locked or otherwise use this information.

        This event will be followed by a manage_start event after all other new
        state has been sent by the server.
      "
                                                            :DESTRUCTOR-P NIL
                                                            :SINCE NIL :EXPORT
                                                            T))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-EVENT ("river_window_manager_v1"
                                                            "session_unlocked"
                                                            :OPCODE 5
                                                            :DESCRIPTION "
        This event indicates that the session has been unlocked.

        This event will be followed by a manage_start event after all other new
        state has been sent by the server.
      "
                                                            :DESTRUCTOR-P NIL
                                                            :SINCE NIL :EXPORT
                                                            T))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-EVENT ("river_window_manager_v1"
                                                            "window" :OPCODE 6
                                                            :DESCRIPTION "
        A new window has been created.

        This event will be followed by a manage_start event after all other new
        state has been sent by the server.
      "
                                                            :DESTRUCTOR-P NIL
                                                            :SINCE NIL :EXPORT
                                                            T)
    ("id" COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:NEW-ID :ENUM NIL
     :INTERFACE "river_window_v1" :ALLOW-NULL-P NIL))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-EVENT ("river_window_manager_v1"
                                                            "output" :OPCODE 7
                                                            :DESCRIPTION "
        A new logical output has been created, perhaps due to a new physical
        monitor being plugged in or perhaps due to a change in configuration.

        This event will be followed by river_output_v1.position and dimensions
        events as well as a manage_start event after all other new state has
        been sent by the server.
      "
                                                            :DESTRUCTOR-P NIL
                                                            :SINCE NIL :EXPORT
                                                            T)
    ("id" COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:NEW-ID :ENUM NIL
     :INTERFACE "river_output_v1" :ALLOW-NULL-P NIL))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-EVENT ("river_window_manager_v1"
                                                            "seat" :OPCODE 8
                                                            :DESCRIPTION "
        A new seat has been created.

        This event will be followed by a manage_start event after all other new
        state has been sent by the server.
      "
                                                            :DESTRUCTOR-P NIL
                                                            :SINCE NIL :EXPORT
                                                            T)
    ("id" COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:NEW-ID :ENUM NIL
     :INTERFACE "river_seat_v1" :ALLOW-NULL-P NIL)))
 (PROGN
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-INTERFACE
   "river_window_v1" :EXPORT T :DESCRIPTION "
      This represents a logical window. For example, a window may correspond to
      an xdg_toplevel or Xwayland window.

      A newly created window will not be displayed until the window manager
      makes a propose_dimensions or fullscreen request as part of a manage
      sequence, the server replies with a dimensions event as part of a render
      sequence, and that render sequence is finished.
    ")
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-ENUM ("river_window_v1"
                                                           "error" :DESCRIPTION
                                                           NIL :BITFIELD-P NIL
                                                           :EXPORT T)
    (:NODE-EXISTS 0 "window already has a node object")
    (:INVALID-DIMENSIONS 1 "proposed dimensions out of bounds")
    (:INVALID-BORDER 2 "invalid arg to set_borders")
    (:INVALID-CLIP-BOX 3 "invalid arg to set_clip_box"))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-ENUM ("river_window_v1"
                                                           "decoration_hint"
                                                           :DESCRIPTION NIL
                                                           :BITFIELD-P NIL
                                                           :EXPORT T)
    (:ONLY-SUPPORTS-CSD 0 "only supports client side decoration")
    (:PREFERS-CSD 1
     "client side decoration preferred, both CSD and SSD supported")
    (:PREFERS-SSD 2
     "server side decoration preferred, both CSD and SSD supported")
    (:NO-PREFERENCE 3 "no preference, both CSD and SSD supported"))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-ENUM ("river_window_v1"
                                                           "edges" :DESCRIPTION
                                                           NIL :BITFIELD-P T
                                                           :EXPORT T)
    (:NONE 0 NIL)
    (:TOP 1 NIL)
    (:BOTTOM 2 NIL)
    (:LEFT 4 NIL)
    (:RIGHT 8 NIL))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-ENUM ("river_window_v1"
                                                           "capabilities"
                                                           :DESCRIPTION NIL
                                                           :BITFIELD-P T
                                                           :EXPORT T)
    (:WINDOW-MENU 1 NIL)
    (:MAXIMIZE 2 NIL)
    (:FULLSCREEN 4 NIL)
    (:MINIMIZE 8 NIL))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-REQUEST ("river_window_v1"
                                                              "destroy" :OPCODE
                                                              0 :DESCRIPTION "
        This request indicates that the client will no longer use the window
        object and that it may be safely destroyed.

        This request should be made after the river_window_v1.closed event or
        river_window_manager_v1.finished is received to complete destruction of
        the window.
      "
                                                              :DESTRUCTOR-P T
                                                              :SINCE NIL
                                                              :EXPORT T))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-REQUEST ("river_window_v1"
                                                              "close" :OPCODE 1
                                                              :DESCRIPTION "
        Request that the window be closed. The window may ignore this request or
        only close after some delay, perhaps opening a dialog asking the user to
        save their work or similar.

        The server will send a river_window_v1.closed event if/when the window
        has been closed.

        This request modifies window management state and may only be made as
        part of a manage sequence, see the river_window_manager_v1 description.
      "
                                                              :DESTRUCTOR-P NIL
                                                              :SINCE NIL
                                                              :EXPORT T))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-REQUEST ("river_window_v1"
                                                              "get_node"
                                                              :OPCODE 2
                                                              :DESCRIPTION "
        Get the node in the render list corresponding to the window.

        It is a protocol error to make this request more than once for a single
        window.
      "
                                                              :DESTRUCTOR-P NIL
                                                              :SINCE NIL
                                                              :EXPORT T)
    ("id" COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:NEW-ID :ENUM NIL
     :INTERFACE "river_node_v1" :ALLOW-NULL-P NIL))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-REQUEST ("river_window_v1"
                                                              "propose_dimensions"
                                                              :OPCODE 3
                                                              :DESCRIPTION "
        This request proposes dimensions for the window in the compositor's
        logical coordinate space.

        The width and height must be greater than or equal to zero. If the width
        or height is zero the window will be allowed to decide its own
        dimensions.

        The window may not take the exact dimensions proposed. The actual
        dimensions taken by the window will be sent in a subsequent
        river_window_v1.dimensions event. For example, a terminal emulator may
        only allow dimensions that are multiple of the cell size.

        When a propose_dimensions request is made, the server must send a
        dimensions event in response as soon as possible. It may not be possible
        to send a dimensions event in the very next render sequence if, for
        example, the window takes too long to respond to the proposed
        dimensions. In this case, the server will send the dimensions event in a
        future render sequence.

        Note that the dimensions of a river_window_v1 refer to the dimensions of
        the window content and are unaffected by the presence of borders or
        decoration surfaces.

        This request modifies window management state and may only be made as
        part of a manage sequence, see the river_window_manager_v1 description.
      "
                                                              :DESTRUCTOR-P NIL
                                                              :SINCE NIL
                                                              :EXPORT T)
    ("width" COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:INT :ENUM NIL :INTERFACE
     NIL :ALLOW-NULL-P NIL)
    ("height" COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:INT :ENUM NIL :INTERFACE
     NIL :ALLOW-NULL-P NIL))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-REQUEST ("river_window_v1"
                                                              "hide" :OPCODE 4
                                                              :DESCRIPTION "
        Request that the window be hidden. Has no effect if the window is
        already hidden. Hides any window borders and decorations as well.

        Newly created windows are considered shown unless explicitly hidden with
        the hide request.

        This request modifies rendering state and may only be made as part of a
        render sequence, see the river_window_manager_v1 description.
      "
                                                              :DESTRUCTOR-P NIL
                                                              :SINCE NIL
                                                              :EXPORT T))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-REQUEST ("river_window_v1"
                                                              "show" :OPCODE 5
                                                              :DESCRIPTION "
        Request that the window be shown. Has no effect if the window is not
        hidden. Does not guarantee that the window is visible as it may be
        completely obscured by other windows placed above it for example.

        Newly created windows are considered shown unless explicitly hidden with
        the hide request.

        This request modifies rendering state and may only be made as part of a
        render sequence, see the river_window_manager_v1 description.
      "
                                                              :DESTRUCTOR-P NIL
                                                              :SINCE NIL
                                                              :EXPORT T))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-REQUEST ("river_window_v1"
                                                              "use_csd" :OPCODE
                                                              6 :DESCRIPTION "
        Tell the client to use client side decoration and draw its own title
        bar, borders, etc.

        This is the default if neither this request nor the use_ssd request is
        ever made.

        This request modifies window management state and may only be made as
        part of a manage sequence, see the river_window_manager_v1 description.
      "
                                                              :DESTRUCTOR-P NIL
                                                              :SINCE NIL
                                                              :EXPORT T))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-REQUEST ("river_window_v1"
                                                              "use_ssd" :OPCODE
                                                              7 :DESCRIPTION "
        Tell the client to use server side decoration and not draw any client
        side decorations.

        This request will have no effect if the client only supports client side
        decoration, see the decoration_hint event.

        This request modifies window management state and may only be made as
        part of a manage sequence, see the river_window_manager_v1 description.
      "
                                                              :DESTRUCTOR-P NIL
                                                              :SINCE NIL
                                                              :EXPORT T))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-REQUEST ("river_window_v1"
                                                              "set_borders"
                                                              :OPCODE 8
                                                              :DESCRIPTION "
        This request decorates the window with borders drawn by the compositor
        on the specified edges of the window. Borders are drawn above the window
        content.

        Corners are drawn only between borders on adjacent edges. If e.g. the
        left edge has a border and the top edge does not, the border drawn on
        the left edge will not extend vertically beyond the top edge of the
        window.

        Borders are not drawn while the window is fullscreen.

        The color is defined by four 32-bit RGBA values. Unless specified in
        another protocol extension, the RGBA values use pre-multiplied alpha.

        Setting the edges to none or the width to 0 disables the borders.
        Setting a negative width is a protocol error.

        This request completely overrides all previous set_borders requests.
        Only the most recent set_borders request has an effect.

        Note that the position/dimensions of a river_window_v1 refer to the
        position/dimensions of the window content and are unaffected by the
        presence of borders or decoration surfaces.

        This request modifies rendering state and may only be made as part of a
        render sequence, see the river_window_manager_v1 description.
      "
                                                              :DESTRUCTOR-P NIL
                                                              :SINCE NIL
                                                              :EXPORT T)
    ("edges" COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:UINT :ENUM "edges"
     :INTERFACE NIL :ALLOW-NULL-P NIL)
    ("width" COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:INT :ENUM NIL :INTERFACE
     NIL :ALLOW-NULL-P NIL)
    ("r" COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:UINT :ENUM NIL :INTERFACE NIL
     :ALLOW-NULL-P NIL)
    ("g" COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:UINT :ENUM NIL :INTERFACE NIL
     :ALLOW-NULL-P NIL)
    ("b" COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:UINT :ENUM NIL :INTERFACE NIL
     :ALLOW-NULL-P NIL)
    ("a" COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:UINT :ENUM NIL :INTERFACE NIL
     :ALLOW-NULL-P NIL))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-REQUEST ("river_window_v1"
                                                              "set_tiled"
                                                              :OPCODE 9
                                                              :DESCRIPTION "
        Inform the window that it is part of a tiled layout and adjacent to
        other elements in the tiled layout on the given edges.

        The window should use this information to change the style of its client
        side decorations and avoid drawing e.g. drop shadows outside of the
        window dimensions on the tiled edges.

        Setting the edges argument to none informs the window that it is not
        part of a tiled layout. If this request is never made, the window is
        informed that it is not part of a tiled layout.

        This request modifies window management state and may only be made as
        part of a manage sequence, see the river_window_manager_v1 description.
      "
                                                              :DESTRUCTOR-P NIL
                                                              :SINCE NIL
                                                              :EXPORT T)
    ("edges" COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:UINT :ENUM "edges"
     :INTERFACE NIL :ALLOW-NULL-P NIL))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-REQUEST ("river_window_v1"
                                                              "get_decoration_above"
                                                              :OPCODE 10
                                                              :DESCRIPTION "
        Create a decoration surface and assign the river_decoration_v1 role to
        the surface. The created decoration is placed above the window in
        rendering order, see the description of river_decoration_v1.

        Providing a wl_surface which already has a role or already has a buffer
        attached or committed is a protocol error.
      "
                                                              :DESTRUCTOR-P NIL
                                                              :SINCE NIL
                                                              :EXPORT T)
    ("id" COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:NEW-ID :ENUM NIL
     :INTERFACE "river_decoration_v1" :ALLOW-NULL-P NIL)
    ("surface" COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:OBJECT :ENUM NIL
     :INTERFACE "wl_surface" :ALLOW-NULL-P NIL))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-REQUEST ("river_window_v1"
                                                              "get_decoration_below"
                                                              :OPCODE 11
                                                              :DESCRIPTION "
        Create a decoration surface and assign the river_decoration_v1 role to
        the surface. The created decoration is placed below the window in
        rendering order, see the description of river_decoration_v1.

        Providing a wl_surface which already has a role or already has a buffer
        attached or committed is a protocol error.
      "
                                                              :DESTRUCTOR-P NIL
                                                              :SINCE NIL
                                                              :EXPORT T)
    ("id" COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:NEW-ID :ENUM NIL
     :INTERFACE "river_decoration_v1" :ALLOW-NULL-P NIL)
    ("surface" COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:OBJECT :ENUM NIL
     :INTERFACE "wl_surface" :ALLOW-NULL-P NIL))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-REQUEST ("river_window_v1"
                                                              "inform_resize_start"
                                                              :OPCODE 12
                                                              :DESCRIPTION "
        Inform the window that it is being resized. The window manager should
        use this request to inform windows that are the target of an interactive
        resize for example.

        The window manager remains responsible for handling the position and
        dimensions of the window while it is resizing.

        This request modifies window management state and may only be made as
        part of a manage sequence, see the river_window_manager_v1 description.
      "
                                                              :DESTRUCTOR-P NIL
                                                              :SINCE NIL
                                                              :EXPORT T))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-REQUEST ("river_window_v1"
                                                              "inform_resize_end"
                                                              :OPCODE 13
                                                              :DESCRIPTION "
        Inform the window that it is no longer being resized. The window manager
        should use this request to inform windows that are the target of an
        interactive resize that the interactive resize has ended for example.

        This request modifies window management state and may only be made as
        part of a manage sequence, see the river_window_manager_v1 description.
      "
                                                              :DESTRUCTOR-P NIL
                                                              :SINCE NIL
                                                              :EXPORT T))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-REQUEST ("river_window_v1"
                                                              "set_capabilities"
                                                              :OPCODE 14
                                                              :DESCRIPTION "
        This request informs the window of the capabilities supported by the
        window manager. If the window manager, for example, ignores requests to
        be maximized from the window it should not tell the window that it
        supports the maximize capability.

        The window might use this information to, for example, only show a
        maximize button if the window manager supports the maximize capability.

        The window manager client should use this request to set capabilities
        for all new windows. If this request is never made, the compositor will
        inform windows that all capabilities are supported.

        This request modifies window management state and may only be made as
        part of a manage sequence, see the river_window_manager_v1 description.
      "
                                                              :DESTRUCTOR-P NIL
                                                              :SINCE NIL
                                                              :EXPORT T)
    ("caps" COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:UINT :ENUM "capabilities"
     :INTERFACE NIL :ALLOW-NULL-P NIL))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-REQUEST ("river_window_v1"
                                                              "inform_maximized"
                                                              :OPCODE 15
                                                              :DESCRIPTION "
        Inform the window that it is maximized. The window might use this
        information to adapt the style of its client-side window decorations for
        example.

        The window manager remains responsible for handling the position and
        dimensions of the window while it is maximized.

        This request modifies window management state and may only be made as
        part of a manage sequence, see the river_window_manager_v1 description.
      "
                                                              :DESTRUCTOR-P NIL
                                                              :SINCE NIL
                                                              :EXPORT T))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-REQUEST ("river_window_v1"
                                                              "inform_unmaximized"
                                                              :OPCODE 16
                                                              :DESCRIPTION "
        Inform the window that it is unmaximized. The window might use this
        information to adapt the style of its client-side window decorations for
        example.

        This request modifies window management state and may only be made as
        part of a manage sequence, see the river_window_manager_v1 description.
      "
                                                              :DESTRUCTOR-P NIL
                                                              :SINCE NIL
                                                              :EXPORT T))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-REQUEST ("river_window_v1"
                                                              "inform_fullscreen"
                                                              :OPCODE 17
                                                              :DESCRIPTION "
        Inform the window that it is fullscreen. The window might use this
        information to adapt the style of its client-side window decorations for
        example.

        This request does not affect the size/position of the window or cause it
        to become the only window rendered, see the river_window_v1.fullscreen
        and exit_fullscreen requests for that.

        This request modifies window management state and may only be made as
        part of a manage sequence, see the river_window_manager_v1 description.
      "
                                                              :DESTRUCTOR-P NIL
                                                              :SINCE NIL
                                                              :EXPORT T))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-REQUEST ("river_window_v1"
                                                              "inform_not_fullscreen"
                                                              :OPCODE 18
                                                              :DESCRIPTION "
        Inform the window that it is not fullscreen. The window might use this
        information to adapt the style of its client-side window decorations for
        example.

        This request does not affect the size/position of the window or cause it
        to become the only window rendered, see the river_window_v1.fullscreen
        and exit_fullscreen requests for that.

        This request modifies window management state and may only be made as
        part of a manage sequence, see the river_window_manager_v1 description.
      "
                                                              :DESTRUCTOR-P NIL
                                                              :SINCE NIL
                                                              :EXPORT T))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-REQUEST ("river_window_v1"
                                                              "fullscreen"
                                                              :OPCODE 19
                                                              :DESCRIPTION "
        Make the window fullscreen on the given output. If multiple windows are
        fullscreen on the same output at the same time only the \"top\" window in
        rendering order shall be displayed.

        All river_shell_surface_v1 objects above the top fullscreen window in
        the rendering order will continue to be rendered.

        The compositor will handle the position and dimensions of the window
        while it is fullscreen. The set_position and propose_dimensions requests
        shall not affect the current position and dimensions of a fullscreen
        window.

        When a fullscreen request is made, the server must send a dimensions
        event in response as soon as possible. It may not be possible to send a
        dimensions event in the very next render sequence if, for example, the
        window takes too long to respond. In this case, the server will send the
        dimensions event in a future render sequence.

        The compositor will clip window content, decoration surfaces, and
        borders to the given output's dimensions while the window is fullscreen.
        The effects of set_clip_box and set_content_clip_box are ignored while
        the window is fullscreen.

        If the output on which a window is currently fullscreen is removed, the
        windowing state is modified as if there were an exit_fullscreen request
        made in the same manage sequence as the river_output_v1.removed event.

        This request does not inform the window that it is fullscreen, see the
        river_window_v1.inform_fullscreen and inform_not_fullscreen requests.

        This request modifies window management state and may only be made as
        part of a manage sequence, see the river_window_manager_v1 description.
      "
                                                              :DESTRUCTOR-P NIL
                                                              :SINCE NIL
                                                              :EXPORT T)
    ("output" COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:OBJECT :ENUM NIL
     :INTERFACE "river_output_v1" :ALLOW-NULL-P NIL))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-REQUEST ("river_window_v1"
                                                              "exit_fullscreen"
                                                              :OPCODE 20
                                                              :DESCRIPTION "
        Make the window not fullscreen.

        The position and dimensions are undefined after this request is made
        until a manage sequence in which the window manager makes the
        propose_dimensions and set_position requests is completed.

        The window manager should make propose_dimensions and set_position
        requests in the same manage sequence as the exit_fullscreen request for
        frame perfection.

        This request does not inform the window that it is fullscreen, see the
        river_window_v1.inform_fullscreen and inform_not_fullscreen requests.

        This request modifies window management state and may only be made as
        part of a manage sequence, see the river_window_manager_v1 description.
      "
                                                              :DESTRUCTOR-P NIL
                                                              :SINCE NIL
                                                              :EXPORT T))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-REQUEST ("river_window_v1"
                                                              "set_clip_box"
                                                              :OPCODE 21
                                                              :DESCRIPTION "
        Clip the window, including borders and decoration surfaces, to the box
        specified by the x, y, width, and height arguments. The x/y position of
        the box is relative to the top left corner of the window.

        The width and height arguments must be greater than or equal to 0.

        Setting a clip box with 0 width or height disables clipping.

        The clip box is ignored while the window is fullscreen.

        Both set_clip_box and set_content_clip_box may be enabled simultaneously.

        This request modifies rendering state and may only be made as part of a
        render sequence, see the river_window_manager_v1 description.
      "
                                                              :DESTRUCTOR-P NIL
                                                              :SINCE 2 :EXPORT
                                                              T)
    ("x" COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:INT :ENUM NIL :INTERFACE NIL
     :ALLOW-NULL-P NIL)
    ("y" COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:INT :ENUM NIL :INTERFACE NIL
     :ALLOW-NULL-P NIL)
    ("width" COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:INT :ENUM NIL :INTERFACE
     NIL :ALLOW-NULL-P NIL)
    ("height" COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:INT :ENUM NIL :INTERFACE
     NIL :ALLOW-NULL-P NIL))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-REQUEST ("river_window_v1"
                                                              "set_content_clip_box"
                                                              :OPCODE 22
                                                              :DESCRIPTION "
        Clip the content of the window, excluding borders and decoration
        surfaces, to the box specified by the x, y, width, and height arguments.
        The x/y position of the box is relative to the top left corner of the
        window.

        Borders drawn by the compositor (see set_borders) are placed around the
        intersection of the window content (as defined by the dimensions event)
        and the content clip box when content clipping is enabled.

        The width and height arguments must be greater than or equal to 0.

        Setting a box with 0 width or height disables content clipping.

        The content clip box is ignored while the window is fullscreen.

        Both set_clip_box and set_content_clip_box may be enabled simultaneously.

        This request modifies rendering state and may only be made as part of a
        render sequence, see the river_window_manager_v1 description.
      "
                                                              :DESTRUCTOR-P NIL
                                                              :SINCE 3 :EXPORT
                                                              T)
    ("x" COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:INT :ENUM NIL :INTERFACE NIL
     :ALLOW-NULL-P NIL)
    ("y" COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:INT :ENUM NIL :INTERFACE NIL
     :ALLOW-NULL-P NIL)
    ("width" COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:INT :ENUM NIL :INTERFACE
     NIL :ALLOW-NULL-P NIL)
    ("height" COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:INT :ENUM NIL :INTERFACE
     NIL :ALLOW-NULL-P NIL))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-EVENT ("river_window_v1"
                                                            "closed" :OPCODE 0
                                                            :DESCRIPTION "
        The window has been closed by the server, perhaps due to an
        xdg_toplevel.close request or similar.

        The server will send no further events on this object and ignore any
        request other than river_window_v1.destroy made after this event is
        sent. The client should destroy this object with the
        river_window_v1.destroy request to free up resources.

        This event will be followed by a manage_start event after all other new
        state has been sent by the server.
      "
                                                            :DESTRUCTOR-P NIL
                                                            :SINCE NIL :EXPORT
                                                            T))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-EVENT ("river_window_v1"
                                                            "dimensions_hint"
                                                            :OPCODE 1
                                                            :DESCRIPTION "
        This event informs the window manager of the window's preferred min/max
        dimensions. These preferences are a hint, and the window manager is free
        to propose dimensions outside of these bounds.

        All min/max width/height values must be strictly greater than or equal
        to 0. A value of 0 indicates that the window has no preference for that
        value.

        The min_width/min_height must be strictly less than or equal to the
        max_width/max_height.

        This event will be followed by a manage_start event after all other new
        state has been sent by the server.
      "
                                                            :DESTRUCTOR-P NIL
                                                            :SINCE NIL :EXPORT
                                                            T)
    ("min_width" COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:INT :ENUM NIL
     :INTERFACE NIL :ALLOW-NULL-P NIL)
    ("min_height" COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:INT :ENUM NIL
     :INTERFACE NIL :ALLOW-NULL-P NIL)
    ("max_width" COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:INT :ENUM NIL
     :INTERFACE NIL :ALLOW-NULL-P NIL)
    ("max_height" COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:INT :ENUM NIL
     :INTERFACE NIL :ALLOW-NULL-P NIL))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-EVENT ("river_window_v1"
                                                            "dimensions"
                                                            :OPCODE 2
                                                            :DESCRIPTION "
        This event indicates the dimensions of the window in the compositor's
        logical coordinate space. The width and height must be strictly greater
        than zero.

        Note that the dimensions of a river_window_v1 refer to the dimensions of
        the window content and are unaffected by the presence of borders or
        decoration surfaces.

        This event is sent as part of a render sequence before the render_start
        event.

        It may be sent due to a propose_dimensions or fullscreen request in a
        previous manage sequence or because a window independently decides to
        change its dimensions.

        The window will not be displayed until the first dimensions event is
        received and the render sequence is finished.
      "
                                                            :DESTRUCTOR-P NIL
                                                            :SINCE NIL :EXPORT
                                                            T)
    ("width" COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:INT :ENUM NIL :INTERFACE
     NIL :ALLOW-NULL-P NIL)
    ("height" COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:INT :ENUM NIL :INTERFACE
     NIL :ALLOW-NULL-P NIL))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-EVENT ("river_window_v1"
                                                            "app_id" :OPCODE 3
                                                            :DESCRIPTION "
        The window set an application ID.

        The app_id argument will be null if the window has never set an
        application ID or if the window cleared its application ID. (Xwayland
        windows may do this for example, though xdg-toplevels may not.)

        This event will be followed by a manage_start event after all other new
        state has been sent by the server.
      "
                                                            :DESTRUCTOR-P NIL
                                                            :SINCE NIL :EXPORT
                                                            T)
    ("app_id" STRING :ENUM NIL :INTERFACE NIL :ALLOW-NULL-P T))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-EVENT ("river_window_v1"
                                                            "title" :OPCODE 4
                                                            :DESCRIPTION "
        The window set a title.

        The title argument will be null if the window has never set a title or
        if the window cleared its title. (Xwayland windows may do this for
        example, though xdg-toplevels may not.)

        This event will be followed by a manage_start event after all other new
        state has been sent by the server.
      "
                                                            :DESTRUCTOR-P NIL
                                                            :SINCE NIL :EXPORT
                                                            T)
    ("title" STRING :ENUM NIL :INTERFACE NIL :ALLOW-NULL-P T))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-EVENT ("river_window_v1"
                                                            "parent" :OPCODE 5
                                                            :DESCRIPTION "
        The window set a parent window. If this event is never received or if
        the parent argument is null then the window has no parent.

        A surface with a parent set might be a dialog, file picker, or similar
        for the parent window.

        Child windows should generally be rendered directly above their parent.

        The compositor must guarantee that there are no loops in the window
        tree: a parent must not be the descendant of one of its children.

        This event will be followed by a manage_start event after all other new
        state has been sent by the server.
      "
                                                            :DESTRUCTOR-P NIL
                                                            :SINCE NIL :EXPORT
                                                            T)
    ("parent" COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:OBJECT :ENUM NIL
     :INTERFACE "river_window_v1" :ALLOW-NULL-P T))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-EVENT ("river_window_v1"
                                                            "decoration_hint"
                                                            :OPCODE 6
                                                            :DESCRIPTION "
        Information from the window about the supported and preferred client
        side/server side decoration options.

        This event may be sent multiple times over the lifetime of the window if
        the window changes its preferences.

        This event will be followed by a manage_start event after all other new
        state has been sent by the server.
      "
                                                            :DESTRUCTOR-P NIL
                                                            :SINCE NIL :EXPORT
                                                            T)
    ("hint" COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:UINT :ENUM
     "decoration_hint" :INTERFACE NIL :ALLOW-NULL-P NIL))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-EVENT ("river_window_v1"
                                                            "pointer_move_requested"
                                                            :OPCODE 7
                                                            :DESCRIPTION "
        This event informs the window manager that the window has requested to
        be interactively moved using the pointer. The seat argument indicates the
        seat for the move.

        The xdg-shell protocol for example allows windows to request that an
        interactive move be started, perhaps when a client-side rendered
        titlebar is dragged.

        The window manager may use the river_seat_v1.op_start_pointer request to
        interactively move the window or ignore this event entirely.

        This event will be followed by a manage_start event after all other new
        state has been sent by the server.
      "
                                                            :DESTRUCTOR-P NIL
                                                            :SINCE NIL :EXPORT
                                                            T)
    ("seat" COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:OBJECT :ENUM NIL :INTERFACE
     "river_seat_v1" :ALLOW-NULL-P NIL))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-EVENT ("river_window_v1"
                                                            "pointer_resize_requested"
                                                            :OPCODE 8
                                                            :DESCRIPTION "
        This event informs the window manager that the window has requested to
        be interactively resized using the pointer. The seat argument indicates
        the seat for the resize.

        The edges argument indicates which edges the window has requested to be
        resized from. The edges argument will never be none and will never have
        both top and bottom or both left and right edges set.

        The xdg-shell protocol for example allows windows to request that an
        interactive resize be started, perhaps when the corner of client-side
        rendered decorations is dragged.

        The window manager may use the river_seat_v1.op_start_pointer request to
        interactively resize the window or ignore this event entirely.

        This event will be followed by a manage_start event after all other new
        state has been sent by the server.
      "
                                                            :DESTRUCTOR-P NIL
                                                            :SINCE NIL :EXPORT
                                                            T)
    ("seat" COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:OBJECT :ENUM NIL :INTERFACE
     "river_seat_v1" :ALLOW-NULL-P NIL)
    ("edges" COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:UINT :ENUM "edges"
     :INTERFACE NIL :ALLOW-NULL-P NIL))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-EVENT ("river_window_v1"
                                                            "show_window_menu_requested"
                                                            :OPCODE 9
                                                            :DESCRIPTION "
        The xdg-shell protocol for example allows windows to request that a
        window menu be shown, for example when the user right clicks on client
        side window decorations.

        A window menu might include options to maximize or minimize the window.

        The window manager is free to ignore this request and decide what the
        window menu contains if it does choose to show one.

        The x and y arguments indicate where the window requested that the
        window menu be shown.

        This event will be followed by a manage_start event after all other new
        state has been sent by the server.
      "
                                                            :DESTRUCTOR-P NIL
                                                            :SINCE NIL :EXPORT
                                                            T)
    ("x" COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:INT :ENUM NIL :INTERFACE NIL
     :ALLOW-NULL-P NIL)
    ("y" COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:INT :ENUM NIL :INTERFACE NIL
     :ALLOW-NULL-P NIL))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-EVENT ("river_window_v1"
                                                            "maximize_requested"
                                                            :OPCODE 10
                                                            :DESCRIPTION "
        The xdg-shell protocol for example allows windows to request to be
        maximized.

        The window manager is free to honor this request using
        river_window_v1.inform_maximize or ignore it.

        This event will be followed by a manage_start event after all other new
        state has been sent by the server.
      "
                                                            :DESTRUCTOR-P NIL
                                                            :SINCE NIL :EXPORT
                                                            T))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-EVENT ("river_window_v1"
                                                            "unmaximize_requested"
                                                            :OPCODE 11
                                                            :DESCRIPTION "
        The xdg-shell protocol for example allows windows to request to be
        unmaximized.

        The window manager is free to honor this request using
        river_window_v1.inform_unmaximized or ignore it.

        This event will be followed by a manage_start event after all other new
        state has been sent by the server.
      "
                                                            :DESTRUCTOR-P NIL
                                                            :SINCE NIL :EXPORT
                                                            T))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-EVENT ("river_window_v1"
                                                            "fullscreen_requested"
                                                            :OPCODE 12
                                                            :DESCRIPTION "
        The xdg-shell protocol for example allows windows to request that they
        be made fullscreen and allows them to provide an output preference.

        The window manager is free to honor this request using
        river_window_v1.fullscreen or ignore it.

        This event will be followed by a manage_start event after all other new
        state has been sent by the server.
      "
                                                            :DESTRUCTOR-P NIL
                                                            :SINCE NIL :EXPORT
                                                            T)
    ("output" COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:OBJECT :ENUM NIL
     :INTERFACE "river_output_v1" :ALLOW-NULL-P T))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-EVENT ("river_window_v1"
                                                            "exit_fullscreen_requested"
                                                            :OPCODE 13
                                                            :DESCRIPTION "
        The xdg-shell protocol for example allows windows to request to exit
        fullscreen.

        The window manager is free to honor this request using
        river_window_v1.exit_fullscreen or ignore it.

        This event will be followed by a manage_start event after all other new
        state has been sent by the server.
      "
                                                            :DESTRUCTOR-P NIL
                                                            :SINCE NIL :EXPORT
                                                            T))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-EVENT ("river_window_v1"
                                                            "minimize_requested"
                                                            :OPCODE 14
                                                            :DESCRIPTION "
        The xdg-shell protocol for example allows windows to request to be
        minimized.

        The window manager is free to ignore this request, hide the window, or
        do whatever else it chooses.

        This event will be followed by a manage_start event after all other new
        state has been sent by the server.
      "
                                                            :DESTRUCTOR-P NIL
                                                            :SINCE NIL :EXPORT
                                                            T))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-EVENT ("river_window_v1"
                                                            "unreliable_pid"
                                                            :OPCODE 15
                                                            :DESCRIPTION "
        This event gives an unreliable PID of the process that created the
        window. Obtaining this information is inherently racy due to PID reuse.
        Therefore, this PID must not be used for anything security sensitive.

        Note also that a single process may create multiple windows, so there is
        not necessarily a 1-to-1 mapping from PID to window. Multiple windows
        may have the same PID.

        This event is sent once when the river_window_v1 is created and never
        sent again.
      "
                                                            :DESTRUCTOR-P NIL
                                                            :SINCE 2 :EXPORT T)
    ("unreliable_pid" COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:INT :ENUM NIL
     :INTERFACE NIL :ALLOW-NULL-P NIL)))
 (PROGN
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-INTERFACE
   "river_decoration_v1" :EXPORT T :DESCRIPTION "
      The rendering order of windows with decorations is follows:

      1. Decorations created with get_decoration_below at the bottom
      2. Window content
      3. Borders configured with river_window_v1.set_borders
      4. Decorations created with get_decoration_above at the top

      The relative ordering of decoration surfaces above/below a window is
      undefined by this protocol and left up to the compositor.
    ")
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-ENUM ("river_decoration_v1"
                                                           "error" :DESCRIPTION
                                                           NIL :BITFIELD-P NIL
                                                           :EXPORT T)
    (:NO-COMMIT 0
     "failed to commit the surface before the window manager commit"))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-REQUEST ("river_decoration_v1"
                                                              "destroy" :OPCODE
                                                              0 :DESCRIPTION "
        This request indicates that the client will no longer use the decoration
        object and that it may be safely destroyed.
      "
                                                              :DESTRUCTOR-P T
                                                              :SINCE NIL
                                                              :EXPORT T))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-REQUEST ("river_decoration_v1"
                                                              "set_offset"
                                                              :OPCODE 1
                                                              :DESCRIPTION "
        This request sets the offset of the decoration surface from the top left
        corner of the window.

        If this request is never sent, the x and y offsets are undefined by this
        protocol and left up to the compositor.

        This request modifies rendering state and may only be made as part of a
        render sequence, see the river_window_manager_v1 description.
      "
                                                              :DESTRUCTOR-P NIL
                                                              :SINCE NIL
                                                              :EXPORT T)
    ("x" COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:INT :ENUM NIL :INTERFACE NIL
     :ALLOW-NULL-P NIL)
    ("y" COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:INT :ENUM NIL :INTERFACE NIL
     :ALLOW-NULL-P NIL))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-REQUEST ("river_decoration_v1"
                                                              "sync_next_commit"
                                                              :OPCODE 2
                                                              :DESCRIPTION "
        Synchronize application of the next wl_surface.commit request on the
        decoration surface with rest of the state atomically applied with the
        next river_window_manager_v1.render_finish request.

        The client must make a wl_surface.commit request on the decoration
        surface after this request and before the render_finish request, failure
        to do so is a protocol error.

        This request modifies rendering state and may only be made as part of a
        render sequence, see the river_window_manager_v1 description.
      "
                                                              :DESTRUCTOR-P NIL
                                                              :SINCE NIL
                                                              :EXPORT T)))
 (PROGN
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-INTERFACE
   "river_shell_surface_v1" :EXPORT T :DESCRIPTION "
      The window manager might use a shell surface to display a status bar,
      background image, desktop notifications, launcher, desktop menu, or
      whatever else it wants.
    ")
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-ENUM ("river_shell_surface_v1"
                                                           "error" :DESCRIPTION
                                                           NIL :BITFIELD-P NIL
                                                           :EXPORT T)
    (:NODE-EXISTS 0 "shell surface already has a node object")
    (:NO-COMMIT 1
     "failed to commit the surface before the window manager commit"))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-REQUEST ("river_shell_surface_v1"
                                                              "destroy" :OPCODE
                                                              0 :DESCRIPTION "
        This request indicates that the client will no longer use the shell
        surface object and that it may be safely destroyed.
      "
                                                              :DESTRUCTOR-P T
                                                              :SINCE NIL
                                                              :EXPORT T))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-REQUEST ("river_shell_surface_v1"
                                                              "get_node"
                                                              :OPCODE 1
                                                              :DESCRIPTION "
        Get the node in the render list corresponding to the shell surface.

        It is a protocol error to make this request more than once for a single
        shell surface.
      "
                                                              :DESTRUCTOR-P NIL
                                                              :SINCE NIL
                                                              :EXPORT T)
    ("id" COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:NEW-ID :ENUM NIL
     :INTERFACE "river_node_v1" :ALLOW-NULL-P NIL))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-REQUEST ("river_shell_surface_v1"
                                                              "sync_next_commit"
                                                              :OPCODE 2
                                                              :DESCRIPTION "
        Synchronize application of the next wl_surface.commit request on the
        shell surface with rest of the rendering state atomically applied with
        the next river_window_manager_v1.render_finish request.

        The client must make a wl_surface.commit request on the shell surface
        after this request and before the render_finish request, failure to do
        so is a protocol error.

        This request modifies rendering state and may only be made as part of a
        render sequence, see the river_window_manager_v1 description.
      "
                                                              :DESTRUCTOR-P NIL
                                                              :SINCE NIL
                                                              :EXPORT T)))
 (PROGN
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-INTERFACE "river_node_v1"
                                                               :EXPORT T
                                                               :DESCRIPTION "
      The render list is a list of nodes that determines the rendering order of
      the compositor. Nodes may correspond to windows or shell surfaces. The
      relative ordering of nodes may be changed with the place_above and
      place_below requests, changing the rendering order.

      The initial position of a node in the render list is undefined, the window
      manager client must use the place_above or place_below request to
      guarantee a specific rendering order.
    ")
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-REQUEST ("river_node_v1"
                                                              "destroy" :OPCODE
                                                              0 :DESCRIPTION "
        This request indicates that the client will no longer use the node
        object and that it may be safely destroyed.
      "
                                                              :DESTRUCTOR-P T
                                                              :SINCE NIL
                                                              :EXPORT T))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-REQUEST ("river_node_v1"
                                                              "set_position"
                                                              :OPCODE 1
                                                              :DESCRIPTION "
        Set the absolute position of the node in the compositor's logical
        coordinate space. The x and y coordinates may be positive or negative.

        Note that the position of a river_window_v1 refers to the position of
        the window content and is unaffected by the presence of borders or
        decoration surfaces.

        If this request is never sent, the position of the node is undefined by
        this protocol and left up to the compositor.

        This request modifies rendering state and may only be made as part of a
        render sequence, see the river_window_manager_v1 description.
      "
                                                              :DESTRUCTOR-P NIL
                                                              :SINCE NIL
                                                              :EXPORT T)
    ("x" COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:INT :ENUM NIL :INTERFACE NIL
     :ALLOW-NULL-P NIL)
    ("y" COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:INT :ENUM NIL :INTERFACE NIL
     :ALLOW-NULL-P NIL))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-REQUEST ("river_node_v1"
                                                              "place_top"
                                                              :OPCODE 2
                                                              :DESCRIPTION "
        This request places the node above all other nodes in the compositor's
        render list.

        This request modifies rendering state and may only be made as part of a
        render sequence, see the river_window_manager_v1 description.
      "
                                                              :DESTRUCTOR-P NIL
                                                              :SINCE NIL
                                                              :EXPORT T))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-REQUEST ("river_node_v1"
                                                              "place_bottom"
                                                              :OPCODE 3
                                                              :DESCRIPTION "
        This request places the node below all other nodes in the compositor's
        render list.

        This request modifies rendering state and may only be made as part of a
        render sequence, see the river_window_manager_v1 description.
      "
                                                              :DESTRUCTOR-P NIL
                                                              :SINCE NIL
                                                              :EXPORT T))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-REQUEST ("river_node_v1"
                                                              "place_above"
                                                              :OPCODE 4
                                                              :DESCRIPTION "
        This request places the node directly above another node in the
        compositor's render list.

        Attempting to place a node above itself has no effect.

        This request modifies rendering state and may only be made as part of a
        render sequence, see the river_window_manager_v1 description.
      "
                                                              :DESTRUCTOR-P NIL
                                                              :SINCE NIL
                                                              :EXPORT T)
    ("other" COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:OBJECT :ENUM NIL
     :INTERFACE "river_node_v1" :ALLOW-NULL-P NIL))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-REQUEST ("river_node_v1"
                                                              "place_below"
                                                              :OPCODE 5
                                                              :DESCRIPTION "
        This request places the node directly below another node in the
        compositor's render list.

        Attempting to place a node below itself has no effect.

        This request modifies rendering state and may only be made as part of a
        render sequence, see the river_window_manager_v1 description.
      "
                                                              :DESTRUCTOR-P NIL
                                                              :SINCE NIL
                                                              :EXPORT T)
    ("other" COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:OBJECT :ENUM NIL
     :INTERFACE "river_node_v1" :ALLOW-NULL-P NIL)))
 (PROGN
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-INTERFACE
   "river_output_v1" :EXPORT T :DESCRIPTION "
      An area in the compositor's logical coordinate space that should be
      treated as a single output for window management purposes. This area may
      correspond to a single physical output or multiple physical outputs in the
      case of mirroring or tiled monitors depending on the hardware and
      compositor configuration.
    ")
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-REQUEST ("river_output_v1"
                                                              "destroy" :OPCODE
                                                              0 :DESCRIPTION "
        This request indicates that the client will no longer use the output
        object and that it may be safely destroyed.

        This request should be made after the river_output_v1.removed event is
        received to complete destruction of the output.
      "
                                                              :DESTRUCTOR-P T
                                                              :SINCE NIL
                                                              :EXPORT T))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-EVENT ("river_output_v1"
                                                            "removed" :OPCODE 0
                                                            :DESCRIPTION "
        This event indicates that the logical output is no longer conceptually
        part of window management space.

        The server will send no further events on this object and ignore any
        request (other than river_output_v1.destroy) made after this event is
        sent. The client should destroy this object with the
        river_output_v1.destroy request to free up resources.

        This event may be sent because a corresponding physical output has been
        physically unplugged or because some output configuration has changed.

        This event will be followed by a manage_start event after all other new
        state has been sent by the server.
      "
                                                            :DESTRUCTOR-P NIL
                                                            :SINCE NIL :EXPORT
                                                            T))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-EVENT ("river_output_v1"
                                                            "wl_output" :OPCODE
                                                            1 :DESCRIPTION "
        The wl_output object corresponding to the river_output_v1. The argument
        is the global name of the wl_output advertised with wl_registry.global.

        It is guaranteed that the corresponding wl_output is advertised before
        this event is sent.

        This event is sent exactly once. The wl_output associated with a
        river_output_v1 cannot change. It is guaranteed that there is a 1-to-1
        mapping between wl_output and river_output_v1 objects.

        The global_remove event for the corresponding wl_output may be sent
        before the river_output_v1.remove event. This is due to the fact that
        river_output_v1 state changes are synced to the river window management
        manage sequence while changes to globals are not.

        Rationale: The window manager may need information provided by the
        wl_output interface such as the name/description. It also may need the
        wl_output object to start screencopy for example.
      "
                                                            :DESTRUCTOR-P NIL
                                                            :SINCE NIL :EXPORT
                                                            T)
    ("name" COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:UINT :ENUM NIL :INTERFACE
     NIL :ALLOW-NULL-P NIL))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-EVENT ("river_output_v1"
                                                            "position" :OPCODE
                                                            2 :DESCRIPTION "
        This event indicates the position of the output in the compositor's
        logical coordinate space. The x and y coordinates may be positive or
        negative.

        This event is sent once when the river_output_v1 is created and again
        whenever the position changes.

        This event will be followed by a manage_start event after all other new
        state has been sent by the server.

        The server must guarantee that the position and dimensions events do not
        cause the areas of multiple logical outputs to overlap when the
        corresponding manage_start event is received.
      "
                                                            :DESTRUCTOR-P NIL
                                                            :SINCE NIL :EXPORT
                                                            T)
    ("x" COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:INT :ENUM NIL :INTERFACE NIL
     :ALLOW-NULL-P NIL)
    ("y" COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:INT :ENUM NIL :INTERFACE NIL
     :ALLOW-NULL-P NIL))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-EVENT ("river_output_v1"
                                                            "dimensions"
                                                            :OPCODE 3
                                                            :DESCRIPTION "
        This event indicates the dimensions of the output in the compositor's
        logical coordinate space. The width and height will always be strictly
        greater than zero.

        This event is sent once when the river_output_v1 is created and again
        whenever the dimensions change.

        This event will be followed by a manage_start event after all other new
        state has been sent by the server.

        The server must guarantee that the position and dimensions events do not
        cause the areas of multiple logical outputs to overlap when the
        corresponding manage_start event is received.
      "
                                                            :DESTRUCTOR-P NIL
                                                            :SINCE NIL :EXPORT
                                                            T)
    ("width" COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:INT :ENUM NIL :INTERFACE
     NIL :ALLOW-NULL-P NIL)
    ("height" COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:INT :ENUM NIL :INTERFACE
     NIL :ALLOW-NULL-P NIL)))
 (PROGN
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-INTERFACE "river_seat_v1"
                                                               :EXPORT T
                                                               :DESCRIPTION "
      This object represents a single user's collection of input devices. It
      allows the window manager to route keyboard input to windows, get
      high-level information about pointer input, define keyboard and pointer
      bindings, etc.

      TODO:
        - touch input
        - tablet input
    ")
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-ENUM ("river_seat_v1"
                                                           "modifiers"
                                                           :DESCRIPTION "
        This enum is used to describe the keyboard modifiers that must be held
        down to trigger a key binding or pointer binding.

        Note that river and wlroots use the values 2 and 16 for capslock and
        numlock internally. It doesn't make sense to use locked modifiers for
        bindings however so these values are not included in this enum.
      "
                                                           :BITFIELD-P T
                                                           :EXPORT T)
    (:NONE 0 NIL)
    (:SHIFT 1 NIL)
    (:CTRL 4 NIL)
    (:MOD1 8 "commonly called alt")
    (:MOD3 32 NIL)
    (:MOD4 64 "commonly called super or logo")
    (:MOD5 128 NIL))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-REQUEST ("river_seat_v1"
                                                              "destroy" :OPCODE
                                                              0 :DESCRIPTION "
        This request indicates that the client will no longer use the seat
        object and that it may be safely destroyed.

        This request should be made after the river_seat_v1.removed event is
        received to complete destruction of the seat.
      "
                                                              :DESTRUCTOR-P T
                                                              :SINCE NIL
                                                              :EXPORT T))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-REQUEST ("river_seat_v1"
                                                              "focus_window"
                                                              :OPCODE 1
                                                              :DESCRIPTION "
        Request that the compositor send keyboard input to the given window.

        This request modifies window management state and may only be made as
        part of a manage sequence, see the river_window_manager_v1 description.
      "
                                                              :DESTRUCTOR-P NIL
                                                              :SINCE NIL
                                                              :EXPORT T)
    ("window" COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:OBJECT :ENUM NIL
     :INTERFACE "river_window_v1" :ALLOW-NULL-P NIL))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-REQUEST ("river_seat_v1"
                                                              "focus_shell_surface"
                                                              :OPCODE 2
                                                              :DESCRIPTION "
        Request that the compositor send keyboard input to the given shell
        surface.

        This request modifies window management state and may only be made as
        part of a manage sequence, see the river_window_manager_v1 description.
      "
                                                              :DESTRUCTOR-P NIL
                                                              :SINCE NIL
                                                              :EXPORT T)
    ("shell_surface" COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:OBJECT :ENUM NIL
     :INTERFACE "river_shell_surface_v1" :ALLOW-NULL-P NIL))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-REQUEST ("river_seat_v1"
                                                              "clear_focus"
                                                              :OPCODE 3
                                                              :DESCRIPTION "
        Request that the compositor not send keyboard input to any client.

        This request modifies window management state and may only be made as
        part of a manage sequence, see the river_window_manager_v1 description.
      "
                                                              :DESTRUCTOR-P NIL
                                                              :SINCE NIL
                                                              :EXPORT T))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-REQUEST ("river_seat_v1"
                                                              "op_start_pointer"
                                                              :OPCODE 4
                                                              :DESCRIPTION "
        Start an interactive pointer operation. During the operation, op_delta
        events will be sent based on pointer input.

        When all pointer buttons are released, the op_release event is sent.

        The pointer operation continues until the op_end request is made during
        a manage sequence and that manage sequence is finished.

        The window manager may use this operation to implement interactive
        move/resize of windows by setting the position of windows and proposing
        dimensions based off of the op_delta events.

        This request is ignored if an operation is already in progress.

        This request modifies window management state and may only be made as
        part of a manage sequence, see the river_window_manager_v1 description.
      "
                                                              :DESTRUCTOR-P NIL
                                                              :SINCE NIL
                                                              :EXPORT T))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-REQUEST ("river_seat_v1"
                                                              "op_end" :OPCODE
                                                              5 :DESCRIPTION "
        End an interactive operation.

        This request is ignored if there is no operation in progress.

        This request modifies window management state and may only be made as
        part of a manage sequence, see the river_window_manager_v1 description.
      "
                                                              :DESTRUCTOR-P NIL
                                                              :SINCE NIL
                                                              :EXPORT T))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-REQUEST ("river_seat_v1"
                                                              "get_pointer_binding"
                                                              :OPCODE 6
                                                              :DESCRIPTION "
        Define a pointer binding in terms of a pointer button, keyboard
        modifiers, and other configurable properties.

        The button argument is a Linux input event code defined in the
        linux/input-event-codes.h header file (e.g. BTN_RIGHT).

        The new pointer binding is not enabled until initial configuration is
        completed and the enable request is made during a manage sequence.
      "
                                                              :DESTRUCTOR-P NIL
                                                              :SINCE NIL
                                                              :EXPORT T)
    ("id" COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:NEW-ID :ENUM NIL
     :INTERFACE "river_pointer_binding_v1" :ALLOW-NULL-P NIL)
    ("button" COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:UINT :ENUM NIL :INTERFACE
     NIL :ALLOW-NULL-P NIL)
    ("modifiers" COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:UINT :ENUM "modifiers"
     :INTERFACE NIL :ALLOW-NULL-P NIL))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-REQUEST ("river_seat_v1"
                                                              "set_xcursor_theme"
                                                              :OPCODE 7
                                                              :DESCRIPTION "
        Set the XCursor theme for the seat. This theme is used for cursors
        rendered by the compositor, but not necessarily for cursors rendered by
        clients.

        Note: The window manager may also wish to set the XCURSOR_THEME and
        XCURSOR_SIZE environment variable for programs it starts.
      "
                                                              :DESTRUCTOR-P NIL
                                                              :SINCE 2 :EXPORT
                                                              T)
    ("name" STRING :ENUM NIL :INTERFACE NIL :ALLOW-NULL-P NIL)
    ("size" COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:UINT :ENUM NIL :INTERFACE
     NIL :ALLOW-NULL-P NIL))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-REQUEST ("river_seat_v1"
                                                              "pointer_warp"
                                                              :OPCODE 8
                                                              :DESCRIPTION "
        Warp the pointer to the given position in the compositor's logical
        coordinate space.

        If the given position is outside the bounds of all outputs, the pointer
        will be warped to the closest point inside an output instead.

        This request modifies window management state and may only be made as
        part of a manage sequence, see the river_window_manager_v1 description.
      "
                                                              :DESTRUCTOR-P NIL
                                                              :SINCE 3 :EXPORT
                                                              T)
    ("x" COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:INT :ENUM NIL :INTERFACE NIL
     :ALLOW-NULL-P NIL)
    ("y" COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:INT :ENUM NIL :INTERFACE NIL
     :ALLOW-NULL-P NIL))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-EVENT ("river_seat_v1"
                                                            "removed" :OPCODE 0
                                                            :DESCRIPTION "
        This event indicates that seat is no longer in use and should be
        destroyed.

        The server will send no further events on this object and ignore any
        request (other than river_seat_v1.destroy) made after this event is
        sent.  The client should destroy this object with the
        river_seat_v1.destroy request to free up resources.

        This event will be followed by a manage_start event after all other new
        state has been sent by the server.
      "
                                                            :DESTRUCTOR-P NIL
                                                            :SINCE NIL :EXPORT
                                                            T))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-EVENT ("river_seat_v1"
                                                            "wl_seat" :OPCODE 1
                                                            :DESCRIPTION "
        The wl_seat object corresponding to the river_seat_v1. The argument is
        the global name of the wl_seat advertised with wl_registry.global.

        It is guaranteed that the corresponding wl_seat is advertised before
        this event is sent.

        This event is sent exactly once. The wl_seat associated with a
        river_seat_v1 cannot change. It is guaranteed that there is a 1-to-1
        mapping between wl_seat and river_seat_v1 objects.

        The global_remove event for the corresponding wl_seat may be sent before
        the river_seat_v1.remove event. This is due to the fact that
        river_seat_v1 state changes are synced to the river window management
        manage sequence while changes to globals are not.

        Rationale: The window manager may want to trigger window management
        state changes based on normal input events received by its shell
        surfaces for example.
      "
                                                            :DESTRUCTOR-P NIL
                                                            :SINCE NIL :EXPORT
                                                            T)
    ("name" COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:UINT :ENUM NIL :INTERFACE
     NIL :ALLOW-NULL-P NIL))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-EVENT ("river_seat_v1"
                                                            "pointer_enter"
                                                            :OPCODE 2
                                                            :DESCRIPTION "
        The seat's pointer entered the given window's area.

        The area of a window is defined to include the area defined by the
        window dimensions, borders configured using river_window_v1.set_borders,
        and the input regions of decoration surfaces. In particular, it does not
        include input regions of surfaces belonging to the window that extend
        outside the window dimensions.

        The pointer of a seat may only enter a single window at a time. When the
        pointer moves between windows, the pointer_leave event for the old
        window must be sent before the pointer_enter event for the new window.

        This event will be followed by a manage_start event after all other new
        state has been sent by the server.
      "
                                                            :DESTRUCTOR-P NIL
                                                            :SINCE NIL :EXPORT
                                                            T)
    ("window" COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:OBJECT :ENUM NIL
     :INTERFACE "river_window_v1" :ALLOW-NULL-P NIL))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-EVENT ("river_seat_v1"
                                                            "pointer_leave"
                                                            :OPCODE 3
                                                            :DESCRIPTION "
        The seat's pointer left the window for which pointer_enter was most
        recently sent. See pointer_enter for details.

        This event will be followed by a manage_start event after all other new
        state has been sent by the server.
      "
                                                            :DESTRUCTOR-P NIL
                                                            :SINCE NIL :EXPORT
                                                            T))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-EVENT ("river_seat_v1"
                                                            "window_interaction"
                                                            :OPCODE 4
                                                            :DESCRIPTION "
        A window has been interacted with beyond the pointer merely passing over
        it. This event might be sent due to a pointer button press or due to a
        touch/tablet tool interaction with the window.

        There are no guarantees regarding how this event is sent in relation to
        the pointer_enter and pointer_leave events as the interaction may use
        touch or tablet tool input.

        Rationale: this event gives window managers necessary information to
        determine when to send keyboard focus, raise a window that already has
        keyboard focus, etc. Rather than expose all pointer, touch, and tablet
        events to window managers, a policy over mechanism approach is taken.

        This event will be followed by a manage_start event after all other new
        state has been sent by the server.
      "
                                                            :DESTRUCTOR-P NIL
                                                            :SINCE NIL :EXPORT
                                                            T)
    ("window" COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:OBJECT :ENUM NIL
     :INTERFACE "river_window_v1" :ALLOW-NULL-P NIL))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-EVENT ("river_seat_v1"
                                                            "shell_surface_interaction"
                                                            :OPCODE 5
                                                            :DESCRIPTION "
        A shell surface has been interacted with beyond the pointer merely
        passing over it. This event might be sent due to a pointer button press
        or due to a touch/tablet tool interaction with the shell_surface.

        There are no guarantees regarding how this event is sent in relation to
        the pointer_enter and pointer_leave events as the interaction may use
        touch or tablet tool input.

        Rationale: While the shell surface does receive all wl_pointer,
        wl_touch, etc. input events for the surface directly, these events do
        not necessarily trigger a manage sequence and therefore do not allow the
        window manager to update focus or perform other actions in response to
        the input in a race-free way.

        This event will be followed by a manage_start event after all other new
        state has been sent by the server.
      "
                                                            :DESTRUCTOR-P NIL
                                                            :SINCE NIL :EXPORT
                                                            T)
    ("shell_surface" COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:OBJECT :ENUM NIL
     :INTERFACE "river_shell_surface_v1" :ALLOW-NULL-P NIL))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-EVENT ("river_seat_v1"
                                                            "op_delta" :OPCODE
                                                            6 :DESCRIPTION "
        This event indicates the total change in position since the start of the
        operation of the pointer/touch point/etc.

        This event will be followed by a manage_start event after all other new
        state has been sent by the server.
      "
                                                            :DESTRUCTOR-P NIL
                                                            :SINCE NIL :EXPORT
                                                            T)
    ("dx" COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:INT :ENUM NIL :INTERFACE NIL
     :ALLOW-NULL-P NIL)
    ("dy" COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:INT :ENUM NIL :INTERFACE NIL
     :ALLOW-NULL-P NIL))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-EVENT ("river_seat_v1"
                                                            "op_release"
                                                            :OPCODE 7
                                                            :DESCRIPTION "
        The input driving the current interactive operation has been released.
        For a pointer op for example, all pointer buttons have been released.

        Depending on the op type, op_delta events may continue to be sent until
        the op is ended with the op_end request.

        This event is sent at most once during an interactive operation.

        This event will be followed by a manage_start event after all other new
        state has been sent by the server.
      "
                                                            :DESTRUCTOR-P NIL
                                                            :SINCE NIL :EXPORT
                                                            T))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-EVENT ("river_seat_v1"
                                                            "pointer_position"
                                                            :OPCODE 8
                                                            :DESCRIPTION "
        The current position of the pointer in the compositor's logical
        coordinate space.

        This state is special in that a change in pointer position alone must
        not cause the compositor to start a manage sequence.

        Assuming the seat has a pointer, this event must be sent in every manage
        sequence unless there is no change in x/y position since the last time this
        event was sent.
      "
                                                            :DESTRUCTOR-P NIL
                                                            :SINCE 2 :EXPORT T)
    ("x" COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:INT :ENUM NIL :INTERFACE NIL
     :ALLOW-NULL-P NIL)
    ("y" COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:INT :ENUM NIL :INTERFACE NIL
     :ALLOW-NULL-P NIL)))
 (PROGN
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-INTERFACE
   "river_pointer_binding_v1" :EXPORT T :DESCRIPTION "
      This object allows the window manager to configure a pointer binding and
      receive events when the binding is triggered.

      The new pointer binding is not enabled until the enable request is made
      during a manage sequence.

      Normally, all pointer button events are sent to the surface with pointer
      focus by the compositor. Pointer button events that trigger a pointer
      binding are not sent to the surface with pointer focus.

      If multiple pointer bindings would be triggered by a single physical
      pointer event on the compositor side, it is compositor policy which
      pointer binding(s) will receive press/release events or if all of the
      matched pointer bindings receive press/release events.
    ")
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-REQUEST ("river_pointer_binding_v1"
                                                              "destroy" :OPCODE
                                                              0 :DESCRIPTION "
        This request indicates that the client will no longer use the pointer
        binding object and that it may be safely destroyed.
      "
                                                              :DESTRUCTOR-P T
                                                              :SINCE NIL
                                                              :EXPORT T))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-REQUEST ("river_pointer_binding_v1"
                                                              "enable" :OPCODE
                                                              1 :DESCRIPTION "
        This request should be made after all initial configuration has been
        completed and the window manager wishes the pointer binding to be able
        to be triggered.

        This request modifies window management state and may only be made as
        part of a manage sequence, see the river_window_manager_v1 description.
      "
                                                              :DESTRUCTOR-P NIL
                                                              :SINCE NIL
                                                              :EXPORT T))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-REQUEST ("river_pointer_binding_v1"
                                                              "disable" :OPCODE
                                                              2 :DESCRIPTION "
        This request may be used to temporarily disable the pointer binding. It
        may be later re-enabled with the enable request.

        This request modifies window management state and may only be made as
        part of a manage sequence, see the river_window_manager_v1 description.
      "
                                                              :DESTRUCTOR-P NIL
                                                              :SINCE NIL
                                                              :EXPORT T))
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-EVENT ("river_pointer_binding_v1"
                                                            "pressed" :OPCODE 0
                                                            :DESCRIPTION "
        This event indicates that the pointer button triggering the binding has
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
  (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:DEFINE-EVENT ("river_pointer_binding_v1"
                                                            "released" :OPCODE
                                                            1 :DESCRIPTION "
        This event indicates that the pointer button triggering the binding has
        been released.

        Releasing the modifiers for the binding without releasing the pointer
        button does not trigger the release event. This event is sent when the
        pointer button is released, even if the modifiers have changed since the
        pressed event.

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
                                                            T)))
 (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:INITIALIZE-INTERFACE "river_window_manager_v1"
     3
   (("stop" NIL) ("destroy" NIL) ("manage_finish" NIL) ("manage_dirty" NIL)
    ("render_finish" NIL)
    ("get_shell_surface" NIL
     (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:NEW-ID NIL
      "river_shell_surface_v1")
     (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:OBJECT NIL "wl_surface")))
   (("unavailable" NIL) ("finished" NIL) ("manage_start" NIL)
    ("render_start" NIL) ("session_locked" NIL) ("session_unlocked" NIL)
    ("window" NIL
     (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:NEW-ID NIL "river_window_v1"))
    ("output" NIL
     (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:NEW-ID NIL "river_output_v1"))
    ("seat" NIL
     (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:NEW-ID NIL "river_seat_v1"))))
 (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:INITIALIZE-INTERFACE "river_window_v1"
     3
   (("destroy" NIL) ("close" NIL)
    ("get_node" NIL
     (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:NEW-ID NIL "river_node_v1"))
    ("propose_dimensions" NIL
     (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:INT NIL NIL)
     (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:INT NIL NIL))
    ("hide" NIL) ("show" NIL) ("use_csd" NIL) ("use_ssd" NIL)
    ("set_borders" NIL (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:UINT NIL NIL)
     (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:INT NIL NIL)
     (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:UINT NIL NIL)
     (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:UINT NIL NIL)
     (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:UINT NIL NIL)
     (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:UINT NIL NIL))
    ("set_tiled" NIL (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:UINT NIL NIL))
    ("get_decoration_above" NIL
     (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:NEW-ID NIL
      "river_decoration_v1")
     (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:OBJECT NIL "wl_surface"))
    ("get_decoration_below" NIL
     (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:NEW-ID NIL
      "river_decoration_v1")
     (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:OBJECT NIL "wl_surface"))
    ("inform_resize_start" NIL) ("inform_resize_end" NIL)
    ("set_capabilities" NIL
     (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:UINT NIL NIL))
    ("inform_maximized" NIL) ("inform_unmaximized" NIL)
    ("inform_fullscreen" NIL) ("inform_not_fullscreen" NIL)
    ("fullscreen" NIL
     (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:OBJECT NIL "river_output_v1"))
    ("exit_fullscreen" NIL)
    ("set_clip_box" 2 (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:INT NIL NIL)
     (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:INT NIL NIL)
     (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:INT NIL NIL)
     (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:INT NIL NIL))
    ("set_content_clip_box" 3
     (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:INT NIL NIL)
     (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:INT NIL NIL)
     (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:INT NIL NIL)
     (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:INT NIL NIL)))
   (("closed" NIL)
    ("dimensions_hint" NIL
     (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:INT NIL NIL)
     (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:INT NIL NIL)
     (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:INT NIL NIL)
     (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:INT NIL NIL))
    ("dimensions" NIL (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:INT NIL NIL)
     (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:INT NIL NIL))
    ("app_id" NIL (STRING T NIL)) ("title" NIL (STRING T NIL))
    ("parent" NIL
     (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:OBJECT T "river_window_v1"))
    ("decoration_hint" NIL
     (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:UINT NIL NIL))
    ("pointer_move_requested" NIL
     (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:OBJECT NIL "river_seat_v1"))
    ("pointer_resize_requested" NIL
     (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:OBJECT NIL "river_seat_v1")
     (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:UINT NIL NIL))
    ("show_window_menu_requested" NIL
     (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:INT NIL NIL)
     (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:INT NIL NIL))
    ("maximize_requested" NIL) ("unmaximize_requested" NIL)
    ("fullscreen_requested" NIL
     (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:OBJECT T "river_output_v1"))
    ("exit_fullscreen_requested" NIL) ("minimize_requested" NIL)
    ("unreliable_pid" 2
     (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:INT NIL NIL))))
 (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:INITIALIZE-INTERFACE "river_decoration_v1"
     3
   (("destroy" NIL)
    ("set_offset" NIL (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:INT NIL NIL)
     (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:INT NIL NIL))
    ("sync_next_commit" NIL))
   NIL)
 (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:INITIALIZE-INTERFACE "river_shell_surface_v1"
     3
   (("destroy" NIL)
    ("get_node" NIL
     (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:NEW-ID NIL "river_node_v1"))
    ("sync_next_commit" NIL))
   NIL)
 (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:INITIALIZE-INTERFACE "river_node_v1"
     3
   (("destroy" NIL)
    ("set_position" NIL (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:INT NIL NIL)
     (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:INT NIL NIL))
    ("place_top" NIL) ("place_bottom" NIL)
    ("place_above" NIL
     (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:OBJECT NIL "river_node_v1"))
    ("place_below" NIL
     (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:OBJECT NIL "river_node_v1")))
   NIL)
 (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:INITIALIZE-INTERFACE "river_output_v1"
     3
   (("destroy" NIL))
   (("removed" NIL)
    ("wl_output" NIL (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:UINT NIL NIL))
    ("position" NIL (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:INT NIL NIL)
     (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:INT NIL NIL))
    ("dimensions" NIL (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:INT NIL NIL)
     (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:INT NIL NIL))))
 (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:INITIALIZE-INTERFACE "river_seat_v1"
     3
   (("destroy" NIL)
    ("focus_window" NIL
     (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:OBJECT NIL "river_window_v1"))
    ("focus_shell_surface" NIL
     (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:OBJECT NIL
      "river_shell_surface_v1"))
    ("clear_focus" NIL) ("op_start_pointer" NIL) ("op_end" NIL)
    ("get_pointer_binding" NIL
     (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:NEW-ID NIL
      "river_pointer_binding_v1")
     (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:UINT NIL NIL)
     (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:UINT NIL NIL))
    ("set_xcursor_theme" 2 (STRING NIL NIL)
     (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:UINT NIL NIL))
    ("pointer_warp" 3 (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:INT NIL NIL)
     (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:INT NIL NIL)))
   (("removed" NIL)
    ("wl_seat" NIL (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:UINT NIL NIL))
    ("pointer_enter" NIL
     (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:OBJECT NIL "river_window_v1"))
    ("pointer_leave" NIL)
    ("window_interaction" NIL
     (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:OBJECT NIL "river_window_v1"))
    ("shell_surface_interaction" NIL
     (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:OBJECT NIL
      "river_shell_surface_v1"))
    ("op_delta" NIL (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:INT NIL NIL)
     (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:INT NIL NIL))
    ("op_release" NIL)
    ("pointer_position" 2 (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:INT NIL NIL)
     (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CORE:INT NIL NIL))))
 (COM.ANDREWSOUTAR.CL-WAYLAND-CLIENT/CODEGEN:INITIALIZE-INTERFACE "river_pointer_binding_v1"
     3
   (("destroy" NIL) ("enable" NIL) ("disable" NIL))
   (("pressed" NIL) ("released" NIL))))