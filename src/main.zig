const std = @import("std");
const ArrayList = std.ArrayList;
const expectEqualStrings = std.testing.expectEqualStrings;

const prompt = "\u{2192}";
pub fn main() !void {
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();
    try stdout.print("\u{0391}lph\u{03b1} Lisp Version {d}.{d}.{s}\n\n{s}", .{ 0, 0, "a", prompt});
    try bw.flush();

    const stdin_file = std.io.getStdIn().reader();
    var br = std.io.bufferedReader(stdin_file);
    const stdin = br.reader();
    defer std.io.getStdIn().close();

    var buffer = [_]u8{0} ** 255;
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    while(true) {
        var input = ArrayList(u8).init(allocator);
        defer input.deinit();
        _ = try stdin.readUntilDelimiterOrEof(&buffer, '\n');
        try input.appendSlice(&buffer);
        try stdout.print("{s}{s}", .{ rep(input).items, prompt });
        try bw.flush();
    }
}

fn read(in: ArrayList(u8)) ArrayList(u8) {
    return in;
}

test "read" {
    var in = ArrayList(u8).init(std.testing.allocator);
    defer in.deinit();
    try in.appendSlice("read");
    try expectEqualStrings(in.items, read(in).items);
}

fn eval(in: ArrayList(u8)) ArrayList(u8) {
    return in;
}

test "eval" {
    var in = ArrayList(u8).init(std.testing.allocator);
    defer in.deinit();
    try in.appendSlice("eval");
    try expectEqualStrings(in.items, eval(in).items);
}

fn print(in: std.ArrayList(u8)) ArrayList(u8) {
    return in;
}
test "print" {
    var in = ArrayList(u8).init(std.testing.allocator);
    defer in.deinit();
    try in.appendSlice("print");
    try expectEqualStrings(in.items, print(in).items);
}

fn rep(in: ArrayList(u8)) ArrayList(u8) {
    return print(eval(read(in)));
}

test "rep" {
    var in = ArrayList(u8).init(std.testing.allocator);
    defer in.deinit();
    try in.appendSlice("rep");
    try expectEqualStrings(in.items, rep(in).items);
}

