package main

import imgui_rl "../imgui_impl_raylib"
import "core:fmt"
import imgui "dependencies:imgui"
import rl "vendor:raylib"

main :: proc() {
	filename_buffer: [256]byte

	rl.SetTraceLogLevel(.WARNING)

	rl.SetConfigFlags({.VSYNC_HINT})
	rl.InitWindow(800, 600, "raylib basic window")
	defer rl.CloseWindow()

	imgui.CreateContext(nil)
	defer imgui.DestroyContext(nil)

	imgui_rl.init()
	defer imgui_rl.shutdown()

	imgui_rl.build_font_atlas()

	for !rl.WindowShouldClose() {
		imgui_rl.process_events()
		imgui_rl.new_frame()
		imgui.NewFrame()

		rl.BeginDrawing()
		rl.ClearBackground(rl.GRAY)

		// imgui.ShowDemoWindow(nil)
		// ui code
		viewport := imgui.GetMainViewport()
		imgui.SetNextWindowPos({0, 0}, .Appearing)
		imgui.SetNextWindowSize(viewport.Size, .Appearing)
		if imgui.Begin("Main", nil, {.MenuBar, .NoResize, .NoCollapse, .NoMove, .NoTitleBar}) {
			imgui.SetWindowFontScale(2)

			if imgui.BeginMenuBar() {
				if imgui.BeginMenu("File") {
					if imgui.MenuItem("Exit") {
						rl.CloseWindow()
					}
					imgui.EndMenu()
				}
				imgui.EndMenuBar()
			}


			if imgui.InputText(
				"Filename",
				transmute(cstring)&filename_buffer,
				len(filename_buffer),
				{},
			) {
				fmt.printfln("Input: %s", filename_buffer)
			}
			imgui.SameLine()

			// get the available space

			// available := imgui.GetContentRegionAvail()
			// imgui.SetCursorPosX(imgui.GetCursorPosX() + available.x / 2)

			button_size := imgui.CalcTextSize("Load").x + imgui.GetStyle().FramePadding.x * 2
			imgui.SetCursorPosX(
				imgui.GetWindowWidth() - button_size - imgui.GetStyle().WindowPadding.x,
			)


			if imgui.Button("Load") {
				// load file here
			}
		}
		imgui.End()
		// end ui code

		imgui.Render()
		imgui_rl.render_draw_data(imgui.GetDrawData())

		rl.EndDrawing()
	}
}
