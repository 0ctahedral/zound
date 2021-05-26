const std = @import("std");
const fs = std.fs;
const c = @cImport({
    @cInclude("linux/input.h");
});
const alloc = std.heap.page_allocator;

//pub const io_mode = .evented;
var evfile: fs.File = undefined;

var keyState: [@typeInfo(KeyCode).Enum.fields.len]bool = undefined;

pub fn init() !void {
    evfile = try fs.openFileAbsolute("/dev/input/event16", .{.read = true} );
    keyState = [_]bool{false} ** @typeInfo(KeyCode).Enum.fields.len;
}

pub fn update() ![]bool {
    const reader = evfile.reader();
    var bytes: [24]u8 = undefined;
    //try reader.readNoEof(bytes[0..]);
    var n = try reader.read(bytes[0..]);
    const ev = @bitCast(c.input_event, bytes);
    if (ev.type == 1 and ev.code < @typeInfo(KeyCode).Enum.fields.len) {
        keyState[ev.code] = if (ev.value > 0) true else false;
    }
    return keyState[0..];
}

pub fn deinit() void {
    evfile.close();
}

pub const KeyCode = enum(u8) {
    KEY_ESC = 1,
    KEY_1 = 2,
    KEY_2 = 3,
    KEY_3 = 4,
    KEY_4 = 5,
    KEY_5 = 6,
    KEY_6 = 7,
    KEY_7 = 8,
    KEY_8 = 9,
    KEY_9 = 10,
    KEY_0 = 11,
    KEY_MINUS = 12,
    KEY_EQUAL = 13,
    KEY_BACKSPACE = 14,
    KEY_TAB = 15,
    KEY_Q = 16,
    KEY_W = 17,
    KEY_E = 18,
    KEY_R = 19,
    KEY_T = 20,
    KEY_Y = 21,
    KEY_U = 22,
    KEY_I = 23,
    KEY_O = 24,
    KEY_P = 25,
    KEY_LEFTBRACE = 26,
    KEY_RIGHTBRACE = 27,
    KEY_ENTER = 28,
    KEY_LEFTCTRL = 29,
    KEY_A = 30,
    KEY_S = 31,
    KEY_D = 32,
    KEY_F = 33,
    KEY_G = 34,
    KEY_H = 35,
    KEY_J = 36,
    KEY_K = 37,
    KEY_L = 38,
    KEY_SEMICOLON = 39,
    KEY_APOSTROPHE = 40,
    KEY_GRAVE = 41,
    KEY_LEFTSHIFT = 42,
    KEY_BACKSLASH = 43,
    KEY_Z = 44,
    KEY_X = 45,
    KEY_C = 46,
    KEY_V = 47,
    KEY_B = 48,
    KEY_N = 49,
    KEY_M = 50,
    KEY_COMMA = 51,
    KEY_DOT = 52,
    KEY_SLASH = 53,
    KEY_RIGHTSHIFT = 54,
    KEY_KPASTERISK = 55,
    KEY_LEFTALT = 56,
    KEY_SPACE = 57,
    KEY_CAPSLOCK = 58,
};
