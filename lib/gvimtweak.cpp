// Fork from "github.com/movsb/gvim_fullscreen".
// And I add some my code.

#include <windows.h>
#include <cstdio>

static BOOL CALLBACK EnumThreadWndProc(HWND hwnd, LPARAM lParam) {
    char ClassName[128];
    ClassName[GetClassNameA(hwnd, &ClassName[0], sizeof(ClassName)/sizeof(*ClassName))] = '\0';
    if(strcmp(ClassName, "Vim") == 0) {
        HWND* phVim = reinterpret_cast<HWND*>(lParam);
        *phVim = hwnd;
        return FALSE;
    }
    else {
        return TRUE;
    }
}

extern "C" __declspec(dllexport) int __cdecl IsMaximum(int) {
    HWND hWnd = NULL;
    if (EnumThreadWindows(GetCurrentThreadId(), EnumThreadWndProc, LPARAM(&hWnd)))
        hWnd = NULL;
    if (hWnd != NULL) {
            int isZoomed = IsZoomed(hWnd)? 1:0;
            return isZoomed;
    }
    return 0;
}

extern "C" __declspec(dllexport) int __cdecl ToggleFullscreen(int) {
    HWND hWnd = NULL;
    if(EnumThreadWindows(GetCurrentThreadId(), EnumThreadWndProc, LPARAM(&hWnd)))
        hWnd = NULL;
    if(hWnd != NULL) {
        RECT* r;
        // 0: non full-screen, 1: full-screen
        switch(reinterpret_cast<int>(GetPropA(hWnd, "__full_state__")))
        {
        case 0:
            if(!(r = reinterpret_cast<RECT*>(GetPropA(hWnd, "__window_rect__")))) {
                r = (RECT*)HeapAlloc(GetProcessHeap(), 0, sizeof(RECT));

                // remove clientedge for vim textarea
                HWND hTextArea = FindWindowEx(hWnd, NULL, "VimTextArea", "Vim text area");
                DWORD dwExStyle = GetWindowLongPtr(hTextArea, GWL_EXSTYLE);
                SetWindowLongPtr(hTextArea, GWL_EXSTYLE, dwExStyle & ~WS_EX_CLIENTEDGE);
            }

            GetWindowRect(hWnd, r);
            SetPropA(hWnd, "__window_rect__", HANDLE(r));

            SetWindowLongPtr(hWnd, GWL_STYLE, WS_POPUP | WS_VISIBLE);
            SetClassLongPtr(hWnd, GCLP_HBRBACKGROUND, (LONG)GetStockObject(BLACK_BRUSH));

            SetWindowPos(hWnd, HWND_TOP, 0, 0, GetSystemMetrics(SM_CXSCREEN), GetSystemMetrics(SM_CYSCREEN), SWP_FRAMECHANGED);

            SetPropA(hWnd, "__full_state__", HANDLE(1));
            break;
        case 1:
            SetWindowLongPtr(hWnd, GWL_STYLE, WS_OVERLAPPEDWINDOW | WS_VISIBLE);
            SetClassLongPtr(hWnd, GCLP_HBRBACKGROUND, (LONG)COLOR_BTNFACE);

            r = reinterpret_cast<RECT*>(GetPropA(hWnd, "__window_rect__"));
            SetWindowPos(hWnd, HWND_TOP, r->left, r->top, r->right-r->left, r->bottom-r->top, SWP_FRAMECHANGED);

            SetPropA(hWnd, "__full_state__", HANDLE(0));
            break;
        }
    }

    return 0;
}

extern "C" __declspec(dllexport) int __cdecl SetTransparency(int ntrans) {
    HWND hWnd = NULL;
    if(EnumThreadWindows(GetCurrentThreadId(), EnumThreadWndProc, LPARAM(&hWnd)))
        hWnd = NULL;
    if(hWnd != NULL) {
            int current = reinterpret_cast<int>(GetPropA(hWnd, "__transparency__"));
            if (current == 0)
                SetWindowLongPtr(hWnd, GWL_EXSTYLE, GetWindowLongPtr(hWnd, GWL_EXSTYLE) | WS_EX_LAYERED);
            SetLayeredWindowAttributes(hWnd, 0, (BYTE)ntrans, LWA_ALPHA);
            SetPropA(hWnd, "__transparency__", HANDLE(ntrans));
    }
    return 0;
}

