--[[
Author(s): big
Date: 2022.6.13
]]

NPL.load("(gl)script/mainstate.lua")
NPL.load("(gl)script/ide/commonlib.lua")
NPL.load("(gl)script/ide/System/System.lua")

NPL.load("(gl)script/ide/Locale.lua");
NPL.load("(gl)script/apps/Aries/Creator/Game/Common/Translation.lua")
local Translation = commonlib.gettable("MyCompany.Aries.Game.Common.Translation")
Translation.Init()

NPL.load("(gl)script/apps/Aries/Creator/Game/game_logic.lua")

NPL.load("(gl)script/apps/Aries/Creator/Game/API/FileDownloader.lua")
local FileDownloader = commonlib.gettable("MyCompany.Aries.Creator.Game.API.FileDownloader")

local cur_dir = ParaEngine.GetAppCommandLineByParam('cur_dir', nil) .. '\\'

function get_version(callback)
    local req_time = os.date('%Y%m%d%H%M', os.time())
    local version_url = 'http://tmlog.paraengine.com/version.php?dt=' .. req_time

    System.os.GetUrl(
        version_url,
        function(err, msg, data)
            if err ~= 200 then
                return
            end

            local version_XML = ParaXML.LuaXML_ParseString(data)
            local version = version_XML[1][1]

            if callback and type(callback) == 'function' then
                callback(version)
            end
        end
    )
end

function get_resource_list(version, callback)
    local resource_list_url = 'http://tmlog.paraengine.com/coredownload/' .. version .. '/list/patch_1.1.0.p'
    local list_filter = {
        'assets_manifest.txt',
        'config/bootstrapper.xml',
        'config/bootstrapper_safemode.xml',
        'config/commands.xml',
        'config/config.txt',
        'config/gameclient.config.xml',
        'main.pkg',
        'main150727.pkg',
        'main_mobile_res.pkg',
        'npl_packages/paracraftbuildinmod.zip',
        'version.txt',
    }
	
	echo(resource_list_url, true)

    System.os.GetUrl(
        resource_list_url,
        function(err, msg, data)
			echo(err, true)
			echo(msg, true)
			echo(data, true)
            if err ~= 200 then
                return
            end

            local line_table = {}

            for line in string.gmatch(data, '[^\r\n]+') do
                local section_table = {}
                local be_download = false

                for section in string.gmatch(line, '[^,]+') do
                    if #section_table == 0 then
                        section = section:gsub('.p$', '')

                        for _, item in ipairs(list_filter) do
                            if item == section then
                                be_download = true
                                break
                            end
                        end

                        if not be_download then
                            break
                        end
                    end

                    section_table[#section_table + 1] = section
                end

                if be_download then
                    line_table[#line_table + 1] = section_table
                end
            end

            local download_timer
            local cur_index = 1
            local total = #line_table
            local is_downloading = false

            download_timer = commonlib.Timer:new({
                callbackFunc = function()
                    if is_downloading then
                        return
                    end

                    if cur_index <= total then
                        is_downloading = true

                        download_file(
                            line_table[cur_index],
                            function()
                                cur_index = cur_index + 1
                                is_downloading = false
                            end
                        )
                    else
                        download_timer:Change(nil, nil)

                        if callback and type(callback) == 'function' then
                            callback()
                        end
                    end
                end
            })

            download_timer:Change(0, 100)
        end
    )
end

function download_file(item, callback)
    local download_url =
        'http://tmlog.paraengine.com/coredownload/update/' ..
        item[1] .. '.p' .. ',' ..
        item[2] .. ',' ..
        item[3] .. '.p'

    local local_name = ''

    if item[1] == 'npl_packages/paracraftbuildinmod.zip' then
        local_name = 'npl_packages/ParacraftBuildinMod.zip'
    else
        local_name = item[1]
    end

    local gzip_file = cur_dir .. item[1] .. '.gzip'
    local origin_file = cur_dir .. local_name

    FileDownloader:new():Init(
        nil,
        download_url,
        gzip_file,
        function()
            local read_file = ParaIO.open(gzip_file, 'r')

            if(read_file:IsValid())then
                local content = read_file:GetText(0, -1)
                local data_io = {content = content, method = "gzip"};

                NPL.Decompress(data_io)

                local file = ParaIO.open(origin_file, "w")

				if(file:IsValid()) then
					file:write(data_io.result, #data_io.result)
					file:close()
				end
            end

            read_file:close()
            
            ParaIO.DeleteFile(gzip_file)

            if callback and type(callback) == 'function' then
                callback()
            end
        end
    )
end

get_version(function(version)
    get_resource_list(version, function()
        ParaGlobal.ExitApp();
    end)
end)

NPL.this(function()
    local msg = msg
end)
