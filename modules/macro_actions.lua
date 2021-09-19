lib = {}

local action_select = 0

local t_juego ={
			 juego_contador_entrada=0
			,ind_arena=0X00FF803A
		}

local t_jugador={
	  nro_jugador=2
	 ,ind_prepara_counter=0
	 ,ind_ejecuta_counter=0
     ,nro_secuencia_desde=1
	 ,ind_recibeGolpe = 0x00FF8708
	 ,ind_inhabilitado= 0x00FF86C1
	 ,ind_orientacion = 0x00FF857C
	 ,ind_mareo 	  = 0x00FF871D
	 ,ind_aire		  = 0X00FF8C49
	 ,ind_contrincante_ejecutaGolpe=0x00FF8549
	 ,ind_contrincante_agachado    =0x00FF83C1
	 ,ind_char        =0x00FF894F
}


local accion_p2_BC={
              secuenciaConterProgramado= {{"Back"}}
			 ,secuenciaAtaqueProgramado_indice=1
			 ,secuenciaConvertida = {}
			 ,secuenciaDefault=""
			 ,nro_repeticion_accion=30
			 ,aux_contador_local=0
	    }
local accion_p2_BCA={
			  secuenciaAtaqueProgramado= {{"Back"}}
			 ,secuenciaAtaqueProgramado_indice=1
			 ,secuenciaConterProgramado= {{"Forward"},{"Down"},{"Forward","Down","Weak Punch"}}
			 ,secuenciaConterProgramado_indice=1
		     ,secuenciaConvertida      = {}
		}


----------------------------------------------------------------------------------------------------
-- Bloquear y contra atacar
----------------------------------------------------------------------------------------------------
function accion_bloquearContraAtacar()
	t_movimientos = {}
	v_orientacion  = memory.readbyte(t_jugador.ind_orientacion)
	v_recibeGolpe  = memory.readbyte(t_jugador.ind_recibeGolpe)
	v_inhabilitado = memory.readbyte(t_jugador.ind_inhabilitado)
	nro_secuencia_hastaCP = #accion_p2_BCA.secuenciaConterProgramado
	nro_secuencia_hastaAP = #accion_p2_BCA.secuenciaAtaqueProgramado
	
	
	if t_jugador.ind_ejecuta_counter==0 then
		if v_recibeGolpe == 0  then
			if t_jugador.ind_prepara_counter==1 then
					if (v_inhabilitado == 8 or v_inhabilitado == 0 ) then
					t_jugador.ind_ejecuta_counter=1
					end
			end 
		elseif (v_recibeGolpe == 1 or v_recibeGolpe==18 or v_recibeGolpe==17 ) then
				t_jugador.ind_prepara_counter=1
		end
	
	else
		if  accion_p2_BCA.secuenciaConterProgramado_indice > nro_secuencia_hastaCP then
			accion_p2_BCA.secuenciaConterProgramado_indice=1
			t_jugador.ind_ejecuta_counter=0
			t_jugador.ind_prepara_counter=0
		end
	end
	
	if  t_jugador.ind_ejecuta_counter == 1 then
		
		for i=1 , #accion_p2_BCA.secuenciaConterProgramado  do  
			accion_p2_BCA.secuenciaConvertida[i]={}
			for j=1, #accion_p2_BCA.secuenciaConterProgramado[i] do 
				if accion_p2_BCA.secuenciaConterProgramado[i][j]=="Forward" then
					if v_orientacion == 1 then
						table.insert(accion_p2_BCA.secuenciaConvertida[i], j, "P"..t_jugador.nro_jugador.." Left")
					elseif v_orientacion == 0 then
						table.insert(accion_p2_BCA.secuenciaConvertida[i], j, "P"..t_jugador.nro_jugador.." Right")
					end
				elseif accion_p2_BCA.secuenciaConterProgramado[i][j]=="Back" then
					if v_orientacion == 1 then
						table.insert(accion_p2_BCA.secuenciaConvertida[i], j, "P"..t_jugador.nro_jugador.." Right")
					elseif v_orientacion == 0 then
						table.insert(accion_p2_BCA.secuenciaConvertida[i], j, "P"..t_jugador.nro_jugador.." Left")
					end
				else
					table.insert(accion_p2_BCA.secuenciaConvertida[i], j, "P"..t_jugador.nro_jugador.." "..accion_p2_BCA.secuenciaConterProgramado[i][j])
				end
			end
		end
	
		for x=1 , #accion_p2_BCA.secuenciaConvertida[accion_p2_BCA.secuenciaConterProgramado_indice] do
			t_movimientos[accion_p2_BCA.secuenciaConvertida[accion_p2_BCA.secuenciaConterProgramado_indice][x]]=true
		end
		accion_p2_BCA.secuenciaConterProgramado_indice = accion_p2_BCA.secuenciaConterProgramado_indice+1
		
	else
			nro_secuencia_hastaAP = #accion_p2_BCA.secuenciaAtaqueProgramado
		if accion_p2_BCA.secuenciaAtaqueProgramado_indice > nro_secuencia_hastaAP then
			accion_p2_BCA.secuenciaAtaqueProgramado_indice=1
		end		
		
		for i=1 , #accion_p2_BCA.secuenciaAtaqueProgramado  do  
			accion_p2_BCA.secuenciaConvertida[i]={}
			for j=1, #accion_p2_BCA.secuenciaAtaqueProgramado[i] do 
				if accion_p2_BCA.secuenciaAtaqueProgramado[i][j]=="Forward" then
					if v_orientacion == 1 then
						table.insert(accion_p2_BCA.secuenciaConvertida[i], j, "P"..t_jugador.nro_jugador.." Left")
					elseif v_orientacion == 0 then
						table.insert(accion_p2_BCA.secuenciaConvertida[i], j, "P"..t_jugador.nro_jugador.." Right")
					end
				elseif accion_p2_BCA.secuenciaAtaqueProgramado[i][j]=="Back" then
					if v_orientacion == 1 then
						table.insert(accion_p2_BCA.secuenciaConvertida[i], j, "P"..t_jugador.nro_jugador.." Right")
					elseif v_orientacion == 0 then
						table.insert(accion_p2_BCA.secuenciaConvertida[i], j, "P"..t_jugador.nro_jugador.." Left")
					end
				else
					table.insert(accion_p2_BCA.secuenciaConvertida[i], j, "P"..t_jugador.nro_jugador.." "..accion_p2_BCA.secuenciaAtaqueProgramado[i][j])
				end
			end
		end
		
		for x=1 , #accion_p2_BCA.secuenciaConvertida[accion_p2_BCA.secuenciaAtaqueProgramado_indice] do
			t_movimientos[accion_p2_BCA.secuenciaConvertida[accion_p2_BCA.secuenciaAtaqueProgramado_indice][x]]=true
		end
		accion_p2_BCA.secuenciaAtaqueProgramado_indice = accion_p2_BCA.secuenciaAtaqueProgramado_indice+1
		
	end 
	
	joypad.set(t_movimientos)

end

----------------------------------------------------------------------------------------------------
-- Macro de patada chica agachado
----------------------------------------------------------------------------------------------------
local function accion_patadaAbajoGrande()
		t_movimientos2 = {}
		if t_juego.juego_contador_entrada == 0 then
		t_movimientos2["P2 Down"]=true
		t_movimientos2["P2 Strong Kick"]=true
		joypad.set(t_movimientos2)
		t_juego.juego_contador_entrada=t_juego.juego_contador_entrada+1
		else
		t_movimientos2["P2 Down"]=true
		t_movimientos2["P2 Strong Kick"]=false
		joypad.set(t_movimientos2)
		t_juego.juego_contador_entrada=t_juego.juego_contador_entrada-1
		end 
end
			 
function accion_patadaAbajoPequena()
		t_movimientos2 = {}
		if t_juego.juego_contador_entrada == 0 then
			t_movimientos2["P2 Down"]=true
			t_movimientos2["P2 Weak Kick"]=true
			joypad.set(t_movimientos2)
			t_juego.juego_contador_entrada=t_juego.juego_contador_entrada+1
		else
			t_movimientos2["P2 Down"]=true
			t_movimientos2["P2 Weak Kick"]=false
			joypad.set(t_movimientos2)
			t_juego.juego_contador_entrada=t_juego.juego_contador_entrada-1
		end 
end

----------------------------------------------------------------------------------------------------
-- Macro de patada fuerte agachado (barrida)
----------------------------------------------------------------------------------------------------
local function accion_patadaAbajoGrande()
		t_movimientos2 = {}
		if t_juego.juego_contador_entrada == 0 then
		t_movimientos2["P2 Down"]=true
		t_movimientos2["P2 Strong Kick"]=true
		joypad.set(t_movimientos2)
		t_juego.juego_contador_entrada=t_juego.juego_contador_entrada+1
		else
		t_movimientos2["P2 Down"]=true
		t_movimientos2["P2 Strong Kick"]=false
		joypad.set(t_movimientos2)
		t_juego.juego_contador_entrada=t_juego.juego_contador_entrada-1
		end 
end

----------------------------------------------------------------------------------------------------
-- Solo bloquea por abajo
----------------------------------------------------------------------------------------------------

local function accion_bloquearComboAbajo()
	t_movimientos = {}
	ind_recibe_golpe = memory.readbyte(t_jugador.ind_recibeGolpe)
	v_orientacion  = memory.readbyte(t_jugador.ind_orientacion)
	
	if ind_recibe_golpe==1 then
		accion_p2_BC.aux_contador_local=accion_p2_BC.nro_repeticion_accion
	end
	
	if accion_p2_BC.aux_contador_local > 0 then
	
		accion_p2_BC.secuenciaDefault="P"..t_jugador.nro_jugador.." Down"
		t_movimientos[accion_p2_BC.secuenciaDefault]=true
		
		if v_orientacion == 1 then
			accion_p2_BC.secuenciaDefault="P"..t_jugador.nro_jugador.." Right"
		elseif v_orientacion == 0 then
			accion_p2_BC.secuenciaDefault="P"..t_jugador.nro_jugador.." Left"
		end
	
		t_movimientos[accion_p2_BC.secuenciaDefault]=true
		joypad.set(t_movimientos)
		accion_p2_BC.aux_contador_local=accion_p2_BC.aux_contador_local-1
	end
end

----------------------------------------------------------------------------------------------------
-- Solo bloquea por arriba
----------------------------------------------------------------------------------------------------
function accion_bloquearComboArriba()
	t_movimientos = {}
	ind_recibe_golpe = memory.readbyte(t_jugador.ind_recibeGolpe)
	v_orientacion    = memory.readbyte(t_jugador.ind_orientacion)
	
	if ind_recibe_golpe==1 then
		accion_p2_BC.aux_contador_local=accion_p2_BC.nro_repeticion_accion
	end
	
	if accion_p2_BC.aux_contador_local > 0 then
	
		if v_orientacion == 1 then
			accion_p2_BC.secuenciaDefault="P"..t_jugador.nro_jugador.." Right"
		elseif v_orientacion == 0 then
			accion_p2_BC.secuenciaDefault="P"..t_jugador.nro_jugador.." Left"
		end
	
		t_movimientos[accion_p2_BC.secuenciaDefault]=true
		joypad.set(t_movimientos)
		accion_p2_BC.aux_contador_local=accion_p2_BC.aux_contador_local-1
	end
end

----------------------------------------------------------------------------------------------------
-- Macro de solo saltar hacia arriba
----------------------------------------------------------------------------------------------------
local function accion_salta()
		t_movimientos = {}
		t_movimientos["P2 Up"]=true
		joypad.set(t_movimientos)
end

----------------------------------------------------------------------------------------------------
-- Macro de saltar en diagonal y patear
----------------------------------------------------------------------------------------------------
local function accion_saltaPatea()
	t_movimientos = {}
	v_indicador_aire= memory.readbyte(t_jugador.ind_aire)
	v_orientacion   = memory.readbyte(t_jugador.ind_orientacion)
	v_char          = memory.readbyte(t_jugador.ind_char)
	--print(v_indicador_aire)
	t_movimientos["P"..t_jugador.nro_jugador.." Up"]=true
	
	if v_orientacion == 1 then
		t_movimientos["P"..t_jugador.nro_jugador.." Left"]=true
	elseif v_orientacion == 0 then
		t_movimientos["P"..t_jugador.nro_jugador.." Right"]=true
	end
	
	if v_char == 0 or v_char == 1 or v_char ==3 or v_char == 4 or v_char == 6 or v_char == 8 or v_char == 9 or v_char == 10 then 
		if v_indicador_aire==10 or v_indicador_aire==9 or v_indicador_aire==8 or v_indicador_aire==7 then
			t_juego.juego_contador_entrada=1
		end
		if (v_indicador_aire == 4 or v_indicador_aire==5 or v_indicador_aire==3 or v_indicador_aire==6)  and t_juego.juego_contador_entrada==1 then
			t_movimientos["P"..t_jugador.nro_jugador.." Strong Kick"]=true
		else
			t_movimientos["P"..t_jugador.nro_jugador.." Strong Kick"]=false
		end
	elseif v_char == 2 or v_char == 5 or v_char ==7 or v_char ==11 then 
		if v_indicador_aire==11 or v_indicador_aire==12 or v_indicador_aire==13 then
			t_juego.juego_contador_entrada=1
		end
		if (v_indicador_aire == 10 or v_indicador_aire==9 or v_indicador_aire==8)  and t_juego.juego_contador_entrada==1 then
			t_movimientos["P"..t_jugador.nro_jugador.." Strong Kick"]=true
		else
			t_movimientos["P"..t_jugador.nro_jugador.." Strong Kick"]=false
		end
	end
	
	
	if v_indicador_aire == 0 then
		t_juego.juego_contador_entrada=0
	end 
	
	joypad.set(t_movimientos)
end

----------------------------------------------------------------------------------------------------
-- Ejecuta la macro seleccionada
----------------------------------------------------------------------------------------------------
function lib.MacroActions()

	if action_select == 1 then		
		accion_bloquearContraAtacar()
	elseif action_select  == 2 then
		accion_patadaAbajoPequena()
	elseif action_select  == 3 then
		accion_patadaAbajoGrande()
	elseif action_select  == 4 then
		accion_bloquearComboAbajo()
	elseif action_select  == 5 then
		accion_bloquearComboArriba()
	elseif action_select  == 6 then
		accion_salta()
	elseif action_select  == 7 then
		accion_saltaPatea()
	end
end

----------------------------------------------------------------------------------------------------
-- hotkey function
----------------------------------------------------------------------------------------------------
local optionMenu={"Ninguna","1 Bloquear Contraatacar","2 Patada Abajo chica","3 Patada Abajo Grande","4 Bloquea Combo Abajo","5 Bloque Combo Arriba","6 Salta","7 Salta y Patea"}
local optionMenuLength = #optionMenu
print (optionMenuLength)

function lib.EnableMacroActions()

	action_select = action_select + 1

	if action_select >= optionMenuLength then
		action_select = 0
	end

	return optionMenu[action_select+1];
end

return lib