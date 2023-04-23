// vim: sw=2 ts=2 expandtab smartindent

const win32 = @import("zigwin32/win32.zig");
const win32_ui = win32.ui.windows_and_messaging;

const user32  = @import("std").os.windows.user32 ;
const UINT    = @import("std").os.windows.UINT   ;
const WINAPI  = @import("std").os.windows.WINAPI ;
const LRESULT = @import("std").os.windows.LRESULT;

const zeroInit = @import("std").mem.zeroInit;

pub fn main() !void {
  const name = "string bean";
  const hInstance = win32.everything.GetModuleHandleW(null);

  win32_ui.RegisterClass(&zeroInit(win32_ui.WNDCLASS, .{
    .lpfnWndProc = winproc,
    .hInstance = hInstance,
    .lpszClassName = name
  }));

  const hwnd = user32.CreateWindowEx(
    0, name, name,
    user32.WS_OVERLAPPEDWINDOW,
    user32.CW_USEDEFAULT,
    user32.CW_USEDEFAULT,
    user32.CW_USEDEFAULT,
    user32.CW_USEDEFAULT,
    null, null, hInstance, null
  );
  user32.ShowWindow(hwnd, .SHOWDEFAULT);

  var msg: user32.MSG = undefined;
  while (user32.GetMessage(&msg, null, 0, 0) > 0) {
    user32.TranslateMessage(&msg);
    user32.DispatchMessage(&msg);
  }

  return 0;
}

export fn winproc(
    hwnd: win32.everything.HWND,
    msg: UINT,
    w_param: win32.everything.WPARAM,
    l_param: win32.everything.LPARAM,
) callconv(WINAPI) LRESULT {

  switch (msg) {
    user32.WM_DESTROY => {
      user32.PostQuitMessage(0);
      return 0;
    },
    else => {}
  }
  return win32_ui.DefWindowProc(hwnd, msg, w_param, l_param);
}
