class PARSER
-- Utiliteur de parse de fichier
	
creation {ANY}
	make

feature {}
	
feature {}
	make is
		do
			
		end

feature {ANY}
	parse_utilisateur(file:STRING):ARRAY[UTILISATEUR] is
	--Function de parse d'un fichier qui permet de renvoyer une liste d'utilisateur
	local
		lesutilisateurs:ARRAY[UTILISATEUR]
		nouvel_utilisateur:UTILISATEUR
		arr:ARRAY[STRING]
		i:INTEGER
	do
		create lesutilisateurs.make(0,0)
		create nouvel_utilisateur.make
		arr := parse(file)
		from
			i := 1
		until i = arr.count
		loop
			
			if(arr.item(i).is_equal("nom"))then
				nouvel_utilisateur.set_nom(arr.item(i+1))
			end
			if(arr.item(i).is_equal("prenom"))then
				nouvel_utilisateur.set_prenom(arr.item(i+1))
			end
			if(arr.item(i).is_equal("identifiant"))then
				nouvel_utilisateur.set_id(arr.item(i+1))
			end
			if(arr.item(i).is_equal("admin"))then
				if(arr.item(i+1).is_equal("OUI"))then
					nouvel_utilisateur.set_isadmin(True)
				end
			end
			if(arr.item(i).is_equal("\e"))then
				lesutilisateurs.add_last(nouvel_utilisateur)
				create nouvel_utilisateur.make
			end
			  
			i := i + 1
		end
		
		Result := lesutilisateurs	
	end
	
	parse_media(file:STRING):ARRAY[MEDIA] is
	--Fonction de parse d'un fichier qui permet de renvoyer une liste de médias
	local
		lesmedias:ARRAY[MEDIA]
		nouveau_livre:LIVRE
		nouveau_dvd:DVD
		arr:ARRAY[STRING]
		current_type:STRING
		i:INTEGER
	do
		create lesmedias.make(0,0)
		create nouveau_livre.make
		create nouveau_dvd.make
		arr := parse(file)
		from
			i := 1
		until i = arr.count
		loop
			if(arr.item(i).is_equal("type_media"))then
				current_type := arr.item(i+1)
			end
			if(arr.item(i).is_equal("titre"))then
				nouveau_livre.set_titre(arr.item(i+1))
				nouveau_dvd.set_titre(arr.item(i+1))
			end
			if(arr.item(i).is_equal("nombre"))then
				nouveau_livre.set_nbexemplaire(arr.item(i+1).to_integer)
				nouveau_dvd.set_nbexemplaire(arr.item(i+1).to_integer)
			end
			if(arr.item(i).is_equal("auteur"))then
				nouveau_livre.set_auteur(arr.item(i+1))
			end
			if(arr.item(i).is_equal("annee"))then
				nouveau_dvd.set_annee(arr.item(i+1))
			end
			if(arr.item(i).is_equal("realisateur"))then
				nouveau_dvd.set_realisateur(arr.item(i+1))
			end
			if(arr.item(i).is_equal("type"))then
				nouveau_dvd.set_type(arr.item(i+1))
			end
			if(arr.item(i).is_equal("acteur"))then
				nouveau_dvd.add_acteur(arr.item(i+1))
			end
			if(arr.item(i).is_equal("\e"))then
				if(current_type.is_equal("livre")) then
					lesmedias.add_last(nouveau_livre)		
				else if(current_type.is_equal("dvd")) then
					lesmedias.add_last(nouveau_dvd)
				end
				end
				
				create nouveau_livre.make
				create nouveau_dvd.make
			end
			  
			i := i + 1
		end
		
		Result := lesmedias	
	end 

	parse(file:STRING):ARRAY[STRING] is
	local
		reader:TEXT_FILE_READ
		vreturn:ARRAY[STRING]
		line:STRING
		buffer:STRING
		is_end_of_line:BOOLEAN
		key:STRING
	do
		create vreturn.make(0,0)
		create reader.make
		reader.connect_to(file)
		from
		until(reader.end_of_input)
		loop
			reader.read_line
			is_end_of_line := False
			line := reader.last_string
			from 
			until(is_end_of_line)
			loop
				if(line.has_substring(";") = False) then
					is_end_of_line := True
					buffer := line
				else
					buffer := line.substring(1, line.index_of(';', 1)-1)
					line := line.substring(line.index_of(';',1)+1, line.count)
				end
				if(buffer.has_substring("<") and buffer.has_substring(">")) then
					key := buffer.substring(1, buffer.index_of('<', 1) -1)
					key.left_adjust
					key.right_adjust	
					key.to_lower
					vreturn.add_last(key)
					vreturn.add_last(buffer.substring(buffer.index_of('<', 1) + 1, buffer.index_of('>', 1) - 1))
				else
					vreturn.add_last("type_media")
					buffer.to_lower
					buffer.left_adjust
					buffer.right_adjust
					vreturn.add_last(buffer)
				end
			end
			vreturn.add_last("\e")
		end

		reader.disconnect
		Result := vreturn
	end

	split_string(string:STRING; delimiter:CHARACTER):ARRAY[STRING] is
	--Prend en entrée une chaine de character et la découpe à l'aide du délimiteur
	local
		vreturn:ARRAY[STRING]
		line:STRING
		buffer:STRING
		is_end_of_line:BOOLEAN
	do
		create vreturn.make(0,0)
		line := ""
		buffer := " "
		is_end_of_line := False
		line.copy(string)
		from 
		until(is_end_of_line)
		loop
			if(line.has_substring(delimiter.to_string) = False) then
				is_end_of_line := True
				buffer := line
			else
				buffer := string.substring(string.count - line.count + 1, line.index_of(delimiter, 1)-1)
				line := string.substring(line.index_of(delimiter,1)+1, line.count)
			end
			vreturn.add_last(buffer)
		end
		Result := vreturn
	end
end
