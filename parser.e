class PARSER
-- Utiliteur de parse de fichier
	
creation {ANY}
	make

feature {}
	
feature {}
	make is
		do
			
		end

feature {MEDIATHEQUE}
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
		nouvel_medias:MEDIA
		arr:ARRAY[STRING]
		i:INTEGER
	do
		create lesmedias.make(0,0)
		create nouvel_medias.make
		arr := parse(file)
		from
			i := 1
		until i = arr.count
		loop
			if(arr.item(i).is_equal("titre"))then
				nouvel_medias.set_titre(arr.item(i+1))
			end
			if(arr.item(i).is_equal("auteur"))then
				nouvel_medias.set_auteur(arr.item(i+1))
			end
			if(arr.item(i).is_equal("annee"))then
				nouvel_medias.set_annee(arr.item(i+1))
			end
			if(arr.item(i).is_equal("\e"))then
				lesmedias.add_last(nouvel_medias)
				create nouvel_medias.make
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
					vreturn.add_last("type")
					vreturn.add_last(buffer)
				end
			end
			vreturn.add_last("\e")
		end

		reader.disconnect
		Result := vreturn
	end
end
