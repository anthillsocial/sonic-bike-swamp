#!/usr/bin/lua
require 'posix'

function check()
    --op = grabrandomsample("/home/sonic/sdcard/findingsonghome/sound/MArketMrLeg1.wav")
    -- print(op)
    op = grabrandomsample("/home/sonic/sdcard/findingsonghome/sound/MArketMrLeg1")
    print(op)
end

-- op = grabrandomsample("/home/sonic/sdcard/findingsonghome/sound/MArketMrLeg1.wav")
function grabrandomsample(path)
    local d = isdir(path)
    --print('File:'..path..' IsFile:'..tostring(f)..' IsDir:'..tostring(d))
    if d==true then 
        -- grab a random sample from the directory
        sample = scandirforrandom(path, '.wav')
        return sample
    else
        return false
    end
end

function isdir(fn)
    local fstype = posix.stat(fn, "type")
    if fstype == 'directory' then
        return true
    else 
        return false
    end
end

function scandirforrandom(directory)
    local i, t, popen = 0, {}, io.popen
    for filename in popen('ls -a "'..directory..'"'):lines() do
        firstchar = string.sub(filename,1,1)
        if firstchar ~= '.' then
            i = i + 1 
            t[i] = filename
        end
    end 
    if i == 0 then
        return false
    end 
    math.randomseed(os.time())
    rand = math.random(i)
    return t[rand]
end

check()

