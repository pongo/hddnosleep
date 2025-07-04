const std = @import("std");

const FILENAME = "D:\\tmp\\hddnosleep.txt";

pub fn main() anyerror!void {
    // const allocator = std.heap.page_allocator;
    // const stdout = std.io.getStdOut().writer();
    
    var buffer: [100]u8 = undefined;
    var fba = std.heap.FixedBufferAllocator.init(&buffer);
    const allocator = fba.allocator();

    const loop_duration = std.time.ns_per_s * 7; // 7 sec

    while (true) {
        const time = try std.time.Instant.now();
        const time_str = try std.fmt.allocPrint(allocator, "{}", .{time.timestamp});
        defer allocator.free(time_str);

        {
            var file = try std.fs.cwd().createFile(FILENAME, .{});
            defer file.close();
            try file.writeAll(time_str);
        }

        // try stdout.writeAll(time_str);

        std.time.sleep(loop_duration);
    }
}
