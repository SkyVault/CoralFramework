import
  nimgl/[glfw]
    

type
    ControlerNumber* {.pure.} = enum
        One = 1,
        Two,
        Three,
        Four

    #ControllerButtons* {.pure.} = enum
        #A                   = sdl.CONTROLLER_BUTTON_A,
        #B                   = sdl.CONTROLLER_BUTTON_B,
        #X                   = sdl.CONTROLLER_BUTTON_X,
        #Y                   = sdl.CONTROLLER_BUTTON_Y,
        #Back                = sdl.CONTROLLER_BUTTON_BACK,
        #Guide               = sdl.CONTROLLER_BUTTON_GUIDE,
        #Start               = sdl.CONTROLLER_BUTTON_START,
        #LeftStick           = sdl.CONTROLLER_BUTTON_LEFTSTICK,
        #RightStick          = sdl.CONTROLLER_BUTTON_RIGHTSTICK,
        #LeftShoulder        = sdl.CONTROLLER_BUTTON_LEFTSHOULDER,
        #RightShoulder       = sdl.CONTROLLER_BUTTON_RIGHTSHOULDER,
        #DpadUp              = sdl.CONTROLLER_BUTTON_DPAD_UP,
        #DpadDown            = sdl.CONTROLLER_BUTTON_DPAD_DOWN,
        #DpadLeft            = sdl.CONTROLLER_BUTTON_DPAD_LEFT,
        #DpadRight           = sdl.CONTROLLER_BUTTON_DPAD_RIGHT,
        #Max                 = sdl.CONTROLLER_BUTTON_MAX,
        #Invalid             = sdl.CONTROLLER_BUTTON_INVALID
type
    Key* {.pure.}= enum
      Unknown = keyUnknown
      Space = keySpace
      Apostrophe = keyApostrophe
      Comma = keyComma
      Minus = keyMinus
      Period = keyPeriod
      Slash = keySlash
      Num0 = key0
      Num1 = key1
      Num2 = key2
      Num3 = key3
      Num4 = key4
      Num5 = key5
      Num6 = key6
      Num7 = key7
      Num8 = key8
      Num9 = key9
      Semicolon  = keySemicolon
      Equal = keyEqual
      A = keyA
      B = keyB
      C = keyC
      D = keyD
      E = keyE
      F = keyF
      G = keyG
      H = keyH
      I = keyI
      J = keyJ
      K = keyK
      L = keyL
      M = keyM
      N = keyN
      O = keyO
      P = keyP
      Q = keyQ
      R = keyR
      S = keyS
      T = keyT
      U = keyU
      V = keyV
      W = keyW
      X = keyX
      Y = keyY
      Z = keyZ
      LeftBracket = keyLeftBracket
      Backslash = keyBackslash
      RightBracket = keyRightBracket
      GraveAccent = keyGraveAccent
      World1 = keyWorld1
      World2 = keyWorld2
      Escape = keyEscape
      Enter = keyEnter
      Tab = keyTab
      Backspace = keyBackspace
      Insert = keyInsert
      Delete = keyDelete
      Right = keyRight
      Left = keyLeft
      Down = keyDown
      Up = keyUp
      PageUp = keyPageUp
      PageDown = keyPageDown
      Home = keyHome
      End = keyEnd
      CapsLock = keyCapsLock
      ScrollLock = keyScrollLock
      NumLock = keyNumLock
      PrintScreen = keyPrintScreen
      Pause = keyPause
      Func1 = keyF1
      Func2 = keyF2
      Func3 = keyF3
      Func4 = keyF4
      Func5 = keyF5
      Func6 = keyF6
      Func7 = keyF7
      Func8 = keyF8
      Func9 = keyF9
      Func10 = keyF10
      Func11 = keyF11
      Func12 = keyF12
      Func13 = keyF13
      Func14 = keyF14
      Func15 = keyF15
      Func16 = keyF16
      Func17 = keyF17
      Func18 = keyF18
      Func19 = keyF19
      Func20 = keyF20
      Func21 = keyF21
      Func22 = keyF22
      Func23 = keyF23
      Func24 = keyF24
      Func25 = keyF25
      Kp0 = keyKp0
      Kp1 = keyKp1
      Kp2 = keyKp2
      Kp3 = keyKp3
      Kp4 = keyKp4
      Kp5 = keyKp5
      Kp6 = keyKp6
      Kp7 = keyKp7
      Kp8 = keyKp8
      Kp9 = keyKp9
      KpDecimal = keyKpDecimal
      KpDivide = keyKpDivide
      KpMultiply = keyKpMultiply
      KpSubtract = keyKpSubtract
      KpAdd = keyKpAdd
      KpEnter = keyKpEnter
      KpEqual = keyKpEqual
      LeftShift = keyLeftShift
      LeftControl = keyLeftControl
      LeftAlt = keyLeftAlt
      LeftSuper = keyLeftSuper
      RightShift = keyRightShift
      RightControl = keyRightControl
      RightAlt = keyRightAlt
      RightSuper = keyRightSuper
      Menu = keyMenu
