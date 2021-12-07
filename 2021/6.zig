const std = @import("std");
const common = @import("./common.zig");

// TODO: solution to day 6
pub fn main() !void {
    var fileContents = try common.readFileContents("/home/daniel/.home/.cache/aoc2021/6.input");
    const stdout = std.io.getStdOut().writer();
    try stdout.print("{s}", .{fileContents});
}

/// Calculate lanternFish value
fn lanternFish() i32 {
    return 48;
}
