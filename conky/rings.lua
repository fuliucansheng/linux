--corner_r=35
--bg_alpha=0.2
back="0x2a2a2a"
normal="0x00ffff"
warn="0xffff00"
crit="0xff000d"

settings_table = {
    {
        name='acpitemp',
        arg='',
        max=90,
        bg_colour=back,
        bg_alpha=0.8,
        fg_colour=normal,
        fg_alpha=0.8,
        x=200, y=120,
        radius=97,
        thickness=4,
        start_angle=0,
        end_angle=240
    },
    {
        name='cpu',
        arg='cpu0',
        max=100,
        bg_colour=back,
        bg_alpha=0.8,
        fg_colour=normal,
        fg_alpha=0.8,
        x=200, y=120,
        radius=86,
        thickness=13,
        start_angle=0,
        end_angle=240
    },
    {
        name='cpu',
        arg='cpu1',
        max=100,
        bg_colour=back,
        bg_alpha=0.7,
        fg_colour=normal,
        fg_alpha=0.8,
        x=200, y=120,
        radius=71,
        thickness=12,
        start_angle=0,
        end_angle=240
    },
    {
        name='cpu',
        arg='cpu2',
        max=100,
        bg_colour=back,
        bg_alpha=0.6,
        fg_colour=normal,
        fg_alpha=0.8,
        x=200, y=120,
        radius=57,
        thickness=11,
        start_angle=0,
        end_angle=240
    },
    {
        name='cpu',
        arg='cpu3',
        max=100,
        bg_colour=back,
        bg_alpha=0.5,
        fg_colour=normal,
        fg_alpha=0.8,
        x=200, y=120,
        radius=44,
        thickness=10,
        start_angle=0,
        end_angle=240
    },
    {
        name='memperc',
        arg='',
        max=100,
        bg_colour=back,
        bg_alpha=0.8,
        fg_colour=normal,
        fg_alpha=0.8,
        x=340, y=234,
        radius=60,
        thickness=15,
        start_angle=180,
        end_angle=420
    },
    {
        name='swapperc',
        arg='',
        max=100,
        bg_colour=back,
        bg_alpha=0.4,
        fg_colour=normal,
        fg_alpha=0.8,
        x=340, y=234,
        radius=45,
        thickness=10,
        start_angle=180,
        end_angle=420
    },
    {
        name='fs_used_perc',
        arg='/',
        max=100,
        bg_colour=back,
        bg_alpha=0.8,
        fg_colour=normal,
        fg_alpha=0.8,
        x=220, y=280,
        radius=40,
        thickness=10,
        start_angle=0,
        end_angle=240
    },
    {
        name='fs_used_perc',
        arg='/home',
        max=100,
        bg_colour=back,
        bg_alpha=0.6,
        fg_colour=normal,
        fg_alpha=0.8,
        x=220, y=280,
        radius=28,
        thickness=10,
        start_angle=0,
        end_angle=240
    },
    {
        name='fs_used_perc',
        arg='/usr',
        max=100,
        bg_colour=back,
        bg_alpha=0.4,
        fg_colour=normal,
        fg_alpha=0.8,
        x=220, y=280,
        radius=16,
        thickness=10,
        start_angle=0,
        end_angle=240
    },
    {
        name='downspeedf',
        arg=conky_parse("${if_up wlp2s0b1}wlp2s0b1${else}enp1s0${endif}"),
        max=1000,
        bg_colour=back,
        bg_alpha=0.8,
        fg_colour=normal,
        fg_alpha=0.8,
        x=290, y=346,
        radius=30,
        thickness=12,
        start_angle=180,
        end_angle=420
    },
    {
        name='upspeedf',
        arg=conky_parse("${if_up wlp2s0b1}wlp2s0b1${else}enp1s0${endif}"),
        max=100,
        bg_colour=back,
        bg_alpha=0.6,
        fg_colour=normal,
        fg_alpha=0.8,
        x=290, y=346,
        radius=18,
        thickness=8,
        start_angle=180,
        end_angle=420
    },
    {
        name='time',
        arg='%S',
        max=60,
        bg_colour=back,
        bg_alpha=0.8,
        fg_colour=normal,
        fg_alpha=0.8,
        x=230, y=410,
        radius=30,
        thickness=12,
        start_angle=0,
        end_angle=240
    },
    {
        name='time',
        arg='%M',
        max=60,
        bg_colour=back,
        bg_alpha=0.6,
        fg_colour=normal,
        fg_alpha=0.8,
        x=230, y=410,
        radius=18,
        thickness=8,
        start_angle=0,
        end_angle=240
    },
    {
        name='time',
        arg='%H',
        max=24,
        bg_colour=back,
        bg_alpha=0.4,
        fg_colour=normal,
        fg_alpha=0.8,
        x=230, y=410,
        radius=10,
        thickness=4,
        start_angle=0,
        end_angle=240
    },
    {
        name='battery_percent',
        arg='BATT',
        max=100,
        bg_colour=back,
        bg_alpha=0.6,
        fg_colour=normal,
        fg_alpha=0.8,
        x=274, y=464,
        radius=18,
        thickness=10,
        start_angle=180,
        end_angle=420
    },
    {
        name='',
        arg='',
        max=100,
        bg_colour=back,
        bg_alpha=0.6,
        fg_colour=normal,
        fg_alpha=0.6,
        x=274, y=464,
        radius=3,
        thickness=13,
        start_angle=0,
        end_angle=360
    },
}

require 'cairo'

function rgb_to_r_g_b(colour,alpha)
    return ((colour / 0x10000) % 0x100) / 255., ((colour / 0x100) % 0x100) / 255., (colour % 0x100) / 255., alpha
end

function draw_ring(cr,t,pt)
    local w,h=conky_window.width,conky_window.height
	
	local xc,yc,ring_r,ring_w,sa,ea=pt['x'],pt['y'],pt['radius'],pt['thickness'],pt['start_angle'],pt['end_angle']
	local bgc, bga, fgc, fga=pt['bg_colour'], pt['bg_alpha'], pt['fg_colour'], pt['fg_alpha']

	local angle_0=sa*(2*math.pi/360)-math.pi/2
	local angle_f=ea*(2*math.pi/360)-math.pi/2
	local t_arc=t*(angle_f-angle_0)

	-- Draw background ring
	cairo_arc(cr,xc,yc,ring_r,angle_0,angle_f)
	cairo_set_source_rgba(cr,rgb_to_r_g_b(bgc,bga))
	cairo_set_line_width(cr,ring_w)
	cairo_stroke(cr)
	
	-- Draw indicator ring
	cairo_arc(cr,xc,yc,ring_r,angle_0,angle_0+t_arc)
	cairo_set_source_rgba(cr,rgb_to_r_g_b(fgc,fga))
	cairo_stroke(cr)
end

function conky_ring_stats()
	local function setup_rings(cr,pt)
		local str=''
		local value=0
		
		str=string.format('${%s %s}',pt['name'],pt['arg'])
		str=conky_parse(str)
		
		value=tonumber(str)
		if value == nil then value = 0 end
		pct=value/pt['max']
		
		draw_ring(cr,pct,pt)
	end

	local cs=cairo_xlib_surface_create(conky_window.display,conky_window.drawable,conky_window.visual, conky_window.width,conky_window.height)
	local cr=cairo_create(cs)
	
	local updates=conky_parse('${updates}')
	update_num=tonumber(updates)

    if update_num>5 then
        for i in pairs(settings_table) do
            setup_rings(cr,settings_table[i])
        end
    end
    cairo_surface_destroy(cs)
    cairo_destroy(cr)
end

function temp_watch()
    warn_value=70
    crit_value=80
    temperature_value=tonumber(conky_parse("${acpitemp}"))
    if temperature_value == nil then temperature_value = 0 end

    if temperature_value<warn_value then
        settings_table[1]['fg_colour']=normal
    elseif temperature_value<crit_value then
        settings_table[1]['fg_colour']=warn
    else
        settings_table[1]['fg_colour']=crit
    end
end

function cpu_watch()
    warn_value=60
    crit_value=80
    cpu_value=tonumber(conky_parse("${cpu cpu0}"))
    if cpu_value == nil then cpu_value = 0 end

    if cpu_value<warn_value then
        settings_table[2]['fg_colour']=normal
    elseif cpu_value<crit_value then
        settings_table[2]['fg_colour']=warn
    else
        settings_table[2]['fg_colour']=crit
    end

    cpu_value=tonumber(conky_parse("${cpu cpu1}"))
    if cpu_value == nil then cpu_value = 0 end

    if cpu_value<warn_value then
        settings_table[3]['fg_colour']=normal
    elseif cpu_value<crit_value then
        settings_table[3]['fg_colour']=warn
    else
        settings_table[3]['fg_colour']=crit
    end

    cpu_value=tonumber(conky_parse("${cpu cpu2}"))
    if cpu_value == nil then cpu_value = 0 end

    if cpu_value<warn_value then
        settings_table[4]['fg_colour']=normal
    elseif cpu_value<crit_value then
        settings_table[4]['fg_colour']=warn
    else
        settings_table[4]['fg_colour']=crit
    end

    cpu_value=tonumber(conky_parse("${cpu cpu3}"))
    if cpu_value == nil then cpu_value = 0 end

    if cpu_value<warn_value then
        settings_table[5]['fg_colour']=normal
    elseif cpu_value<crit_value then
        settings_table[5]['fg_colour']=warn
    else
        settings_table[5]['fg_colour']=crit
    end
end

function mem_watch()
    warn_value=50
    crit_value=70
    memory_value=tonumber(conky_parse("${memperc}"))
    if memory_value == nil then memory_value = 0 end

    if memory_value<warn_value then
        settings_table[6]['fg_colour']=normal
    elseif memory_value<crit_value then
        settings_table[6]['fg_colour']=warn
    else
        settings_table[6]['fg_colour']=crit
    end
end

function swap_watch()
    warn_value=0
    crit_value=0
    swap_value=tonumber(conky_parse("${swapperc}"))
    if swap_value == nil then swap_value = 0 end

    if swap_value<warn_value then
        settings_table[7]['fg_colour']=normal
    elseif swap_value<crit_value then
        settings_table[7]['fg_colour']=warn
    else
        settings_table[7]['fg_colour']=crit
    end
end

function disk_watch()
    warn_value=93
    crit_value=98
    disk_value=tonumber(conky_parse("${fs_used_perc /}"))
    if disk_value == nil then disk_value = 0 end

    if disk_value<warn_value then
        settings_table[8]['fg_colour']=normal
    elseif disk_value<crit_value then
        settings_table[8]['fg_colour']=warn
    else
        settings_table[8]['fg_colour']=crit
    end

    disk_value=tonumber(conky_parse("${fs_used_perc /home}"))
    if disk_value == nil then disk_value = 0 end

    if disk_value<warn_value then
        settings_table[9]['fg_colour']=normal
    elseif disk_value<crit_value then
        settings_table[9]['fg_colour']=warn
    else
        settings_table[9]['fg_colour']=crit
    end

    disk_value=tonumber(conky_parse("${fs_used_perc /usr}"))
    if disk_value == nil then disk_value = 0 end

    if disk_value<warn_value then
        settings_table[10]['fg_colour']=normal
    elseif disk_value<crit_value then
        settings_table[10]['fg_colour']=warn
    else
        settings_table[10]['fg_colour']=crit
    end
end

function battery_watch()
    warn_value=40
    crit_value=20
    battery_value=tonumber(conky_parse("${battery_percent BATT}"))
    if battery_value == nil then battery_value = 0 end

    if battery_value>warn_value then
        settings_table[16]['fg_colour']=normal
    elseif battery_value>crit_value then
        settings_table[16]['fg_colour']=warn
    else
        settings_table[16]['fg_colour']=crit
    end
end

function conky_main()
    if conky_window==nil then return end
    temp_watch()
    cpu_watch()
    mem_watch()
    swap_watch()
    disk_watch()
    battery_watch()
    conky_ring_stats()
end
