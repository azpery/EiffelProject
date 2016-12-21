class IU

creation{ANY}
	make

feature{}
	parser:PARSER
	nb_char:INTEGER
feature{ANY}
	make is
	do
		create parser.make
		nb_char := 80
	end

	show_multiple_choice(choices:STRING; header:STRING):INTEGER is
	--fonction qui permet d'afficher un choix multiple
	--Elle prend en entrée une chaine de caractère de type texte à afficher;etc
	--Elle retourne le choix entré par l'utilisateur
	local
		choice:ARRAY[STRING]
		padding:INTEGER
		i:INTEGER
	do
		choice := parser.split_string(choices, ';')
		put_centered_string(header, '*')
		from 
			i := 1
		until(i = choice.count)
		loop
			padding := get_padding(choice.item(i)) 
			io.put_string(choice.item(i) + get_string_from_char(' ', padding) + i.to_string + "%N")
			i := i+1
		end
		padding := get_padding("Retour") - 2
		io.put_string("Retour" + get_string_from_char(' ', padding) + "q" + "%N")
		io.read_line
		if(io.last_string.is_integer)then
			Result := io.last_string.to_integer
		else if(io.last_string.is_equal("q"))then
			Result := 0
		else
			Result := show_multiple_choice(choices, header)
		end end
	end

	show_list(list:ARRAY[STRING]; header:STRING) is
	--Procédure permettant d'afficher une liste de valeur
	local
		i:INTEGER
	do
		io.put_string(header + "%N")
		from
			i := 1
		until(i = list.count)
		loop
			io.put_string("- " + list.item(i) + "%N")
			i := i + 1
		end
	end

	ask_question(question:STRING):STRING is
	do
		io.put_string(question+" :%NVotre réponse:")
		io.read_line
		Result := io.last_string
	end

	put_centered_string(text:STRING; padding_char:CHARACTER) is
	--Affiche du texte centré
	local
		nb_stars:REAL
		padding:STRING
	do
		nb_stars := get_padding(text) / 2
		padding := get_string_from_char(padding_char, nb_stars.force_to_integer_32)
		io.put_string("%N"+padding+text+padding+"%N")
	end

	get_padding(text:STRING):INTEGER is
	--Retourne le nombre de charactère on peut mettre à la fin
	local
		padding:INTEGER
	do
		if(text.count > nb_char)then
			Result := 0
		else
			padding := nb_char - text.count
			if(padding \\ 2 /= 0)then
				padding := padding - 1
			end
			Result := padding			
		end
	end
	
	get_string_from_char(char:CHARACTER; nb_occurence:INTEGER):STRING is
	--Retourne une chaîne de caractere avec nb_occurence fois le nombre de caractère passé en paramètre
	local
		i:INTEGER
		vretour:STRING
	do
		vretour := ""
		from
			i := 0
		until(i = nb_occurence - 1)
		loop
			vretour := vretour + char.to_string
			i:= i + 1
		end
		Result := vretour
	end

	to_file ( path : STRING; content:STRING ) is
	local
		fichier : TEXT_FILE_WRITE
		i : INTEGER
	do
		create fichier.make
		fichier.connect_to(path)
		fichier.put_string(content)
		fichier.disconnect
	end

end -- class IU
