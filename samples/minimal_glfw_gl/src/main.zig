const std = @import("std");
const glfw = @import("zglfw");
const zopengl = @import("zopengl");

const minimal_glfw_gl = @import("minimal_glfw_gl.zig");

const gl_version_major: u16 = 4;
const gl_version_minor: u16 = 0;

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

    try glfw.init();
    defer glfw.terminate();

    glfw.windowHint(.client_api, .opengl_api);
    glfw.windowHint(.context_version_major, gl_version_major);
    glfw.windowHint(.context_version_minor, gl_version_minor);
    glfw.windowHint(.opengl_profile, .opengl_core_profile);
    glfw.windowHint(.opengl_forward_compat, true);
    glfw.windowHint(.doublebuffer, true);

    try minimal_glfw_gl.init();
    defer minimal_glfw_gl.deinit();

    try zopengl.loadCoreProfile(glfw.getProcAddress, gl_version_major, gl_version_minor);

    while (!minimal_glfw_gl.window.shouldClose()) {
        minimal_glfw_gl.updateAndRender();
    }
}
