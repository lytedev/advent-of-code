const std = @import("std");

pub fn readFileContents(file_path: []const u8, alloc: *std.mem.Allocator) anyerror![]u8 {
    var gp = std.heap.GeneralPurposeAllocator(.{.safety = true}){};
    defer _ = gp.deinit();
    const alloc = &gp.allocator;

    var path_buffer: [std.fs.MAX_PATH_BYTES]u8 = undefined;
    const path = try std.fs.realpath(file_path, &path_buffer);

    const file = try std.fs.openFileAbsolute(path, .{ .read = true });
    defer file.close();

    const fb = try file.readToEndAlloc(alloc, 50000);
    defer alloc.free(fb);

    return fb;
}
