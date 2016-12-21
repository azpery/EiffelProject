class LIVRE

inherit MEDIA
	redefine make end	

creation{ANY}
	 make

feature{}
	auteur : STRING

feature{ANY}
	make is 
	do
		super_make
		auteur := "Pas d'auteur"
	end

	set_auteur (a : STRING) is
	do
		auteur := a
	end

	get_auteur : STRING is
	do
		Result := auteur
	end
	get_class:STRING is
	do
		Result := "LIVRE"
	end

	set_media is
		--Méthode pour renseigner tous les champs de l'objet
	local
		choix:STRING
	do
		titre.copy(iu.ask_question("Renseigner le titre"))
		auteur.copy(iu.ask_question("Renseigner l'auteur"))
		nbexemplaire := iu.ask_question("Renseigner le nombre d'exemplaires disponibles").to_integer
	end

	modifier_media is
		--Méthode pour renseigner tous les champs de l'objet
	local
		choix:STRING
		c:INTEGER
	do
		from
			c := 1
		until(c=0)
		loop
			choix := ""
			c := iu.show_multiple_choice("Modifier le titre;Modifier l'auteur;Modifier le nombre d'exemplaires","Modification de "+titre)
			inspect c
			when 1 then
				titre.copy(iu.ask_question("Renseigner le titre"))
			when 2 then 
				auteur.copy(iu.ask_question("Renseigner l'auteur"))
			when 3 then 
				nbexemplaire := iu.ask_question("Renseigner le nombre d'exemplaires disponibles").to_integer
			else		
			end
		end
	end

	print_media is
	do
		iu.put_centered_string(titre, '*')
		io.put_string("%N")
		io.put_string("Auteur:")
		io.put_string(auteur)
		io.put_string("%N")
		io.put_string("Nombre d'exemplaire disponibles:")
		io.put_integer(nbexemplaire)
		io.put_string("%N")
	end

	to_file_string:STRING is
	do
		Result := "Livre ; Titre<"+titre+"> ; Auteur<"+auteur+"> ; Nombre<"+nbexemplaire.to_string+">" 
	end

	is_equals(object:LIVRE):BOOLEAN is
	do
		Result := False
		if(object.get_auteur.is_equal(get_auteur) and object.get_titre.is_equal(get_titre))then
			Result := True
		end
	end

	is_equal_to(terme:STRING; t:STRING):BOOLEAN is
	do
		Result := False
		if(t.is_equal("titre") and get_titre.is_equal(terme))then
			Result := True
		elseif(t.is_equal("auteur") and get_auteur.is_equal(terme))then
			Result := True
		elseif(t.is_equal("id") and get_id.is_equal(terme))then
			Result := True
		elseif(t.is_equal("") and get_auteur.is_equal(terme) or get_titre.is_equal(terme))then
			Result := True
		end
	end

	get_id:STRING is
	--Retourne un identifiant unique au média
	local
		res:STRING
	do
		Result := titre+auteur
	end

end -- class LIVRE
