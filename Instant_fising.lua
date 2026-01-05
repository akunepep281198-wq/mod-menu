-- InstantFish_debug.lua (debug helper)
-- Jalankan sebagai LocalScript / executor script. Salin output error ke saya.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer

-- Config singkat
local AUTO_FISH = true
local CAST_COOLDOWN = 0.7
local BOBBER_SEARCH_TIMEOUT = 12
local SEARCH_NAMES = {"bobber","float","floater","marker","buoy"}
local CLICK_INTERVAL = 0.04

-- Coba ambil VirtualInputManager kalau tersedia
local okVIM, VIM = pcall(function()
	return game:GetService("VirtualInputManager")
end)
if okVIM and VIM then
	print("[Debug] VirtualInputManager tersedia")
else
	print("[Debug] VirtualInputManager TIDAK tersedia (fallback akan dipakai)")
	VIM = nil
end

local function trySendLeftClick()
	-- Metode 1: VirtualInputManager (kebanyakan executor)
	if VIM then
		local ok, err = pcall(function()
			local cam = workspace.CurrentCamera
			if not cam then error("Camera nil") end
			local vs = cam.ViewportSize
			VIM:SendMouseButtonEvent(vs.X/2, vs.Y/2, 0, true, game, 0)
			VIM:SendMouseButtonEvent(vs.X/2, vs.Y/2, 0, false, game, 0)
		end)
		if ok then
			print("[Debug] Click via VIM OK")
			return true
		else
			warn("[Debug] Click via VIM failed:", err)
		end
	end

	-- Metode 2: coba SendMouseClick (beberapa exploit menyediakan fungsi global)
	if type(mouse1click) == "function" then
		local ok, err = pcall(function() mouse1click() end)
		if ok then
			print("[Debug] Click via mouse1click() OK")
			return true
		else
			warn("[Debug] mouse1click() gagal:", err)
		end
	end

	-- Metode 3: fallback - tidak ada cara pasti, hanya log
	warn("[Debug] Tidak ada metode click yang berhasil. Jika executor Anda tidak mendukung VIM atau mouse1click, klik manual diperlukan.")
	return false
end

local function findBobber()
	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("BasePart") or obj:IsA("Model") then
			local lname = obj.Name:lower()
			for _, pattern in ipairs(SEARCH_NAMES) do
				if lname:find(pattern:lower()) then
					if obj:IsA("Model") then
						if obj.PrimaryPart then return obj.PrimaryPart end
						for _, d in ipairs(obj:GetDescendants()) do
							if d:IsA("BasePart") then return d end
						end
					else
						return obj
					end
				end
			end
		end
	end
	return nil
end

local function waitForBobber(timeout)
	local t0 = tick()
	while tick() - t0 < (timeout or BOBBER_SEARCH_TIMEOUT) do
		local b = findBobber()
		if b and b.Parent then
			print("[Debug] Bobber ditemukan:", b:GetFullName())
			return b
		end
		task.wait(0.25)
	end
	print("[Debug] Bobber tidak ditemukan dalam timeout")
	return nil
end

local function detectBiteSimple(bobber, maxWait)
	maxWait = maxWait or 10
	local ok, initPos = pcall(function() return bobber.Position end)
	if not ok or not initPos then
		warn("[Debug] Tidak bisa baca posisi awal bobber")
		return false
	end
	local initY = initPos.Y
	local t0 = tick()
	while tick() - t0 < maxWait do
		if not bobber or not bobber.Parent then
			warn("[Debug] Bobber hilang saat menunggu bite")
			return false
		end
		local ok2, pos = pcall(function() return bobber.Position end)
		if ok2 and pos then
			local dy = math.abs(initY - pos.Y)
			if (initY - pos.Y) > 0.25 then
				print("[Debug] Indikasi bite: perubahan Y =", initY - pos.Y)
				return true
			end
		end
		task.wait(0.07)
	end
	print("[Debug] Tidak ada bite terdeteksi pada bobber:", bobber:GetFullName())
	return false
end

-- Main loop debug: cast -> cari bobber -> tunggu bite -> klik
task.spawn(function()
	while AUTO_FISH do
		print("[Debug] Mulai cast")
		trySendLeftClick()
		task.wait(CAST_COOLDOWN)

		local bobber = waitForBobber(BOBBER_SEARCH_TIMEOUT)
		if not bobber then
			print("[Debug] Ulang karena bobber tidak ditemukan")
			task.wait(1)
			goto continue
		end

		local ok, gotBite = pcall(function() return detectBiteSimple(bobber, 12) end)
		if not ok then
			warn("[Debug] Error saat detectBiteSimple:", gotBite)
			gotBite = false
		end

		if gotBite then
			print("[Debug] Bite terdeteksi, mencoba reel (klik x3)")
			for i=1,3 do
				trySendLeftClick()
				task.wait(CLICK_INTERVAL)
			end
		else
			print("[Debug] Tidak ada bite, ulang")
		end

		::continue::
		task.wait(0.5)
	end
end)

print("[Debug] Script siap. AUTO_FISH =", AUTO_FISH)
