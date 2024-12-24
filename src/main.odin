package main

import "core:fmt"
import "core:mem"
import "core:os"
import rl "vendor:raylib"
_ :: mem
_ :: fmt

PROG_NAME :: #config(PROG_NAME, "")
PROG_VERSION :: #config(PROG_VERSION, "")

WINDOW_WIDTH :: 1280
WINDOW_HEIGHT :: 720

start :: proc() -> (ok: bool) {
    rl.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, PROG_NAME + " " + PROG_VERSION)

    rl.SetTargetFPS(60)

    for !rl.WindowShouldClose() {
        rl.BeginDrawing()
        {
            rl.ClearBackground(rl.GetColor(0x202020FF))
        }
        rl.EndDrawing()

        rl.DrawFPS(0, 0)
    }

    rl.CloseWindow()
    return true
}

main :: proc() {
    ok: bool
    defer os.exit(!ok)
    defer free_all(context.temp_allocator)
    when ODIN_DEBUG {
        mem_track: mem.Tracking_Allocator
        mem.tracking_allocator_init(&mem_track, context.allocator)
        context.allocator = mem.tracking_allocator(&mem_track)
        defer {
            fmt.print("\033[1;31m")
            if len(mem_track.allocation_map) > 0 {
                fmt.eprintfln("### %v unfreed allocations ###", len(mem_track.allocation_map))
                for _, v in mem_track.allocation_map {
                    fmt.eprintfln(" -> %v bytes from %v", v.size, v.location)
                }
            }
            if len(mem_track.bad_free_array) > 0 {
                fmt.eprintfln("### %v bad frees ###", len(mem_track.bad_free_array))
                for x in mem_track.bad_free_array {
                    fmt.eprintfln(" -> %p from %v", x.memory, x.location)
                }
            }
            fmt.print("\033[0m")
            mem.tracking_allocator_destroy(&mem_track)
        }
    }

    ok = start()
}

