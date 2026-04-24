const std = @import("std");

const sdl2_demo = @import("sdl2_demo.zig");

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    { // Change current working directory to where the executable is located.
        var buffer: [1024]u8 = undefined;
        const idx = try std.process.executableDirPath(io, buffer[0..]);
        const path = buffer[0..idx];
        const dir = try std.Io.Dir.openDirAbsolute(io, path, .{});
        defer dir.close(io);
        try std.process.setCurrentDir(io, dir);
    }

    try sdl2_demo.init();
    defer sdl2_demo.deinit();

    while (sdl2_demo.shouldQuit() == false) {
        try sdl2_demo.updateAndRender();
    }
}
